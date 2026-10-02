import sys,collections
from load import load
from tr import *
from tr2 import *
funcs,desc=load('../aw2/angelwingsAD_PROD.lua')
fails=collections.Counter();ex={}
ok=0;tot=0
for fid,F in funcs.items():
    cx=Ctx(F)
    for bi,(lab,stmts) in enumerate(F.blocks):
        tot+=1
        b=BT3(cx,F,lab,stmts)
        try:
            b.run();ok+=1
        except Unsupported as e:
            k=str(e)[:80];fails[k]+=1;ex.setdefault(k,(fid,lab))
        except Exception as e:
            k='EXC '+type(e).__name__+' '+str(e)[:60];fails[k]+=1;ex.setdefault(k,(fid,lab))
print(ok,tot)
for k,v in fails.most_common(40): print(v,k,ex[k])
