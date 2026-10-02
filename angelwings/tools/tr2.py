from tr import *

DESC={}

def has_name_assign(stmts,name):
    r=walk(stmts,lambda n: n and n[0]=='assign' and any(t==('name',name) for t in n[1]),[])
    return bool(r)

class BT3(BT2):
    # ---- conditions
    def jump_if(s,cond,label,truth):
        c=cond
        while c[0]=='un' and c[1]=='not':
            c=c[2];truth=not truth
        if c[0]=='bin' and c[1] in('==','~=','<','<=','>','>='):
            op=c[1];a=c[2];b=c[3]
            if op=='~=': op='==';truth=not truth
            if op=='>': op='<';a,b=b,a
            if op=='>=': op='<=';a,b=b,a
            ra=s.rk(a,0);rb=s.rk(b,1)
            if isinstance(ra,tuple) and isinstance(rb,tuple):
                ra=s.reg(a,0)
            ins={'==':'EQ','<':'LT','<=':'LE'}[op]
            s.emit(ins,1 if truth else 0,ra,rb)
            s.emit('JMP',0,0,0,label);return
        r=s.reg(c,0)
        s.emit('TEST',r,0,1 if truth else 0)
        s.emit('JMP',0,0,0,label)
    def ifstmt(s,st):
        cl,el=st[1],st[2]
        if len(cl)!=1: raise Unsupported('elseif')
        cond=ev(cl[0][0],s.env,s.cx)
        th=cl[0][1]; el=el or []
        lt=label_of(th) if th else None
        le=label_of(el) if el else None
        if (th and lt is None) or (el and le is None): raise Unsupported('if body %s / %s'%([x[0] for x in th],[x[0] for x in el]))
        if lt and not le: s.jump_if(cond,lt,True)
        elif le and not lt: s.jump_if(cond,le,False)
        elif lt and le:
            s.jump_if(cond,lt,True);s.emit('GOTO',0,0,0,le)
    def retstmt(s,st):
        ex=st[1]
        vals=[ev(e,s.env,s.cx) for e in ex]
        if not vals:
            s.emit('RETURN',0,1,0);return
        if len(vals)==1 and vals[0][0]=='call':
            c=vals[0]
            s.docall(c,None,'multi')
            a=c[1][1]-1
            s.out[-1][0]='TAILCALL'
            s.emit('RETURN',a,0,0);return
        if len(vals)==1 and vals[0][0]=='UNPACK':
            lo,hi=vals[0][1],vals[0][2]
            if hi[0]=='K': s.emit('RETURN',lo[1]-1,hi[1]-lo[1]+2,0)
            elif hi[0]=='TOP': s.emit('RETURN',lo[1]-1,0,0)
            else: raise Unsupported('ret unpack hi')
            return
        regs=[]
        for v in vals:
            if v[0]!='R': raise Unsupported('ret non-reg %s'%(v,))
            regs.append(v[1])
        for j in range(1,len(regs)):
            if regs[j]!=regs[0]+j: raise Unsupported('ret non-consecutive')
        s.emit('RETURN',regs[0]-1,len(regs)+1,0)
    def loopmacro(s,st):
        raise Unsupported('loopmacro %s'%st[0])
    # ---- whole-block macros
    def run(s):
        out=s._run()
        i=0
        while i+1<len(out):
            x,y=out[i],out[i+1]
            if x[0]=='MOVE' and y[0]=='GETTABLE' and y[2]==x[2] and y[1]==x[1]-1 and x[2]!=x[1]:
                out[i:i+2]=[['SELF',y[1],x[2],y[3],None]]
            i+=1
        return out
    def _run(s):
        st=strip_close(s.stmts)
        s.close_thr=close_threshold(s.stmts)
        s.info=None
        s.env.pop('r',None)
        # prologue: Y = ({...}); for l=1,N do W[l]=Y[l] end   /  A = 1; j,x=pack(...); for p=1,N ...
        if st and st[0][0]=='assign' and st[0][2] and dp(st[0][2][0])==('table',[(None,('vararg',))]) :
            f0=[n for n in st if n[0]=='fornum']
            s.cx.nparams=dp(f0[0][3])[1] if f0 else 0
            s.info=('PROLOGUE',);return s.out
        if find_calls(st,'bind'): return s.m_closure(st)
        packs=walk(st,lambda n: n and n[0]=='assign' and len(n[2])==1 and n[2][0][0]=='call' and n[2][0][1]==('name','pack'),[])
        if packs:
            if packs[0][2][0][2]==[('vararg',)]:
                f0=[n for n in st if n[0]=='fornum']
                s.cx.nparams=dp(f0[0][3])[1] if f0 else 0
                s.cx.vararg=True
                return s.m_varargprep(st)
            return s.m_multicall(st)
        if has_name_assign(st,'G') and walk(dp(st),lambda n:n and n[0]=='assign' and n[1]==[('name','G')] and n[2][0][0]=='table',[]):
            return s.m_loopprep(st)
        if walk(st,lambda n:n and n[0]=='assign' and n[1]==[('name','Q')] and n[2][0][0]=='index' and n[2][0][1]==('name','G') ,[]) or \
           walk(st,lambda n:n and n[0]=='assign' and n[1]==[('name','Q')] and n[2][0][0]=='paren' and n[2][0][1][0]=='index' and n[2][0][1][1]==('name','G') ,[]):
            s.info=('POP',);return s.out
        if has_name_assign(st,'Q') and walk(dp(st),lambda n:n and n[0]=='assign' and n[1]==[('name','Q')] and n[2][0][0]=='bin' and n[2][0][1]=='+' and n[2][0][2]==('name','Q'),[]):
            return s.m_forhead(st)
        if walk(st,lambda n:n and n[0]=='call' and n[1]==('name','Q'),[]):
            return s.m_tfor(st)
        fn=walk(st,lambda n:n and n[0]=='fornum',[])
        if fn:
            f0=fn[0]
            body=f0[5]
            if body and body[0][0]=='assign':
                tg=body[0][1][0]
                if tg[0]=='index' and tg[1][0]=='name' and tg[1][1]=='z': return s.m_setlist(st)
                if tg[0]=='index' and tg[1] in(('name','W'),('paren',('name','W'))) and body[0][2][0][0] in('index',) and body[0][2][0][1] in (('name','x'),('paren',('name','x'))):
                    pass
            if body and body[0][0]=='assign' and body[0][2][0][0]=='paren' and False: pass
            if has_name_assign(body,'z') or find_calls(body,'x'): pass
            # vararg?
            if walk(f0,lambda n:n and n[0]=='index' and n[1]==('name','x'),[]) : return s.m_vararg(st)
            if body and body[0][0]=='assign' and body[0][1]==[('name','s')] and body[0][2]==[('name','z')]: return s.m_setlist2(st)
            if walk(f0,lambda n:n and n[0]=='assign' and n[1][0][0]=='index' and n[1][0][1] in (('name','z'),('paren',('name','z'))),[]): return s.m_setlist(st)
            if walk(f0,lambda n:n and n[0]=='assign' and n[2][0]==('nil',),[]): return s.m_loadnil(st)
        s.exec(st)
        if s.close_thr is not None and not any(i[0] in('RETURN','TAILCALL') for i in s.out):
            s.emit('CLOSE',s.close_thr-1,0,0)
        return s.out
    def m_closure(s,st):
        # find id, dest
        call=find_calls(st,'bind')[0]
        a0=call[2][0]
        cid=a0[2][1]
        # var assigned from bind
        dv=None
        for n in walk(st,lambda n:n and n[0]=='assign' and len(n[2])==1 and n[2][0]==call,[]):
            dv=n[1][0][1]
        dest=None
        for n in walk(st,lambda n:n and n[0]=='assign' and len(n[1])==1 and len(n[2])==1,[]):
            if n[2][0] in(('paren',('name',dv)),('name',dv)):
                dest=tgt_reg(n[1][0],{},s.cx)
        if dest is None: raise Unsupported('closure dest')
        s.emit('CLOSURE',dest-1,('P',cid),0)
        ups=DESC[cid]
        for (idx,kind) in ups:
            if kind in(0,1): s.emit('MOVE',0,idx-1,0)
            elif kind==2: s.emit('GETUPVAL',0,idx,0)
            else: raise Unsupported('upkind')
        s.cx.maxreg=max(s.cx.maxreg,dest)
        return s.out
    def m_varargprep(s,st):
        s.info=('PROLOGUE',)
        return s.out
    def m_vararg(s,st):
        # find base from first fornum: for p=A,(A+P) or for p=A,B
        f0=walk(st,lambda n:n and n[0]=='fornum',[])
        base=f0[0][2]
        if base[0]!='num': raise Unsupported('vararg base')
        a=base[1]
        top=walk(st,lambda n:n and n[0]=='assign' and n[1]==[('name','r')],[])
        # variable count?  look for  "(j - A)"
        if walk(st,lambda n:n and n[0]=='bin' and n[1]=='-' and n[2]==('name','j'),[]) or walk(st,lambda n:n and n[0]=='bin' and n[1]=='-' and n[2][0]=='paren' and n[2][1:]==('bin','-',('name','j'),('name','A')) if False else False,[]):
            s.emit('VARARG',a-1,0,0);s.top_out=('M',a);return s.out
        # fixed
        hi=f0[0][3]
        if hi[0]!='num': raise Unsupported('vararg fixed hi')
        n=hi[1]-a+1
        s.emit('VARARG',a-1,n+1,0)
        return s.out
    def m_loadnil(s,st):
        f0=walk(st,lambda n:n and n[0]=='fornum',[])[0]
        lo,hi=f0[2][1],f0[3][1]
        s.emit('LOADNIL',lo-1,hi-1,0);return s.out
    def m_setlist(s,st):
        # Y = a; P = off; z = W[a]; for p=1,n do z[(off+p)] = W[(a+p)] end
        a=None
        for n in st:
            if n[0]=='assign' and n[1]==[('name','Y')]: a=n[2][0][1]
        off=[n for n in st if n[0]=='assign' and n[1]==[('name','P')]][0][2][0][1]
        f0=[n for n in st if n[0]=='fornum'][0]
        hi=f0[3]
        while hi[0]=='paren': hi=hi[1]
        if hi[0]=='num': B=hi[1]
        elif hi[0]=='bin' and hi[1]=='-' and hi[2]==('name','r'): B=0
        else: raise Unsupported('setlist hi')
        C=off//50+1
        if off%50: raise Unsupported('setlist off')
        s.emit('SETLIST',a-1,B,C);return s.out
    def m_setlist2(s,st):
        a=s.env['Y'][1];off=s.env['P'][1]
        f0=[n for n in st if n[0]=='fornum'][0]
        B=dp(f0[3])[1]
        if off%50: raise Unsupported('setlist2 off')
        s.emit('SETLIST',a-1,B,off//50+1);return s.out
    def m_multicall(s,st):
        # find pack assignment
        idx=[i for i,n in enumerate(st) if n[0]=='assign' and len(n[2])==1 and n[2][0][0]=='call' and n[2][0][1]==('name','pack')][0]
        pk=st[idx][2][0]
        env=s.env
        c=ev(pk[2][0],env,s.cx)
        if c[0]!='call': raise Unsupported('pack arg')
        a=c[1][1]
        # results: find 'q = X' after
        qv=None;rest=st[idx+1:]
        for n in rest:
            if n[0]=='assign' and n[1]==[('name','q')]:
                qv=n[2][0]
        f0=[n for n in rest if n[0]=='fornum'][0]
        lo=f0[2][1]
        while qv[0]=='paren': qv=qv[1]
        if qv[0]=='num':
            hi=qv[1]
            nres=hi-a+1
            C=nres+1
        else:
            C=0
        s.docall(c,None,('n',nres) if C else 'multi')
        s.out[-1][3]=C
        if C==0: s.top_out=('M',a)
        return s.out
    def m_loopprep(s,st):
        # numeric: R=(W[a+2]+0); u=(W[a+1]+0); Q=(W[a]-R) ; generic: Q=W[a];u=W[a+1];R=W[a+2]
        gen=any(n[0]=='assign' and n[1]==[('name','r')] for n in st)
        regs=[]
        for n in st:
            if n[0]=='assign' and n[1] in([('name','Q')],):
                e=n[2][0]
                if gen:
                    k=ev(e,{}, s.cx);regs.append(k[1])
        if gen:
            a=regs[0]
            s.info=('TFORPREP',a)
        else:
            qn=[n for n in st if n[0]=='assign' and n[1]==[('name','Q')]][0][2][0]
            while qn[0]=='paren': qn=qn[1]
            a=ev(qn[2],{},s.cx)[1]
            s.info=('FORPREP',a)
        return s.out
    def m_forhead(s,st):
        # exit label & body var:  if(...) goto X ... (W)[a+3] = Q
        gt=walk(st,lambda n:n and n[0]=='goto',[])
        s.info=('FORHEAD',gt[0][1])
        return s.out
    def m_tfor(s,st):
        gt=walk(st,lambda n:n and n[0]=='goto',[])
        asg=walk(st,lambda n:n and n[0]=='assign' and len(n[2])==1 and n[2][0][0]=='call' and n[2][0][1]==('name','Q'),[])[0]
        nv=len(asg[1])
        a=[n for n in st if n[0]=='assign' and n[1]==[('name','Y')]][0][2][0][1]
        s.info=('TFOR',gt[0][1],a,nv)
        return s.out
