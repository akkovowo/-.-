import time,json,re
from luap import parse
t0=time.time()
b=open('../aw2/angelwingsAD_PROD.lua','rb').read()
i=b.index(b'factories.main[2] =')
# parse the whole function section as chunk (factories.main[N]=function(f) ... end are assignments)
ast=parse(b[i:])
print(len(ast),time.time()-t0)
