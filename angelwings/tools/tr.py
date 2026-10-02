"""Translate lifted blocks -> Lua 5.1 instructions (symbolic, 0-based regs)."""
import re,copy
class Unsupported(Exception): pass

def K(v): return ('K',v)
def R(k): return ('R',k)

def dp(e):
    """remove paren wrappers recursively"""
    if isinstance(e,tuple):
        if e and e[0]=='paren': return dp(e[1])
        return tuple(dp(x) for x in e)
    if isinstance(e,list): return [dp(x) for x in e]
    return e

def strip_close(stmts):
    """remove open-upvalue closing loops: forin over next,a ; collapse if(not a) duplicates"""
    out=[]
    for s in stmts:
        t=s[0]
        if t=='forin' and len(s[2])==2 and s[2][0]==('name','next') and s[2][1]==('name','a'):
            continue
        if t=='if':
            cl=[(c,strip_close(b)) for c,b in s[1]]
            el=strip_close(s[2]) if s[2] is not None else None
            s=('if',cl,el)
            # collapse: if (not a) then X else X end  (or if a then X else X)
            if len(cl)==1 and el is not None and cl[0][1]==el and dp(cl[0][0]) in (('un','not',('name','a')),('name','a')):
                out.extend(el);continue
            # if a then (empty) else (empty)
            if len(cl)==1 and dp(cl[0][0]) in (('un','not',('name','a')),('name','a')) and not cl[0][1] and not el:
                continue
        elif t=='do':
            s=('do',strip_close(s[1]))
        out.append(s)
    return out

def close_threshold(stmts):
    """find threshold N in (X >= N) of the closing loop; returns None if none"""
    found=[]
    def walk(x):
        if isinstance(x,tuple):
            if x and x[0]=='forin' and len(x[2])==2 and x[2][0]==('name','next') and x[2][1]==('name','a'):
                def w2(y):
                    if isinstance(y,tuple):
                        if len(y)==4 and y[0]=='bin' and y[1] in('>=','<') and y[3][0]=='num': found.append((y[1],y[3][1]))
                        for z in y: w2(z)
                    elif isinstance(y,list):
                        for z in y: w2(z)
                w2(x)
            else:
                for y in x: walk(y)
        elif isinstance(x,list):
            for y in x: walk(y)
    walk(stmts)
    return found[0][1] if found else None

class Ctx:
    def __init__(s,F):
        s.F=F;s.nregs=F.nregs;s.tmp0=F.nregs  # temp regs start (1-based W idx => 0-based reg nregs.. )
        s.maxreg=F.nregs
        s.vararg=False;s.nparams=0;s.env={};s.rkset=set()

class Blk:
    pass

def norm_cond(e):
    while e[0]=='paren': e=e[1]
    return e

def ev(e,env,cx):
    """evaluate AST expr to symbolic value"""
    t=e[0]
    if t=='paren': return ev(e[1],env,cx)
    if t=='num': return ('K',e[1])
    if t=='str': return ('K',e[1])
    if t=='nil': return ('K',None)
    if t=='true': return ('K',True)
    if t=='false': return ('K',False)
    if t=='vararg': return ('VARARG',)
    if t=='name':
        n=e[1]
        if n in env: 
            v=env[n]
            if v[0]=='DEAD': raise Unsupported('dead env %s'%n)
            return v
        if n=='W': return ('Wt',)
        if n=='v': return ('ENV',)
        if n=='f': return ('UPS',)
        if n=='r': return ('TOP',)
        if n in('error','offline_http'): return ('G',n.encode())
        return ('S',n)
    if t=='index':
        o=ev(e[1],env,cx);k=ev(e[2],env,cx)
        return mkindex(o,k)
    if t=='call':
        fn=e[1]
        if fn[0]=='name' and fn[1]=='unpack':
            a=e[2]
            w=ev(a[0],env,cx)
            if w!=('Wt',): raise Unsupported('unpack nonW')
            lo=ev(a[1],env,cx);hi=ev(a[2],env,cx) if len(a)>2 else None
            return ('UNPACK',lo,hi)
        if fn[0]=='name' and fn[1]=='pack':
            return ('PACK',[ev(x,env,cx) for x in e[2]])
        f=ev(fn,env,cx)
        return ('call',f,[ev(x,env,cx) for x in e[2]])
    if t=='bin':
        return ('bin',e[1],ev(e[2],env,cx),ev(e[3],env,cx))
    if t=='un':
        return ('un',e[1],ev(e[2],env,cx))
    if t=='table':
        return ('table',[(None if k is None else ev(k,env,cx),ev(v,env,cx)) for k,v in e[1]])
    raise Unsupported('expr %s'%t)

API={'regs':set(),'ups':set(),'names':{}}

def mkindex(o,k):
    if k[0]=='K' and isinstance(k[1],(int,float)) and int(k[1])==k[1] and ((o[0]=='R' and o[1] in API['regs']) or (o[0]=='UP' and o[1] in API['ups'])):
        nm=API['names'].get(int(k[1]))
        if nm: return ('APIFN',nm)
    if o==('Wt',):
        if k[0]=='K' and isinstance(k[1],(int,float)):
            if k[1]==0: return ('K',None)
            return ('R',int(k[1]))
        raise Unsupported('W dyn index %s'%(k,))
    if o==('ENV',):
        if k[0]=='K' and isinstance(k[1],bytes): return ('G',k[1])
        raise Unsupported('ENV dyn')
    if o==('UPS',):
        if k[0]=='K' and isinstance(k[1],int): return ('UP',k[1])
        raise Unsupported('UPS dyn')
    if o[0]=='UP' and k[0]=='K' and k[1] in (2,3): return ('UPC%d'%k[1],o[1])
    if o[0]=='UPC3' and k[0]=='UPC2' and k[1]==o[1]: return ('UPCELL',o[1])
    if o==('S','x') and k==('S','L'): return ('VARARG1',)
    return ('idx',o,k)

# ---------- block translation ----------
OPS_ARITH={'+':'ADD','-':'SUB','*':'MUL','/':'DIV','%':'MOD','^':'POW'}

class BT:
    """translate one block into instruction list"""
    def __init__(s,cx,F,blkname,stmts):
        s.cx=cx;s.F=F;s.name=blkname;s.out=[];s.env=cx.env;s.stmts=stmts
        s.top_out=None  # None=unchanged, int = fixed top register, ('M',a) multi from reg a
    # --- helpers
    def emit(s,op,A=0,B=0,C=0,lbl=None):
        i=[op,A,B,C,lbl];s.out.append(i);return i
    def tmpreg(s,n=0):
        r=s.cx.nregs+n   # 0-based index of first temp (W idx nregs+1)
        s.cx.maxreg=max(s.cx.maxreg,r+n+2)
        return r
    def const(s,v):
        return ('K',v)
    def rk(s,v,tmpn=0):
        """return operand (reg int or ('K',c)) loading into temp if needed"""
        if v[0]=='R': return v[1]-1
        if v[0]=='K':
            key=(type(v[1]).__name__,v[1])
            rs=s.cx.rkset
            if key in rs or len(rs)<250:
                rs.add(key);return v
            r=s.tmpreg(tmpn)
            s.load(r,v);return r
        r=s.tmpreg(tmpn)
        s.load(r,v,avoid=None)
        return r
    def reg(s,v,tmpn=0):
        """value into a register, returns reg (0-based)"""
        if v[0]=='R': return v[1]-1
        r=s.tmpreg(tmpn)
        s.load(r,v)
        return r
    def load(s,d,v,avoid=None):
        """load symbolic value v into 0-based register d"""
        t=v[0]
        if t=='R':
            if v[1]-1!=d: s.emit('MOVE',d,v[1]-1)
        elif t=='K':
            c=v[1]
            if c is None: s.emit('LOADNIL',d,d)
            elif c is True: s.emit('LOADBOOL',d,1,0)
            elif c is False: s.emit('LOADBOOL',d,0,0)
            else: s.emit('LOADK',d,('K',c))
        elif t=='APIFN':
            lib,mem=v[1].split('.',1)
            s.emit('GETGLOBAL',d,('K',lib.encode()))
            s.emit('GETTABLE',d,d,s.rk(('K',mem.encode()),1))
        elif t=='G': s.emit('GETGLOBAL',d,('K',v[1]))
        elif t=='UP': s.emit('GETUPVAL',d,v[1])
        elif t=='UPCELL': s.emit('GETUPVAL',d,v[1])
        elif t=='idx':
            o=v[1];k=v[2]
            if o[0]=='R': ob=o[1]-1
            else:
                ob=d if not s.uses_reg(k,d) else s.tmpreg(1)
                s.load(ob,o)
            kk=s.rk(k,2)
            s.emit('GETTABLE',d,ob,kk)
        elif t=='bin' and v[1] in OPS_ARITH:
            a=s.rk(v[2],1);b=s.rk(v[3],2)
            s.emit(OPS_ARITH[v[1]],d,a,b)
        elif t=='bin' and v[1]=='..':
            ops=s.flatten_concat(v)
            base=s.tmpreg(0)
            for i,x in enumerate(ops):
                s.load(base+i,x)
            s.cx.maxreg=max(s.cx.maxreg,base+len(ops)+1)
            s.emit('CONCAT',d,base,base+len(ops)-1)
        elif t=='un':
            if v[1]=='-': s.emit('UNM',d,s.reg(v[2],1))
            elif v[1]=='not': s.emit('NOT',d,s.reg(v[2],1))
            elif v[1]=='#': s.emit('LEN',d,s.reg(v[2],1))
            else: raise Unsupported('un '+v[1])
        elif t=='table' and not v[1]:
            s.emit('NEWTABLE',d,0,0)
        elif t=='bin' and v[1] in('==','~=','<','<=','>','>='):
            # value of comparison: emit  cmp; jmp; loadbool; loadbool
            s.cmp_value(d,v)
        else:
            raise Unsupported('load %s'%(t,))
    def uses_reg(s,v,d):
        if isinstance(v,tuple):
            if v and v[0]=='R' and v[1]-1==d: return True
            return any(s.uses_reg(x,d) for x in v)
        if isinstance(v,list): return any(s.uses_reg(x,d) for x in v)
        return False
    def flatten_concat(s,v):
        if v[0]=='bin' and v[1]=='..':
            # right assoc
            return [v[2]]+s.flatten_concat(v[3])
        return [v]
    def cmp_value(s,d,v):
        s.cx.nlab=getattr(s.cx,'nlab',0)+1
        lt=('LOC',s.cx.nlab)
        s.jump_if(v,lt,True)
        s.emit('LOADBOOL',d,0,1)
        s.emit('LABEL',0,0,0,lt)
        s.emit('LOADBOOL',d,1,0)

def walk(x,pred,out):
    if isinstance(x,tuple):
        if pred(x): out.append(x)
        for y in x: walk(y,pred,out)
    elif isinstance(x,list):
        for y in x: walk(y,pred,out)
    return out

def find_calls(stmts,name):
    return walk(stmts,lambda n: n and n[0]=='call' and n[1]==('name',name),[])

def is_W(e):
    while e[0]=='paren': e=e[1]
    return e==('name','W')

def tgt_reg(t,env,cx):
    """if assignment target is a W register return 1-based index"""
    if t[0]=='index':
        o=t[1]
        while o[0]=='paren': o=o[1]
        if o[0]=='name' and (o[1]=='W' or (o[1] in env and env[o[1]]==('Wt',))):
            k=ev(t[2],env,cx)
            if k[0]=='K' and isinstance(k[1],int): return k[1]
            raise Unsupported('W tgt dyn')
    return None

def label_of(body):
    """return label if body is exactly [goto L]"""
    if len(body)==1 and body[0][0]=='goto': return body[0][1]
    return None

class BT2(BT):
    def run(s):
        st=strip_close(s.stmts)
        thr=close_threshold(s.stmts)
        s.close_thr=thr
        s.exec(st)
        return s.out
    def exec(s,stmts):
        i=0
        while i<len(stmts):
            st=stmts[i]
            s.stmt(st,stmts[i+1:])
            i+=1
    # ----
    def stmt(s,st,rest):
        t=st[0]
        cx=s.cx
        if t=='local':
            # 'local p = N' dummies (close markers)
            for n,e in zip(st[1],st[2]):
                s.env[n]=ev(e,s.env,cx)
            return
        if t=='assign':
            return s.assign(st)
        if t=='callstmt':
            return s.callstmt(st[1])
        if t=='if': return s.ifstmt(st)
        if t=='return': return s.retstmt(st)
        if t=='goto':
            s.emit('GOTO',0,0,0,st[1]);return
        if t=='fornum' or t=='forin': return s.loopmacro(st)
        if t=='do':
            return s.exec(st[1])
        raise Unsupported('stmt '+t)
    def assign(s,st):
        tg,ex=st[1],st[2]
        cx=s.cx
        if len(tg)==1 and len(ex)==1:
            t=tg[0];e=ex[0]
            # bind closure
            if e[0]=='call' and e[1]==('name','bind'):
                return s.closure(t,e)
            if t[0]=='name':
                s.env[t[1]]=ev(e,s.env,cx)
                return
            k=tgt_reg(t,s.env,cx)
            if k is not None:
                return s.setreg(k,e)
            return s.store(t,e)
        # multi assign:  q, d = nil ; q,d = pack(...)
        if len(ex)==1 and ex[0]==('nil',) :
            for t in tg:
                if t[0]!='name': raise Unsupported('multi-nil')
                s.env[t[1]]=('K',None)
            return
        if len(ex)==1 and ex[0][0]=='call' and ex[0][1]==('name','pack'):
            return s.packcall(tg,ex[0])
        if len(tg)==len(ex) and all(t[0]=='name' for t in tg):
            vals=[ev(e,s.env,cx) for e in ex]
            for t,v in zip(tg,vals): s.env[t[1]]=v
            return
        raise Unsupported('multi assign')
    def kill(s,k):
        for n,v in list(s.env.items()):
            if s.uses_reg(v,k-1): s.env[n]=('DEAD',)
    def setreg(s,k,e):
        v=ev(e,s.env,s.cx)
        d=k-1
        if v[0] in('VARARG','VARARG1'):
            s.emit('VARARG',d,2,0);s.kill(k);return
        if v[0]=='call' and v[1]==('S','new_table'):
            s.emit('NEWTABLE',d,0,0);s.kill(k);return
        # call?
        if v[0]=='call':
            s.docall(v,k,'single');s.kill(k);return
        s.load(d,v)
        s.kill(k)
        s.cx.maxreg=max(s.cx.maxreg,k)
    def docall(s,c,dest,mode,ret_top=False):
        """c=('call',fn,args). dest=1-based result register or None."""
        fn=c[1];args=c[2]
        if fn[0]!='R':
            base=s.cx.nregs+1
            s.load(base-1,fn)
            args2=[]
            for j,x in enumerate(args):
                if x[0]=='UNPACK': raise Unsupported('call mat unpack')
                s.load(base+j,x)
            s.cx.maxreg=max(s.cx.maxreg,base+len(args)+2)
            s.emit('CALL',base-1,len(args)+1,{'single':2,'stmt':1,'multi':0}.get(mode,1))
            return 1
        a=fn[1]
        n=0;multi=False
        flat=[]
        for j,x in enumerate(args):
            if x[0]=='UNPACK':
                if j!=len(args)-1: raise Unsupported('unpack not last')
                lo=x[1];hi=x[2]
                if lo[0]!='K': raise Unsupported('unpack lo')
                if hi is None: raise Unsupported('unpack no hi')
                if hi[0]=='K':
                    for r in range(lo[1],hi[1]+1): flat.append(('R',r))
                elif hi==('TOP',) or hi[0]=='TOP':
                    multi=True
                    for r in range(lo[1],a+1+ (0)): pass
                    flat.append(('TOPFROM',lo[1]))
                else:
                    raise Unsupported('unpack hi %s'%(hi,))
            else: flat.append(x)
        # check consecutive
        regs=[]
        for j,x in enumerate(flat):
            if x[0]=='TOPFROM':
                if x[1]!=a+1+j: raise Unsupported('topfrom pos')
                multi=True;break
            if x!=('R',a+1+j): raise Unsupported('call args not consecutive: %s at %d (a=%d)'%(x,j,a))
        nargs=len([x for x in flat if x[0]!='TOPFROM'])
        B=0 if multi else nargs+1
        if mode=='single': C=2
        elif mode=='stmt': C=1
        elif mode=='multi': C=0
        elif isinstance(mode,tuple) and mode[0]=='n': C=mode[1]+1
        if dest is not None and dest!=a: raise Unsupported('call dest != fn reg')
        s.emit('CALL',a-1,B,C)
        return C
    def callstmt(s,e):
        v=ev(e,s.env,s.cx)
        if v[0]!='call': raise Unsupported('callstmt')
        s.docall(v,None,'stmt')
    def store(s,t,e):
        cx=s.cx
        if t[0]!='index': raise Unsupported('store tgt')
        val=ev(e,s.env,cx)
        o=ev(t[1],s.env,cx);k=ev(t[2],s.env,cx)
        # upvalue cell store: Y[3][Y[2]] = val
        full=mkindex(o,k)
        if full[0]=='UPCELL':
            s.emit('SETUPVAL',s.reg(val,0),full[1]);return
        if full[0]=='G':
            s.emit('SETGLOBAL',s.reg(val,0),('K',full[1]));return
        if full[0]!='idx': raise Unsupported('store kind %s'%(full[0],))
        o,k=full[1],full[2]
        ob=s.reg(o,1)
        kk=s.rk(k,2)
        vv=s.rk(val,0)
        s.emit('SETTABLE',ob,kk,vv)

