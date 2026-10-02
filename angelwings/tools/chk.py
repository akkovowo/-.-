import subprocess,sys,collections
sys.argv=[sys.argv[0]]
from build import *
bad=[]
def enc_stub_children(fid):
    P=protos[fid]
    def ch(cid): return encode(stub(cid,funcs[cid]),None,lambda c:b'')
    return HEADER+encode(P,None,ch)
for fid in protos:
    data=enc_stub_children(fid)
    open('/tmp/claude-0/t.luac','wb').write(data)
    r=subprocess.run(['luac5.1','-l','/tmp/claude-0/t.luac'],capture_output=True,text=True)
    if r.returncode!=0: bad.append((fid,r.stderr.strip()[:80]))
print(len(bad));print(bad[:20])
