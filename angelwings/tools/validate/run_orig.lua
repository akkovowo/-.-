package.path = './?.lua;' .. package.path
local M = dofile('mock.lua')
local f = assert(loadfile(arg[1]))
setfenv(f, M.env)
local FS = {}
M.env.readfile = function(p) return FS[p] end
M.env.writefile = function(p, b) FS[p] = b end
M.env.install_offline_resources = nil
local ok, err = xpcall(f, function(e) return e .. "\n" .. debug.traceback() end)
io.stderr:write('result: ', tostring(ok), ' ', tostring(err), '\n')
local k = 0
local i = 1
while M.cbs[i] and i < 4000 do
  local info = debug.getinfo(M.cbs[i], 'S')
  if info.linedefined < 159100 and info.linedefined > 60 then
  k = k + 1

  local ok2, e2 = pcall(M.cbs[i], M.mk('event'), M.mk('arg2'), M.mk('arg3'))
  M.log[#M.log + 1] = 'cb#' .. k .. ' -> ' .. tostring(ok2) .. ' ' .. (ok2 and '' or tostring(e2):gsub('^[^:]*:%d+: ', ''))
  end
  i = i + 1
end
local out = io.open(arg[2], 'w')
for _, l in ipairs(M.log) do out:write(l, '\n') end
out:close()
