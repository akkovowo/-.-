-- angelwings: раздел config_cloud (декомпилировано, имена восстановлены эвристикой)
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
    local pcall_2 = pcall(json.stringify, arg1)
    if pcall(json.stringify, arg1) then
      do
        local pcall_2, pcall_3 = base64.encode, pcall(base64.encode, pcall_2, "KXsoAciaIvD82pElTFH5u0xRkN3eOwJM1SbPj6QBzLrmhyd9UW4ZGnVYgfCt7q+/=")
      end
      if pcall_3 then
        pcall_2 = string.gsub(pcall_2, "[%+%/%=]", {
          ["+"] = "z113Z",
          ["/"] = "z143Z",
          ["="] = "_"
        })
        pcall_2 = string.format("angelwings_%s", pcall_2)
        return true, pcall_2
      end
      return false, pcall_2
    end
    return false, pcall_2
  end
  function v18_2.decode(arg1)
    local v1, v2 = arg1:match("angelwings_([%w%+%/]+)(_*)")
    if v1 == nil then
      return false, "Config not supported"
    end
    local v3 = v2
    if v3 then
      v3 = string
      v3 = v3.rep
      v3 = v3("=", #v2)
    end
    v3 = v3 or ""
    v2 = v3
    v3 = string
    v3 = v3.gsub
    v3 = v3(v1, "z1%d3Z", {z113Z = "+", z143Z = "/"})
    local pcall_2 = pcall(base64.decode, v3 .. v2, "KXsoAciaIvD82pElTFH5u0xRkN3eOwJM1SbPj6QBzLrmhyd9UW4ZGnVYgfCt7q+/=")
    if pcall(base64.decode, v3 .. v2, "KXsoAciaIvD82pElTFH5u0xRkN3eOwJM1SbPj6QBzLrmhyd9UW4ZGnVYgfCt7q+/=") then
      do
        local pcall_2, pcall_3 = json.parse, pcall(json.parse, pcall_2)
      end
      if pcall_3 then
        return true, pcall_2
      end
      return false, pcall_2
    end
    return false, pcall_2
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

