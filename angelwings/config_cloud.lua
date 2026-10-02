-- angelwings: раздел config_cloud (декомпилировано; имена восстановлены эвристикой)
-- Локальные (vNN, ...) объявлены в angelwings_full.lua выше по файлу

-- ===== блок 33 =====
local v18_2 = {}
do
  local v19_3 = {}
  local v20_3 = {}
  local v21 = {}
  v21[0] = "Always on"
  v21[1] = "On hotkey"
  v21[2] = "Toggle"
  v21[3] = "Off hotkey"
  local v22 = function(arg1)
    local v1 = {}
    if arg1 ~= nil then
      for _FORV_5_ = 1, #arg1 do
        v1[arg1[_FORV_5_]] = _FORV_5_
      end
    end
    return v1
  end
  function v18_2.push(arg1, arg2, arg3)
    if v20_3[arg1] == nil then
      v20_3[arg1] = {}
    end
    local v3 = {}
    v3.tab = arg1
    v3.name = arg2
    v3.item = arg3
    if v20_3[arg1][arg2] ~= nil then
      print(string.format("found copy %s - %s", arg1, arg2))
    end
    v20_3[arg1][arg2] = arg3
    table.insert(v19_3, v3)
    return arg3
  end
  function v18_2.encode(arg1)
    local ok, json_str = pcall(json.stringify, arg1)
    if not ok then
      return false, json_str
    end
    local ok2, b64 = pcall(base64.encode, json_str, "KXsoAciaIvD82pElTFH5u0xRkN3eOwJM1SbPj6QBzLrmhyd9UW4ZGnVYgfCt7q+/=")
    if not ok2 then
      return false, b64
    end
    b64 = string.gsub(b64, "[%+%/%=]", {
      ["+"] = "z113Z",
      ["/"] = "z143Z",
      ["="] = "_"
    })
    return true, string.format("angelwings_%s", b64)
  end
  function v18_2.decode(arg1)
    local body, pad = arg1:match("angelwings_([%w%+%/]+)(_*)")
    if body == nil then
      return false, "Config not supported"
    end
    if pad then
      pad = string.rep("=", #pad)
    end
    pad = pad or ""
    body = string.gsub(body, "z1%d3Z", {z113Z = "+", z143Z = "/"})
    local ok, decoded = pcall(base64.decode, body .. pad, "KXsoAciaIvD82pElTFH5u0xRkN3eOwJM1SbPj6QBzLrmhyd9UW4ZGnVYgfCt7q+/=")
    if not ok then
      return false, decoded
    end
    local ok2, data = pcall(json.parse, decoded)
    if ok2 then
      return true, data
    end
    return false, data
  end
  function v18_2.import(arg1, arg2)
    if arg1 == nil then
      return
    end
    local v22_2 = v22(arg2)
    for _FORV_6_, _FORV_7_ in pairs(arg1) do
      local v8 = v20_3[_FORV_6_]
      do
        local v9
        v9 = v8 ~= nil
        if v9 then
          v9 = arg2 == nil
          if not v9 then
            v9 = v22_2[_FORV_6_]
            v9 = v9 ~= nil
          end
        end
      end
      if v9 then
        for _FORV_13_, _FORV_14_ in pairs(_FORV_7_) do
          local v15 = v8[_FORV_13_]
          if v15 ~= nil then
            v15:set(unpack(_FORV_14_))
          end
        end
      end
    end
    return
  end
  function v18_2.export(arg1)
    local v1 = {}
    local v22_2 = v22(arg1)
    for _FORV_6_, _FORV_7_ in pairs(v20_3) do
      do
        local v8
        v8 = arg1 == nil
        if not v8 then
          v8 = v22_2[_FORV_6_]
          v8 = v8 ~= nil
        end
      end
      if v8 then
        local v9 = {}
        for _FORV_13_, _FORV_14_ in pairs(_FORV_7_) do
          if _FORV_14_.type ~= "hotkey" then
            v9[_FORV_13_] = {
              _FORV_14_:get()
            }
          else
            v9[_FORV_13_] = {
              v21[_FORV_14_:get()],
              _FORV_14_:get()
            }
          end
        end
        v1[_FORV_6_] = v9
      end
    end
    return v1
  end
end

