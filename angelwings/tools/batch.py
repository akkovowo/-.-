import sys,subprocess,os,concurrent.futures as cf,tempfile
sys.argv=['x']
from build import *
import asm
asm.VARFLAG=3
def wrap(fid):
    P=protos[fid];n=P.nups
    W=Proto();W.id=-1;W.consts=[];W.kids=[fid];W.nups=0;W.nparams=0;W.vararg=False
    code=[]
    if n: code.append(['LOADNIL',0,n-1,0])
    code.append(['CLOSURE',n,('KBX',0),0])
    for i in range(n): code.append(['MOVE',0,i,0])
    code.append(['RETURN',n,2,0]);code.append(['RETURN',0,1,0])
    W.code=code;W.maxstack=n+3
    return W
def one(fid):
    def ch(cid):
        if cid==fid: return encode(protos[fid],None,ch2)
        return encode(stub(cid,funcs[cid]),None,lambda c:b'')
    def ch2(cid): return encode(stub(cid,funcs[cid]),None,lambda c:b'')
    data=HEADER+encode(wrap(fid),None,ch)
    d='/tmp/claude-0/b'
    os.makedirs(d,exist_ok=True)
    p='%s/f%d.luac'%(d,fid)
    open(p,'wb').write(data)
    env=dict(os.environ,JAVA_TOOL_OPTIONS='')
    q=p+'.lua'
    rc=subprocess.run("JAVA_TOOL_OPTIONS= timeout 20 java -Xss256m -cp ../unluac-build2 unluac.Main %s 2>%s.err | head -c 3000000 > %s"%(p,p,q),shell=True).returncode
    out=open(q,'rb').read().decode('utf-8','replace')
    err=open(p+'.err').read()
    if len(out)>=3000000: return fid,'TIMEOUT/HUGE',''
    if 'Exception' in err: return fid,'EXC '+err.strip().split('\n')[0][:80],out
    c=subprocess.run(['luac5.1','-p',q],capture_output=True,text=True)
    if c.returncode!=0: return fid,'SYNTAX '+c.stderr.strip()[:100],out
    return fid,None,out
FIDS=[]
if __name__=='__main__':
    res={}
    with cf.ThreadPoolExecutor(8) as ex:
        for fid,err,out in ex.map(one,[f for f in (FIDS if FIDS else protos) if f not in fails]):
            res[fid]=(err,out)
    bad=[(f,e) for f,(e,o) in res.items() if e]
    print('total',len(res),'bad',len(bad))
    for b in bad[:40]: print(b)
    import pickle;pickle.dump(res,open('batch_res.pkl','wb'))
