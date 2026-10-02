import re
KEYWORDS={'and','break','do','else','elseif','end','false','for','function','goto','if','in','local','nil','not','or','repeat','return','then','true','until','while'}
def sanitize(s,maxlen=28):
    if isinstance(s,bytes): s=s.decode('utf-8','replace')
    s=re.sub(r'([a-z0-9])([A-Z])',r'\1_\2',s)
    s=re.sub(r'[^A-Za-z0-9]+','_',s).strip('_').lower()
    if not s: return None
    if s[0].isdigit(): s='n_'+s
    return s[:maxlen].strip('_')

class Namer:
    def __init__(s,P,consts_of=None):
        s.P=P;s.code=P.code
    def kstr(s,v):
        return v[1] if isinstance(v,tuple) and v[0]=='K' else None
    def src(s,reg,pc):
        """nearest earlier instruction (<pc) that defines reg, within 60 instrs, straight-line"""
        c=s.code
        for k in range(pc-1,max(-1,pc-80),-1):
            op,A,B,C=c[k]
            if op in('MOVE','LOADK','LOADBOOL','GETUPVAL','GETGLOBAL','GETTABLE','NEWTABLE','CLOSURE','ADD','SUB','MUL','DIV','MOD','POW','UNM','NOT','LEN','CONCAT') and A==reg: return k
            if op=='CALL' and A<=reg<A+max(C-1,1): return k
            if op=='SELF' and A in(reg,reg-1): return k
            if op=='LOADNIL' and A<=reg<=B: return k
        return None
    def const(s,idx):
        return s.P.consts[idx]
    def describe(s,reg,pc,depth=0):
        """string path of what reg holds before pc (e.g. 'ui.reference'), or None"""
        if depth>4: return None
        k=s.src(reg,pc)
        if k is None: return None
        op,A,B,C=s.code[k]
        if op=='GETGLOBAL': return s.const(B[1]).decode('utf-8','replace') if isinstance(s.const(B[1]),bytes) else None
        if op=='GETUPVAL':
            un=getattr(s.P,'upnames',None)
            return un[B] if un and B<len(un) else None
        if op=='GETTABLE':
            base=s.describe(B,k,depth+1)
            key=None
            if isinstance(C,int) and C>=256:
                kv=s.P.consts[C-256]
                key=kv.decode('utf-8','replace') if isinstance(kv,bytes) else str(kv)
            if base and key: return base+'.'+key
            return key
        if op=='MOVE': return s.describe(B,k,depth+1)
        return None
    def argconst(s,reg,pc):
        k=s.src(reg,pc)
        if k is None: return None
        op,A,B,C=s.code[k]
        if op=='LOADK':
            return s.const(B[1])
        return None
    def name_for(s,d):
        c=s.code[d];op,A,B,C=c
        if op=='CALL':
            fn=s.describe(A,d)
            args=[]
            nargs=(B-1) if B else 0
            for i in range(1,nargs+1): args.append(s.argconst(A+i,d))
            if fn:
                last=fn.split('.')[-1]
                if fn=='require' and args and isinstance(args[0],bytes): return sanitize(args[0].split(b'/')[-1])
                if fn=='ui.reference' and len(args)>=3 and isinstance(args[2],bytes): return sanitize(args[2])+'_ref'
                if fn.startswith('ui.new_') and args and isinstance(args[-1],bytes):
                    return (sanitize(args[-1]) or 'item')+'_'+fn[len('ui.new_'):]
                if fn=='vector': return 'vec'
                if fn=='entity.get_prop' and len(args)>=2 and isinstance(args[1],bytes):
                    p=re.sub(r'^m_(vec|fl|i|b|n|h|a|s|ang|u|sz|e)?','',args[1].decode('utf-8','replace'))
                    return sanitize(p)
                if fn=='entity.get_local_player': return 'me'
                if fn.endswith('.new') or last in('new','create'): return None
                if last.startswith('get_'): last=last[4:]
                if last.startswith('is_'): return last
                nm=sanitize(last)
                if nm in('get','call','set'): return None
                return nm
            return None
        if op=='GETGLOBAL':
            v=s.const(B[1]);return sanitize(v)
        if op=='GETUPVAL':
            un=getattr(s.P,'upnames',None)
            return sanitize(un[B]) if un and B<len(un) and not re.match(r'^(up|r)\d+$',un[B]) else None
        if op=='GETTABLE':
            if isinstance(C,int) and C>=256:
                kv=s.P.consts[C-256]
                if isinstance(kv,bytes): return sanitize(kv)
            return None
        if op=='SELF':
            return None
        if op=='MOVE':
            return None
        if op=='LOADK':
            v=s.const(B[1])
            if isinstance(v,bytes) and len(v)<=24: return sanitize(v)
            return None
        if op=='NEWTABLE': return None
        if op in('ADD','SUB','MUL','DIV','MOD','POW'): return {'ADD':'sum','SUB':'diff','MUL':'prod','DIV':'ratio','MOD':'rem','POW':'pow'}[op]
        if op=='CONCAT': return 'str'
        if op=='LEN': return 'len'
        return None
