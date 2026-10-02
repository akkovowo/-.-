import sys,traceback
from load import load
from asm import *
funcs,desc=load('../aw2/angelwingsAD_PROD.lua')
import tr2
tr2.DESC.update(desc)
import re as _re,tr
_src=open('../aw2/angelwingsAD_PROD.lua','rb').read()
_m=_src.index(b'local api_names')
tr.API['names']={int(a):c.decode() for a,c in _re.findall(rb'\[(\d+)\]="([^"]+)"',_src[_m:_m+9000])}
print('api names',len(tr.API['names']))
# parent map and api propagation
parent={}
for _fid,_F in funcs.items():
    for _lab,_st in _F.blocks:
        for _c in find_calls(_st,'bind'):
            _a0=_c[2][0]
            parent[_a0[2][1]]=_fid
for _F in funcs.values(): _F.api_regs=set();_F.api_ups=set()
funcs[407].api_regs={1}
def _prop(fid):
    for cid,p in parent.items():
        if p!=fid: continue
        C=funcs[cid]
        for j,(s_,k_) in enumerate(desc[cid]):
            if (k_ in(0,1) and s_ in funcs[fid].api_regs) or (k_==2 and s_ in funcs[fid].api_ups):
                C.api_ups.add(j)
        _prop(cid)
_prop(407)
protos={};fails={}
for fid,F in funcs.items():
    try: protos[fid]=translate2(F,None,{c:len(desc[c]) for c in desc})
    except Unsupported as e: fails[fid]=str(e)
    except Exception as e: fails[fid]='EXC '+repr(e)
print(len(protos),len(fails),'fused',getattr(__import__('asm'),'FUSED_TOTAL',0));print(list(fails.items())[:10])

def stub(fid,F):
    P=Proto();P.id=fid;P.code=[['RETURN',0,1,0]];P.consts=[];P.kids=[];P.nups=len(F.ups);P.nparams=0;P.vararg=True;P.maxstack=2
    return P
for fid in fails: protos[fid]=stub(fid,funcs[fid])
import locals as LV
import naming as _naming
GLOBALS=set()
for _P in protos.values():
    for _i in _P.code:
        if _i[0] in('GETGLOBAL','SETGLOBAL'):
            _c=_P.consts[_i[2][1]]
            if isinstance(_c,bytes): GLOBALS.add(_c.decode('utf-8','replace'))
def process_tree():
    kn={fid:P.nups for fid,P in protos.items()}
    for fid,P in protos.items():
        if fid in fails: P.locvars=[];continue
        LV.patch_newtable(P,kn)
    def lname(P,reg,pc):
        best=None
        for (r,nm,st,en) in getattr(P,'locvars',[]):
            if r==reg and st<=pc<=en: best=nm
        return best or 'r%d'%reg
    def go(fid):
        P=protos[fid]
        if not hasattr(P,'upnames') or P.upnames is None: P.upnames=['up%d'%i for i in range(P.nups)]
        if fid in FALLBACK:
            P.locvars=[(r,'arg%d'%(r+1),0,len(P.code)-1) for r in range(P.nparams)]
        elif fid not in fails:
            L=LV.make_locals(P,kn,None,GLOBALS)
            nn=len(P.code)
            P.locvars=[(reg,name,min(st,nn-1),min(en,nn-1)) for reg,name,st,en in L]
        for pc,ins in enumerate(P.code):
            if ins[0]=='CLOSURE':
                cid=P.kids[ins[2][1]]
                C=protos[cid]
                names=[]
                for j in range(C.nups):
                    pi=P.code[pc+1+j]
                    if pi[0]=='MOVE': names.append(lname(P,pi[2],pc))
                    else: names.append(P.upnames[pi[2]] if pi[2]<len(P.upnames) else 'up%d'%pi[2])
                C.upnames=names
                go(cid)
    go(407)
FALLBACK=[169,188]
process_tree()
def child(cid):
    return encode(protos[cid],None,child)
def chunk(root):
    protos[root].nups=0;protos[root].upnames=[]
    return HEADER+encode(protos[root],None,child)
if __name__=='__main__':
    root=int(sys.argv[1]) if len(sys.argv)>1 else 407
    import asm as _asm
    open('out_%d.luac'%root,'wb').write(chunk(root))
    _asm.VARFLAG=3
    open('out_%d_dec.luac'%root,'wb').write(chunk(root))
    _asm.VARFLAG=2
