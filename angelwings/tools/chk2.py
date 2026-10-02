import sys
sys.argv=[sys.argv[0]]
from build import *
def check(P,funcs):
    errs=[]
    n=len(P.code)
    def reg(i,r,what):
        if not(0<=r<P.maxstack): errs.append((i,'reg %s=%s >= maxstack %s'%(what,r,P.maxstack)))
    if P.code[-1][0]!='RETURN': errs.append((n-1,'last not RETURN'))
    for i,(op,A,B,C) in enumerate(P.code):
        if op in('EQ','LT','LE','TEST','TESTSET'):
            if i+1>=n or P.code[i+1][0]!='JMP': errs.append((i,'cond not followed by JMP'))
        if op in('JMP','FORLOOP','FORPREP'):
            d=i+1+B
            if not(0<=d<n): errs.append((i,'jump out of range %d'%d))
        if op=='GETUPVAL' or op=='SETUPVAL':
            u=B if op=='GETUPVAL' else B
            if not(0<=u<P.nups): errs.append((i,'upval %s >= nups %s'%(u,P.nups)))
        if op=='CLOSURE':
            cid=P.kids[B[1]];nu=len(funcs[cid].ups)
            for j in range(1,nu+1):
                if i+j>=n or P.code[i+j][0] not in('MOVE','GETUPVAL'): errs.append((i,'closure pseudo-ops missing'))
        if op in('MOVE','GETTABLE','SELF','UNM','NOT','LEN'): 
            reg(i,A,'A'); reg(i,B,'B')
        if op in('CALL','TAILCALL'):
            reg(i,A,'A')
            if B: reg(i,A+B-1,'B')
            if C>1: reg(i,A+C-2,'C')
        if op in('LOADK','LOADBOOL','NEWTABLE','GETGLOBAL','SETGLOBAL','GETUPVAL','SETUPVAL','VARARG'): reg(i,A,'A')
        if op=='CONCAT':
            if not(B<C): errs.append((i,'concat b>=c'))
            reg(i,C,'C')
        if op in('FORLOOP','FORPREP'): reg(i,A+3,'A+3')
        if op=='TFORLOOP': reg(i,A+C+2,'tfor')
        if op in('SETTABLE',): reg(i,A,'A')
        if op in('ADD','SUB','MUL','DIV','MOD','POW'):
            reg(i,A,'A')
            if B<256: reg(i,B,'B')
            if C<256: reg(i,C,'C')
        if op in('GETTABLE','SETTABLE'):
            for v in (B,C):
                if isinstance(v,int) and v<256: reg(i,v,'rk')
        if op in('EQ','LT','LE'):
            for v in (B,C):
                if v<256: reg(i,v,'rk')
        if op=='RETURN' and B>1: reg(i,A+B-2,'ret')
        if op in('CALL','RETURN','SETLIST') and not (P.code[i-1][0]=='TAILCALL') and ((op!='RETURN' and B==0) or (op=='RETURN' and B==0) or (op=='SETLIST' and B==0)):
            pv=P.code[i-1] if i>0 else None
            if not pv or not ((pv[0]=='CALL' and pv[3]==0) or (pv[0]=='VARARG' and pv[2]==0)): errs.append((i,'open op without producer (prev=%s)'%(pv,)))
    return errs
if __name__=='__main__':
    import collections
    cnt=collections.Counter();ex={}
    for fid,P in protos.items():
        if fid in fails: continue
        for e in check(P,funcs):
            k=e[1].split(' ')[0]+' '+e[1].split(' ')[1] if ' ' in e[1] else e[1]
            cnt[e[1][:40]]+=1;ex.setdefault(e[1][:40],(fid,e[0]))
    for k,v in cnt.most_common(30): print(v,k,ex[k])
