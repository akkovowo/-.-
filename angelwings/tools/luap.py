"""Minimal Lua 5.1/LuaJIT(goto) parser -> tuple AST. Strings are kept as bytes."""
import re
KW={'and','break','do','else','elseif','end','false','for','function','goto','if','in','local','nil','not','or','repeat','return','then','true','until','while'}
TOK=re.compile(rb'''
 (?P<ws>\s+|--\[(?P<ceq>=*)\[.*?\](?P=ceq)\]|--[^\n]*)
|(?P<num>0[xX][0-9a-fA-F]+|\d+\.?\d*(?:[eE][+-]?\d+)?|\.\d+(?:[eE][+-]?\d+)?)
|(?P<name>[A-Za-z_][A-Za-z_0-9]*)
|(?P<lstr>\[(?P<eq>=*)\[)
|(?P<str>"(?:[^"\\\n]|\\.|\\\n)*"|'(?:[^'\\\n]|\\.|\\\n)*')
|(?P<op>\.\.\.|\.\.|==|~=|<=|>=|::|[-+*/%^#<>=(){}\[\];:,.])
''',re.X|re.S)
ESC={b'n':b'\n',b't':b'\t',b'r':b'\r',b'a':b'\a',b'b':b'\b',b'f':b'\f',b'v':b'\v',b'\\':b'\\',b'"':b'"',b"'":b"'",b'\n':b'\n'}
def unesc(s):
    s=s[1:-1]
    if b'\\' not in s: return s
    out=bytearray();i=0
    while i<len(s):
        c=s[i:i+1]
        if c!=b'\\': out+=c;i+=1;continue
        i+=1;c=s[i:i+1]
        if c.isdigit():
            j=i
            while j<i+3 and s[j:j+1].isdigit(): j+=1
            out.append(int(s[i:j])&255);i=j
        elif c==b'x':
            out.append(int(s[i+1:i+3],16));i+=3
        elif c==b'z':
            i+=1
            while s[i:i+1].isspace(): i+=1
        else:
            out+=ESC.get(c,c);i+=1
    return bytes(out)
def tokenize(b):
    pos=0;toks=[]
    n=len(b)
    while pos<n:
        m=TOK.match(b,pos)
        if not m: raise SyntaxError('bad char %r at %d'%(b[pos:pos+20],pos))
        pos=m.end();k=m.lastgroup
        if k=='ws': continue
        v=m.group()
        if k=='lstr':
            eq=m.group('eq');close=b']'+eq+b']'
            e=b.index(close,pos)
            body=b[pos:e];pos=e+len(close)
            if body[:1]==b'\r': body=body[1:]
            if body[:1]==b'\n': body=body[1:]
            toks.append(('str',body));continue
        if k=='name': toks.append(('kw' if v.decode() in KW else 'name',v.decode()))
        elif k=='num':
            t=v.decode()
            toks.append(('num',int(t,16) if t[:2].lower()=='0x' else (int(t) if re.fullmatch(r'\d+',t) else float(t))))
        elif k=='str': toks.append(('str',unesc(v)))
        else: toks.append(('op',v.decode()))
    toks.append(('eof',None))
    return toks
BIN={'or':(1,1),'and':(2,2),'<':(3,3),'>':(3,3),'<=':(3,3),'>=':(3,3),'~=':(3,3),'==':(3,3),'..':(5,4),'+':(6,6),'-':(6,6),'*':(7,7),'/':(7,7),'%':(7,7),'^':(10,9)}
UNP=8
class P:
    def __init__(s,b): s.t=tokenize(b);s.i=0
    def pk(s): return s.t[s.i]
    def nx(s): x=s.t[s.i];s.i+=1;return x
    def isop(s,v): t=s.t[s.i];return t[0] in('op','kw') and t[1]==v
    def acc(s,v):
        if s.isop(v): s.i+=1;return True
        return False
    def exp(s,v):
        if not s.acc(v): raise SyntaxError('expected %s got %s'%(v,s.pk()))
    def name(s):
        t=s.nx()
        if t[0]!='name': raise SyntaxError('name expected %s'%(t,))
        return t[1]
    def block(s):
        out=[]
        while True:
            t=s.pk()
            if t[0]=='eof' or (t[0]=='kw' and t[1] in('end','else','elseif','until')): return out
            if s.isop('return'):
                s.i+=1;ex=[]
                if not(s.pk()[0]=='eof' or (s.pk()[0]=='kw' and s.pk()[1] in('end','else','elseif','until')) or s.isop(';')): ex=s.exlist()
                s.acc(';');out.append(('return',ex));continue
            st=s.stmt()
            if st: out.append(st)
    def stmt(s):
        if s.acc(';'): return None
        if s.acc('::'):
            n=s.name();s.exp('::');return ('label',n)
        if s.acc('goto'): return ('goto',s.name())
        if s.acc('break'): return ('break',)
        if s.acc('do'):
            b=s.block();s.exp('end');return ('do',b)
        if s.acc('while'):
            c=s.ex();s.exp('do');b=s.block();s.exp('end');return ('while',c,b)
        if s.acc('repeat'):
            b=s.block();s.exp('until');c=s.ex();return ('repeat',b,c)
        if s.acc('if'):
            cl=[];c=s.ex();s.exp('then');cl.append((c,s.block()));els=None
            while True:
                if s.acc('elseif'):
                    c=s.ex();s.exp('then');cl.append((c,s.block()))
                elif s.acc('else'): els=s.block()
                else: break
            s.exp('end');return ('if',cl,els)
        if s.acc('for'):
            n1=s.name()
            if s.acc('='):
                a=s.ex();s.exp(',');b=s.ex();c=None
                if s.acc(','): c=s.ex()
                s.exp('do');body=s.block();s.exp('end');return ('fornum',n1,a,b,c,body)
            names=[n1]
            while s.acc(','): names.append(s.name())
            s.exp('in');ex=s.exlist();s.exp('do');body=s.block();s.exp('end');return ('forin',names,ex,body)
        if s.acc('function'):
            n=('name',s.name())
            while s.isop('.') or s.isop(':'):
                if s.acc('.'): n=('index',n,('str',s.name().encode()))
                else: s.i+=1;n=('index',n,('str',s.name().encode()))
            f=s.funcbody();return ('assign',[n],[f])
        if s.acc('local'):
            if s.acc('function'):
                n=s.name();return ('local',[n],[s.funcbody()])
            names=[s.name()];
            while s.acc(','): names.append(s.name())
            ex=s.exlist() if s.acc('=') else []
            return ('local',names,ex)
        e=s.suffixed()
        if s.isop('=') or s.isop(','):
            tg=[e]
            while s.acc(','): tg.append(s.suffixed())
            s.exp('=');return ('assign',tg,s.exlist())
        if e[0] not in('call','mcall'): raise SyntaxError('stmt expected call %s'%(e,))
        return ('callstmt',e)
    def funcbody(s):
        s.exp('(');ps=[]
        if not s.isop(')'):
            while True:
                if s.acc('...'): ps.append('...');break
                ps.append(s.name())
                if not s.acc(','): break
        s.exp(')');b=s.block();s.exp('end');return ('func',ps,b)
    def exlist(s):
        l=[s.ex()]
        while s.acc(','): l.append(s.ex())
        return l
    def primary(s):
        t=s.nx()
        if t[0]=='name': return ('name',t[1])
        if t==('op','('):
            e=s.ex();s.exp(')');return ('paren',e)
        raise SyntaxError('unexpected %s'%(t,))
    def suffixed(s):
        e=s.primary()
        while True:
            if s.acc('.'): e=('index',e,('str',s.name().encode()))
            elif s.acc('['):
                k=s.ex();s.exp(']');e=('index',e,k)
            elif s.acc(':'):
                n=s.name();a=s.callargs();e=('mcall',e,n,a)
            elif s.isop('(') or s.isop('{') or s.pk()[0]=='str':
                e=('call',e,s.callargs())
            else: return e
    def callargs(s):
        t=s.pk()
        if t[0]=='str': s.i+=1;return [('str',t[1])]
        if s.isop('{'): return [s.table()]
        s.exp('(')
        if s.acc(')'): return []
        l=s.exlist();s.exp(')');return l
    def table(s):
        s.exp('{');it=[]
        while not s.isop('}'):
            if s.acc('['):
                k=s.ex();s.exp(']');s.exp('=');it.append((k,s.ex()))
            elif s.pk()[0]=='name' and s.t[s.i+1]==('op','='):
                k=s.name();s.i+=1;it.append((('str',k.encode()),s.ex()))
            else: it.append((None,s.ex()))
            if not(s.acc(',') or s.acc(';')): break
        s.exp('}');return ('table',it)
    def simple(s):
        t=s.pk()
        if t[0]=='num': s.i+=1;return ('num',t[1])
        if t[0]=='str': s.i+=1;return ('str',t[1])
        if t[0]=='kw' and t[1] in('nil','true','false'): s.i+=1;return (t[1],)
        if s.acc('...'): return ('vararg',)
        if s.isop('{'): return s.table()
        if s.acc('function'): return s.funcbody()
        return s.suffixed()
    def ex(s,lim=0):
        t=s.pk()
        if (t[0]=='kw' and t[1]=='not') or t in(('op','-'),('op','#')):
            s.i+=1;a=s.ex(UNP);l=('un',t[1],a)
        else: l=s.simple()
        while True:
            t=s.pk();op=t[1] if t[0] in('op','kw') else None
            if op in BIN and BIN[op][0]>lim:
                s.i+=1;r=s.ex(BIN[op][1]);l=('bin',op,l,r)
            else: return l
def parse(b):
    p=P(b);r=p.block()
    assert p.pk()[0]=='eof',p.pk()
    return r
