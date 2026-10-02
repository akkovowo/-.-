local loader = assert(loadfile('head2.lua'))
local env = setmetatable({}, {__index = _G})
env.getfenv = function() return env end
setfenv(loader, env)
local bind, descriptors = loader()
local encs = dofile('enc.lua')
for _, id in ipairs({126, 254, 281}) do
  local ok, fn = pcall(bind, descriptors.main[id], {})
  if ok then
    setfenv(fn, env)
    for _, e in ipairs(encs) do
      local ok2, r = pcall(fn, e[2])
      if ok2 and type(r) == 'string' then
        io.write('fn ', id, ' line ', e[1], ': ', (r:gsub('[^%g ]', function(c) return string.format('\\%d', c:byte()) end)), '\n')
      else
        io.write('fn ', id, ' line ', e[1], ': ERR ', tostring(r):sub(1,60), '\n')
      end
    end
  else io.write('bind ', id, ' failed ', tostring(fn), '\n') end
end
