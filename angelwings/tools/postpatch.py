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

import re
src=open('out_407.lua',encoding='utf-8').read()
src=re.sub(r'^[ \t]*local _unused\n','',src,flags=re.M)
src=src.replace('local _unused = ...','local _ = ...')
open('out_407.lua','w',encoding='utf-8').write(src)

# restore decrypted strings (protection stubs): decrypted by running the original decryptor functions
src=open('out_407.lua',encoding='utf-8').read()
repl=["https://cdn.hysteria.one/angelwings/angelwings_eva_img.png","https://cdn.hysteria.one/angelwings/trashtalk.txt","404","https://cdn.hysteria.one/angelwings/trashtalk2.txt","404"]
pat=re.compile(r'\(function\(\.\.\.\)\s*local L1_\d+\s*end\)\(("(?:[^"\\]|\\.)*")\)')
it=iter(repl)
def f(m): return '"%s"'%next(it)
src2,n=pat.subn(f,src)
print('decrypted-string sites restored:',n)
open('out_407.lua','w',encoding='utf-8').write(src2)

# hand-clean the one function that unluac could only emit in register style
src=open('out_407.lua',encoding='utf-8').read()
i=src.index("      local L0_2, L1_3, L2_4, L3_5\n")
j=src.index("\n    end\n",i)
m=re.search(r"L0_2 = (\w+)\n\s+L0_2 = L0_2\.enabled",src[i:j]); tbl=m.group(1)
m=re.search(r"L0_2 = (\w+)\n\s+L0_2 = L0_2\(\)",src[i:j]); chk=m.group(1)
m=re.search(r"elseif not (\w+)\(\) then",src[i:j]); chk2=m.group(1)
new=f"""      if not {tbl}.enabled:get() then
        return
      end
      if not {chk}() then
        return
      end
      local r, g, b, a
      if not client.current_threat() then
        r, g, b, a = 255, 255, 255, 200
      elseif not {chk2}() then
        r, g, b, a = 255, 10, 10, 255
      else
        r, g, b, a = 159, 202, 43, 255
      end
      renderer.indicator(r, g, b, a, "SHOT")
      return"""
src=src[:i]+new+src[j:]
open('out_407.lua','w',encoding='utf-8').write(src)
print('hand-cleaned SHOT indicator')

# PRELUDE: bundled offline assets + offline_http (taken verbatim from the original cracked loader)
orig=open('../aw2/angelwingsAD_PROD.lua','rb').read().split(b'\n')
start=[k for k,l in enumerate(orig) if l.startswith(b'local offline_asset_files=')][0]
end_=[k for k,l in enumerate(orig) if l.startswith(b'descriptors.main[')][0]
pre=b'\n'.join(orig[start:end_]).decode('utf-8','replace')
src=open('out_407.lua',encoding='utf-8').read()
if 'PRELUDE' not in src and not src.startswith('-- angelwings'):
    src=src.replace('local v0 = (...)\n','',1)
    src='-- angelwings: читаемая версия (декомпиляция). PRELUDE: ресурсы и offline_http из исходного загрузчика\n'+pre+'\ninstall_offline_resources()\n\n'+src
open('out_407.lua','w',encoding='utf-8').write(src)
print('prelude added')
