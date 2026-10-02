-- angelwings: раздел visuals (декомпилировано, имена восстановлены эвристикой)
-- Локальные ссылки вида vNN/arg1 могут быть объявлены в основном файле angelwings_full.lua

-- ===== блок 48 =====
local v34_6 = {}
do
  local v35_5 = function(arg1)
    if arg1 > 0 then
      return 1
    end
    if not (arg1 < 0) then
      return 0
    end
    return -1
  end
  local v36_3 = function(arg1, arg2, arg3)
    local v3 = {}
    local v4 = 1
    local v5 = {}
    ;({})[1] = arg1[1]
    ;({})[2] = arg1[2]
    ;({})[3] = arg1[3]
    ;({})[4] = arg1[4]
    for _FORV_9_ = 1, 4 do
      v3[v4] = tonumber(("%.0f"):format(v5[_FORV_9_] + arg3 * (arg2[_FORV_9_] - arg1[_FORV_9_])))
      v4 = v4 + 1
    end
    return v3
  end
  local v37_4 = function(arg1, arg2, arg3)
    local ratio = 1 / (arg3 - 1)
    local v4 = {}
    local v5 = 1
    for _FORV_9_ = 0, arg3 - 1 do
      v4[v5] = v36_3(arg1, arg2, ratio * _FORV_9_)
      v5 = v5 + 1
    end
    return v4
  end
  function v34_6.glow(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
    arg10 = math.max(2, arg10)
    do
      local v11 = arg11
      v11 = v11 or 1
      arg11 = v11
    end
    local v37_4_2 = v37_4({
      arg5,
      arg6,
      arg7,
      0
    }, {
      arg5,
      arg6,
      arg7,
      arg8 * arg11
    }, arg10)
    for _FORV_15_ = 1, arg10 do
      renderer.circle_outline(arg1 + arg9, arg2 + arg9, v37_4_2[_FORV_15_][1], v37_4_2[_FORV_15_][2], v37_4_2[_FORV_15_][3], v37_4_2[_FORV_15_][4], arg9 + 1 + (arg10 - _FORV_15_), 180, 0.25, 1)
      renderer.circle_outline(arg1 + arg3 - arg9, arg2 + arg9, v37_4_2[_FORV_15_][1], v37_4_2[_FORV_15_][2], v37_4_2[_FORV_15_][3], v37_4_2[_FORV_15_][4], arg9 + 1 + (arg10 - _FORV_15_), 270, 0.25, 1)
      renderer.circle_outline(arg1 + arg3 - arg9, arg2 + arg4 - arg9, v37_4_2[_FORV_15_][1], v37_4_2[_FORV_15_][2], v37_4_2[_FORV_15_][3], v37_4_2[_FORV_15_][4], arg9 + 1 + (arg10 - _FORV_15_), 0, 0.25, 1)
      renderer.circle_outline(arg1 + arg9, arg2 + arg4 - arg9, v37_4_2[_FORV_15_][1], v37_4_2[_FORV_15_][2], v37_4_2[_FORV_15_][3], v37_4_2[_FORV_15_][4], arg9 + 1 + (arg10 - _FORV_15_), 90, 0.25, 1)
      renderer.rectangle(arg1 + arg3 + _FORV_15_ - 1, arg2 + arg9, 1, arg4 - 2 * arg9, v37_4_2[arg10 - _FORV_15_ + 1][1], v37_4_2[arg10 - _FORV_15_ + 1][2], v37_4_2[arg10 - _FORV_15_ + 1][3], v37_4_2[arg10 - _FORV_15_ + 1][4])
      renderer.rectangle(arg1 - _FORV_15_, arg2 + arg9, 1, arg4 - 2 * arg9, v37_4_2[arg10 - _FORV_15_ + 1][1], v37_4_2[arg10 - _FORV_15_ + 1][2], v37_4_2[arg10 - _FORV_15_ + 1][3], v37_4_2[arg10 - _FORV_15_ + 1][4])
      renderer.rectangle(arg1 + arg9, arg2 - _FORV_15_, arg3 - 2 * arg9, 1, v37_4_2[arg10 - _FORV_15_ + 1][1], v37_4_2[arg10 - _FORV_15_ + 1][2], v37_4_2[arg10 - _FORV_15_ + 1][3], v37_4_2[arg10 - _FORV_15_ + 1][4])
      renderer.rectangle(arg1 + arg9, arg2 + arg4 + _FORV_15_ - 1, arg3 - 2 * arg9, 1, v37_4_2[arg10 - _FORV_15_ + 1][1], v37_4_2[arg10 - _FORV_15_ + 1][2], v37_4_2[arg10 - _FORV_15_ + 1][3], v37_4_2[arg10 - _FORV_15_ + 1][4])
    end
    return
  end
  function v34_6.rectangle_outline(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
    if arg9 == nil or arg9 == 0 then
      arg9 = 1
    end
    if arg10 == nil then
      arg10 = 0
    end
    local prod = v35_5(arg3) * arg9
    local prod_2 = v35_5(arg4) * arg9
    do
      v12 = arg10 == 1
      v12 = v12 and 1
      v12 = v12 or 0
      local prod_3 = v12 * 2
      local prod_4 = arg10 * 2
      renderer.circle_outline(arg1 + arg10, arg2 + arg10, arg5, arg6, arg7, arg8, arg10, 180, 0.25, arg9)
      renderer.circle_outline(arg1 + arg10, arg2 + arg4 - arg10, arg5, arg6, arg7, arg8, arg10, 90, 0.25, arg9)
      renderer.circle_outline(arg1 + arg3 - arg10, arg2 + arg10, arg5, arg6, arg7, arg8, arg10, 270, 0.25, arg9)
      renderer.circle_outline(arg1 + arg3 - arg10, arg2 + arg4 - arg10, arg5, arg6, arg7, arg8, arg10, 0, 0.25, arg9)
      renderer.rectangle(arg1, arg2 + arg10, prod, arg4 - prod_4, arg5, arg6, arg7, arg8)
      renderer.rectangle(arg1 + arg3, arg2 + arg10, -prod, arg4 - prod_4, arg5, arg6, arg7, arg8)
      renderer.rectangle(arg1 + v12 + arg10, arg2, arg3 - prod_3 - prod_4, prod_2, arg5, arg6, arg7, arg8)
    end
    renderer.rectangle(arg1 + v12 + arg10, arg2 + arg4, arg3 - prod_3 - prod_4, -prod_2, arg5, arg6, arg7, arg8)
    return
  end
  function v34_6.rectangle(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    arg9 = math.min(arg9, arg3 / 2, arg4 / 2)
    local prod = arg9 * 2
    renderer.rectangle(arg1 + arg9, arg2, arg3 - prod, arg4, arg5, arg6, arg7, arg8)
    renderer.rectangle(arg1, arg2 + arg9, arg9, arg4 - prod, arg5, arg6, arg7, arg8)
    renderer.rectangle(arg1 + arg3 - arg9, arg2 + arg9, arg9, arg4 - prod, arg5, arg6, arg7, arg8)
    renderer.circle(arg1 + arg9, arg2 + arg9, arg5, arg6, arg7, arg8, arg9, 180, 0.25)
    renderer.circle(arg1 + arg9, arg2 + arg4 - arg9, arg5, arg6, arg7, arg8, arg9, 270, 0.25)
    renderer.circle(arg1 + arg3 - arg9, arg2 + arg9, arg5, arg6, arg7, arg8, arg9, 90, 0.25)
    renderer.circle(arg1 + arg3 - arg9, arg2 + arg4 - arg9, arg5, arg6, arg7, arg8, arg9, 0, 0.25)
    return
  end
end

-- ===== блок 54 =====
do
  local aimbot_logs = v29_4.ragebot.aimbot_logs
  local v40_7 = v12.name:sub(1, 1):upper()
  local v41_7 = v12.name:lower()
  local v42_8 = {}
  local v43_7 = {}
  local v44_9 = {}
  v44_9[0] = "generic"
  v44_9[1] = "head"
  v44_9[2] = "chest"
  v44_9[3] = "stomach"
  do
    local v109 = 4
    v44_9[v109] = "left arm"
  end
  do
    local v109_2 = 5
    v44_9[v109_2] = "right arm"
  end
  do
    local v109_3 = 6
    v44_9[v109_3] = "left leg"
  end
  do
    local v109_4 = 7
    v44_9[v109_4] = "right leg"
    v44_9[8] = "neck"
  end
  do
    local v109_5 = 10
    v44_9[v109_5] = "gear"
    local v45_10 = {}
  end
  do
    local c4 = "c4"
    v45_10[c4] = "bombed"
  end
  do
    local knife = "knife"
    v45_10[knife] = "knifed"
  end
  do
    local decoy = "decoy"
    v45_10[decoy] = "decoyed"
  end
  do
    local inferno = "inferno"
    v45_10[inferno] = "burned"
  end
  do
    local molotov = "molotov"
    v45_10[molotov] = "harmed"
  end
  do
    local flashbang = "flashbang"
    v45_10[flashbang] = "harmed"
  end
  do
    local hegrenade = "hegrenade"
    v45_10[hegrenade] = "naded"
  end
  do
    local incgrenade = "incgrenade"
    v45_10[incgrenade] = "harmed"
  end
  do
    local smokegrenade = "smokegrenade"
    v45_10[smokegrenade] = "harmed"
    local event_bus_3 = v20_4.get_event_bus()
  end
  local v47_11 = function(arg1, arg2, arg3, arg4, arg5)
    if aimbot_logs.show_on_screen:get() then
      local sum = #v43_7 + 1
      v43_7[sum] = {
        text = arg5,
        color = {
          arg1,
          arg2,
          arg3,
          arg4
        },
        time = aimbot_logs.duration:get() * 0.5,
        alpha = 0
      }
      return sum
    end
    return
  end
  local v48_7 = function(arg1, arg2, arg3, arg4)
    local color, color_2 = v27_6.color(arg4)
    for _FORV_9_ = 1, color_2 do
      local v10 = color[_FORV_9_]
      local v11 = v10[1]
      local v12 = v10[2]
      if _FORV_9_ ~= color_2 then
        v11 = v11 .. "\000"
      end
      if v12 == nil then
        client.color_log(arg1, arg2, arg3, v11)
      else
        client.color_log(v13_2.from_hex(v12))
      end
    end
    return
  end
  local v49_7 = function(arg1, arg2, arg3)
    local gsub = string.gsub(arg1, "${(.-)}", string.format("\a%s%%1\a%s", arg2, arg3))
    if gsub:sub(1, 1) ~= "\a" then
      gsub = "\a" .. arg3 .. gsub
    end
    return gsub
  end
  local v50_7 = function()
    for _FORV_3_ = 1, #v43_7 do
      v43_7[_FORV_3_] = nil
    end
    return
  end
  local v51_9 = function(arg1)
    if arg1 == "off" then
      return nil
    end
    if arg1 == "icon" then
      return v40_7
    end
    if arg1 == v12.name then
      return v41_7
    end
    return arg1
  end
  local v52_9 = function(arg1, arg2)
    return (arg1:gsub("\a(%x%x%x%x%x%x)(%x%x)", function(arg1, arg2)
      return "\a" .. arg1 .. string.format("%02x", tonumber(arg2, 16) * arg2)
    end))
  end
  local v53_9 = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    local prod = aimbot_logs.glow:get() * 0.01
    if prod > 0 then
      v34_6.glow(arg1, arg2, arg3, arg4, arg5, arg6, arg7, v13_2.map(prod, 0, 1.5, 0, 115, true) * arg9, 4, math.round(8 * prod))
    end
    v34_6.rectangle(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 * arg9, 4)
    return
  end
  local v54_7 = function()
    local v0_2, v1, v2, v3 = aimbot_logs.color_background:get()
    local frametime = globals.frametime()
    local len = #v43_7
    local ratio = vector(client.screen_size()) / 2
    ratio.y = ratio.y + aimbot_logs.offset:get() * 5
    local v51_9_2 = v51_9((aimbot_logs.logo:get()))
    local v37_5_2 = v37_5("b")
    local vec = vector(renderer.measure_text(v37_5_2, v51_9_2))
    do
      v12 = v51_9_2 == "!"
      v13 = v51_9_2 ~= nil
      v13 = v13 and not v12
      for _FORV_17_ = len, 1, -1 do
        local v18 = v43_7[_FORV_17_]
        do
          v19 = v18.time > 0
          if v19 then
            v19 = len - _FORV_17_
            v19 = v19 < 6
          end
          v18.alpha = v32_5.interp(v18.alpha, v19, 0.075)
        end
        if not v19 then
          if 0 >= v18.alpha then
            table.remove(v43_7, _FORV_17_)
          end
        else
          v18.time = v18.time - frametime
        end
      end
      local v37_5_3 = v37_5("")
      for _FORV_18_ = 1, #v43_7 do
        local v19_2 = v43_7[_FORV_18_]
        local unpack_2, unpack_3, unpack_4, unpack_5 = unpack(v19_2.color)
        do
          local text = v19_2.text
          local alpha = v19_2.alpha
          if v13 then
            text = text .. " !"
          end
          local vec_2 = vector(renderer.measure_text(v37_5_3, text))
          local sum = vec_2 + vector(7, 5) * 2
          if v51_9_2 ~= nil then
            sum.x = sum.x + vec.x + 7
          end
          local diff = ratio - sum / 2
          local sum_2 = diff + vector(7, 5)
          local vec_3 = vector(sum_2.x, diff.y + (sum.y - vec.y) / 2)
          v53_9(diff.x, diff.y, sum.x, sum.y, v0_2, v1, v2, v3, alpha)
          if v51_9_2 ~= nil then
            renderer.text(vec_3.x, vec_3.y, unpack_2, unpack_3, unpack_4, unpack_5 * alpha, v37_5_2, nil, v51_9_2)
            sum_2.x = sum_2.x + vec.x + 7
          end
          sum_2.y = diff.y + (sum.y - vec_2.y) / 2
          text = v52_9(text, alpha)
          renderer.text(sum_2.x, sum_2.y, 255, 255, 255, 200 * alpha, v37_5_3, nil, text)
        end
        ratio.y = ratio.y - math.round((sum.y + 5) * alpha)
      end
    end
    return
  end
  local v55_9 = function(arg1)
    local v1 = v42_8[arg1.id]
    if v1 == nil then
      return
    end
    local target = arg1.target
    if target == nil then
      return
    end
    local v3, v4, v5, v6 = aimbot_logs.color_hit:get()
    local player_name = entity.get_player_name(target)
    local health = entity.get_prop(target, "m_iHealth")
    local hit_chance = arg1.hit_chance
    local damage = arg1.damage
    damage = damage or 0
    local damage_2 = v1.aim.damage
    damage_2 = damage_2 or 0
    local v12 = v44_9[arg1.hitgroup]
    v12 = v12 or "?"
    local v13 = v44_9[v1.aim.hitgroup]
    v13 = v13 or "?"
    do
      v14 = damage_2 - damage > 10
      v15 = v13 ~= v12
      local v16 = string.format("hit ${%s}'s ${%s} for ${%d} dmg", player_name, v12, damage)
      do
        local v18 = {}
        table.insert(v18, string.format("hit: ${%s}", player_name))
        if not v15 then
          table.insert(v18, string.format("hb: ${%s}", v12))
        else
          table.insert(v18, string.format("hb: ${%s}/%s", v12, v13))
        end
        if not v14 then
          table.insert(v18, string.format("dmg: ${%d}", damage))
        else
          table.insert(v18, string.format("dmg: ${%d}/%d", damage, damage_2))
        end
        table.insert(v18, string.format("bt: ${%d}", v1.history))
        table.insert(v18, string.format("hc: ${%d%%}", hit_chance))
        if v1.safe then
          table.insert(v18, "sp: ${on}")
        end
        if health <= 0 then
          table.insert(v18, "rph: ${0} (dead)")
        else
          table.insert(v18, string.format("rph: ${%d}", health))
        end
        local v17 = table.concat(v18, "  ")
      end
      v16 = v49_7(v16, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")
    end
    local v17_2 = v49_7(v17, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")
    v47_11(v3, v4, v5, v6, (v49_7(v16, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")))
    v48_7(255, 255, 255, v17_2)
    return
  end
  local v56_9 = function(arg1)
    local v1 = v42_8[arg1.id]
    if v1 == nil then
      return
    end
    local target = arg1.target
    if target == nil then
      return
    end
    local v3, v4, v5, v6 = aimbot_logs.color_miss:get()
    local player_name = entity.get_player_name(target)
    local reason = arg1.reason
    local hit_chance = arg1.hit_chance
    local damage = v1.aim.damage
    damage = damage or 0
    local v11 = v44_9[v1.aim.hitgroup]
    v11 = v11 or "?"
    do
      local v12 = string.format("missed ${%s}'s ${%s} due to ${%s}", player_name, v11, reason)
      do
        local v14 = {}
        table.insert(v14, string.format("missed: ${%s}", player_name))
        table.insert(v14, string.format("hb: ${%s}", v11))
        table.insert(v14, string.format("due: ${%s}", reason))
        table.insert(v14, string.format("dmg: ${%d}", damage))
        table.insert(v14, string.format("bt: ${%d}", v1.history))
        table.insert(v14, string.format("hc: ${%d%%}", hit_chance))
        if v1.safe then
          table.insert(v14, "sp: ${on}")
        end
        if v1.aim.teleported then
          table.insert(v14, "${LC}")
        end
        if v1.aim.interpolated then
          table.insert(v14, "${IN}")
        end
        if v1.aim.extrapolated then
          table.insert(v14, "${EX}")
        end
        local v13 = table.concat(v14, "  ")
      end
      v12 = v49_7(v12, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")
    end
    local v13_3 = v49_7(v13, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")
    v47_11(v3, v4, v5, v6, (v49_7(v12, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")))
    v48_7(200, 200, 200, v13_3)
    return
  end
  local v57_8 = function(arg1)
    local diff = globals.tickcount() - arg1.tick
    local id = arg1.id
    local v4 = {}
    v4.aim = arg1
    do
      v5 = plist.get(arg1.target, "Override safe point") == "On"
      v4.safe = v5
    end
    v4.history = diff
    v42_8[id] = v4
    return
  end
  local v58_10 = function(arg1)
    local me = entity.get_local_player()
    local userid_to_entindex = client.userid_to_entindex(arg1.userid)
    if client.userid_to_entindex(arg1.attacker) == me and userid_to_entindex ~= me then
      local weapon = arg1.weapon
      local v5 = v45_10[weapon]
      if v5 == nil then
        return
      end
      local v6, v7, v8, v9 = aimbot_logs.color_hit:get()
      local player_name = entity.get_player_name(userid_to_entindex)
      local health = entity.get_prop(userid_to_entindex, "m_iHealth")
      local dmg_health = arg1.dmg_health
      do
        local v13 = string.format("%s ${%s} for ${%d} dmg", v5, player_name, dmg_health)
        do
          local v15 = {}
          table.insert(v15, string.format("harmed: ${%s}", player_name))
          table.insert(v15, string.format("dmg: ${%d}", dmg_health))
          if health <= 0 then
            table.insert(v15, "rph: ${0} (dead)")
          else
            table.insert(v15, string.format("rph: ${%d}", health))
          end
          table.insert(v15, string.format("wep: ${%s}", weapon))
          local v14 = table.concat(v15, "  ")
        end
        v13 = v49_7(v13, v13_2.to_hex(v6, v7, v8, v9), "c8c8c8ff")
      end
      local v14_2 = v49_7(v14, v13_2.to_hex(v6, v7, v8, v9), "c8c8c8ff")
      v47_11(v6, v7, v8, v9, (v49_7(v13, v13_2.to_hex(v6, v7, v8, v9), "c8c8c8ff")))
      v48_7(255, 255, 255, v14_2)
      return
    end
    return
  end
  local v59_8 = function(arg1)
    if entity.get_local_player() == arg1.victim then
      return
    end
    local player_name = entity.get_player_name(arg1.player)
    if player_name == nil then
      return
    end
    do
      local v4 = {}
      table.insert(v4, "ab active")
      table.insert(v4, string.format("target ${%s}", player_name))
    end
    v48_7(255, 255, 255, (v49_7(table.concat(v4, "  "), v13_2.to_hex(176, 198, 255, 255), "c8c8c8ff")))
    return
  end
  local v60_7 = function(arg1)
    local v1 = arg1:get()
    if not v1 then
      v50_7()
    end
    v13_2.event_callback("paint", v54_7, v1)
    return
  end
  aimbot_logs.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      aimbot_logs.show_on_screen:unset_callback(v60_7)
    else
      aimbot_logs.show_on_screen:set_callback(v60_7, true)
    end
    if not v1 then
      v13_2.event_callback("paint", v54_7, false)
      v50_7()
    end
    v13_2.event_callback("aim_hit", v55_9, v1)
    v13_2.event_callback("aim_miss", v56_9, v1)
    v13_2.event_callback("aim_fire", v57_8, v1)
    v13_2.event_callback("player_hurt", v58_10, v1)
    event_bus_3.enemy_shot:set(v59_8, v1)
    return
  end, true)
end

-- ===== блок 57 =====
do
  local watermarks = v29_4.visuals.watermarks
  do
    local v41_9 = string.format("\a%%s%s\a%%s.pink", v12.name:lower())
    do
      local v42_10 = string.format("build: \a%%s%s", v12.build:lower())
      do
        local v43_10 = string.format("user: \a%%s%s", v12.user)
        do
          local v44_12 = panorama.open()
          do
            local v46_7 = images.get_steam_avatar((function()
              local my_persona_api = v44_12.MyPersonaAPI
              if my_persona_api == nil then
                return 0
              end
              local get_xuid = my_persona_api.GetXuid
              return get_xuid()
            end)(), 34)
            local v40_9 = function()
              local v0_2, v1, v2 = watermarks.color_corner:get()
              local to_hex = v13_2.to_hex(v0_2, v1, v2, watermarks.color_corner:get())
              local vec = vector(vector(client.screen_size()).x, 0)
              local v37_5_2 = v37_5("b")
              local format = string.format(v41_9, to_hex, (v13_2.to_hex(255, 255, 255, 255)))
              local v37_5_3 = v37_5("")
              local format_2 = string.format(v42_10, to_hex)
              local v37_5_4 = v37_5("")
              local format_3 = string.format(v43_10, to_hex)
              local vec_2 = vector(renderer.measure_text(v37_5_2, format))
              local vec_3 = vector(renderer.measure_text(v37_5_3, format_2))
              local vec_4 = vector(renderer.measure_text(v37_5_4, format_3))
              local sum = vector(3, 3) * 2 + vector(math.max(vec_2.x, vec_3.x, vec_4.x) + 34 + 5, math.max(vec_2.y + vec_3.y + vec_4.y, 34))
              local sum_2 = sum + vector(10, 0)
              local sum_3 = vec + vector(-37, (sum.y - 34) / 2)
              renderer.gradient(vec.x - sum_2.x, vec.y, sum_2.x, sum_2.y, v0_2, v1, v2, 0, v0_2, v1, v2, 220, true)
              v46_7:draw(sum_3.x, sum_3.y, 34, 34, 255, 255, 255, 255, "f")
              local sum_4 = vec + vector(-sum.x + 3, 3)
              renderer.text(sum_4.x, sum_4.y, 255, 255, 255, 255, v37_5_2, nil, format)
              sum_4.y = sum_4.y + vec_2.y
              renderer.text(sum_4.x, sum_4.y, 255, 255, 255, 255, v37_5_3, nil, format_2)
              sum_4.y = sum_4.y + vec_3.y
              renderer.text(sum_4.x, sum_4.y, 255, 255, 255, 255, v37_5_4, nil, format_3)
              sum_4.y = sum_4.y + vec_4.y
              return
            end
          end
        end
      end
    end
  end
  do
    local v42_11 = string.format("%s\a%%s.PINK", v12.name:upper())
  end
  local v42_12 = function(arg1)
    v13_2.event_callback("paint_ui", v40_9, arg1:get("corner"))
    v13_2.event_callback("paint_ui", v41_10, arg1:get("branded"))
    return
  end
  watermarks.enabled:set_callback(function(arg1)
    if not arg1:get() then
      watermarks.types:unset_callback(v42_12)
      v13_2.event_callback("paint_ui", v40_9, false)
      v13_2.event_callback("paint_ui", v41_10, false)
    else
      watermarks.types:set_callback(v42_12, true)
    end
    return
  end, true)
end

-- ===== блок 58 =====
do
  local indicators = v29_4.visuals.indicators
  local v40_10 = 0
  do
    local v42_13 = {}
    ;({})[1] = {
      "\226\156\166",
      0,
      12,
      0.5
    }
    ;({})[2] = {
      "\226\139\134",
      -6,
      3,
      0.2
    }
    ;({})[3] = {
      "\226\152\133",
      -1,
      8,
      0.4
    }
    ;({})[4] = {
      "\226\156\168",
      -1,
      6,
      0.7
    }
    ;({})[5] = {
      "\226\139\134",
      -3,
      4,
      0.3
    }
    ;({})[6] = {
      "\226\152\133",
      -1,
      7,
      0.6
    }
    ;({})[7] = {
      "\226\139\134",
      -2,
      5,
      0.2
    }
    ;({})[8] = {
      "\226\156\168",
      0,
      8,
      0.7
    }
    do
      local v43_12 = 0
      local v44_13 = 0
      local v45_12 = 0
      local v46_8 = 0
      local v47_13 = 0
      local v48_10 = function()
        if v23_5.is_onground then
          if not v23_5.is_crouched then
            if not v23_5.is_moving then
              return "stand"
            end
            if not v14_2.is_slow_motion() then
              return "run"
            end
            return "walk"
          end
          if not v23_5.is_moving then
            return "crouch"
          end
          return "sneak"
        end
        if not v23_5.is_crouched then
          return "air"
        end
        return "airc"
      end
      local v49_12 = function(arg1, arg2, arg3, arg4, arg5)
        local realtime = globals.realtime()
        do
          local v36_5_2 = v36_5()
          if v36_5_2 then
            v36_5_2 = v14_2
            v36_5_2 = v36_5_2.get_dpi
            v36_5_2 = v36_5_2()
          end
          v36_5_2 = v36_5_2 or 1
          do
            local x = arg1.x
            do
              local y = arg1.y
              local v9 = {}
              do
                local len = #v42_13
                local v11 = 0
                do
                  local v12 = 0
                  for _FORV_16_ = 1, len do
                    local v17 = v42_13[_FORV_16_]
                    local vec = vector(renderer.measure_text("", v17[1]))
                    v11 = v11 + (vec.x + v17[2]) * v36_5_2
                    v12 = math.max(v12, vec.y + v17[3])
                    v9[_FORV_16_] = vec
                  end
                  local v7 = math.round(x - v11 * 0.5 * (1 - v44_13))
                  for _FORV_16_ = 1, len do
                    local v17_2 = v42_13[_FORV_16_]
                    local v18 = v9[_FORV_16_]
                    local v20 = v17_2[2]
                    renderer.text(v7 + v20, y + v17_2[3], arg2, arg3, arg4, arg5 * ((math.sin(realtime * v17_2[4]) * 0.5 + 0.5) * 0.7 + 0.3), v37_5(""), nil, v17_2[1])
                    v7 = v7 + (v18.x + v20) * v36_5_2
                  end
                end
              end
            end
          end
        end
        arg1.y = arg1.y + v12 * 0.58 * v36_5_2
        return
      end
      local v50_13 = function(arg1, arg2, arg3, arg4, arg5, arg6)
        local v48_10_2 = v48_10()
        local v37_5_2 = v37_5("")
        local vec = vector(renderer.measure_text(v37_5_2, v48_10_2))
        local y = arg1.y
        renderer.text(math.round(arg1.x - vec.x * 0.5 * (1 - v44_13)), y, arg2, arg3, arg4, arg5 * arg6, v37_5_2, nil, v48_10_2)
        arg1.y = arg1.y + math.round(vec.y)
        return
      end
      local v51_16 = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
        do
          local name = v12.name
          local v37_5_2 = v37_5("b")
          local vec = vector(renderer.measure_text(v37_5_2, name))
          name = v26_6.gradient(name, -globals.realtime() * 1.25, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
          local y = arg1.y
          renderer.text(math.round(arg1.x - vec.x * 0.5 * (1 - v44_13)), y, arg2, arg3, arg4, arg5, v37_5_2, nil, name)
        end
        arg1.y = arg1.y + vec.y
        return
      end
      local v52_15 = function(arg1, arg2, arg3, arg4, arg5, arg6)
        local v37_5_2 = v37_5("")
        local vec = vector(renderer.measure_text(v37_5_2, "dt"))
        do
          local y = arg1.y
          local v8 = math.round(arg1.x - vec.x * 0.5 * (1 - v44_13))
          if v14_2.is_duck_peek_assist() then
            arg5 = 255
            arg4 = 50
            arg3 = 0
            arg2 = 255
          end
        end
        renderer.text(v8, y, arg2, arg3, arg4, arg5 * arg6, v37_5_2, nil, "dt")
        arg1.y = arg1.y + math.round(vec.y * arg6)
        return
      end
      local v53_17 = function(arg1, arg2, arg3, arg4, arg5, arg6)
        local v37_5_2 = v37_5("")
        local vec = vector(renderer.measure_text(v37_5_2, "dmg"))
        local y = arg1.y
        renderer.text(math.round(arg1.x - vec.x * 0.5 * (1 - v44_13)), y, arg2, arg3, arg4, arg5 * arg6, v37_5_2, nil, "dmg")
        arg1.y = arg1.y + math.round(vec.y * arg6)
        return
      end
      local v54_13 = function(arg1, arg2, arg3, arg4, arg5, arg6)
        local v37_5_2 = v37_5("")
        local vec = vector(renderer.measure_text(v37_5_2, "osaa"))
        local y = arg1.y
        renderer.text(math.round(arg1.x - vec.x * 0.5 * (1 - v44_13)), y, arg2, arg3, arg4, arg5 * arg6, v37_5_2, nil, "osaa")
        arg1.y = arg1.y + math.round(vec.y * arg6)
        return
      end
      do
        local v55_15 = function(arg1)
          local is_scoped = entity.get_prop(arg1, "m_bIsScoped")
          local is_double_tap_active = v14_2.is_double_tap_active()
          local is_override_minimum_damage = v14_2.is_override_minimum_damage()
          local is_on_shot_antiaim_active = v14_2.is_on_shot_antiaim_active()
          v43_12 = v32_5.interp(v43_12, entity.is_alive(arg1), 0.05)
          do
            local interp = v32_5.interp
            local v44_13_2 = v44_13
            v8 = is_scoped == 1
            interp = interp(v44_13_2, v8, 0.05)
          end
          v44_13 = interp
          v45_12 = v32_5.interp(v45_12, is_double_tap_active, 0.05)
          v46_8 = v32_5.interp(v46_8, is_override_minimum_damage, 0.05)
          v47_13 = v32_5.interp(v47_13, is_on_shot_antiaim_active, 0.05)
          return
        end
        do
          local v56_14 = function()
            local prod = vector(client.screen_size()) * 0.5
            do
              local v2, v3, v4, v5 = indicators.color_accent:get()
              do
                do
                  local v6, v7, v8, v9 = indicators.color_secondary:get()
                  prod.x = prod.x + math.round(10 * v44_13)
                  prod.y = prod.y + v40_10
                  local prod_2 = v5 * v43_12
                  local prod_3 = v9 * v43_12
                end
                v49_12(prod, v2, v3, v4, prod_2)
              end
            end
            v51_16(prod, v2, v3, v4, prod_2, v6, v7, v8, prod_3)
            v50_13(prod, 255, 255, 255, 200, v43_12)
            v52_15(prod, 255, 255, 255, 200, v45_12 * v43_12)
            v53_17(prod, 255, 255, 255, 200, v46_8 * v43_12)
            v54_13(prod, 255, 255, 255, 200 * (1 - v45_12 * 0.5), v47_13 * v43_12)
            return
          end
          local v41_11 = function()
            local me = entity.get_local_player()
            if me == nil then
              return
            end
            v55_15(me)
            if v43_12 > 0 then
              v56_14()
            end
            return
          end
        end
      end
    end
  end
  do
    local v43_13 = ""
    do
      local v44_14 = 0
      local v45_13 = 0
      local v46_9 = 0
      local v47_14 = 0
      local v48_11 = 0
      local v49_13 = 0
      local v50_14 = 0
      local v51_17 = function(arg1)
        local player_weapon = entity.get_player_weapon(arg1)
        if player_weapon == nil then
          return false
        end
        local csgo_weapons_2 = csgo_weapons(player_weapon)
        if csgo_weapons_2 == nil then
          return false
        end
        if csgo_weapons_2.type ~= "grenade" then
          return false
        end
        return true
      end
      local v52_16 = function(arg1, arg2)
        local lerp = v13_2.lerp
        return lerp(arg1, arg2, (math.abs(math.sin(globals.realtime() * 3))))
      end
      local v53_18 = function()
        if v23_5.is_onground then
          if not v23_5.is_crouched then
            if not v23_5.is_moving then
              return "-STANDING-"
            end
            if not v14_2.is_slow_motion() then
              return "-MOVING-"
            end
            return "-WALKING-"
          end
          return "-CROUCH-"
        end
        return "-AIR-"
      end
      local v54_14 = function()
        if not v14_2.is_double_tap_active() then
          if v14_2.is_on_shot_antiaim_active() then
            v43_13 = "HIDE"
          end
        else
          v43_13 = "DT"
        end
        return v43_13
      end
      local v55_16 = function(arg1, arg2)
        return (arg1:gsub("\a(%x%x%x%x%x%x)(%x%x)", function(arg1, arg2)
          return "\a" .. arg1 .. string.format("%02x", tonumber(arg2, 16) * arg2)
        end))
      end
      local v56_15 = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        local v37_5_2 = v37_5("-")
        local vec = vector(renderer.measure_text(v37_5_2, "ANGELIC"))
        local vec_2 = vector(renderer.measure_text(v37_5_2, "YAW"))
        local max = math.max(vec.y, vec_2.y)
        do
          local v16 = arg1:unpack()
          local v15 = math.round(arg1:unpack() - (2 + (vec.x + vec_2.x + 1) * 0.5) * (1 - v45_13))
          local v52_16_2 = v52_16(0.25, 1)
          renderer.text(v15, v16, arg6, arg7, arg8, arg9 * arg10, v37_5_2, nil, "ANGELIC")
          v15 = v15 + vec.x + 1
        end
        renderer.text(v15, v16, arg2, arg3, arg4, arg5 * arg10 * v52_16_2, v37_5_2, nil, "YAW")
        arg1.y = arg1.y + max
        return
      end
      local v57_13 = function(arg1, arg2, arg3, arg4, arg5, arg6)
        local v53_18_2 = v53_18()
        local v37_5_2 = v37_5("-")
        local vec = vector(renderer.measure_text(v37_5_2, v53_18_2))
        vec.x = vec.x + 1
        if vec.x < v46_9 then
          v46_9 = vec.x
        else
          v46_9 = v32_5.interp(v46_9, vec.x, 0.034)
        end
        local v10 = arg1:unpack()
        renderer.text(math.round(arg1:unpack() - (2 + v46_9 * 0.5) * (1 - v45_13)), v10, arg2, arg3, arg4, arg5 * arg6, v37_5_2, math.round(v46_9), v53_18_2)
        arg1.y = arg1.y + vec.y
        return
      end
      local v58_14 = function(arg1, arg2, arg3)
        local defensive = v24_5.get().defensive
        do
          local v54_14_2 = v54_14()
          do
            local v37_5_2 = v37_5("-")
            if v50_14 == 1 then
              if defensive.left > 0 then
                local active = "ACTIVE"
                local v11 = 255
                local v10 = 255
                local v9 = 255
                local v8 = 120
              else
                active = "READY"
                v11 = 255
                v10 = 109
                v9 = 255
                v8 = 192
              end
            elseif v50_14 == 0 then
              active = "WAITING"
              v11 = 128
              v10 = 64
              v9 = 64
              v8 = 255
            else
              active = "CHARGING"
              v8 = v13_2.lerp(255, 192, v50_14)
              v9 = v13_2.lerp(64, 255, v50_14)
              v10 = v13_2.lerp(64, 145, v50_14)
              v11 = 255
            end
            local v5 = string.format("\a%s%s \a%s%s", v13_2.to_hex(255, 255, 255, v11), v54_14_2, v13_2.to_hex(v8, v9, v10, v11), active)
            local v55_16_2 = v55_16(v5, arg3 * arg2)
            local v55_16_3 = v55_16(v55_16_2, 0.5 * arg2)
            local vec = vector(renderer.measure_text(v37_5_2, v5))
            vec.x = vec.x + 1
            local round = math.round(vec.x * arg2)
            local round_2 = math.round(vec.y * arg2)
            local round_3 = math.round(round * v50_14)
            do
              local v19 = arg1:unpack()
              local v18 = math.round(arg1:unpack() - (1 + round * 0.5) * (1 - v45_13))
              if round_3 ~= 0 then
                renderer.text(v18, v19, v8, v9, v10, v11 * arg2 * arg3, v37_5_2, round_3, v55_16_2)
              end
              if round ~= 0 then
                renderer.text(v18, v19, v8, v9, v10, v11 * arg2 * arg3, v37_5_2, round, v55_16_3)
              end
            end
          end
        end
        arg1.y = arg1.y + round_2
        return
      end
      local v59_12 = function(arg1, arg2, arg3)
        local v37_5_2 = v37_5("-")
        local vec = vector(renderer.measure_text(v37_5_2, "DMG"))
        vec.x = vec.x + 1
        local round = math.round(vec.x * arg2)
        local round_2 = math.round(vec.y * arg2)
        if round == 0 then
          return
        end
        local v8 = arg1:unpack()
        renderer.text(math.round(arg1:unpack() - (2 + round * 0.5) * (1 - v45_13)), v8, 255, 255, 255, 255 * arg2 * arg3, v37_5_2, round, "DMG")
        arg1.y = arg1.y + round_2
        return
      end
      do
        local v60_11 = function(arg1)
          local v1 = v24_5.get()
          local is_scoped = entity.get_prop(arg1, "m_bIsScoped")
          local v51_17_2 = v51_17(arg1)
          local is_double_tap_active = v14_2.is_double_tap_active()
          local is_override_minimum_damage = v14_2.is_override_minimum_damage()
          local is_on_shot_antiaim_active = v14_2.is_on_shot_antiaim_active()
          local v8 = 0
          if entity.is_alive(arg1) then
            local v9 = v51_17_2
            v9 = v9 and 0.5
            v9 = v9 or 1
            v8 = v9
          end
          v44_14 = v32_5.interp(v44_14, v8, 0.05)
          do
            local interp = v32_5.interp
            local v45_13_2 = v45_13
            v11 = is_scoped == 1
            interp = interp(v45_13_2, v11, 0.05)
          end
          v45_13 = interp
          v47_14 = v32_5.interp(v47_14, is_double_tap_active, 0.03)
          v48_11 = v32_5.interp(v48_11, is_override_minimum_damage, 0.03)
          v49_13 = v32_5.interp(v49_13, is_on_shot_antiaim_active, 0.03)
          v50_14 = v32_5.interp(v50_14, v1.shift, 0.03)
          if not v1.shift then
            v50_14 = 0
          end
          return
        end
        do
          local v61_8 = function()
            local prod = vector(client.screen_size()) * 0.5
            local v2, v3, v4, v5 = indicators.color_accent:get()
            local v6, v7, v8, v9 = indicators.color_secondary:get()
            prod.x = prod.x + math.round(10 * v45_13)
            prod.y = prod.y + v40_10
            v56_15(prod, v2, v3, v4, v5, v6, v7, v8, v9, v44_14)
            v57_13(prod, 255, 255, 255, 255, v44_14)
            v58_14(prod, math.max(v47_14, v49_13), v44_14)
            v59_12(prod, v48_11, v44_14)
            return
          end
          local v42_14 = function()
            local me = entity.get_local_player()
            if me == nil then
              return
            end
            v60_11(me)
            if v44_14 > 0 then
              v61_8()
            end
            return
          end
        end
      end
    end
  end
  do
    local v44_15 = 0
    do
      local v45_14 = 0
      local v46_10 = 0
      local v47_15 = 0
      local v48_12 = false
      local v49_14 = false
      local v50_15 = function(arg1)
        if arg1 == nil then
          return false
        end
        if v38_4.manual_yaw:get() == nil then
          return true
        end
        return false
      end
      do
        local v51_18 = function(arg1)
          local v1 = v24_5.get()
          local is_double_tap_active = v14_2.is_double_tap_active()
          local is_on_shot_antiaim_active = v14_2.is_on_shot_antiaim_active()
          local v5 = 0
          if entity.is_alive(arg1) then
            v5 = 1
          end
          v48_12 = v50_15(arg1)
          v49_14 = v14_2.is_duck_peek_assist()
          v44_15 = v32_5.interp(v44_15, v5, 0.05)
          v45_14 = v32_5.interp(v45_14, v1.shift, 0.03)
          v46_10 = v32_5.interp(v46_10, is_on_shot_antiaim_active, 0.03)
          v47_15 = v32_5.interp(v47_15, is_double_tap_active, 0.03)
          if not v1.shift then
            v45_14 = 0
          end
          return
        end
        local v52_17 = function(arg1, arg2)
          local v48_12_2 = v48_12
          v48_12_2 = v48_12_2 and "\227\129\166\227\130\147\227\129\151\227\129\174\227\130\136\227\129\134\227\129\170 YAW"
          v48_12_2 = v48_12_2 or "\227\131\170\227\130\187\227\131\131\227\131\136 YAW"
          local v37_5_2 = v37_5("")
          local vec = vector(renderer.measure_text(v37_5_2, v48_12_2))
          math.round(vec.x)
          local round = math.round(vec.y)
          local v6 = {}
          ;({})[1] = 218
          ;({})[2] = 118
          ;({})[3] = 0
          local v7 = {}
          ;({})[1] = 177
          ;({})[2] = 151
          ;({})[3] = 255
          local v48_12_3 = v48_12
          v48_12_3 = v48_12_3 and v6
          v48_12_3 = v48_12_3 or v7
          local v10 = arg1:unpack()
          renderer.text(math.round(arg1:unpack()), v10, v48_12_3[1], v48_12_3[2], v48_12_3[3], 255 * arg2, v37_5_2, 0, v48_12_2)
          arg1.y = arg1.y + round
          return
        end
        local v53_19 = function(arg1, arg2)
          local v48_12_2 = v48_12
          v48_12_2 = v48_12_2 and "\227\129\169\227\129\134\227\129\166\227\129\141\227\129\170"
          v48_12_2 = v48_12_2 or "\227\131\135\227\131\149\227\130\169\227\131\171\227\131\136"
          local vec = vector(renderer.measure_text("", v48_12_2))
          math.round(vec.x)
          local round = math.round(vec.y)
          local v5 = {}
          ;({})[1] = 209
          ;({})[2] = 139
          ;({})[3] = 230
          local v6 = {}
          ;({})[1] = 255
          ;({})[2] = 0
          ;({})[3] = 0
          local v48_12_3 = v48_12
          v48_12_3 = v48_12_3 and v5
          v48_12_3 = v48_12_3 or v6
          local v9 = arg1:unpack()
          renderer.text(math.round(arg1:unpack()), v9, v48_12_3[1], v48_12_3[2], v48_12_3[3], 255 * arg2, "", 0, v48_12_2)
          arg1.y = arg1.y + round
          return
        end
        local v54_15 = function(arg1, arg2)
          local v2 = not v49_14
          v2 = v2 and "\229\128\141\227\129\174"
          v2 = v2 or "\229\128\141\227\129\174 (\227\131\149\227\130\167\227\130\164\227\130\175\227\131\128\227\131\131\227\130\175)"
          local v37_5_2 = v37_5("")
          local vec = vector(renderer.measure_text(v37_5_2, v2))
          math.round(vec.x)
          local round = math.round(vec.y)
          do
            v6 = v45_14 == 1
            if v6 then
              v6 = {}
              ;({})[1] = 0
              ;({})[2] = 255
              ;({})[3] = 0
            end
            if not v6 then
              v6 = {}
              ;({})[1] = 255
              ;({})[2] = 0
              ;({})[3] = 0
            end
            local v8 = arg1:unpack()
          end
          renderer.text(math.round(arg1:unpack()), v8, v6[1], v6[2], v6[3], 255 * arg2 * v47_15, v37_5_2, 0, v2)
          arg1.y = arg1.y + round
          return
        end
        local v55_17 = function(arg1, arg2)
          local v2 = not v49_14
          v2 = v2 and "\227\130\162\227\131\179\227\131\129\227\130\168\227\130\164\227\131\160"
          v2 = v2 or "\227\130\162\227\131\179\227\131\129\227\130\168\227\130\164\227\131\160 (\227\131\149\227\130\167\227\130\164\227\130\175\227\131\128\227\131\131\227\130\175)"
          local v37_5_2 = v37_5("")
          local vec = vector(renderer.measure_text(v37_5_2, v2))
          math.round(vec.x)
          local round = math.round(vec.y)
          local v49_14_2 = v49_14
          if v49_14_2 then
            v49_14_2 = {}
            ;({})[1] = 255
            ;({})[2] = 0
            ;({})[3] = 0
          end
          if not v49_14_2 then
            v49_14_2 = {}
            ;({})[1] = 209
            ;({})[2] = 139
            ;({})[3] = 230
          end
          local v8 = arg1:unpack()
          renderer.text(math.round(arg1:unpack()), v8, v49_14_2[1], v49_14_2[2], v49_14_2[3], 255 * arg2 * v46_10, v37_5_2, 0, v2)
          arg1.y = arg1.y + round
          return
        end
        do
          local v56_16 = function()
            local prod = vector(client.screen_size()) * 0.5
            prod.y = prod.y + 40
            local is_on_shot_antiaim_active = v14_2.is_on_shot_antiaim_active()
            local is_double_tap_active = v14_2.is_double_tap_active()
            v52_17(prod, v44_15)
            v53_19(prod, v44_15)
            if is_double_tap_active then
              v54_15(prod, v44_15)
            end
            if is_on_shot_antiaim_active and not is_double_tap_active then
              v55_17(prod, v44_15)
            end
            return
          end
          local v43_14 = function()
            local me = entity.get_local_player()
            if me == nil then
              return
            end
            v51_18(me)
            if v44_15 > 0 then
              v56_16()
            end
            return
          end
        end
      end
    end
  end
  local v44_16 = function(arg1)
    local v1 = arg1:get():lower()
    do
      local event_callback = v13_2.event_callback
      local paint_ui = "paint_ui"
      local v41_11_2 = v41_11
      v5 = v1 == "stars"
      event_callback(paint_ui, v41_11_2, v5)
    end
    do
      local event_callback_2 = v13_2.event_callback
      local paint_ui_2 = "paint_ui"
      local v42_14_2 = v42_14
      v5_2 = v1 == "pixel"
      event_callback_2(paint_ui_2, v42_14_2, v5_2)
    end
    local event_callback_3 = v13_2.event_callback
    local paint_ui_3 = "paint_ui"
    local v43_14_2 = v43_14
    do
      v5_3 = v1 == "\227\130\138\227\129\157\227\129\134"
      event_callback_3(paint_ui_3, v43_14_2, v5_3)
    end
    return
  end
  local v45_15 = function(arg1)
    v40_10 = arg1:get() * 5
    return
  end
  indicators.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      indicators.style:unset_callback(v44_16)
      indicators.offset:unset_callback(v45_15)
    else
      indicators.style:set_callback(v44_16, true)
      indicators.offset:set_callback(v45_15, true)
    end
    if not v1 then
      v13_2.event_callback("paint_ui", v41_11, false)
      v13_2.event_callback("paint_ui", v42_14, false)
      v13_2.event_callback("paint_ui", v43_14, false)
    end
    return
  end, true)
end

-- ===== блок 59 =====
do
  local damage_indicator = v29_4.visuals.damage_indicator
  local v40_11 = ""
  local v41_12 = {}
  do
    local standart = "standart"
    v41_12[standart] = ""
  end
  local v43_15 = function()
    local me = entity.get_local_player()
    if me ~= nil and entity.is_alive(me) then
      local v1, v2, v3, v4 = damage_indicator.color:get()
      local vec = vector(client.screen_size())
      local vec_2 = vector(vec.x / 2 + 4, vec.y / 2 - 4)
      local v42_15_2 = v42_15()
      if v42_15_2 == nil then
        return
      end
      local v37_5_2 = v37_5(v40_11)
      renderer.text(vec_2.x, vec_2.y - vector(renderer.measure_text(v37_5_2, v42_15_2)).y, v1, v2, v3, v4, v37_5_2, nil, v42_15_2)
      return
    end
    return
  end
  local v44_17 = function(arg1)
    local v1 = v41_12[arg1:get()]
    v1 = v1 or ""
    v40_11 = v1
    return
  end
  damage_indicator.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      damage_indicator.font:unset_callback(v44_17)
    else
      damage_indicator.font:set_callback(v44_17, true)
    end
    v13_2.event_callback("paint_ui", v43_15, v1)
    return
  end, true)
end

-- ===== блок 60 =====
do
  local visuals = v29_4.visuals
  local v40_12 = v12.name:lower()
  local v41_13 = 0
  local v42_16 = function()
    if v41_13 <= 0 then
      return
    end
    v41_13 = math.max(v41_13 - globals.frametime() * 1.66, 0)
    return
  end
  local v43_16 = function()
    local vec = vector(client.screen_size())
    local vec_2 = vector(vec.x / 2, vec.y - 18)
    local v40_12_2 = v40_12
    local vec_3 = vector(renderer.measure_text("b", v40_12_2))
    vec_2.x = vec_2.x - vec_3.x / 2
    vec_2.y = vec_2.y - vec_3.y
    renderer.text(vec_2.x, vec_2.y, 255, 255, 255, 255, "b", nil, v40_12_2)
    if v41_13 > 0 then
      local vec_4 = vector(vec_2.x - vector(renderer.measure_text("", "\194\168\203\156\226\128\157*\194\176\226\128\162")).x - 5, vec_2.y)
      local vec_5 = vector(vec_2.x + vec_3.x + 5, vec_2.y)
      renderer.text(vec_4.x, vec_4.y, 255, 255, 255, 255 * v41_13, "", nil, "\194\168\203\156\226\128\157*\194\176\226\128\162")
      renderer.text(vec_5.x, vec_5.y, 255, 255, 255, 255 * v41_13, "", nil, "\226\128\162\194\176*\226\128\157\203\156\194\168")
    end
    return
  end
  local v44_18 = function()
    v42_16()
    v43_16()
    return
  end
  local v45_16 = function(arg1)
    local me = entity.get_local_player()
    local userid_to_entindex = client.userid_to_entindex(arg1.userid)
    if client.userid_to_entindex(arg1.attacker) == me and userid_to_entindex ~= me then
      v41_13 = 1
      return
    end
    return
  end
  local v46_11 = function()
    do
      local v0 = not visuals.watermarks.enabled:get()
      if v0 then
        v0 = visuals
        v0 = v0.indicators
        v0 = v0.enabled
        v0 = v0.get
        v0 = v0(v0)
        v0 = not v0
      end
      v13_2.event_callback("paint_ui", v44_18, v0)
    end
    v13_2.event_callback("player_death", v45_16, v0)
    return
  end
  visuals.watermarks.enabled:set_callback(v46_11)
  visuals.indicators.enabled:set_callback(v46_11)
  v46_11()
end

-- ===== блок 61 =====
do
  local manual_arrows = v29_4.visuals.manual_arrows
  local v40_13 = 0
  local v41_14 = 0
  local v42_17 = 0
  local v43_17 = function(arg1, arg2, arg3)
    local vec = vector()
    vec:init_from_angles(0, arg3, 0)
    return arg1 + arg2 * vec
  end
  local v44_19 = function()
    if manual_arrows.dynamic_mode:get() then
      local v0_2 = manual_arrows.style:get()
      if v0_2 ~= "invictus" and v0_2 ~= "ambani" then
        return 0
      end
      local me = entity.get_local_player()
      local current_threat = client.current_threat()
      if me == nil or current_threat == nil then
        return 0
      end
      local vec = vector(client.camera_angles())
      local vec_2 = vector(entity.get_prop(current_threat, "m_angEyeAngles"))
      local vec_3 = vector(entity.get_origin(me))
      local vec_4 = vector(entity.get_origin(current_threat))
      local v43_17_2 = v43_17(vec_3, 50, vec.y + 110)
      local v43_17_3 = v43_17(vec_3, 30, vec.y + 60)
      local v43_17_4 = v43_17(vec_3, 50, vec.y - 110)
      local v43_17_5 = v43_17(vec_3, 30, vec.y - 60)
      local v43_17_6 = v43_17(vec_4, 40, vec_2.y + 115)
      local v43_17_7 = v43_17(vec_4, 20, vec_2.y + 35)
      local v43_17_8 = v43_17(vec_4, 40, vec_2.y - 115)
      local v43_17_9 = v43_17(vec_4, 20, vec_2.y - 35)
      local trace_bullet = client.trace_bullet(current_threat, v43_17_6.x, v43_17_6.y, v43_17_6.z + 70, v43_17_2.x, v43_17_2.y, v43_17_2.z, true)
      local trace_bullet_2 = client.trace_bullet(current_threat, v43_17_7.x, v43_17_7.y, v43_17_7.z + 30, v43_17_3.x, v43_17_3.y, v43_17_3.z, true)
      local trace_bullet_3 = client.trace_bullet(current_threat, v43_17_8.x, v43_17_8.y, v43_17_8.z + 70, v43_17_4.x, v43_17_4.y, v43_17_4.z, true)
      local trace_bullet_4 = client.trace_bullet(current_threat, v43_17_9.x, v43_17_9.y, v43_17_9.z + 30, v43_17_5.x, v43_17_5.y, v43_17_5.z, true)
      local v23 = 0
      if trace_bullet == 0 then
        if trace_bullet_4 > 0 then
          v23 = 2
        elseif trace_bullet_3 > 0 then
          v23 = 1
        end
      end
      if trace_bullet_3 == 0 then
        if trace_bullet_2 > 0 then
          v23 = -2
        elseif trace_bullet > 0 then
          v23 = -1
        end
      end
      return v23
    end
    return 0
  end
  local v45_17 = function()
    v41_14 = v44_19()
    return
  end
  local v46_12 = function()
    local me = entity.get_local_player()
    if me ~= nil and entity.is_alive(me) then
      do
        local v36_5_2 = v36_5()
        if v36_5_2 then
          v36_5_2 = v14_2
          v36_5_2 = v36_5_2.get_dpi
          v36_5_2 = v36_5_2()
        end
        v36_5_2 = v36_5_2 or 1
        local v2 = manual_arrows.style:get()
        local v33_5_2 = v33_5(manual_arrows.color_accent:get())
        local v33_5_3 = v33_5(manual_arrows.color_secondary:get())
        local v5 = v38_4.manual_yaw:get()
        local body_yaw_offset = v38_4.buffer.body_yaw_offset
        v7 = v5 == "left"
        if not v7 then
          v7 = v41_14
          v7 = v7 < 0
        end
        v8 = v5 == "right"
        if not v8 then
          v8 = v41_14
          v8 = v8 > 0
        end
        v9 = entity.get_prop(me, "m_bIsScoped") == 1
        local vec = vector(client.screen_size())
        local v12, v13 = vector(vec.x / 2, vec.y / 2):unpack()
        do
          local interp = v32_5.interp
          local v42_17_2 = v42_17
          local v16 = v9
          if v16 then
            v16 = manual_arrows
            v16 = v16.animate_scope
            v16 = v16.get
            v16 = v16(v16)
          end
          interp = interp(v42_17_2, v16, 0.05)
        end
        v42_17 = interp
        if v5 ~= nil or v41_14 ~= 0 then
          if v2 == "invictus" then
            local v37_5_2 = v37_5("+")
            do
              v15 = v41_14 == -2
              v15 = v15 and "<<"
              v15 = v15 or "<"
              v16_2 = v41_14 == 2
              v16_2 = v16_2 and ">>"
              v16_2 = v16_2 or ">"
              local vec_2 = vector(renderer.measure_text(v37_5_2, v15))
              local vec_3 = vector(renderer.measure_text(v37_5_2, v16_2))
              local v19 = v7
              v19 = v19 and v33_5_2
              v19 = v19 or v33_5_3
              local v20 = v8
              v20 = v20 and v33_5_2
              v20 = v20 or v33_5_3
              renderer.text(v12 - v40_13, v13 - 1 - vec_2.y * 0.5, v19.r, v19.g, v19.b, v19.a, v37_5_2 .. "r", nil, v15)
            end
            renderer.text(v12 + v40_13, v13 - 1 - vec_3.y * 0.5, v20.r, v20.g, v20.b, v20.a, v37_5_2, nil, v16_2)
          end
          if v2 == "modern" then
            local v37_5_3 = v37_5("+")
            local vec_4 = vector(renderer.measure_text(v37_5_3, "\238\130\158"))
            local vec_5 = vector(renderer.measure_text(v37_5_3, "\238\130\159"))
            local v17 = v7
            v17 = v17 and v33_5_2
            v17 = v17 or v33_5_3
            local v18 = v8
            v18 = v18 and v33_5_2
            v18 = v18 or v33_5_3
            local round = math.round(20 * v42_17)
            local round_2 = math.round(20 * v42_17)
            v17.a = v17.a - v17.a * 0.4 * v42_17
            v18.a = v18.a - v18.a * 0.4 * v42_17
            renderer.text(v12 - v40_13 - round, v13 - vec_4.y * 0.66, v17.r, v17.g, v17.b, v17.a, v37_5_3 .. "r", nil, "\238\130\158")
            renderer.text(v12 + v40_13 + round_2, v13 - vec_5.y * 0.66, v18.r, v18.g, v18.b, v18.a, v37_5_3, nil, "\238\130\159")
          end
          if v2 == "ambani" then
            local prod = 7 * v36_5_2
            local v37_5_4 = v37_5("")
            do
              v16_3 = v41_14 == -2
              v16_3 = v16_3 and "\226\157\174\226\157\174"
              v16_3 = v16_3 or "\226\157\174"
              v17_2 = v41_14 == 2
              v17_2 = v17_2 and "\226\157\175\226\157\175"
              v17_2 = v17_2 or "\226\157\175"
              local v18_2 = v7
              v18_2 = v18_2 and v33_5_2
              v18_2 = v18_2 or v33_5_3
              local v19_2 = v8
              v19_2 = v19_2 and v33_5_2
              v19_2 = v19_2 or v33_5_3
              renderer.text(v12 - v40_13, v13 - prod - 1, v18_2.r, v18_2.g, v18_2.b, v18_2.a, v37_5_4 .. "r", nil, v16_3)
            end
            renderer.text(v12 + v40_13, v13 - prod - 1, v19_2.r, v19_2.g, v19_2.b, v19_2.a, v37_5_4, nil, v17_2)
          end
        end
        if v2 == "teamskeet" then
          local round_3 = math.round(2 * v36_5_2)
          local round_4 = math.round(13 * v36_5_2)
          local round_5 = math.round(9 * v36_5_2)
          local v33_5_4 = v33_5(35, 35, 35, 150)
          local v18_3 = v7
          v18_3 = v18_3 and v33_5_2
          v18_3 = v18_3 or v33_5_4
          local v19_3 = v8
          v19_3 = v19_3 and v33_5_2
          v19_3 = v19_3 or v33_5_4
          do
            v20_2 = body_yaw_offset ~= nil
            v20_2 = v20_2 and body_yaw_offset < 0
            v20_2 = v20_2 and v33_5_3
            v20_2 = v20_2 or v33_5_4
            do
              v21 = body_yaw_offset ~= nil
              v21 = v21 and body_yaw_offset > 0
              v21 = v21 and v33_5_3
              v21 = v21 or v33_5_4
              do
                local diff = v12 - v40_13 - round_4
                do
                  local sum = v12 + v40_13 + round_4
                  local v20_3 = v20_2:clone()
                  local v21_2 = v21:clone()
                  renderer.triangle(diff - round_4, v13, diff, v13 - round_5, diff, v13 + round_5, v18_3:unpack())
                  renderer.triangle(sum + round_4, v13, sum, v13 - round_5, sum, v13 + round_5, v19_3:unpack())
                  renderer.rectangle(diff + round_3 + 2, v13 - round_5, -round_3, round_5 * 2, v20_3:unpack())
                end
              end
            end
          end
          renderer.rectangle(sum - round_3 - 2, v13 - round_5, round_3, round_5 * 2, v21_2:unpack())
        end
      end
      return
    end
    return
  end
  local v47_16 = function(arg1)
    v40_13 = arg1:get()
    return
  end
  manual_arrows.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      manual_arrows.offset:unset_callback(v47_16)
    else
      manual_arrows.offset:set_callback(v47_16, true)
    end
    v13_2.event_callback("paint_ui", v46_12, v1)
    v13_2.event_callback("run_command", v45_17, v1)
    return
  end, true)
end

-- ===== блок 63 =====
do
  local lc_indicator = v29_4.visuals.lc_indicator
  local v40_15 = 0
  local v41_16 = false
  local v42_19 = 0
  local v43_19 = 0
  local v44_20 = 0
  local v45_18 = ""
  local v46_13 = v33_5()
  local v47_17 = 0
  local v48_13 = function(arg1)
    if arg1 > 0 then
      if arg1 <= 3 then
        return "bad", v33_5(255, 175, 104, 255)
      end
      if arg1 <= 6 then
        return "ok", v33_5(255, 255, 255, 255)
      end
      if arg1 <= 9 then
        return "good", v33_5(205, 236, 142, 255)
      end
      if arg1 <= 11 then
        return "nice", v33_5(122, 241, 182, 255)
      end
      if arg1 <= 12 then
        return "ideal lc", v33_5(101, 213, 255, 255)
      end
      if arg1 == 13 then
        return "angel lc", v33_5(207, 145, 255, 255)
      end
    end
    return "failed", v33_5(255, 64, 64, 255)
  end
  local v49_15 = function()
    local frametime = globals.frametime()
    local is_menu_open = ui.is_menu_open()
    local vec = vector(vector(client.screen_size()).x / 2, v47_17)
    if is_menu_open then
      v42_19 = 1
    end
    if v42_19 > 0 then
      local v37_5_2 = v37_5("")
      local v45_18_2 = v45_18
      local str = v44_20 .. "t"
      local v7 = v46_13:clone()
      local v33_5_2 = v33_5(255, 255, 255, 128)
      if v43_19 == 0 and is_menu_open then
        v45_18_2 = "lc status"
        v7 = v33_5(255, 255, 255, 255)
      end
      v7.a = v7.a * v42_19
      v33_5_2.a = v33_5_2.a * v42_19
      local vec_2 = vector(renderer.measure_text(v37_5_2, v45_18_2))
      local vec_3 = vector(renderer.measure_text(v37_5_2, str))
      vec.y = vec.y - (vec_2.y + vec_3.y + 1) / 2
      local sum = vec + vector(-vec_2.x / 2, 0)
      local sum_2 = vec + vector(-vec_3.x / 2, vec_2.y + 1)
      renderer.text(sum.x, sum.y, v7.r, v7.g, v7.b, v7.a, v37_5_2, nil, v45_18_2)
      renderer.text(sum_2.x, sum_2.y, v33_5_2.r, v33_5_2.g, v33_5_2.b, v33_5_2.a, v37_5_2, nil, str)
      v43_19 = math.max(0, v43_19 - frametime)
      if v43_19 == 0 then
        v42_19 = v42_19 - frametime * 8
      end
    end
    return
  end
  local v50_16 = function()
    local v0 = v24_5.get()
    local defensive = v0.defensive
    if defensive.force and not v0.shift and v41_16 and (not v23_5.is_onground or v40_15 > 0) then
      v42_19 = 1
      v43_19 = 0.66
      v44_20 = v40_15
      local v46_13, v48_13_2 = v44_20, v48_13(v44_20)
      v45_18 = v48_13_2
    end
    v41_16 = v0.shift
    v40_15 = defensive.left
    return
  end
  local v51_19 = function(arg1)
    v47_17 = arg1:get() * 5
    return
  end
  lc_indicator.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      lc_indicator.offset:unset_callback(v51_19)
    else
      lc_indicator.offset:set_callback(v51_19, true)
    end
    v13_2.event_callback("paint_ui", v49_15, v1)
    v13_2.event_callback("setup_command", v50_16, v1)
    return
  end, true)
end

-- ===== блок 64 =====
do
  local v40_16 = {}
  v40_16.__index = v40_16
  function v40_16.new(arg1, arg2, arg3)
    local setmetatable_2 = setmetatable
    return setmetatable_2({id = arg2, size = arg3}, arg1)
  end
  function v40_16.draw(arg1, arg2, arg3, ...)
    v34_6.texture(arg1.id, arg2, arg1.size, arg3, ...)
    return
  end
  local v41_17 = {}
  local v42_20 = function()
    for _FORV_3_ = 1, #v41_17 do
      v41_17[_FORV_3_] = nil
    end
    return
  end
  local v43_20 = function(arg1)
    local vec = vector(renderer.measure_text("d+", arg1.text))
    local vec_2 = vector(client.screen_size())
    vec.y = vec.y + 4
    do
      v3 = next(v41_17) == nil
      if v3 then
        v3 = vec_2.y
        v3 = v3 - (vec_2.y - 380) / 2
      end
      if not v3 then
        v3 = v41_17
        v3 = #v3
        v3 = v41_17[v3]
        v3 = v3.offset
        v3 = v3 - 4
        v3 = v3 - vec.y
      end
      arg1.offset = v3
      arg1.text_size = vec
      table.insert(v41_17, arg1)
    end
    return v3
  end
  local v44_21 = function(arg1, arg2, ...)
    arg2 = table.concat({
      arg2,
      ...
    })
    local v43_20_2 = v43_20
    return v43_20_2({text = arg2, color = arg1})
  end
  local v45_19 = function(arg1, arg2, arg3, arg4)
    local floor = math.floor(arg3 / 2)
    renderer.gradient(arg1, arg2, floor, arg4, 0, 0, 0, 0, 0, 0, 0, 56, true)
    renderer.gradient(arg1 + floor, arg2, arg3 - floor, arg4, 0, 0, 0, 56, 0, 0, 0, 0, true)
    return
  end
  local v46_14 = function()
    for _FORV_3_ = 1, #v41_17 do
      local v4 = v41_17[_FORV_3_]
      if v4.color ~= nil then
        local vec = vector(10, v4.offset)
        local sum = vec + vector(10, 2)
        local text_size = v4.text_size
        local color = v4.color
        v45_19(vec.x, vec.y, text_size.x, text_size.y)
        renderer.text(sum.x, sum.y, color.r, color.g, color.b, color.a, "d+", nil, v4.text)
        sum.x = sum.x + v4.text_size.x
      end
    end
    v42_20()
    return
  end
  local v47_18 = function(arg1)
    v44_21(v33_5(arg1.r, arg1.g, arg1.b, arg1.a), arg1.text)
    return
  end
  v29_4.visuals.old_feature_indicators.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    v13_2.event_callback("paint_ui", v46_14, v1)
    v13_2.event_callback("indicator", v47_18, v1)
    return
  end, true)
  do
    local animated_zoom = v29_4.misc.animated_zoom
    local v40_17
    local v41_18 = 0.05
    local v42_21 = function(arg1)
      if v40_17 == nil then
        v40_17 = arg1.fov
      end
      v40_17 = v32_5.interp(v40_17, arg1.fov, v41_18)
      arg1.fov = v40_17
      return
    end
    local v43_21 = function(arg1)
      v41_18 = 1 / arg1:get()
      return
    end
    animated_zoom.enabled:set_callback(function(arg1)
      local v1 = arg1:get()
      if not v1 then
        animated_zoom.speed:unset_callback(v43_21)
      else
        animated_zoom.speed:set_callback(v43_21, true)
      end
      if not v1 then
        v40_17 = nil
      end
      v13_2.event_callback("override_view", v42_21, v1)
      return
    end, true)
  end
end

