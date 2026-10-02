import re,sys
src=open('out_407.lua',encoding='utf-8').read()
ALPH="KXsoAciaIvD82pElTFH5u0xRkN3eOwJM1SbPj6QBzLrmhyd9UW4ZGnVYgfCt7q+/="
enc='''  function {T}.encode(arg1)
    local ok, json_str = pcall(json.stringify, arg1)
    if not ok then
      return false, json_str
    end
    local ok2, b64 = pcall(base64.encode, json_str, "%s")
    if not ok2 then
      return false, b64
    end
    b64 = string.gsub(b64, "[%%+%%/%%=]", {
      ["+"] = "z113Z",
      ["/"] = "z143Z",
      ["="] = "_"
    })
    return true, string.format("angelwings_%%s", b64)
  end
''' % ALPH
dec='''  function {T}.decode(arg1)
    local body, pad = arg1:match("angelwings_([%%w%%+%%/]+)(_*)")
    if body == nil then
      return false, "Config not supported"
    end
    if pad then
      pad = string.rep("=", #pad)
    end
    pad = pad or ""
    body = string.gsub(body, "z1%%d3Z", {z113Z = "+", z143Z = "/"})
    local ok, decoded = pcall(base64.decode, body .. pad, "%s")
    if not ok then
      return false, decoded
    end
    local ok2, data = pcall(json.parse, decoded)
    if ok2 then
      return true, data
    end
    return false, data
  end
''' % ALPH
m=re.search(r'  function (\w+)\.encode\(arg1\)\n',src)
T=m.group(1)
def repl(name,new):
    global src
    i=src.index('  function %s.%s('%(T,name))
    j=src.index('\n  function %s.'%T,i+10)
    src=src[:i]+new.replace('{T}',T)+src[j+1:]
repl('encode',enc);repl('decode',dec)
open('out_407.lua','w',encoding='utf-8').write(src)
print('patched',T)
