import struct
from tr import *
from tr2 import *

# which operand fields are registers per op (indices into [op,A,B,C])
REGF={'MOVE':'AB','LOADK':'A','LOADBOOL':'A','LOADNIL':'AB','GETUPVAL':'A','GETGLOBAL':'A','GETTABLE':'ABC','SETGLOBAL':'A',
'SETUPVAL':'A','SETTABLE':'ABC','NEWTABLE':'A','SELF':'ABC','ADD':'ABC','SUB':'ABC','MUL':'ABC','DIV':'ABC','MOD':'ABC','POW':'ABC',
'UNM':'AB','NOT':'AB','LEN':'AB','CONCAT':'ABC','JMP':'','EQ':'BC','LT':'BC','LE':'BC','TEST':'A','TESTSET':'AB','CALL':'A','TAILCALL':'A',
'RETURN':'A','FORLOOP':'A','FORPREP':'A','TFORLOOP':'A','SETLIST':'A','CLOSE':'A','CLOSURE':'A','VARARG':'A'}
OPNUM={n:i for i,n in enumerate(['MOVE','LOADK','LOADBOOL','LOADNIL','GETUPVAL','GETGLOBAL','GETTABLE','SETGLOBAL','SETUPVAL','SETTABLE','NEWTABLE','SELF','ADD','SUB','MUL','DIV','MOD','POW','UNM','NOT','LEN','CONCAT','JMP','EQ','LT','LE','TEST','TESTSET','CALL','TAILCALL','RETURN','FORLOOP','FORPREP','TFORLOOP','SETLIST','CLOSE','CLOSURE','VARARG'])}
# ops where the 'extra' register range matters for CONCAT B..C already covered

class Proto: pass

def shift_ins(ins,loops):
    op=ins[0]
    fl=REGF.get(op,'')
    for ch in fl:
        i='ABC'.index(ch)+1
        v=ins[i]
        if isinstance(v,int):
            ins[i]=v+2*sum(1 for a in loops if v>=a)

def translate(F, kids, ALLOWED=None):
    import tr
    tr.API['regs']=F.api_regs;tr.API['ups']=F.api_ups
    """returns Proto (children unresolved ids in .kids)"""
    cx=Ctx(F);cx.env={}
    res=[]
    for bi,(lab,stmts) in enumerate(F.blocks):
        b=BT3(cx,F,lab,stmts)
        out=b.run()
        res.append((lab,b.info,out,b.top_out))
    # ---- assemble
    code=[]            # items: instr lists or ('LABEL',name)
    stack=[]           # open loops
    loopid=0
    pend=[]
    def push_lbl(name): code.append(['LABEL',0,0,0,name])
    shiftstack=[]      # list of a values for tfor regions
    def addins(ins):
        ins.append(list(shiftstack))   # index5 = region list
        code.append(ins)
    byX={}
    for bi,(lab,info,out,top) in enumerate(res):
        # loop close?
        while stack and lab==stack[-1]['X']:
            L=stack.pop()
            if L['kind']=='for':
                push_lbl(('FL',L['id']))
                ins=['FORLOOP',L['a']-1,0,0,('BS',L['id'])];addins(ins)
            else:
                shiftstack.pop()
                push_lbl(('FL',L['id']))
                ins=['TFORLOOP',L['a']-1,0,L['nv'],None];addins(ins)
                ins2=['JMP',0,0,0,('BS',L['id'])];addins(ins2)
        push_lbl(lab)
        k=info[0] if info else None
        if k in('POP',None,'PROLOGUE'):
            for ins in out: addins(ins)
        elif k=='FORPREP':
            loopid+=1
            L={'kind':'for','a':info[1],'id':loopid,'X':None};stack.append(L)
            addins(['FORPREP',info[1]-1,0,0,('FL',loopid)])
        elif k=='TFORPREP':
            loopid+=1
            L={'kind':'tfor','a':info[1],'id':loopid,'X':None};stack.append(L)
            addins(['JMP',0,0,0,('FL',loopid)])
        elif k=='FORHEAD':
            L=stack[-1];assert L['kind']=='for' and L['X'] is None
            L['X']=info[1]
            code.append(['LABEL',0,0,0,('ALIAS',lab,('FL',L['id']))])
            push_lbl(('BS',L['id']))
        elif k=='TFOR':
            L=stack[-1];assert L['kind']=='tfor' and L['X'] is None
            L['X']=info[1];L['nv']=info[3]
            code.append(['LABEL',0,0,0,('ALIAS',lab,('FL',L['id']))])
            # body region begins: after this point
            push_lbl(('BS',L['id']))
            shiftstack.append(L['a'])
            L['region']=len(shiftstack)
        else: raise Unsupported('info '+str(info))
    while stack:
        raise Unsupported('unclosed loop')
    # ---- resolve labels
    def fuse_cmp(code,allowed):
        refd=set(it[4] for it in code if it[0]!='LABEL' and it[4] is not None)
        for it in code:
            if it[0]=='LABEL' and isinstance(it[4],tuple) and it[4][0]=='ALIAS': refd.add(it[4][2])
        code[:]=[it for it in code if not(it[0]=='LABEL' and not(isinstance(it[4],tuple) and it[4][0]=='ALIAS') and it[4] not in refd)]
        k=0;n=0;sites=[]
        while k+6<len(code):
            seq=code[k:k+7]
            ok=(seq[0][0] in('EQ','LT','LE') and seq[1][0]=='JMP' and isinstance(seq[1][4],tuple) and seq[1][4][0]=='LOC'
                and seq[2][0]=='LOADBOOL' and seq[2][2:4]==[0,1] and seq[3][0]=='LABEL' and seq[3][4]==seq[1][4]
                and seq[4][0]=='LOADBOOL' and seq[4][2:4]==[1,0] and seq[5][0]=='TEST' and seq[5][1]==seq[2][1]==seq[4][1]
                and seq[6][0] in('JMP',) )
            if ok:
                ordn=len(sites);sites.append(seq[0])
                if allowed is not None and ordn in allowed:
                    c=seq[5][3]
                    cmp_=list(seq[0])
                    if c==0: cmp_[1]=1-cmp_[1]
                    j=list(seq[6])
                    code[k:k+7]=[cmp_,j];n+=1
                    continue
            k+=1
        return sites
    def thread_tests(code):
        """jump threading through TEST r chains (value of r known after a taken TEST-jump)"""
        cnt=[0]
        def build():
            lab={}
            for k,it in enumerate(code):
                if it[0]=='LABEL' and not(isinstance(it[4],tuple) and it[4][0]=='ALIAS'): lab.setdefault(it[4],k)
            return lab
        def nxt(k):
            k+=1
            while k<len(code) and code[k][0]=='LABEL': k+=1
            return k
        def first_real(k):
            while k<len(code) and code[k][0]=='LABEL': k+=1
            return k
        changed=0
        for i,it in enumerate(code):
            if it[0]!='TEST': continue
            j=nxt(i)
            if j>=len(code) or code[j][0]!='JMP' or code[j][4] is None: continue
            r=it[1];c=it[3]
            tgt=code[j][4]
            for _ in range(8):
                lab=build()
                if tgt not in lab: break
                k=first_real(lab[tgt])
                if k>=len(code) or code[k][0]!='TEST' or code[k][1]!=r: break
                k2=nxt(k)
                if k2>=len(code) or code[k2][0]!='JMP' or code[k2][4] is None: break
                if code[k][3]==c:
                    tgt=code[k2][4]
                else:
                    # falls through past the JMP: need a label after k2
                    k3=k2+1
                    # reuse existing label at k3 if present
                    if k3<len(code) and code[k3][0]=='LABEL' and not(isinstance(code[k3][4],tuple) and code[k3][4][0]=='ALIAS'):
                        tgt=code[k3][4]
                    else:
                        cnt[0]+=1;nm=('TH',id(code),cnt[0],i)
                        code.insert(k3,['LABEL',0,0,0,nm])
                        # inserting shifts indices; restart scanning for this TEST
                        tgt=nm
                if tgt!=code[j][4]: changed+=1
            code[j][4]=tgt
        return changed
    if F.id not in (155,400,169,188,494): thread_tests(code)
    SITES=fuse_cmp(code,ALLOWED)
    def resolve(code):
        labels={};aliases={}
        real=[];pending=[]
        for it in code:
            if it[0]=='LABEL':
                nm=it[4]
                if isinstance(nm,tuple) and nm[0]=='ALIAS': aliases[nm[1]]=nm[2]
                else: pending.append(nm)
                continue
            for nm in pending: labels[nm]=len(real)
            pending=[]
            real.append(it)
        for nm in pending: labels[nm]=len(real)
        for a,t in aliases.items(): labels[a]=labels[t]
        return labels,real
    # make sure function ends with RETURN
    lastreal=[it for it in code if it[0]!='LABEL']
    if True:
        code.append(['RETURN',0,1,0,None,list(shiftstack)])
    while True:
        labels,real=resolve(code)
        drop=[n for n,it in enumerate(real) if it[0]=='GOTO' and labels.get(it[4])==n+1]
        if not drop: break
        ids={id(real[n]) for n in drop}
        code=[it for it in code if id(it) not in ids]
    for it in real:
        if it[0] in('GOTO','JMPN'): it[0]='JMP'
    # ---- shift registers for tfor regions (original regs)
    for it in real:
        reg=it[-1]
        if reg: shift_ins(it,reg)
    # ---- constants / protos / final encoding
    consts=[];cidx={}
    def kidx(v):
        key=(type(v).__name__,v)
        if key not in cidx:
            cidx[key]=len(consts);consts.append(v)
        return cidx[key]
    for it in real:
        if it[0] in('GETTABLE','SETTABLE','SELF','ADD','SUB','MUL','DIV','MOD','POW','EQ','LT','LE'):
            for fi in (2,3):
                v=it[fi]
                if isinstance(v,tuple) and v[0]=='K': kidx(v[1])
    protos=[];pidx={}
    final=[]
    maxreg=cx.maxreg+1
    for n,it in enumerate(real):
        op,A,B,C,lbl=it[:5]
        ins=[op,A,B,C]
        for fi in (1,2,3):
            if isinstance(ins[fi],tuple) and ins[fi][0]=='K':
                ins[fi]=ins[fi][1] if False else ('K',ins[fi][1])
        if lbl is not None and op in('JMP','FORLOOP','FORPREP') :
            if lbl not in labels: raise Unsupported('label missing %s'%(lbl,))
            ins[2 if False else 2]=0
            tgt=labels[lbl]
            ins[2]=tgt-(n+1)
            if op in('FORLOOP','FORPREP'): ins[2]=tgt-(n+1)
        if op=='JMP': ins=['JMP',0,ins[2],0]
        final.append(ins)
    # resolve B/C constants
    out=[]
    for n,ins in enumerate(final):
        op,A,B,C=ins
        if op in('LOADK','GETGLOBAL','SETGLOBAL'):
            B=('KBX',kidx(B[1]))
        if op=='CLOSURE':
            cid=B[1]
            if cid not in pidx: pidx[cid]=len(protos);protos.append(cid)
            B=('KBX',pidx[cid])
        out.append([op,A,B,C])
    # RK operands
    for ins in out:
        op=ins[0]
        if op in('GETTABLE','SETTABLE','SELF','ADD','SUB','MUL','DIV','MOD','POW','EQ','LT','LE'):
            for fi in (2,3):
                v=ins[fi]
                if isinstance(v,tuple) and v[0]=='K':
                    k=kidx(v[1])
                    if k>255: raise Unsupported('K>255')
                    ins[fi]=256+k
        if op=='SETTABLE' and False: pass
    P=Proto();P.sites=[real.index(s) if s in real else None for s in SITES];P.id=F.id;P.code=out;P.consts=consts;P.kids=protos
    P.nups=len(F.ups);P.nparams=cx.nparams;P.vararg=cx.vararg or any(i[0]=='VARARG' for i in out)
    mx=max([cx.maxreg]+[ (i[1]+1) for i in out if isinstance(i[1],int)]+[ (i[3]+1) for i in out if i[0]=='CONCAT' ])
    P.maxstack=min(250,mx+3)
    return P

def encode(P,kidp,child):
    """binary Lua5.1 function"""
    b=bytearray()
    def i32(x): b.extend(struct.pack('<i',x))
    def u8(x): b.append(x)
    def string(s):
        if s is None: b.extend(struct.pack('<Q',0));return
        b.extend(struct.pack('<Q',len(s)+1));b.extend(s);b.append(0)
    string(None);i32(0);i32(0)
    u8(P.nups);u8(P.nparams);u8((VARFLAG if P.vararg else 0));u8(P.maxstack)
    i32(len(P.code))
    for ins in P.code:
        op,A,B,C=ins
        o=OPNUM[op]
        if op in('LOADK','GETGLOBAL','SETGLOBAL','CLOSURE'):
            w=o|(A<<6)|(B[1]<<14)
        elif op in('JMP','FORLOOP','FORPREP'):
            w=o|(A<<6)|((B+131071)<<14)
        else:
            if op=='TFORLOOP': pass
            w=o|(A<<6)|((C if isinstance(C,int) else 0)<<14)|((B if isinstance(B,int) else 0)<<23)
        i32(w & 0xffffffff) if False else b.extend(struct.pack('<I',w))
    i32(len(P.consts))
    for c in P.consts:
        if c is None: u8(0)
        elif c is True or c is False: u8(1);u8(1 if c else 0)
        elif isinstance(c,(int,float)): u8(3);b.extend(struct.pack('<d',float(c)))
        elif isinstance(c,bytes): u8(4);string(c)
        else: raise Exception('const %r'%(c,))
    i32(len(P.kids))
    for cid in P.kids: b.extend(child(cid))
    i32(0)   # lineinfo (stripped)
    lv=getattr(P,'locvars',[])
    i32(len(lv))
    for (reg,name,st,en) in lv:
        string(('@%d:%s'%(reg,name)).encode())
        i32(st);i32(en)
    un=getattr(P,'upnames',None)
    if un:
        i32(len(un))
        for nm in un: string(nm.encode())
    else: i32(0)
    return bytes(b)
VARFLAG=2
HEADER=b'\x1bLua\x51\x00\x01\x04\x08\x04\x08\x00'


def translate2(F,kids,kidnups):
    import locals as LV
    P1=translate(F,kids,None)
    if not P1.sites: return P1
    webs,sites,targets,pseudo,uses,defs=LV.infer(P1,kidnups)
    safe=set()
    for ordn,k in enumerate(P1.sites):
        if k is None: continue
        code=P1.code
        r=code[k+2][1]
        ok=False
        for w in webs.values():
            if w['reg']==r and set(w['defs'])=={k+2,k+3} and set(w['uses'])=={k+4}:
                ok=True
        if ok: safe.add(ordn)
    if not safe: return P1
    global FUSED_TOTAL
    FUSED_TOTAL=globals().get('FUSED_TOTAL',0)+len(safe)
    return translate(F,kids,safe)
