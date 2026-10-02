import sys,subprocess,os
FID=int(sys.argv[1]);sys.argv=['x']
from build import *
fid=FID
def wrap(fid):
    P=protos[fid]
    n=P.nups
    W=Proto();W.id=-1;W.consts=[];W.kids=[fid];W.nups=0;W.nparams=0;W.vararg=False
    code=[]
    if n: code.append(['LOADNIL',0,n-1,0])
    code.append(['CLOSURE',n,('KBX',0),0])
    for i in range(n): code.append(['MOVE',0,i,0])
    code.append(['RETURN',n,2,0]);code.append(['RETURN',0,1,0])
    W.code=code;W.maxstack=n+3
    return W
def ch(cid):
    if cid==fid: return encode(protos[fid],None,ch2)
    return encode(stub(cid,funcs[cid]),None,lambda c:b'')
def ch2(cid): return encode(stub(cid,funcs[cid]),None,lambda c:b'')
data=HEADER+encode(wrap(fid),None,ch)
open('/tmp/claude-0/one.luac','wb').write(data)
env=dict(os.environ);env['JAVA_TOOL_OPTIONS']=''
r=subprocess.run(['java','-Xss256m','-cp','../unluac-build2','unluac.Main','/tmp/claude-0/one.luac'],capture_output=True,text=True,env=env)
print(r.stdout);print(r.stderr[:500])
