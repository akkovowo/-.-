-- generic recording mock environment
local LOG = {}
local CBS = {}
local CBSEEN = {}
local function collect(...)
  for j = 1, select('#', ...) do local a = select(j, ...); if type(a) == 'function' and not CBSEEN[a] then CBSEEN[a] = true; CBS[#CBS + 1] = a end end
end
local function fmt(v)
  local t = type(v)
  if t == 'string' then return '"' .. v:gsub('[^%w ]', function(c) return '\\' .. string.format('%03d', c:byte()) end) .. '"'
  elseif t == 'number' or t == 'boolean' or t == 'nil' then return tostring(v)
  elseif t == 'table' and rawget(v, '__name') then return '<' .. v.__name .. '>'
  elseif t == 'table' then
    local parts = {}
    local n = 0
    for k, x in pairs(v) do n = n + 1 end
    return '{table#' .. n .. '}'
  elseif t == 'function' then return 'function'
  else return t end
end
local counter = 0
local mk
local mt = {}
local function newproxy_(name)
  counter = counter + 1
  local p = setmetatable({__name = name, __id = counter}, mt)
  return p
end
mk = newproxy_
mt.__index = function(t, k)
  local v = rawget(t, k)
  if v ~= nil then return v end
  local name = rawget(t, '__name') .. '.' .. tostring(k)
  local c = mk(name)
  rawset(t, k, c)
  return c
end
mt.__newindex = function(t, k, v)
  LOG[#LOG + 1] = 'set ' .. rawget(t, '__name') .. '.' .. tostring(k) .. ' = ' .. fmt(v)
  rawset(t, k, v)
end
mt.__call = function(t, ...)
  local args = {}
  local n = select('#', ...)
  collect(...)
  for i = 1, n do args[#args + 1] = fmt((select(i, ...))) end
  LOG[#LOG + 1] = 'call ' .. rawget(t, '__name') .. '(' .. table.concat(args, ',') .. ')'
  -- call callbacks? no. return a proxy for the result
  return mk(rawget(t, '__name') .. '()')
end
local function arith(op) return function(a, b)
  return mk('(' .. fmt(a) .. op .. fmt(b) .. ')') end end
mt.__add = arith('+'); mt.__sub = arith('-'); mt.__mul = arith('*'); mt.__div = arith('/'); mt.__mod = arith('%'); mt.__pow = arith('^')
mt.__unm = function(a) return mk('-' .. fmt(a)) end
mt.__concat = function(a, b) return mk(fmt(a) .. '..' .. fmt(b)) end
mt.__len = function(a) return 3 end
mt.__lt = function(a, b) return false end
mt.__le = function(a, b) return true end
mt.__eq = function(a, b) return rawget(a, '__id') == rawget(b, '__id') end
mt.__tostring = function(a) return '<' .. rawget(a, '__name') .. '>' end

local root = {}
local envmt = {}
local genv = setmetatable({}, {__index = function(t, k)
  if k == 'getfenv' or k == 'setfenv' or k == 'pcall' or k == 'type' or k == 'tostring' or k == 'tonumber' or k == 'pairs' or k == 'ipairs' or k == 'next' or k == 'select' or k == 'unpack' or k == 'rawget' or k == 'rawset' or k == 'rawequal' or k == 'setmetatable' or k == 'getmetatable' or k == 'error' or k == 'assert' or k == 'loadstring' or k == 'string' or k == 'table' or k == 'math' then
    return _G[k]
  end
  local c = mk(tostring(k))
  rawset(t, k, c)
  return c
end})
local apinames = {}
for line in io.lines('apinames.txt') do
  local i, n = line:match('^(%d+) (.+)$')
  apinames[tonumber(i)] = n
end
local libs = {}
for i = 1, 179 do
  local ns, mem = apinames[i]:match('^([^.]+)%.(.+)$')
  libs[ns] = libs[ns] or {}
  libs[ns][mem] = function(...)
    local args = {}
    collect(...)
    for j = 1, select('#', ...) do args[#args + 1] = fmt((select(j, ...))) end
    LOG[#LOG + 1] = 'call ' .. apinames[i] .. '(' .. table.concat(args, ',') .. ')'
    return mk(apinames[i] .. '()')
  end
end
for ns, tbl in pairs(libs) do
  if ns ~= 'string' and ns ~= 'table' and ns ~= 'math' then
    rawset(genv, ns, setmetatable(tbl, {__index = function(t, k) local c = mk(ns .. '.' .. k); rawset(t, k, c); return c end}))
  end
end
-- keep real string/table/math/etc so code logic works
local function isproxy(v) return type(v) == 'table' and rawget(v, '__name') ~= nil end
local function wrapLib(lib)
  local w = {}
  for k, f in pairs(lib) do
    if type(f) == 'function' then
      w[k] = function(...)
        local n = select('#', ...)
        local r = {pcall(f, ...)}
        if r[1] then return unpack(r, 2, #r) end
        for _, sub in ipairs({1, ''}) do
          local a = {...}
          for i = 1, n do if isproxy(a[i]) or (a[i] == nil and i > 1) then a[i] = sub end end
          local r2 = {pcall(f, unpack(a, 1, n))}
          if r2[1] then return unpack(r2, 2, #r2) end
        end
        do local d = {} for i = 1, n do local x = select(i, ...) d[#d+1] = type(x) .. ':' .. (type(x)=='table' and tostring(rawget(x,'__name')) or tostring(x)) end io.stderr:write('FAIL ', k, ' ', table.concat(d, ' | '), '\n') end
        error(k .. ': ' .. tostring(r[2]) .. ' args=' .. tostring(select('#', ...)), 2)
      end
    else w[k] = f end
  end
  return w
end
genv.string = wrapLib(string); genv.table = wrapLib(table); genv.math = wrapLib(math)
local realtostring, realtonumber = tostring, tonumber
genv.tostring = function(v) return realtostring(v) end
genv.tonumber = function(v, b) if isproxy(v) then return 1 end return realtonumber(v, b) end
genv._G = genv
genv.os = nil
genv.require = function(name) LOG[#LOG + 1] = 'require ' .. name; return mk('require:' .. name) end
genv.offline_http = mk('offline_http')
genv._USER_NAME = 'offline'; genv._SCRIPT_NAME = 'angelwings angel'
genv.getfenv = function() return genv end
genv.setfenv = function(f, e) return f end
genv.pcall = function(f, ...)
  local r = {pcall(f, ...)}
  LOG[#LOG + 1] = 'pcall ' .. tostring(r[1])
  return unpack(r)
end

return {cbs = CBS, env = genv, log = LOG, mk = mk, fmt = fmt, apinames = apinames}
