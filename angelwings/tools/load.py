"""Load lifted file -> {fid: Func}"""
import re,sys
from luap import parse
class Func:
    pass
def load(path):
    b=open(path,'rb').read()
    i=b.index(b'factories.main[2] =')
    # descriptors section
    desc={}
    for m in re.finditer(rb'descriptors\.main\[(\d+)\]=\{group="main",id=\d+,\[6\]=\{(.*?)\}\}\n',b[:i]):
        ups=[]
        for u in re.finditer(rb'\[(\d+)\]=\{\[2\]=(\d+),\[3\]=(\d+)\}',m.group(2)):
            ups.append((int(u.group(2)),int(u.group(3))))
        desc[int(m.group(1))]=ups
    ast=parse(b[i:])
    funcs={}
    for st in ast:
        if st[0]=='assign' and st[1][0][0]=='index' and st[1][0][1]==('index',('name','factories'),('str',b'main')):
            fid=st[1][0][2][1]
            fn=st[2][0]
            assert fn[0]=='func' and fn[1]==['f']
            ret=fn[2]
            assert len(ret)==1 and ret[0][0]=='return' and ret[0][1][0][0]=='func',fid
            inner=ret[0][1][0]
            body=inner[2]
            F=Func();F.id=fid;F.ups=desc.get(fid)
            # body: local, local, then label/do pairs
            assert body[0][0]=='local' and body[1][0]=='local'
            F.decl=(body[0],body[1])
            blocks=[];k=2
            while k<len(body):
                s=body[k]
                if s[0]=='label':
                    nxt=body[k+1]
                    assert nxt[0]=='do',(fid,nxt[0])
                    blocks.append((s[1],nxt[1]));k+=2
                else:
                    raise Exception('unexpected top stmt %s in %s'%(s[0],fid))
            F.blocks=blocks
            # maxstack
            m=body[0][2][0]
            assert m[0]=='call' and m[1]==('name','new_table')
            F.nregs=m[2][0][1]
            funcs[fid]=F
    return funcs,desc
if __name__=='__main__':
    f,d=load(sys.argv[1]);print(len(f),len(d),sum(len(x.blocks) for x in f.values()))
    nodesc=[k for k in f if f[k].ups is None]; print('no desc',len(nodesc),nodesc[:10])
