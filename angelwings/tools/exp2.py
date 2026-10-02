import sys,subprocess,os,copy
FID=int(sys.argv[1]);mode=sys.argv[2]
sys.argv=['x']
from build import *
fid=FID
exec(open('one.py').read().split("def ch(cid)")[0].split("from build import *")[1])
P=protos[FID]
n=len(P.code)
if mode=='params': P.locvars=[(r,'arg%d'%(r+1),0,n-1) for r in range(P.nparams)]
elif mode=='params_n': P.locvars=[(r,'arg%d'%(r+1),0,n) for r in range(P.nparams)]
elif mode=='none': P.locvars=[]
def ch(cid):
    if cid==fid: return encode(protos[fid],None,ch2)
    return encode(stub(cid,funcs[cid]),None,lambda c:b'')
def ch2(cid): return encode(stub(cid,funcs[cid]),None,lambda c:b'')
open('/tmp/claude-0/one.luac','wb').write(HEADER+encode(wrap(fid),None,ch))
r=subprocess.run(['java','-Xss256m','-cp','../unluac-build2','unluac.Main','/tmp/claude-0/one.luac'],capture_output=True,text=True,env=dict(os.environ,JAVA_TOOL_OPTIONS=''))
print(r.stdout[:2500]);print(r.stderr[:300])
