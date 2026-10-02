import re,sys,difflib
def segs(p):
    S=[];cur=[]
    for l in open(p,encoding='utf-8',errors='replace').read().split('\n'):
        if 'load_png' in l or 'delay_call(0' in l or 'offline_http.get' in l or 'config is created' in l: continue
        l=re.sub(r"(attempt to .*|bad argument.*)$","ERR",l)
        l=re.sub(r"^cb#\d+","cb#",l)
        cur.append(l)
        if l.startswith('cb#'): S.append(cur);cur=[]
    S.append(cur);return S
a=segs(sys.argv[1]);b=segs(sys.argv[2])
ha=['\n'.join(x) for x in a];hb=['\n'.join(x) for x in b]
sm=difflib.SequenceMatcher(None,ha,hb,autojunk=False)
n=int(sys.argv[3]) if len(sys.argv)>3 else 6
k=0
for tag,i1,i2,j1,j2 in sm.get_opcodes():
    if tag=='equal': continue
    k+=1
    print(tag,'orig',i1,i2,'text',j1,j2)
    if k<=n:
        for x in a[i1:i1+1]: print('  O:',x[0][:150] if x else '', '| len',len(x))
        for x in b[j1:j1+1]: print('  T:',x[0][:150] if x else '', '| len',len(x))
        # first differing line within first pair
        if i2>i1 and j2>j1:
            for p,q in zip(a[i1],b[j1]):
                if p!=q: print('   dO:',p[:160]);print('   dT:',q[:160]);break
