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
    # labels (jump targets)
    targets=set()
    for pc in range(n):
        for s in succ[pc]:
            if s!=pc+1 or code[pc][0] in('JMP',): targets.add(s)
    for pc in range(n):
        if code[pc][0] in('EQ','LT','LE','TEST','TESTSET'): targets.add(pc+2)
    return webs,sites,targets,pseudo,uses,defs

def is_temp(w,targets,code,pseudo,uses_,defs_):
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
    L=[]   # dicts: reg,lo,lu,end
    for w in webs.values():
        r=w['reg']
        if r<P.nparams: continue
        if any(code[d][0] in('FORLOOP','FORPREP','TFORLOOP') for d in w['defs']): continue
        if is_temp(w,targets,code,pseudo,uses,defs): continue
        lo=min(w['defs'])
        lu=max(w['defs']+w['uses'])
        later=[d for d in firstdef[r] if d>lo]
        lim=E[lo]
        if later: lim=min(lim,later[0]-1)
        L.append({'reg':r,'lo':lo+1,'lu':lu,'end':max(lu,lim),'d':lo})
    # merge overlapping same-register locals
    byreg={}
    for x in L: byreg.setdefault(x['reg'],[]).append(x)
    L=[]
    for r,lst in byreg.items():
        lst.sort(key=lambda x:x['lo'])
        cur=None
        for x in lst:
            if cur and x['lo']<=cur['end']:
                cur['end']=max(cur['end'],x['end']);cur['lu']=max(cur['lu'],x['lu'])
            else:
                cur=dict(x);L.append(cur)
    # stack-discipline normalization
    L.sort(key=lambda x:(x['lo'],x['reg']))
    for k,Y in enumerate(L):
        for X in L[:k]:
            if X['lo']<=Y['lo']<=X['end']:
                if X['reg']>=Y['reg']:
                    # X is dead once Y's register (or a lower one) starts
                    X['end']=max(X['lu'],min(X['end'],Y['lo']-1))
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
    for r in range(P.nparams):
        out.append((r,'arg%d'%(r+1),0,n));used.add('arg%d'%(r+1))
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
        if not is_temp(w,targets,code,pseudo,uses,defs): continue
        r=w['reg']
        narr=0;nh=0
        for pc in sorted(set(w['uses'])):
            op,A,B,C=code[pc]
            if op=='SETLIST' and A==r: narr+=B if B else 1
            elif op=='SETTABLE' and A==r: nh+=1
            else: break
        code[d][2]=fb_encode(min(narr,500));code[d][3]=fb_encode(min(nh,500))
