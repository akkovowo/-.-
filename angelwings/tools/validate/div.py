import re,difflib
def segs(p):
    S=[];cur=[]
    for l in open(p,encoding='utf-8',errors='replace').read().split('\n'):
        if False: continue
        cur.append(l)
        if l.startswith('cb#'): S.append(cur);cur=[]
    S.append(cur);return S
a=segs('orig2.log');b=segs('text.log')
def n(x): return ['\n'.join(re.sub(r"(attempt to .*|bad argument.*|table index is nil)$","ERR",re.sub(r"^cb#\d+","cb#",l)) for l in s) for s in x]
sm=difflib.SequenceMatcher(None,n(a),n(b),autojunk=False)
cbl={}
for l in open('text.err'):
    if l.startswith('CBL'):
        _,i,ln=l.split();cbl[int(i)]=int(ln)
for tag,i1,i2,j1,j2 in sm.get_opcodes():
    if tag=='equal': continue
    A=a[i1:i2];B=b[j1:j2]
    print(tag,'seg',j1,'textline',cbl.get(j1+1),'O_end:',A[0][-1][:50] if A else '-','| T_end:',B[0][-1][:60] if B else '-')
    if A and B:
        for p,q in zip(A[0],B[0]):
            if p!=q: print('    O:',p[:100]);print('    T:',q[:100]);break
print('--- multiset check')
from collections import Counter
for tag,i1,i2,j1,j2 in sm.get_opcodes():
    if tag=='equal': continue
    A=Counter(l for s in a[i1:i2] for l in s if not l.startswith('cb#'));B=Counter(l for s in b[j1:j2] for l in s if not l.startswith('cb#'))
    print('seg',j1,'same-multiset' if A==B else 'DIFF: only-orig=%d only-text=%d'%(sum((A-B).values()),sum((B-A).values())))
    if A!=B:
        for l,c in list((A-B).items())[:2]: print('   O+',l[:120])
        for l,c in list((B-A).items())[:2]: print('   T+',l[:120])
