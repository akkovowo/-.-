package.path = './?.lua;' .. package.path
local M = dofile('mock.lua')
local f = assert(loadfile(arg[1]))
setfenv(f, M.env)
local game_api = {}
for i = 1, 179 do
  local ns, mem = M.apinames[i]:match('^([^.]+)%.(.+)$')
  game_api[i] = M.env[ns][mem]
end
local ok, err = xpcall(function() return f(game_api) end, function(e) return tostring(e) .. "\n" .. debug.traceback() end)
io.stderr:write('result: ', tostring(ok), ' ', tostring(err), '\n')
local i = 1
while M.cbs[i] and i < 4000 do
  local ok2, e2 = pcall(M.cbs[i], M.mk('event'), M.mk('arg2'), M.mk('arg3'))
  local di = debug.getinfo(M.cbs[i], 'S')
  io.stderr:write('CBL ', i, ' ', di.linedefined, '\n'); M.log[#M.log + 1] = 'cb#' .. i .. ' -> ' .. tostring(ok2) .. ' ' .. (ok2 and '' or tostring(e2):gsub('^[^:]*:%d+: ', ''))
  i = i + 1
end
local out = io.open(arg[2], 'w')
for _, l in ipairs(M.log) do out:write(l, '\n') end
out:close()
