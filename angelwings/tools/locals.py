"""Infer local variable table (explicit register) for a Proto."""
def rk_is_reg(v): return isinstance(v,int) and v<256

def analyze(P,kidnups):
    code=P.code;n=len(code)
    pseudo=set()
    for pc,ins in enumerate(code):
        if ins[0]=='CLOSURE':
            nu=kidnups[P.kids[ins[2][1]]]
            for j in range(1,nu+1): pseudo.add(pc+j)
    uses=[set() for _ in range(n)];defs=[set() for _ in range(n)]
    for pc,(op,A,B,C) in enumerate(code):
        U=uses[pc];D=defs[pc]
        if pc in pseudo:
            if op=='MOVE': U.add(B)
            continue
        if op=='MOVE': D.add(A);U.add(B)
        elif op in('LOADK','LOADBOOL','NEWTABLE','GETUPVAL','GETGLOBAL','CLOSURE'): D.add(A)
        elif op=='LOADNIL': D.update(range(A,B+1))
        elif op=='GETTABLE':
            D.add(A);U.add(B)
            if rk_is_reg(C): U.add(C)
        elif op in('SETGLOBAL','SETUPVAL'): U.add(A)
        elif op=='SETTABLE':
            U.add(A)
            if rk_is_reg(B): U.add(B)
            if rk_is_reg(C): U.add(C)
        elif op=='SELF':
            D.update((A,A+1));U.add(B)
            if rk_is_reg(C): U.add(C)
        elif op in('ADD','SUB','MUL','DIV','MOD','POW'):
            D.add(A)
            if rk_is_reg(B): U.add(B)
            if rk_is_reg(C): U.add(C)
        elif op in('UNM','NOT','LEN'): D.add(A);U.add(B)
        elif op=='CONCAT': D.add(A);U.update(range(B,C+1))
        elif op in('EQ','LT','LE'):
            if rk_is_reg(B): U.add(B)
            if rk_is_reg(C): U.add(C)
        elif op=='TEST': U.add(A)
        elif op=='TESTSET': D.add(A);U.add(B)
        elif op in('CALL','TAILCALL'):
            if B==0:
                pa=code[pc-1][1]
                U.update(range(A,pa+1))
            else: U.update(range(A,A+B))
            if op=='CALL':
                if C==0: D.add(A)
                else: D.update(range(A,A+C-1))
        elif op=='RETURN':
            if B==0:
                pa=code[pc-1][1]
                U.update(range(A,pa+1))
            else: U.update(range(A,A+B-1))
        elif op=='FORLOOP': U.update((A,A+1,A+2));D.update((A,A+3))
        elif op=='FORPREP': U.update((A,A+1,A+2));D.add(A)
        elif op=='TFORLOOP': U.update((A,A+1,A+2));D.update(range(A+3,A+3+C))
        elif op=='SETLIST':
            U.add(A)
            if B==0:
                pa=code[pc-1][1]
                U.update(range(A+1,pa+1))
            else: U.update(range(A+1,A+B+1))
        elif op=='VARARG':
            if B==0: D.add(A)
            else: D.update(range(A,A+B-1))
    # successors
    succ=[[] for _ in range(n)]
    for pc,(op,A,B,C) in enumerate(code):
        if pc in pseudo and op in('MOVE','GETUPVAL'): succ[pc]=[pc+1] if pc+1<n else [];continue
        if op=='JMP': succ[pc]=[pc+1+B]
        elif op in('EQ','LT','LE','TEST','TESTSET'): succ[pc]=[pc+1,pc+2]
        elif op=='RETURN': succ[pc]=[]
        elif op=='FORLOOP': succ[pc]=[pc+1,pc+1+B]
        elif op=='FORPREP': succ[pc]=[pc+1+B]
        elif op=='TFORLOOP': succ[pc]=[pc+1,pc+2]
        elif op=='LOADBOOL' and C: succ[pc]=[pc+2]
        else: succ[pc]=[pc+1] if pc+1<n else []
        succ[pc]=[s for s in succ[pc] if 0<=s<n]
    pred=[[] for _ in range(n)]
    for pc in range(n):
        for s in succ[pc]: pred[s].append(pc)
    return uses,defs,succ,pred,pseudo

def infer(P,kidnups,mode_names=None):
    uses,defs,succ,pred,pseudo=analyze(P,kidnups)
    code=P.code;n=len(code)
    # def sites
    sites=[];sid={}
    byreg={}
    for pc in range(n):
        for r in defs[pc]:
            sid[(pc,r)]=len(sites);sites.append((pc,r));byreg.setdefault(r,[]).append(len(sites)-1)
    kill={r:sum(1<<i for i in ids) for r,ids in byreg.items()}
    # reaching defs (bitset over sites)
    IN=[0]*n;OUT=[0]*n
    gen=[0]*n;killm=[0]*n
    for pc in range(n):
        for r in defs[pc]:
            gen[pc]|=1<<sid[(pc,r)];killm[pc]|=kill[r]
    # params defined at entry as pseudo-sites (-1)
    entry=0
    changed=True
    order=list(range(n))
    while changed:
        changed=False
        for pc in order:
            i=0
            for p in pred[pc]: i|=OUT[p]
            o=(i&~killm[pc])|gen[pc]
            if i!=IN[pc] or o!=OUT[pc]:
                IN[pc]=i;OUT[pc]=o;changed=True
    # union-find over sites
    par=list(range(len(sites)))
    def find(x):
        while par[x]!=x:
            par[x]=par[par[x]];x=par[x]
        return x
    usesite=[]  # (pc,reg,rootsite or -1)
    webuses={}
    for pc in range(n):
        for r in uses[pc]:
            m=IN[pc]&kill.get(r,0)
            ids=[i for i in byreg.get(r,[]) if m>>i&1]
            if not ids: usesite.append((pc,r,None));continue
            f=find(ids[0])
            for i in ids[1:]:
                g=find(i)
                if g!=f: par[g]=f
            usesite.append((pc,r,ids[0]))
    webs={}
    for i,(pc,r) in enumerate(sites):
        w=webs.setdefault(find(i),{'reg':r,'defs':[],'uses':[]})
        w['defs'].append(pc)
    for pc,r,i in usesite:
        if i is None: continue
        webs[find(i)]['uses'].append(pc)
    global LAST_S2W,LAST_WEBS
    LAST_WEBS=webs
    LAST_S2W={(pc,r):find(i) for i,(pc,r) in enumerate(sites)}
    # labels (jump targets)
    targets=set()
    for pc in range(n):
        for s in succ[pc]:
            if s!=pc+1 or code[pc][0] in('JMP',): targets.add(s)
    for pc in range(n):
        if code[pc][0] in('EQ','LT','LE','TEST','TESTSET'): targets.add(pc+2)
    return webs,sites,targets,pseudo,uses,defs

TEMP_MEMO={}
def is_temp(w,targets,code,pseudo,uses_,defs_):
    key=(id(code),w['reg'],min(w['defs']) if w['defs'] else -1)
    if key in TEMP_MEMO: return TEMP_MEMO[key]
    TEMP_MEMO[key]=True   # in-progress assumption
    r_=_is_temp(w,targets,code,pseudo,uses_,defs_)
    TEMP_MEMO[key]=r_
    return r_

def _is_temp(w,targets,code,pseudo,uses_,defs_):
    ds=w['defs'];us=sorted(set(w['uses']))
    if len(ds)!=1: return False
    r=w['reg']
    if len(us)==0: return True   # dead/unused result
    d=ds[0];u=us[-1]
    if u<=d: return False
    if u-d>400: return False
    # non-final uses must be stores into this very table (constructor)
    for pc in us[:-1]:
        op,A,B,C=code[pc]
        if code[d][0]!='NEWTABLE': return False
        if not ((op=='SETTABLE' and A==r) or (op=='SETLIST' and A==r)): return False
        if op=='SETTABLE' and (B==r or C==r): return False
    if u in pseudo: return False
    for k in range(d+1,u+1):
        if k in targets: return False
    for k in range(d+1,u):
        op,A,B,C=code[k]
        if k in pseudo: continue
        if op in('SETGLOBAL','SETUPVAL','CLOSE','RETURN','TAILCALL','FORLOOP','FORPREP','TFORLOOP'): return False
        if op=='CALL' and C==1: return False
        if op=='SETTABLE' and A<r: return False
        for x in defs_[k]:
            if x<r: return False
            if x>r:
                root=LAST_S2W.get((k,x))
                if root is not None:
                    wq=LAST_WEBS[root]
                    if wq['uses'] and max(wq['uses'])>u and not is_temp(wq,targets,code,pseudo,uses_,defs_): return False
    return True

def scope_ends(code,succ):
    n=len(code)
    fj=[];bj=[]
    for pc in range(n):
        op=code[pc][0]
        if op=='JMP':
            t=pc+1+code[pc][2]
            (fj if t>pc else bj).append((pc,t))
        elif op in('FORPREP',):
            fj.append((pc,pc+1+code[pc][2]))
    E=[n-1]*n
    for pc in range(n):
        e=n-1
        for (o,t) in fj:
            if o<pc<t: e=min(e,t-1)
        for (o,t) in bj:
            if t<=pc<=o: e=min(e,o)
        E[pc]=e
    return E

def make_locals(P,kidnups,names,reserved=frozenset()):
    webs,sites,targets,pseudo,uses,defs=infer(P,kidnups)
    code=P.code;n=len(code)
    uses_,defs_,succ_,pred_,pseudo_=analyze(P,kidnups)
    E=scope_ends(code,succ_)
    firstdef={}
    for w in webs.values():
        firstdef.setdefault(w['reg'],[]).append(min(w['defs']))
    for r in firstdef: firstdef[r].sort()
    s2w=LAST_S2W
    tempmemo={}
    def istemp(root):
        if root not in tempmemo:
            tempmemo[root]=is_temp(webs[root],targets,code,pseudo,uses,defs)
        return tempmemo[root]
    def extend(w,seen=None):
        seen=seen or set()
        lu=max(w['defs']+w['uses'])
        for u in set(w['uses']):
            for t in defs[u]:
                root=s2w.get((u,t))
                if root is None or root in seen: continue
                wt=webs[root]
                if wt is w: continue
                if istemp(root):
                    seen.add(root)
                    lu=max(lu,extend(wt,seen))
        return lu
    spans=[]
    for pc in range(n):
        if code[pc][0]=='JMP':
            t=pc+1+code[pc][2]
            if t>pc+1:
                so=pc-1 if pc>0 and code[pc-1][0] in('EQ','LT','LE','TEST','TESTSET') else pc
                spans.append((so,t))
    spans.sort()
    L=[]   # dicts: reg,lo,lu,end
    forced=set();groups=[]
    roots_of={id(w):rt for rt,w in webs.items()}
    islocal=lambda rt: not is_temp(webs[rt],targets,code,pseudo,uses,defs)
    for pc in range(n):
        op,A,B,C=code[pc]
        if (op=='CALL' and C>=3) or (op=='VARARG' and B>=3):
            regs=range(A,A+C-1) if op=='CALL' else range(A,A+B-1)
            grp=[s2w.get((pc,x)) for x in regs]
            grp=[g for g in grp if g is not None and webs[g]['uses']]
            groups.append(grp)
            if any(islocal(g) for g in grp):
                forced.update(grp)
    for rt,w in webs.items():
        r=w['reg']
        if r<P.nparams: continue
        if any(code[d][0] in('FORLOOP','FORPREP','TFORLOOP') for d in w['defs']): continue
        if any(code[u][0] in('FORLOOP','FORPREP','TFORLOOP') for u in w['uses']): continue
        dead_call=(not w['uses']) and len(w['defs'])==1 and code[w['defs'][0]][0]=='CALL' and code[w['defs'][0]][3]==2
        if dead_call:
            dd=w['defs'][0]
            L.append({'reg':r,'lo':dd+1,'lu':dd+1,'end':dd+1,'d':dd,'roots':{rt},'captured':False,'dead':True})
            continue
        if rt not in forced and is_temp(w,targets,code,pseudo,uses,defs): continue
        lo=min(w['defs']);d0=lo
        lu=extend(w)
        if code[lu][0] in('TEST','TESTSET','EQ','LT','LE') and lu+1<n: lu+=1
        ch=True
        while ch:
            ch=False
            for so,t in spans:
                if so<lo<t and lu>=t:
                    lo=so-0;ch=True;break
        later=[d for d in firstdef[r] if d>lo]
        lim=E[lo]
        if later: lim=min(lim,later[0]-1)
        L.append({'reg':r,'lo':lo+1,'lu':lu,'end':max(lu,lim),'d':d0,'roots':{rt},'lim':lim,'captured':any(u in pseudo for u in w['uses'])})
    # merge overlapping same-register locals
    byreg={}
    for x in L: byreg.setdefault(x['reg'],[]).append(x)
    L=[]
    for r,lst in byreg.items():
        lst.sort(key=lambda x:x['lo'])
        cur=None
        for x in lst:
            if cur and x['lo']<=cur['end']:
                cur['end']=max(cur['end'],x['end']);cur['lu']=max(cur['lu'],x['lu']);cur['roots']|=x['roots'];cur['lim']=max(cur.get('lim',0),x.get('lim',0));cur['captured']=cur['captured'] or x['captured']
            else:
                cur=dict(x);L.append(cur)
    for grp in groups:
        ents=[e for e in L if e['roots']&set(grp)]
        if len(ents)>1:
            hi=max(e['end'] for e in ents);lo_=min(e['lo'] for e in ents);lu_=max(e['lu'] for e in ents)
            for e in ents: e['end']=hi;e['lo']=lo_;e['lu']=lu_
    # stack-discipline normalization
    L.sort(key=lambda x:(x['lo'],x['reg']))
    # demote locals that live past the definition of a lower-register local (impossible in stack discipline)
    drop=set()
    for k,Y in enumerate(L):
        for X in L[:k]:
            if id(X) in drop: continue
            if X['reg']>Y['reg'] and X['lo']<=Y['lo']-1<=X['end'] and X['lu']>=Y['lo']-1:
                if X.get('captured'):
                    # try hoisting Y's declaration to an earlier dead 'local x' (LOADNIL)
                    cand=[v['defs'][0] for v in webs.values() if v['reg']==Y['reg'] and not v['uses'] and len(v['defs'])==1 and code[v['defs'][0]][0]=='LOADNIL' and v['defs'][0]<X['lo']-1 and v['defs'][0]<Y['lo']]
                    if cand:
                        Y['lo']=max(cand)+1
                else:
                    drop.add(id(X))
    L=[x for x in L if id(x) not in drop]
    for k,Y in enumerate(L):
        for X in L[:k]:
            if X['lo']<=Y['lo']-1<=X['end']:
                if X['reg']>=Y['reg']:
                    # X is dead once Y's register (or a lower one) starts
                    X['end']=max(X['lu'],min(X['end'],Y['lo']-2))
                else:
                    # Y must nest inside X
                    if Y['end']>X['end']:
                        Y['end']=max(Y['lu'],X['end'])
                        if Y['lu']>X['end']:
                            X['end']=Y['lu']
    out=[]
    import naming
    nm=naming.Namer(P)
    used=set(naming.KEYWORDS)|set(reserved)|set(getattr(P,'upnames',None) or [])
    ups=set(getattr(P,'upnames',None) or [])
    for r in range(P.nparams):
        pn='arg%d'%(r+1)
        while pn in ups: pn+='_'
        out.append((r,pn,0,n));used.add(pn)
    for x in sorted(L,key=lambda x:(x['lo'],x['reg'])):
        base=None
        try: base=nm.name_for(x['d'])
        except Exception: base=None
        if not base: base='v%d'%x['reg']
        name=base;k=1
        while name in used:
            k+=1;name='%s_%d'%(base,k)
        used.add(name)
        out.append((x['reg'],name,x['lo'],x['end']+1))
    return out

def fb_encode(x):
    if x<8: return x
    e=0
    while x>=16:
        x=(x+1)>>1;e+=1
    return ((e+1)<<3)|(x-8)

def patch_newtable(P,kidnups):
    webs,sites,targets,pseudo,uses,defs=infer(P,kidnups)
    code=P.code
    for w in webs.values():
        if len(w['defs'])!=1: continue
        d=w['defs'][0]
        if code[d][0]!='NEWTABLE': continue
        temp=is_temp(w,targets,code,pseudo,uses,defs)
        r=w['reg']
        narr=0;nh=0
        for pc in sorted(set(w['uses'])):
            op,A,B,C=code[pc]
            if op=='SETLIST' and A==r: narr+=B if B else 1
            elif op=='SETTABLE' and A==r: nh+=1
            else: break
        code[d][2]=fb_encode(min(narr,500))
        if temp: code[d][3]=fb_encode(min(nh,500))


def patch_deadcalls(P,kidnups):
    webs,sites,targets,pseudo,uses,defs=infer(P,kidnups)
    code=P.code;n=0
    for w in webs.values():
        if w['uses'] or len(w['defs'])!=1: continue
        d=w['defs'][0]
        if code[d][0]=='CALL' and code[d][3]==2:
            code[d][3]=1;n+=1
    return n
