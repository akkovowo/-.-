import sys,subprocess,os,re,concurrent.futures as cf
sys.argv=['x']
import batch
from batch import *
def undeclared(fid):
    """decompile single fid; return (text, set of locvar names that appear as globals)"""
    fid_,err,out=batch.one(fid)
    q='/tmp/claude-0/b/f%d.luac.lua'%fid
    if err and not err.startswith('SYNTAX'): return err,None
    r=subprocess.run(['luac5.1','-l','-l',q],capture_output=True,text=True)
    gl=set(re.findall(r'(?:GETGLOBAL|SETGLOBAL)\s.*;\s*(\S+)\s*$',r.stdout,flags=re.M))
    names={l[1] for l in getattr(protos[fid],"locvars",[])}
    return err,gl&names
def repair(rounds=3):
    todo=[f for f in protos if f not in fails]
    for rd in range(rounds):
        bad={}
        with cf.ThreadPoolExecutor(8) as ex:
            for f,(err,u) in zip(todo,ex.map(undeclared,todo)):
                if u: bad[f]=u
        print('round',rd,'functions with undeclared locals:',len(bad))
        if not bad: break
        for f,u in bad.items():
            P=protos[f];n=len(P.code)
            new=[]
            for reg,name,st,en in getattr(P,"locvars",[]):
                if name in u: st=min(st,1);en=n-1
                new.append((reg,name,st,en))
            P.locvars=new
        todo=list(bad)
    return
if __name__=='__main__':
    repair()
    import pickle
    pickle.dump({f:getattr(P,"locvars",[]) for f,P in protos.items()},open('locvars_repaired.pkl','wb'))
