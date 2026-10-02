-- angelwings: раздел antiaim (декомпилировано; имена восстановлены эвристикой)
-- Локальные (vNN, ...) объявлены в angelwings_full.lua выше по файлу

-- ===== блок 19 =====
local v14_2 = {}
v14_2.ragebot = {
  weapon_type = ui.reference("Rage", "Weapon type", "Weapon type"),
  aimbot = {
    enabled = {
      ui.reference("Rage", "Aimbot", "Enabled")
    },
    target_hitboxes = ui.reference("Rage", "Aimbot", "Target hitbox"),
    double_tap = {
      ui.reference("Rage", "Aimbot", "Double tap")
    },
    minimum_hit_chance = ui.reference("Rage", "Aimbot", "Minimum hit chance"),
    minimum_damage = ui.reference("Rage", "Aimbot", "Minimum damage"),
    minimum_damage_override = {
      ui.reference("Rage", "Aimbot", "Minimum damage override")
    },
    force_baim = ui.reference("Rage", "Aimbot", "Force body aim"),
    automatic_scope = ui.reference("Rage", "Aimbot", "Automatic scope")
  },
  other = {
    quick_peek_assist = {
      ui.reference("Rage", "Other", "Quick peek assist")
    },
    quick_peek_assist_mode = ui.reference("Rage", "Other", "Quick peek assist mode"),
    duck_peek_assist = ui.reference("Rage", "Other", "Duck peek assist")
  }
}
v14_2.antiaimbot = {
  angles = {
    enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = {
      ui.reference("AA", "Anti-aimbot angles", "Pitch")
    },
    yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {
      ui.reference("AA", "Anti-aimbot angles", "Yaw")
    },
    yaw_jitter = {
      ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
    },
    body_yaw = {
      ui.reference("AA", "Anti-aimbot angles", "Body yaw")
    },
    freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = {
      ui.reference("AA", "Anti-aimbot angles", "Freestanding")
    },
    roll = ui.reference("AA", "Anti-aimbot angles", "Roll")
  },
  fake_lag = {
    enabled = {
      ui.reference("AA", "Fake lag", "Enabled")
    },
    amount = ui.reference("AA", "Fake lag", "Amount"),
    variance = ui.reference("AA", "Fake lag", "Variance"),
    limit = ui.reference("AA", "Fake lag", "Limit")
  },
  other = {
    slow_motion = {
      ui.reference("AA", "Other", "Slow motion")
    },
    on_shot_antiaim = {
      ui.reference("AA", "Other", "On shot anti-aim")
    },
    leg_movement = ui.reference("AA", "Other", "Leg movement")
  }
}
v14_2.misc = {
  settings = {
    menu_color = ui.reference("Misc", "Settings", "Menu color"),
    dpi_scale = ui.reference("Misc", "Settings", "DPI scale")
  },
  movement = {
    strafe = ui.reference("Misc", "Movement", "Air strafe")
  }
}
v14_2.visual = {
  effects = {
    force_third_person = {
      ui.reference("Visuals", "Effects", "Force third person (alive)")
    }
  }
}
function v14_2.get_dpi()
  local match = string.match(ui.get(v14_2.misc.settings.dpi_scale), "(%d+)%%")
  if match then
    return match * 0.01
  end
  return 0
end

-- ===== блок 39 =====
local v24_5 = {}
do
  local v25_5 = 0
  local v26_4 = 0
  local v27_5 = {}
  v27_5.old_origin = vector()
  v27_5.old_simtime = 0
  v27_5.shift = false
  v27_5.breaking_lc = false
  v27_5.defensive = {
    force = false,
    left = 0,
    max = 0
  }
  v27_5.lagcompensation = {distance = 0, teleport = false}
  local v28_3 = function(arg1)
    do
      local v1 = globals.tickcount()
      v1 = globals.tickcount() > entity.get_prop(arg1, "m_nTickBase")
      v27_5.shift = v1
    end
    return
  end
  local v29_2 = function(arg1, arg2)
    local v3 = (arg2 - arg1):lengthsqr()
    do
      local v4 = arg2 - arg1
      v4 = v3 > 4096
      v27_5.breaking_lc = v4
      v27_5.lagcompensation.distance = v3
      v27_5.lagcompensation.teleport = v4
    end
    return
  end
  local v30 = function(arg1)
    local old_origin = v27_5.old_origin
    local old_simtime = v27_5.old_simtime
    local vec = vector(entity.get_origin(arg1))
    local toticks_2 = toticks(entity.get_prop(arg1, "m_flSimulationTime"))
    if old_simtime ~= nil then
      local diff = toticks_2 - old_simtime
      if diff < 0 or diff > 0 and diff <= 64 then
        v29_2(old_origin, vec)
      end
    end
    v27_5.old_origin = vec
    v27_5.old_simtime = toticks_2
    return
  end
  local v31 = function(arg1)
    local tick_base = entity.get_prop(arg1, "m_nTickBase")
    if 64 < math.abs(tick_base - v25_5) then
      v25_5 = 0
    end
    local v2 = 0
    if tick_base > v25_5 then
      v25_5 = tick_base
    elseif tick_base < v25_5 then
      v2 = math.min(14, math.max(0, v25_5 - tick_base - 1))
    end
    if v2 > 0 then
      v27_5.breaking_lc = true
      v27_5.defensive.left = v2
      if v27_5.defensive.max == 0 then
        v27_5.defensive.max = v2
      end
    else
      v27_5.defensive.left = 0
      v27_5.defensive.max = 0
    end
    return
  end
  function v24_5.get()
    do return v27_5 end
  end
  local v32 = function(arg1)
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    if arg1.command_number == v26_4 then
      v31(me)
      v26_4 = nil
    end
    return
  end
  local v33 = function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    v28_3(me)
    return
  end
  local v34 = function(arg1)
    v26_4 = arg1.command_number
    return
  end
  local v35 = function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    v30(me)
    return
  end
  client.set_event_callback("predict_command", v32)
  client.set_event_callback("setup_command", v33)
  client.set_event_callback("run_command", v34)
  client.set_event_callback("net_update_start", v35)
end

-- ===== блок 43 =====
local v28_6 = {}
v28_6.states = {
  "shared",
  "standing",
  "moving",
  "slow walk",
  "air",
  "air-crouching",
  "crouching",
  "move-crouching",
  "on use",
  "fakelag",
  "dormant",
  "safe head",
  "manual aa",
  "freestanding"
}
v28_6.aim_tools = {
  "awp",
  "auto",
  "scout",
  "pistol",
  "deagle",
  "revolver"
}
local v29_4 = {}
do
  local v30_3 = function(arg1, arg2)
    local v2 = arg2
    if not v2 then
      v2 = v14_2
      v2 = v2.get_color
      v2 = v2(true)
    end
    return (string.gsub(arg1, "${(.-)}", (string.format("\a%s%%1\a%s", v2, "FFFFFFC8"))))
  end
  local v31_3 = function(arg1, arg2)
    if arg1:find("\n") == nil then
      arg1 = arg1 .. "\n"
    end
    return arg1 .. arg2
  end
  local v32_3 = function(arg1, arg2)
    local v2 = arg1:get()
    if #v2 == 0 then
      if arg2 == nil then
        if arg1.type == "multiselect" then
          arg2 = arg1.list
        elseif arg1.type == "list" then
          arg2 = {}
          for _FORV_6_ = 1, #arg1.list do
            arg2[_FORV_6_] = _FORV_6_
          end
        end
      end
      v2 = arg2
      arg1:set(arg2)
    end
    arg1:set_callback(function()
      local v0 = arg1:get()
      if #v0 > 0 then
        v2 = v0
      else
        arg1:set(v2)
      end
      return
    end)
    return
  end
  local v33_2 = {}
  v33_2.wings = v21_4.new(ui.new_label, "AA", "Anti-aimbot angles", v12.name)
  v33_2.category = v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", [[

 angelwings.category]], {
    "anti-aim",
    "ragebot",
    "visuals",
    "misc",
    "config"
  })
  client.set_event_callback("paint_ui", function()
    if ui.is_menu_open() then
      local color, color_2, color_3, color_4 = v14_2.get_color()
      v33_2.wings:set(string.rep(" ", v13_2.lerp(6, 12, (v13_2.map(ui.menu_size(), 660, 750, 0, 1, true)))) .. ("\a" .. v13_2.to_hex(color, color_2, color_3, color_4) .. "\194\168\203\156\226\128\157*\194\176\226\128\162 " .. v26_6.gradient(v12.name, -globals.realtime(), 55, 55, 55, 255, color, color_2, color_3, color_4)) .. "\a" .. v13_2.to_hex(color, color_2, color_3, color_4) .. " \226\128\162\194\176*\226\128\157\203\156\194\168")
      return
    end
    return
  end)
  v29_4.general = v33_2
  local v34_2 = {}
  v34_2.enabled = v18_2.push("antiaim", "fakelags.enabled", v21_4.new(ui.new_checkbox, "AA", "Fake lag", "custom fakelags"))
  v34_2.amount = v18_2.push("antiaim", "fakelags.amount", v21_4.new(ui.new_combobox, "AA", "Fake lag", v31_3(v30_3("  ${~}  amount"), "fakelags"), {"angelic", "random"}))
  v34_2.limit = v18_2.push("antiaim", "fakelags.limit", v21_4.new(ui.new_slider, "AA", "Fake lag", v31_3(v30_3("  ${~}  limit"), "fakelags"), 1, 15, 13, true, "t"))
  v29_4.fakelags = v34_2
  local v35_2 = {}
  do
    local v36 = function(arg1)
      local v1 = {}
      local v2 = function(arg1_)
        return arg1 .. ":defensive_" .. arg1_
      end
      local v3 = function(arg1)
        local v31_3_2 = v31_3
        return v31_3_2(v30_3(arg1), v2(arg1))
      end
      v1.force_break_lc = v18_2.push("antiaim", v2("force_break_lc"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3("\ab6b665ffforce break lc", v2("force_break_lc"))))
      v1.enabled = v18_2.push("antiaim", v2("enabled"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3("defensive aa", v2("enabled"))))
      v1.pitch = v18_2.push("antiaim", v2("pitch"), v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v3("pitch"), {
        "off",
        "static",
        "jitter",
        "spin",
        "random",
        "angelic"
      }))
      v1.pitch_label_1 = v21_4.new(ui.new_label, "AA", "Anti-aimbot angles", v30_3("  ${~}  offset 1"))
      v1.pitch_offset_1 = v18_2.push("antiaim", v2("pitch_offset_1"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3("\n", v2("pitch_offset_1")), -89, 89, 0, true, "\194\176"))
      v1.pitch_label_2 = v21_4.new(ui.new_label, "AA", "Anti-aimbot angles", v30_3("  ${~}  offset 2"))
      v1.pitch_offset_2 = v18_2.push("antiaim", v2("pitch_offset_2"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3("\n", v2("pitch_offset_2")), -89, 89, 0, true, "\194\176"))
      v1.pitch_speed = v18_2.push("antiaim", v2("pitch_speed"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  speed"), v2("pitch_speed")), -50, 50, 20, true, nil, 0.1))
      v1.yaw = v18_2.push("antiaim", v2("yaw"), v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v3("yaw"), {
        "off",
        "static",
        "spin",
        "random",
        "left/right",
        "side-based"
      }))
      v1.yaw_left = v18_2.push("antiaim", v2("yaw_left"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  yaw left"), v2("yaw_left")), -180, 180, 0, true, "\194\176"))
      v1.yaw_right = v18_2.push("antiaim", v2("yaw_right"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  yaw right"), v2("yaw_right")), -180, 180, 0, true, "\194\176"))
      v1.yaw_offset = v18_2.push("antiaim", v2("yaw_offset"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3("\n", v2("yaw_offset")), 0, 360, 0, true, "\194\176"))
      v1.yaw_speed = v18_2.push("antiaim", v2("yaw_speed"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  speed"), v2("yaw_speed")), -50, 50, 20, true, "", 0.1))
      v1.yaw_modifier = v18_2.push("antiaim", v2("yaw_modifier"), v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v3("yaw modifier"), {
        "off",
        "offset",
        "center",
        "skitter"
      }))
      v1.modifier_offset = v18_2.push("antiaim", v2("modifier_offset"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3("\n", v2("modifier_offset")), -180, 180, 0, true, "\194\176"))
      v1.delay = v18_2.push("antiaim", v2("delay"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v3("delay")))
      v1.delays = {}
      for _FORV_7_ = 1, 2 do
        v1.delays[_FORV_7_] = v18_2.push("antiaim", v2("delay_" .. _FORV_7_), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  delay " .. _FORV_7_), v2("delay_" .. _FORV_7_)), 1, 14, 0, true, "t"))
      end
      v1.delay_affect_modifier = v18_2.push("antiaim", v2("delay_affect_modifier"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  affect modifier"), v2("delay_affect_modifier"))))
      v1.force_target_yaw = v18_2.push("antiaim", v2("force_target_yaw"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3("force target yaw", v2("force_target_yaw"))))
      return v1
    end
    local v37 = function(arg1, arg2)
      local v2 = {}
      do
        local v3
        v3 = arg1 == "shared"
        local v4
        v4 = arg1 == "on use"
        local v5
        v5 = arg1 == "freestanding"
        local v6 = function(arg1_)
          return arg1 .. ":" .. arg1_
        end
        local v7 = function(arg1)
          local v31_3_2 = v31_3
          return v31_3_2(v30_3(arg1), v6(arg1))
        end
        if arg2 ~= nil then
          function v6(arg1_)
            return arg1 .. ":" .. arg1_ .. ":" .. arg2
          end
        end
        if not v3 then
          v2.override = v18_2.push("antiaim", v6("override"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("${" .. string.format("allow %s condition", arg1) .. "}"), v6("override"))))
        end
        if v4 then
          v2.bomb_e_fix = v18_2.push("antiaim", v6("bomb_e_fix"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  bomb e fix"), v6("bomb_e_fix"))))
        elseif not v4 then
          v2.pitch = v18_2.push("antiaim", v6("pitch"), v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v7("pitch"), {
            "off",
            "down",
            "up",
            "random"
          }))
          v2.pitch:set("down")
        end
        if not v5 then
          v2.yaw_offset = v18_2.push("antiaim", v6("yaw_offset"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v7("yaw offset"), -180, 180, 0, true, "\194\176"))
          v2.add_yaw = v18_2.push("antiaim", v6("add_yaw"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  add yaw"), v6("add_yaw"))))
          v2.yaw_left = v18_2.push("antiaim", v6("yaw_left"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v7("yaw left"), -180, 180, 0, true, "\194\176"))
          v2.yaw_right = v18_2.push("antiaim", v6("yaw_right"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v7("yaw right"), -180, 180, 0, true, "\194\176"))
          v2.yaw_random = v18_2.push("antiaim", v6("yaw_random"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v7("yaw random"), 0, 100, 0, true, "%", 1, {
            [0] = "Off"
          }))
          v2.yaw_jitter = v18_2.push("antiaim", v6("yaw_jitter"), v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v7("yaw jitter"), {
            "off",
            "offset",
            "center",
            "skitter",
            "spin",
            "random",
            "5-way",
            "modern",
            "angelic"
          }))
          v2.way_method = v18_2.push("antiaim", v6("way_method"), v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  way method"), v6("way_method")), {"default", "custom"}))
          v2.ways = {}
          for _FORV_11_ = 1, 5 do
            v2.ways[_FORV_11_] = v18_2.push("antiaim", v6("ways_" .. _FORV_11_), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  way " .. _FORV_11_), v6("ways_" .. _FORV_11_)), -180, 180, 0, true, "\194\176"))
          end
          v2.jitter_offset = v18_2.push("antiaim", v6("jitter_offset"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3("\n", v6("jitter offset")), -180, 180, 0, true, "\194\176"))
          v2.jitter_random = v18_2.push("antiaim", v6("jitter_random"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v7("jitter random"), 0, 100, 0, true, "%", 1, {
            [0] = "Off"
          }))
        end
        v2.body_yaw = v18_2.push("antiaim", v6("body_yaw"), v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v7("body yaw"), {
          "off",
          "static",
          "jitter",
          "random",
          "min/max"
        }))
        v2.body_yaw_offset = v18_2.push("antiaim", v6("body_yaw_offset"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3("\n", v6("body yaw offset")), -180, 180, 0, true, "\194\176"))
        v2.body_yaw_offset_min = v18_2.push("antiaim", v6("body_yaw_offset_min"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  minimum offset"), v6("body yaw offset min")), -180, 180, 0, true, "\194\176"))
        v2.body_yaw_offset_max = v18_2.push("antiaim", v6("body_yaw_offset_max"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  maximum offset"), v6("body yaw offset max")), -180, 180, 0, true, "\194\176"))
        v2.freestanding_body_yaw = v18_2.push("antiaim", v6("freestanding_body_yaw"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v7("freestanding body yaw")))
        v2.delay_mode = v18_2.push("antiaim", v6("delay_mode"), v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  delay mode"), v6("delay_mode")), {"default", "custom"}))
        v2.delay_count = v18_2.push("antiaim", v6("delay_count"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  delay count"), v6("delay_count")), 2, 10, 2, true, ""))
        v2.delays = {}
        for _FORV_11_ = 1, 10 do
          v2.delays[_FORV_11_] = v18_2.push("antiaim", v6("delay_" .. _FORV_11_), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  delay " .. _FORV_11_), v6("delay_" .. _FORV_11_)), 1, 14, 0, true, "t"))
        end
        v2.invert_chance = v18_2.push("antiaim", v6("invert_chance"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  invert chance"), v6("invert_chance")), 1, 100, 100, true, "%"))
      end
      return v2
    end
    v35_2.select = v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", [[

 antiaim.select]], {
      "settings",
      "builder",
      "antibrute"
    })
    local v38 = {}
    v38.avoid_backstab = {
      enabled = v18_2.push("antiaim", "antiaim.settings.avoid_backstab.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "avoid backstab"))
    }
    do
      local v40 = {}
      v40.enabled = v18_2.push("antiaim", "antiaim.settings.safe_head.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "safe head"))
      v40.states = v18_2.push("antiaim", "antiaim.settings.safe_head.states", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  states"), "safe_head"), {
        "standing",
        "crouch",
        "air crouch knife",
        "distance"
      }))
      v19_4.push(-1, v40.enabled)
      v38.safe_head = v40
      local v41 = {}
      v41.enabled = v18_2.push("antiaim", "antiaim.settings.force_break_lc_triggers.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "force break lc triggers"))
      v41.states = v18_2.push("antiaim", "antiaim.settings.force_break_lc_triggers.states", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  states"), "force_break_lc_triggers"), {
        "flashed",
        "reloading",
        "taking damage"
      }))
      v19_4.push(-1, v41.enabled)
      v32_3(v41.states)
      v38.force_break_lc_triggers = v41
      local v42 = {}
      v42.enabled = v18_2.push("antiaim", "antiaim.settings.defensive_flick.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "defensive flick"))
      v42.states = v18_2.push("antiaim", "antiaim.settings.defensive_flick.states", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  states"), "defensive_flick"), {
        "standing",
        "slow walk",
        "crouching",
        "move-crouching",
        "air",
        "air-crouching"
      }))
      v19_4.push(-1, v42.enabled)
      v32_3(v42.states, {
        "slow walk",
        "move-crouching"
      })
      v38.defensive_flick = v42
      v38.freestanding = {
        enabled = v18_2.push("antiaim", "antiaim.settings.freestanding.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "freestanding")),
        hotkey = v18_2.push("antiaim", "antiaim.settings.freestanding.hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3("\n", "freestanding"), true)),
        options = v18_2.push("antiaim", "antiaim.settings.freestanding.options", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~} options"), "freestanding"), {
          "disable yaw modifiers",
          "body freestanding"
        })),
        disablers = v18_2.push("antiaim", "antiaim.settings.freestanding.disablers", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  disablers"), "freestanding"), {
          "standing",
          "moving",
          "slow walk",
          "crouching",
          "air"
        }))
      }
      local v44 = {}
      v44.enabled = v18_2.push("antiaim", "antiaim.settings.manual_yaw.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "manual yaw"))
      v44.options = v18_2.push("antiaim", "antiaim.settings.manual_yaw.options", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~} options"), "manual_yaw"), {
        "disable yaw modifiers",
        "body freestanding"
      }))
      v44.left_hotkey = v18_2.push("antiaim", "antiaim.settings.manual_yaw.left_hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~} left"), "manual_yaw")))
      v44.right_hotkey = v18_2.push("antiaim", "antiaim.settings.manual_yaw.right_hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~} right"), "manual_yaw")))
      v44.forward_hotkey = v18_2.push("antiaim", "antiaim.settings.manual_yaw.forward_hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~} forward"), "manual_yaw")))
      v44.backward_hotkey = v18_2.push("antiaim", "antiaim.settings.manual_yaw.backward_hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~} backward"), "manual_yaw")))
      v44.reset_hotkey = v18_2.push("antiaim", "antiaim.settings.manual_yaw.reset_hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~} reset"), "manual_yaw")))
      v44.left_hotkey:set("Toggle")
      v44.right_hotkey:set("Toggle")
      v44.forward_hotkey:set("Toggle")
      v44.backward_hotkey:set("Toggle")
      v44.reset_hotkey:set("On hotkey")
      v38.manual_yaw = v44
      v38.roll_antiaim = {
        enabled = v18_2.push("antiaim", "antiaim.settings.roll_antiaim.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "roll antiaim")),
        hotkey = v18_2.push("antiaim", "antiaim.settings.roll_antiaim.hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3("\n", "roll_antiaim"), true)),
        value = v18_2.push("antiaim", "antiaim.settings.roll_antiaim.value", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3([[

 value]]), "roll_antiaim"), -50, 50, 0, true, "\194\176")),
        change_on_fakelag = v18_2.push("antiaim", "antiaim.settings.roll_antiaim.change_on_fakelag", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  change on fakelag"), "roll_antiaim"))),
        fakelag_value = v18_2.push("antiaim", "antiaim.settings.roll_antiaim.fakelag_value", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3([[

 fakelag_value]]), "roll_antiaim"), -50, 50, 0, true, "\194\176"))
      }
      v35_2.settings = v38
    end
    local v39 = {}
    v39.state = v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("${state}"), "builder"), v28_6.states)
    for _FORV_43_ = 1, #v28_6.states do
      local v44_2 = v28_6.states[_FORV_43_]
      local v45 = v37(v44_2)
      v45.separator = v21_4.new(ui.new_label, "AA", "Anti-aimbot angles", v31_3("\n", "separator"))
      if v44_2 ~= "fakelag" then
        v45.defensive = v36(v44_2)
      end
      v39[v44_2] = v45
    end
    v35_2.builder = v39
    local v40_2 = {}
    local enable_anti_bruteforce = "enable anti-bruteforce"
    if not v19_4.is_locked(-1) then
      enable_anti_bruteforce = v30_3("${" .. enable_anti_bruteforce .. "}")
    end
    v40_2.enabled = v18_2.push("antiaim", "antiaim.antibrute.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(enable_anti_bruteforce, "antibrute")))
    v40_2.refresh_modifier = v18_2.push("antiaim", "antiaim.antibrute.refresh_modifier", v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  refresh modifier"), "antibrute"), {
      "off",
      "adaptive",
      "increase",
      "decrease"
    }))
    v40_2.refresh_offset = v18_2.push("antiaim", "antiaim.antibrute.refresh_offset", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  refresh offset"), "antibrute")))
    v40_2.enforce_delay = v18_2.push("antiaim", "antiaim.antibrute.enforce_delay", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  enforce delay period"), "antibrute")))
    v40_2.duration = v18_2.push("antiaim", "antiaim.antibrute.duration", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  duration"), "antibrute"), 9, 200, 9, true, "s.", 0.1, {
      [9] = "inf."
    }))
    v19_4.push(-1, v40_2.enabled)
    v35_2.antibrute = v40_2
    v29_4.antiaim = v35_2
  end
  local v36_2 = {}
  do
    local v37_2 = {}
    do
      local resolver = "resolver"
      if not v19_4.is_locked(-2) then
        resolver = "\ab6b665ff" .. resolver
      end
      v37_2.enabled = v18_2.push("ragebot", "resolver.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", resolver))
      v19_4.push(-2, v37_2.enabled)
      v36_2.resolver = v37_2
    end
    local v38_2 = {}
    do
      local v39_2 = {
        "awp",
        "auto",
        "scout",
        "pistol",
        "deagle"
      }
      v38_2.enabled = v18_2.push("ragebot", "ai_peek.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "ai-peek   "))
      v38_2.weapon = v18_2.push("ragebot", "ai_peek.weapons", v21_4.new(ui.new_multiselect, "AA", "Anti-Aimbot angles", v31_3(v30_3("  ${~}  weapons"), "ai_peek"), v39_2))
      v19_4.push(-2, v38_2.enabled)
      v36_2.ai_peek = v38_2
    end
    local v39_3 = {}
    do
      local v40_3 = function(arg1)
        local v2 = function(arg1_)
          return arg1 .. ":" .. arg1_
        end
        return {
          body_aim = v18_2.push("ragebot", v2("body_aim"), v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  prefer body aim on"), v2("body_aim")), {
            "higher than you",
            "lower than you",
            "lethal",
            "after x misses",
            "hp lower than x"
          })),
          body_misses = v18_2.push("ragebot", v2("body_misses"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  misses"), v2("body_misses")), 1, 10, 2)),
          body_hp = v18_2.push("ragebot", v2("body_hp"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  hp"), v2("body_hp")), 0, 100, 80)),
          safe_point = v18_2.push("ragebot", v2("safe_point"), v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  force safe point on"), v2("safe_point")), {
            "higher than you",
            "lower than you",
            "lethal",
            "after x misses",
            "hp lower than x"
          })),
          safe_misses = v18_2.push("ragebot", v2("safe_misses"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  misses"), v2("safe_misses")), 1, 10, 2)),
          safe_hp = v18_2.push("ragebot", v2("safe_hp"), v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  hp"), v2("safe_hp")), 0, 100, 80))
        }
      end
      v39_3.enabled = v18_2.push("ragebot", "aim_tools.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "aim tools"))
      v39_3.weapon = v18_2.push("ragebot", "aim_tools.weapon", v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  weapon"), "aim_tools"), v28_6.aim_tools))
      for _FORV_44_ = 1, #v28_6.aim_tools do
        local v45_2 = v28_6.aim_tools[_FORV_44_]
        v39_3[v45_2] = v40_3(v45_2)
      end
      v39_3.esp_flag = v18_2.push("ragebot", "aim_tools.esp_flag", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  esp flag"), "aim_tools")))
      v19_4.push(-1, v39_3.enabled)
      v36_2.aim_tools = v39_3
    end
    v36_2.aimbot_logs = {
      enabled = v18_2.push("ragebot", "aimbot_logs.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "aimbot logs")),
      color_hit = v18_2.push("ragebot", "aimbot_logs.color_hit", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.aimbot_logs.color_hit]], 163, 211, 80)),
      show_on_screen = v18_2.push("ragebot", "aimbot_logs.show_on_screen", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  show on screen"), "aimbot_logs"))),
      color_miss = v18_2.push("ragebot", "aimbot_logs.color_miss", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.aimbot_logs.color_miss]], 240, 191, 86)),
      label_background = v21_4.new(ui.new_label, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  background color"), "aimbot_logs")),
      color_background = v18_2.push("ragebot", "aimbot_logs.color_background", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.aimbot_logs.color_background]], 22, 22, 22)),
      logo = v18_2.push("ragebot", "aimbot_logs.logo", v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  logo"), "aimbot_logs"), {
        "off",
        "!",
        "icon",
        v12.name
      })),
      glow = v18_2.push("ragebot", "aimbot_logs.glow", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  glow"), "aimbot_logs"), 0, 150, 100, true, "%")),
      offset = v18_2.push("ragebot", "aimbot_logs.offset", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  offset"), "aimbot_logs"), 1, 144, 60, true, "px", 5)),
      duration = v18_2.push("ragebot", "aimbot_logs.duration", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  duration"), "aimbot_logs"), 1, 16, 10, true, "s.", 0.5))
    }
    local v41_2 = {}
    do
      local angelic_tap = "angelic tap"
      if not v19_4.is_locked(-1) then
        angelic_tap = v30_3("${" .. angelic_tap .. "}")
      end
      v41_2.enabled = v18_2.push("ragebot", "angelic_tap.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", angelic_tap))
      v19_4.push(-1, v41_2.enabled)
      v36_2.angelic_tap = v41_2
    end
    local v42_2 = {}
    v42_2.enabled = v18_2.push("ragebot", "teleport_fix.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "teleport fix"))
    v19_4.push(-1, v42_2.enabled)
    v36_2.teleport_fix = v42_2
    local v43 = {}
    v43.enabled = v18_2.push("ragebot", "air_autostop.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "quick stop in air"))
    v43.hotkey = v18_2.push("ragebot", "air_autostop.hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", "quick stop in air hotkey", true))
    v19_4.push(-1, v43.enabled)
    v36_2.air_autostop = v43
    local v44_3 = {}
    v44_3.enabled = v18_2.push("ragebot", "force_shot.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "force shot"))
    v44_3.hotkey = v18_2.push("ragebot", "force_shot.hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", "force shot hotkey", true))
    v44_3.indicator = v18_2.push("ragebot", "force_shot.indicator", v21_4.new(ui.new_checkbox, "AA", "Anti-Aimbot angles", v31_3(v30_3("  ${~}  draw indicator"), "force_shot")))
    v44_3.hc = v18_2.push("ragebot", "force_shot.hc", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  hitchance"), "force_shot"), 0, 100, 0, true, "%"))
    v19_4.push(-2, v44_3.enabled)
    v36_2.force_shot = v44_3
    local v45_3 = {}
    do
      local v46 = {
        "awp",
        "auto",
        "scout",
        "pistol",
        "deagle"
      }
      local v47 = {
        "standing",
        "moving",
        "slow walk",
        "air",
        "air-crouching",
        "crouching",
        "move-crouching"
      }
      v45_3.enabled = v18_2.push("ragebot", "auto_hide_shots.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "auto hide shots"))
      v45_3.weapons = v18_2.push("ragebot", "auto_hide_shots.weapons", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  weapons"), "auto_hide_shots"), v46))
      v45_3.states = v18_2.push("ragebot", "auto_hide_shots.states", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  states"), "auto_hide_shots"), v47))
      v32_3(v45_3.weapons)
      v32_3(v45_3.states, {
        "slow walk",
        "crouching",
        "move-crouching"
      })
      v19_4.push(-1, v45_3.enabled)
      v36_2.auto_hide_shots = v45_3
    end
    v36_2.hide_shots_fix = {
      enabled = v18_2.push("ragebot", "hide_shots_fix.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "hide shots fix"))
    }
    local v47_2 = {}
    v47_2.enabled = v18_2.push("ragebot", "allow_duck_on_fd.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "allow duck on fd"))
    v19_4.push(-1, v47_2.enabled)
    v36_2.allow_duck_on_fd = v47_2
    local v48 = {}
    local o_o = "o.o\203\154\226\130\138\194\183\226\153\161"
    if not v19_4.is_locked(-2) then
      o_o = "\ab6b665ff" .. o_o
    end
    v48.enabled = v18_2.push("ragebot", "interpolation.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", o_o))
    v48.draw_indicator = v18_2.push("ragebot", "interpolation.draw_indicator", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  draw indicator"), "interpolation")))
    v48.safe_mode = v18_2.push("ragebot", "interpolation.safe_mode", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  interpolation manipulations"), "interpolation")))
    v48.unsafe = v18_2.push("ragebot", "interpolation.unsafe", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  unsafe (use with func. above)"), "interpolation")))
    v48.extrapolation = v18_2.push("ragebot", "interpolation.extrapolation", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  extrapolation"), "interpolation"), 0, 250, 25, true, "", 0.01))
    v48.force_extrapolation = v18_2.push("ragebot", "interpolation.force_extrapolation", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  force extrapolate"), "interpolation"), 0, 250, 0, true, "", 0.01))
    v48.force_extrapolation_hotkey = v18_2.push("ragebot", "interpolation.force_extrapolation_hotkey", v21_4.new(ui.new_hotkey, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  force extrapolate"), "interpolation"), true))
    v19_4.push(-2, v48.enabled)
    v36_2.interpolation = v48
    v29_4.ragebot = v36_2
  end
  local v37_3 = {}
  v37_3.allow_dpi_scale = {
    enabled = v18_2.push("visuals", "allow_dpi_scale.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "allow dpi scale"))
  }
  do
    local v39_4 = {}
    v39_4.enabled = v18_2.push("visuals", "watermarks.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "watermarks"))
    v39_4.types = v18_2.push("visuals", "watermarks.types", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  types"), "watermarks"), {"corner", "branded"}))
    v39_4.color_corner = v18_2.push("visuals", "watermarks.color_corner", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.watermarks.color_corner]], 172, 167, 209))
    v39_4.color_branded = v18_2.push("visuals", "watermarks.color_branded", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.watermarks.color_branded]], 172, 167, 209))
    v32_3(v39_4.types, {"branded"})
    v37_3.watermarks = v39_4
    v37_3.indicators = {
      enabled = v18_2.push("visuals", "indicators.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "screen indicators")),
      style = v18_2.push("visuals", "indicators.style", v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  style"), "indicators"), {
        "stars",
        "pixel",
        "\227\130\138\227\129\157\227\129\134"
      })),
      color_accent = v18_2.push("visuals", "indicators.color_accent", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.indicators.color_accent]], 172, 167, 209)),
      color_secondary = v18_2.push("visuals", "indicators.color_secondary", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.indicators.color_secondary]], 255, 255, 255)),
      offset = v18_2.push("visuals", "indicators.offset", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  offset"), "indicators"), 1, 80, 5, true, "px", 5))
    }
    v37_3.damage_indicator = {
      enabled = v18_2.push("visuals", "damage_indicator.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "damage indicator")),
      if_override = v18_2.push("visuals", "damage_indicator.if_override", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  if override"), "damage_indicator"))),
      font = v18_2.push("visuals", "damage_indicator.font", v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  font"), "damage_indicator"), {
        "standart",
        "alternative"
      })),
      color = v18_2.push("visuals", "damage_indicator.color", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.damage_indicator.color]], 255, 255, 255))
    }
    v37_3.manual_arrows = {
      enabled = v18_2.push("visuals", "manual_arrows.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "manual arrows")),
      style = v18_2.push("visuals", "manual_arrows.style", v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  style"), "manual_arrows"), {
        "invictus",
        "teamskeet",
        "modern",
        "ambani"
      })),
      color_accent = v18_2.push("visuals", "manual_arrows.color_accent", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.manual_arrows.color_accent]], 172, 167, 209)),
      color_secondary = v18_2.push("visuals", "manual_arrows.color_secondary", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.manual_arrows.color_secondary]], 255, 255, 255)),
      offset = v18_2.push("visuals", "manual_arrows.offset", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  offset"), "manual_arrows"), 5, 150, 40, true, "px")),
      animate_scope = v18_2.push("visuals", "manual_arrows.animate_scope", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  animate scope"), "manual_arrows"))),
      dynamic_mode = v18_2.push("visuals", "manual_arrows.dynamic_mode", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  dynamic mode"), "manual_arrows")))
    }
    v37_3.velocity_warning = {
      enabled = v18_2.push("visuals", "velocity_warning.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "velocity warning")),
      color_accent = v18_2.push("visuals", "velocity_warning.color_accent", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.velocity_warning.color_accent]], 255, 255, 255, 200)),
      color_secondary = v18_2.push("visuals", "velocity_warning.color_secondary", v21_4.new(ui.new_color_picker, "AA", "Anti-aimbot angles", [[

 angelwings.velocity_warning.color_secondary]], 150, 150, 150, 255)),
      offset = v18_2.push("visuals", "velocity_warning.offset", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  offset"), "velocity_warning"), 20, 150, 75, true, "px", 5))
    }
    local v44_4 = {}
    v44_4.enabled = v18_2.push("visuals", "lc_indicator.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "lc indicator"))
    v44_4.offset = v18_2.push("visuals", "lc_indicator.offset", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  offset"), "lc_indicator"), 10, 150, 50, true, "px", 5))
    v19_4.push(-1, v44_4.enabled)
    v37_3.lc_indicator = v44_4
    local v45_4 = {}
    v45_4.enabled = v18_2.push("visuals", "old_feature_indicators.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "old feature indicators"))
    v19_4.push(-2, v45_4.enabled)
    v37_3.old_feature_indicators = v45_4
    v29_4.visuals = v37_3
  end
  local v38_3 = {}
  v38_3.animated_zoom = {
    enabled = v18_2.push("visuals", "animated_zoom.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "animated zoom")),
    speed = v18_2.push("visuals", "animated_zoom.speed", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  animation speed"), "animated_zoom"), 1, 100, 20, true, "%"))
  }
  v38_3.second_zoom_fov = {
    enabled = v18_2.push("visuals", "second_zoom_fov.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "second zoom fov")),
    fov = v18_2.push("visuals", "second_zoom_fov.speed", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  fov"), "second_zoom_fov"), 0, 100, 0, true, "%"))
  }
  v38_3.fast_ladder = {
    enabled = v18_2.push("visuals", "fast_ladder.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "fast ladder"))
  }
  v38_3.console_filter = {
    enabled = v18_2.push("visuals", "console_filter.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "console filter"))
  }
  v38_3.chat_spammer = {
    enabled = v18_2.push("visuals", "chat_spammer.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "chat spammer")),
    mode = v18_2.push("visuals", "chat_spammer.mode", v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  mode"), "chat_spammer"), {"default", "floss"}))
  }
  v38_3.clientside_nickname = {
    enabled = v18_2.push("visuals", "clientside_nickname.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "clientside nickname")),
    input = v18_2.push("visuals", "clientside_nickname.input", v21_4.new(ui.new_textbox, "AA", "Anti-aimbot angles", v31_3("input", "clientside_nickname"))),
    set = v21_4.new(ui.new_button, "AA", "Anti-aimbot angles", "Set name", v10)
  }
  do
    local v45_5 = {}
    v45_5.enabled = v18_2.push("visuals", "fps_optimize.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "fps optimize"))
    v45_5.always_on = v18_2.push("visuals", "fps_optimize.always_on", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  always on"), "fps_optimize")))
    v45_5.detections = v18_2.push("visuals", "fps_optimize.detections", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  detections"), "fps_optimize"), {"peeking", "hit flag"}))
    v45_5.list = v18_2.push("visuals", "fps_optimize.list", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  optimizations"), "fps_optimize"), {
      "blood",
      "bloom",
      "decals",
      "shadows",
      "sprites",
      "particles",
      "ropes",
      "dynamic lights",
      "map details",
      "weapon effects"
    }))
    v32_3(v45_5.detections)
    v32_3(v45_5.list, {
      "blood",
      "decals",
      "sprites",
      "ropes",
      "dynamic lights",
      "weapon effects"
    })
    v38_3.fps_optimize = v45_5
    v38_3.animation_breaker = {
      enabled = v18_2.push("visuals", "animation_breaker.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "animation breaker")),
      onground = v18_2.push("visuals", "animation_breaker.onground", v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  legs on ground"), "animation_breaker"), {
        "default",
        "static",
        "jitter",
        "allah",
        "kangaroo",
        "angelic"
      })),
      in_air = v18_2.push("visuals", "animation_breaker.in_air", v21_4.new(ui.new_combobox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  legs in air"), "animation_breaker"), {
        "default",
        "static",
        "haram",
        "kangaroo"
      })),
      body_lean = v18_2.push("visuals", "animation_breaker.body_lean", v21_4.new(ui.new_slider, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  body lean"), "animation_breaker"), 0, 100, 0, true, "%", 1, {
        [0] = "Off"
      })),
      pitch_on_land = v18_2.push("visuals", "animation_breaker.pitch_on_land", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  pitch on land"), "animation_breaker"))),
      smooth_animfix = v18_2.push("visuals", "animation_breaker.smooth_animfix", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  smooth animfix"), "animation_breaker")))
    }
    local v47_3 = {}
    v47_3.enabled = v18_2.push("visuals", "never_slide.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "never slide"))
    v19_4.push(-1, v47_3.enabled)
    v38_3.never_slide = v47_3
    v29_4.misc = v38_3
  end
  local v39_5 = {}
  do
    local str = v12.name .. "#db"
    local read = database.read(str)
    read = read or {}
    local v42_3 = {}
    local v43_2 = {}
    local v44_5 = {}
    v44_5[1] = {
      name = "default",
      data = "angelwings_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"
    }
    for _FORV_48_ = 1, #read do
      v42_3[_FORV_48_] = read[_FORV_48_]
    end
    for _FORV_48_ = #v44_5, 1, -1 do
      local v49 = v44_5[_FORV_48_]
      if v49.data ~= nil then
        local decode, decode_2 = v18_2.decode(v49.data)
        if decode then
          v49.data = decode_2
        else
          table.remove(v44_5, _FORV_48_)
        end
      end
    end
    local v45_6 = function(arg1, arg2, arg3)
      return {
        name = arg1,
        data = arg2,
        default = arg3
      }
    end
    local v46_2 = function(arg1, arg2)
      for _FORV_5_ = 1, #arg1 do
        local v6 = arg1[_FORV_5_]
        if v6.name == arg2 then
          return v6, _FORV_5_
        end
      end
      return nil, -1
    end
    local v47_4 = function()
      database.write(str, v42_3)
      do return end
    end
    local v48_2 = function()
      for _FORV_3_ = 1, #v43_2 do
        v43_2[_FORV_3_] = nil
      end
      for _FORV_3_ = 1, #v44_5 do
        local v4 = v44_5[_FORV_3_]
        table.insert(v43_2, (v45_6(v4.name, v4.data, true)))
      end
      for _FORV_3_ = 1, #v42_3 do
        local v4_2 = v42_3[_FORV_3_]
        local v45_6_2 = v45_6(v4_2.name, v4_2.data, false)
        v45_6_2.data_index = _FORV_3_
        table.insert(v43_2, v45_6_2)
      end
      return
    end
    local v49_2 = function()
      local v0 = {}
      for _FORV_4_ = 1, #v43_2 do
        local v5 = v43_2[_FORV_4_]
        local name = v5.name
        if v5.default then
          name = "*" .. name
        end
        table.insert(v0, name)
      end
      return v0
    end
    local v50 = function(arg1)
      local v46_2_2 = v46_2
      return v46_2_2(v43_2, arg1)
    end
    local v51 = function(arg1)
      local v50_2, v50_3 = v50(arg1)
      if v50_2 == nil or v50_3 == -1 then
        v17_2.error("config not found")
        return
      end
      v18_2.import(v50_2.data)
      v17_2.success(string.format("%s config is loaded", v50_2.name))
      client.fire_event("config_loaded", v50_2.name)
      return
    end
    local v52 = function(arg1)
      local export = v18_2.export()
      local v50_2, v50_3 = v50(arg1)
      if v50_2 == nil or v50_3 == -1 then
        table.insert(v42_3, v45_6(arg1, export, false))
        v47_4()
        v48_2()
        v39_5.list:update(v49_2())
        v17_2.success(string.format("%s config is created", arg1))
        return
      end
      if not v50_2.default then
        v50_2.data = export
        if v50_2.data_index ~= nil then
          local v4 = v42_3[v50_2.data_index]
          if v4 ~= nil then
            v4.data = export
          end
        end
        v47_4()
        v48_2()
        v17_2.success(string.format("%s config is saved", arg1))
        return
      end
      v17_2.error("unable to edit default config")
      return
    end
    local v53 = function(arg1)
      local v50_2, v50_3 = v50(arg1)
      if v50_2 == nil or v50_3 == -1 then
        return
      end
      if not v50_2.default then
        local data_index = v50_2.data_index
        if data_index == nil then
          return
        end
        table.remove(v42_3, data_index)
        v47_4()
        v48_2()
        v39_5.list:update(v49_2())
        local v4 = ""
        local v6 = v43_2[math.min(v39_5.list:get() + 1, #v43_2)]
        if v6 ~= nil then
          v4 = v6.name
        end
        v39_5.input:set(v4)
        return
      end
      v17_2.error("unable to delete default config")
      return
    end
    v39_5.list = v21_4.new(ui.new_listbox, "AA", "Anti-aimbot angles", [[

 config.list]], {})
    v39_5.input = v21_4.new(ui.new_textbox, "AA", "Anti-aimbot angles", [[

 config.input]], "")
    v39_5.load_button = v21_4.new(ui.new_button, "AA", "Anti-aimbot angles", "load", function()
      local trim = v13_2.trim(v39_5.input:get())
      if trim == "" then
        return
      end
      v51(trim)
      return
    end)
    v39_5.save_button = v21_4.new(ui.new_button, "AA", "Anti-aimbot angles", "save", function()
      local trim = v13_2.trim(v39_5.input:get())
      if trim == "" then
        return
      end
      v52(trim)
      return
    end)
    v39_5.delete_button = v21_4.new(ui.new_button, "AA", "Anti-aimbot angles", "delete", function()
      local trim = v13_2.trim(v39_5.input:get())
      if trim == "" then
        v17_2.error("unable to delete empty config")
        return
      end
      v53(trim)
      return
    end)
    v39_5.export_button = v21_4.new(ui.new_button, "AA", "Anti-aimbot angles", "export", function()
      local encode, encode_2 = v18_2.encode(v18_2.export())
      if encode then
        clipboard.set(encode_2)
        v17_2.success("config exported")
        return
      end
      return
    end)
    v39_5.import_button = v21_4.new(ui.new_button, "AA", "Anti-aimbot angles", "import", function()
      local decode, decode_2 = v18_2.decode(clipboard.get())
      if decode then
        v18_2.import(decode_2)
        v17_2.success("config imported")
        return
      end
      return
    end)
    v48_2()
    v39_5.list:update(v49_2())
    v39_5.list:set_callback(function(arg1)
      local v1 = arg1:get()
      if v1 == nil then
        return
      end
      local v2 = v43_2[v1 + 1]
      if v2 == nil then
        return
      end
      v39_5.input:set(v2.name)
      return
    end)
    v29_4.config = v39_5
  end
  local v40_4 = function(arg1)
    local angles = v14_2.antiaimbot.angles
    local v2 = ui.get(angles.pitch[1])
    local v3 = ui.get(angles.yaw[1])
    local v4 = ui.get(angles.body_yaw[1])
    ui.set_visible(angles.enabled, arg1)
    ui.set_visible(angles.pitch[1], arg1)
    if v2 == "Custom" then
      ui.set_visible(angles.pitch[2], arg1)
    end
    ui.set_visible(angles.yaw_base, arg1)
    ui.set_visible(angles.yaw[1], arg1)
    if v3 ~= "Off" then
      local v5 = ui.get(angles.yaw_jitter[1])
      ui.set_visible(angles.yaw[2], arg1)
      ui.set_visible(angles.yaw_jitter[1], arg1)
      if v5 ~= "Off" then
        ui.set_visible(angles.yaw_jitter[2], arg1)
      end
    end
    ui.set_visible(angles.body_yaw[1], arg1)
    if v4 ~= "Off" then
      if v4 ~= "Opposite" then
        ui.set_visible(angles.body_yaw[2], arg1)
      end
      ui.set_visible(angles.freestanding_body_yaw, arg1)
    end
    ui.set_visible(angles.edge_yaw, arg1)
    ui.set_visible(angles.freestanding[1], arg1)
    ui.set_visible(angles.freestanding[2], arg1)
    ui.set_visible(angles.roll, arg1)
    return
  end
  local v41_3 = function(arg1)
    local fake_lag = v14_2.antiaimbot.fake_lag
    ui.set_visible(fake_lag.enabled[1], arg1)
    ui.set_visible(fake_lag.enabled[2], arg1)
    ui.set_visible(fake_lag.amount, arg1)
    ui.set_visible(fake_lag.variance, arg1)
    ui.set_visible(fake_lag.limit, arg1)
    return
  end
  local v42_4 = function(arg1)
    local defensive = arg1.defensive
    if arg1.override ~= nil then
      v22_5.set(arg1.override, true)
    elseif arg1.override:get() then
      if arg1.bomb_e_fix ~= nil then
        v22_5.set(arg1.bomb_e_fix, true)
      end
      if arg1.pitch ~= nil then
        v22_5.set(arg1.pitch, true)
      end
      if arg1.yaw_offset ~= nil then
        v22_5.set(arg1.yaw_offset, true)
        v22_5.set(arg1.add_yaw, true)
        if arg1.add_yaw:get() then
          v22_5.set(arg1.yaw_left, true)
          v22_5.set(arg1.yaw_right, true)
          v22_5.set(arg1.yaw_random, true)
        end
      end
      if arg1.yaw_jitter ~= nil then
        v22_5.set(arg1.yaw_jitter, true)
        if arg1.yaw_jitter:get() ~= "off" then
          if arg1.yaw_jitter:get() == "5-way" then
            v22_5.set(arg1.way_method, true)
            if arg1.way_method:get() == "default" then
              v22_5.set(arg1.jitter_offset, true)
              v22_5.set(arg1.jitter_random, true)
            end
            if arg1.way_method:get() == "custom" then
              for _FORV_5_ = 1, 5 do
                v22_5.set(arg1.ways[_FORV_5_], true)
              end
              v22_5.set(arg1.jitter_offset, true)
              v22_5.set(arg1.jitter_random, true)
            end
          end
        end
      end
      if arg1.body_yaw ~= nil then
        v22_5.set(arg1.body_yaw, true)
        if arg1.body_yaw:get() ~= "off" then
          if arg1.body_yaw:get() == "min/max" then
            v22_5.set(arg1.body_yaw_offset_min, true)
            v22_5.set(arg1.body_yaw_offset_max, true)
          else
            v22_5.set(arg1.body_yaw_offset, true)
          end
          if arg1.body_yaw:get() == "static" then
            v22_5.set(arg1.freestanding_body_yaw, true)
          else
            v22_5.set(arg1.delay_mode, true)
            if arg1.delay_mode:get() == "custom" then
              local v2 = arg1.delay_count:get()
              v22_5.set(arg1.delay_count, true)
              for _FORV_6_ = 1, v2 do
                v22_5.set(arg1.delays[_FORV_6_], true)
              end
            end
            v22_5.set(arg1.delays[1], true)
            v22_5.set(arg1.delays[2], true)
            v22_5.set(arg1.invert_chance, true)
          end
        end
      end
      if arg1.separator ~= nil then
        v22_5.set(arg1.separator, true)
      end
      if defensive ~= nil then
        if defensive.force_break_lc ~= nil then
          v22_5.set(defensive.force_break_lc, true)
        end
        v22_5.set(defensive.enabled, true)
        if defensive.enabled:get() then
          v22_5.set(defensive.pitch, true)
          if defensive.pitch:get() ~= "off" and defensive.pitch:get() ~= "angelic" then
            v22_5.set(defensive.pitch_offset_1, true)
            if defensive.pitch:get() ~= "static" then
              v22_5.set(defensive.pitch_label_1, true)
              v22_5.set(defensive.pitch_label_2, true)
              v22_5.set(defensive.pitch_offset_2, true)
            end
            if defensive.pitch:get() == "spin" then
              v22_5.set(defensive.pitch_speed, true)
            end
          end
          v22_5.set(defensive.yaw, true)
          if defensive.yaw:get() ~= "off" then
            if defensive.yaw:get() == "left/right" then
              v22_5.set(defensive.yaw_left, true)
              v22_5.set(defensive.yaw_right, true)
            else
              v22_5.set(defensive.yaw_offset, true)
            end
            if defensive.yaw:get() == "spin" then
              v22_5.set(defensive.yaw_speed, true)
            end
            v22_5.set(defensive.yaw_modifier, true)
            if defensive.yaw_modifier:get() ~= "off" then
              v22_5.set(defensive.modifier_offset, true)
            end
            v22_5.set(defensive.delay, true)
            if defensive.delay:get() then
              v22_5.set(defensive.delays[1], true)
              v22_5.set(defensive.delays[2], true)
              v22_5.set(defensive.delay_affect_modifier, true)
            end
            v22_5.set(defensive.force_target_yaw, true)
          end
        end
      end
      return
    end
    return
  end
  local v43_3 = function()
    v22_5.set(v33_2.wings, true)
    v22_5.set(v33_2.category, true)
    v22_5.set(v34_2.enabled, true)
    if v34_2.enabled:get() then
      v22_5.set(v34_2.amount, true)
      v22_5.set(v34_2.limit, true)
    end
    local v0 = v33_2.category:get()
    if v0 == "anti-aim" then
      local v1 = v35_2.select:get()
      v22_5.set(v35_2.select, true)
      if v1 == "settings" then
        local settings = v35_2.settings
        v22_5.set(settings.avoid_backstab.enabled, true)
        local v3 = settings.safe_head.enabled:get()
        v22_5.set(settings.safe_head.enabled, true)
        if v3 then
          v22_5.set(settings.safe_head.states, true)
        end
        local v4 = settings.force_break_lc_triggers.enabled:get()
        v22_5.set(settings.force_break_lc_triggers.enabled, true)
        if v4 then
          v22_5.set(settings.force_break_lc_triggers.states, true)
        end
        local v5 = settings.defensive_flick.enabled:get()
        v22_5.set(settings.defensive_flick.enabled, true)
        if v5 then
          v22_5.set(settings.defensive_flick.states, true)
        end
        local v6 = settings.freestanding.enabled:get()
        v22_5.set(settings.freestanding.enabled, true)
        v22_5.set(settings.freestanding.hotkey, true)
        if v6 then
          v22_5.set(settings.freestanding.options, true)
          v22_5.set(settings.freestanding.disablers, true)
        end
        local v7 = settings.manual_yaw.enabled:get()
        v22_5.set(settings.manual_yaw.enabled, true)
        if v7 then
          v22_5.set(settings.manual_yaw.options, true)
          v22_5.set(settings.manual_yaw.left_hotkey, true)
          v22_5.set(settings.manual_yaw.right_hotkey, true)
          v22_5.set(settings.manual_yaw.forward_hotkey, true)
          v22_5.set(settings.manual_yaw.backward_hotkey, true)
          v22_5.set(settings.manual_yaw.reset_hotkey, true)
        end
        local v8 = settings.roll_antiaim.enabled:get()
        v22_5.set(settings.roll_antiaim.enabled, true)
        v22_5.set(settings.roll_antiaim.hotkey, true)
        if v8 then
          v22_5.set(settings.roll_antiaim.value, true)
          v22_5.set(settings.roll_antiaim.change_on_fakelag, true)
          if settings.roll_antiaim.change_on_fakelag:get() then
            v22_5.set(settings.roll_antiaim.fakelag_value, true)
          end
        end
      end
      if v1 == "builder" then
        local builder = v35_2.builder
        local v3_2 = builder.state:get()
        v22_5.set(builder.state, true)
        local v4_2 = builder[v3_2]
        if v4_2 ~= nil then
          v42_4(v4_2)
        end
      end
      if v1 == "antibrute" then
        local antibrute = v35_2.antibrute
        v22_5.set(antibrute.enabled, true)
        if antibrute.enabled:get() then
          v22_5.set(antibrute.refresh_modifier, true)
          v22_5.set(antibrute.refresh_offset, true)
          v22_5.set(antibrute.enforce_delay, true)
          v22_5.set(antibrute.duration, true)
        end
      end
    end
    if v0 == "ragebot" then
      v22_5.set(v36_2.resolver.enabled, true)
      local v1_2 = v36_2.aim_tools.enabled:get()
      v22_5.set(v36_2.aim_tools.enabled, true)
      if v1_2 then
        v22_5.set(v36_2.aim_tools.weapon, true)
        v22_5.set(v36_2.aim_tools.esp_flag, true)
        local v2 = v36_2.aim_tools[v36_2.aim_tools.weapon:get()]
        if v2 ~= nil then
          v22_5.set(v2.body_aim, true)
          if v2.body_aim:get("after x misses") then
            v22_5.set(v2.body_misses, true)
          end
          if v2.body_aim:get("hp lower than x") then
            v22_5.set(v2.body_hp, true)
          end
          v22_5.set(v2.safe_point, true)
          if v2.safe_point:get("after x misses") then
            v22_5.set(v2.safe_misses, true)
          end
          if v2.safe_point:get("hp lower than x") then
            v22_5.set(v2.safe_hp, true)
          end
        end
      end
      local v2_2 = v36_2.aimbot_logs.enabled:get()
      v22_5.set(v36_2.aimbot_logs.enabled, true)
      if v2_2 then
        v22_5.set(v36_2.aimbot_logs.color_hit, true)
        v22_5.set(v36_2.aimbot_logs.color_miss, true)
        v22_5.set(v36_2.aimbot_logs.show_on_screen, true)
        if v36_2.aimbot_logs.show_on_screen:get() then
          v22_5.set(v36_2.aimbot_logs.label_background, true)
          v22_5.set(v36_2.aimbot_logs.color_background, true)
          v22_5.set(v36_2.aimbot_logs.logo, true)
          v22_5.set(v36_2.aimbot_logs.glow, true)
          v22_5.set(v36_2.aimbot_logs.offset, true)
          v22_5.set(v36_2.aimbot_logs.duration, true)
        end
      end
      v22_5.set(v36_2.angelic_tap.enabled, true)
      v22_5.set(v36_2.teleport_fix.enabled, true)
      local v3_3 = v36_2.force_shot.enabled:get()
      v22_5.set(v36_2.force_shot.enabled, true)
      if v3_3 then
        v22_5.set(v36_2.force_shot.hotkey, true)
        v22_5.set(v36_2.force_shot.hc, true)
        v22_5.set(v36_2.force_shot.indicator, true)
      end
      local v4_3 = v36_2.ai_peek.enabled:get()
      v22_5.set(v36_2.ai_peek.enabled, true)
      if v4_3 then
        v22_5.set(v36_2.ai_peek.weapon, true)
      end
      local v5_2 = v36_2.air_autostop.enabled:get()
      v22_5.set(v36_2.air_autostop.enabled, true)
      if v5_2 then
        v22_5.set(v36_2.air_autostop.hotkey, true)
      end
      local v6_2 = v36_2.auto_hide_shots.enabled:get()
      v22_5.set(v36_2.auto_hide_shots.enabled, true)
      if v6_2 then
        v22_5.set(v36_2.auto_hide_shots.weapons, true)
        v22_5.set(v36_2.auto_hide_shots.states, true)
      end
      v22_5.set(v36_2.hide_shots_fix.enabled, true)
      v22_5.set(v36_2.allow_duck_on_fd.enabled, true)
      local v7_2 = v36_2.interpolation.enabled:get()
      v22_5.set(v36_2.interpolation.enabled, true)
      if v7_2 then
        v22_5.set(v36_2.interpolation.draw_indicator, true)
        v22_5.set(v36_2.interpolation.safe_mode, true)
        v22_5.set(v36_2.interpolation.unsafe, true)
        v22_5.set(v36_2.interpolation.extrapolation, true)
        v22_5.set(v36_2.interpolation.force_extrapolation, true)
        v22_5.set(v36_2.interpolation.force_extrapolation_hotkey, true)
      end
    end
    if v0 == "visuals" then
      v22_5.set(v37_3.allow_dpi_scale.enabled, true)
      local v1_3 = v37_3.watermarks.enabled:get()
      v22_5.set(v37_3.watermarks.enabled, true)
      if v1_3 then
        v22_5.set(v37_3.watermarks.types, true)
        if v37_3.watermarks.types:get("corner") then
          v22_5.set(v37_3.watermarks.color_corner, true)
        end
        if v37_3.watermarks.types:get("branded") then
          v22_5.set(v37_3.watermarks.color_branded, true)
        end
      end
      local v2_3 = v37_3.indicators.enabled:get()
      v22_5.set(v37_3.indicators.enabled, true)
      if v2_3 then
        v22_5.set(v37_3.indicators.style, true)
        if v37_3.indicators.style:get() ~= "\227\130\138\227\129\157\227\129\134" then
          v22_5.set(v37_3.indicators.offset, true)
        end
        v22_5.set(v37_3.indicators.color_accent, true)
        v22_5.set(v37_3.indicators.color_secondary, true)
      end
      local v3_4 = v37_3.damage_indicator.enabled:get()
      v22_5.set(v37_3.damage_indicator.enabled, true)
      if v3_4 then
        v22_5.set(v37_3.damage_indicator.if_override, true)
        v22_5.set(v37_3.damage_indicator.font, true)
        v22_5.set(v37_3.damage_indicator.color, true)
      end
      local v4_4 = v37_3.manual_arrows.enabled:get()
      v22_5.set(v37_3.manual_arrows.enabled, true)
      if v4_4 then
        local v5_3 = v37_3.manual_arrows.style:get()
        v22_5.set(v37_3.manual_arrows.style, true)
        v22_5.set(v37_3.manual_arrows.offset, true)
        if v5_3 == "modern" then
          v22_5.set(v37_3.manual_arrows.animate_scope, true)
        end
        if v5_3 == "invictus" or v5_3 == "ambani" then
          v22_5.set(v37_3.manual_arrows.dynamic_mode, true)
        end
        v22_5.set(v37_3.manual_arrows.color_accent, true)
        v22_5.set(v37_3.manual_arrows.color_secondary, true)
      end
      local v5_4 = v37_3.velocity_warning.enabled:get()
      v22_5.set(v37_3.velocity_warning.enabled, true)
      if v5_4 then
        v22_5.set(v37_3.velocity_warning.offset, true)
        v22_5.set(v37_3.velocity_warning.color_accent, true)
        v22_5.set(v37_3.velocity_warning.color_secondary, true)
      end
      local v6_3 = v37_3.lc_indicator.enabled:get()
      v22_5.set(v37_3.lc_indicator.enabled, true)
      if v6_3 then
        v22_5.set(v37_3.lc_indicator.offset, true)
      end
      v22_5.set(v37_3.old_feature_indicators.enabled, true)
    end
    if v0 == "misc" then
      local v1_4 = v38_3.animated_zoom.enabled:get()
      v22_5.set(v38_3.animated_zoom.enabled, true)
      if v1_4 then
        v22_5.set(v38_3.animated_zoom.speed, true)
      end
      local v2_4 = v38_3.second_zoom_fov.enabled:get()
      v22_5.set(v38_3.second_zoom_fov.enabled, true)
      if v2_4 then
        v22_5.set(v38_3.second_zoom_fov.fov, true)
      end
      v22_5.set(v38_3.fast_ladder.enabled, true)
      v22_5.set(v38_3.console_filter.enabled, true)
      local v3_5 = v38_3.chat_spammer.enabled:get()
      v22_5.set(v38_3.chat_spammer.enabled, true)
      if v3_5 then
        v22_5.set(v38_3.chat_spammer.mode, true)
      end
      local v4_5 = v38_3.clientside_nickname.enabled:get()
      v22_5.set(v38_3.clientside_nickname.enabled, true)
      if v4_5 then
        v22_5.set(v38_3.clientside_nickname.input, true)
        v22_5.set(v38_3.clientside_nickname.set, true)
      end
      local v5_5 = v38_3.animation_breaker.enabled:get()
      v22_5.set(v38_3.animation_breaker.enabled, true)
      if v5_5 then
        v22_5.set(v38_3.animation_breaker.onground, true)
        v22_5.set(v38_3.animation_breaker.in_air, true)
        v22_5.set(v38_3.animation_breaker.body_lean, true)
        v22_5.set(v38_3.animation_breaker.pitch_on_land, true)
        v22_5.set(v38_3.animation_breaker.smooth_animfix, true)
      end
      local v6_4 = v38_3.fps_optimize.enabled:get()
      v22_5.set(v38_3.fps_optimize.enabled, true)
      if v6_4 then
        v22_5.set(v38_3.fps_optimize.always_on, true)
        if not v38_3.fps_optimize.always_on:get() then
          v22_5.set(v38_3.fps_optimize.detections, true)
        end
        v22_5.set(v38_3.fps_optimize.list, true)
      end
      v22_5.set(v38_3.never_slide.enabled, true)
    end
    if v0 == "config" then
      v22_5.set(v39_5.list, true)
      v22_5.set(v39_5.input, true)
      v22_5.set(v39_5.load_button, true)
      v22_5.set(v39_5.save_button, true)
      v22_5.set(v39_5.delete_button, true)
      v22_5.set(v39_5.import_button, true)
      v22_5.set(v39_5.export_button, true)
    end
    return
  end
  local v44_6 = function()
    v40_4(true)
    v41_3(true)
    do return end
  end
  local v45_7 = function()
    local v0 = not v34_2.enabled:get()
    v40_4(false)
    v41_3(v0)
    return
  end
  v22_5.get_event_bus().update:set(v43_3)
  v43_3()
  v22_5.force_update()
  client.set_event_callback("shutdown", v44_6)
  client.set_event_callback("paint_ui", v45_7)
end

-- ===== блок 52 =====
local v38_4 = {}
do
  local v39_6 = 0
  local v40_5 = false
  local v41_4
  local v42_5 = 0
  local v43_4 = {
    -1,
    1,
    0,
    -1,
    1,
    0,
    -1,
    0,
    1,
    -1,
    0,
    1
  }
  local v44_7 = {}
  v44_7.default = 0
  v44_7.defensive = 0
  local v45_8 = {}
  do
    local angles = v14_2.antiaimbot.angles
    local v47_5 = function(arg1, ...)
      if (...) == nil then
        return
      end
      v30_4.set(arg1, ...)
      return
    end
    local v48_3 = {}
    v48_3.__index = v48_3
    function v48_3.clear(arg1)
      for _FORV_4_, _FORV_5_ in pairs(arg1) do
        arg1[_FORV_4_] = nil
      end
      return
    end
    function v48_3.copy(arg1, arg2)
      for _FORV_5_, _FORV_6_ in pairs(arg2) do
        arg1[_FORV_5_] = _FORV_6_
      end
      return
    end
    function v48_3.unset()
      v30_4.unset(angles.roll)
      v30_4.unset(angles.freestanding[2])
      v30_4.unset(angles.freestanding[1])
      v30_4.unset(angles.edge_yaw)
      v30_4.unset(angles.freestanding_body_yaw)
      v30_4.unset(angles.body_yaw[2])
      v30_4.unset(angles.body_yaw[1])
      v30_4.unset(angles.yaw[2])
      v30_4.unset(angles.yaw[1])
      v30_4.unset(angles.yaw_jitter[2])
      v30_4.unset(angles.yaw_jitter[1])
      v30_4.unset(angles.yaw_base)
      v30_4.unset(angles.pitch[2])
      v30_4.unset(angles.pitch[1])
      v30_4.unset(angles.enabled)
      do return end
    end
    function v48_3.set(arg1)
      if arg1.pitch_offset ~= nil then
        arg1.pitch_offset = v13_2.clamp(arg1.pitch_offset, -89, 89)
      end
      if arg1.yaw_offset ~= nil then
        arg1.yaw_offset = v13_2.normalize(arg1.yaw_offset, -180, 180)
      end
      if arg1.jitter_offset ~= nil then
        arg1.jitter_offset = v13_2.normalize(arg1.jitter_offset, -180, 180)
      end
      if arg1.body_yaw_offset ~= nil then
        arg1.body_yaw_offset = v13_2.clamp(arg1.body_yaw_offset, -180, 180)
      end
      v47_5(angles.enabled, arg1.enabled)
      v47_5(angles.pitch[1], arg1.pitch)
      v47_5(angles.pitch[2], arg1.pitch_offset)
      v47_5(angles.yaw_base, arg1.yaw_base)
      v47_5(angles.yaw[1], arg1.yaw)
      v47_5(angles.yaw[2], arg1.yaw_offset)
      v47_5(angles.yaw_jitter[1], arg1.yaw_jitter)
      v47_5(angles.yaw_jitter[2], arg1.jitter_offset)
      v47_5(angles.body_yaw[1], arg1.body_yaw)
      v47_5(angles.body_yaw[2], arg1.body_yaw_offset)
      v47_5(angles.freestanding_body_yaw, arg1.freestanding_body_yaw)
      v47_5(angles.edge_yaw, arg1.edge_yaw)
      if arg1.freestanding == true then
        v47_5(angles.freestanding[1], true)
        v47_5(angles.freestanding[2], "Always on")
      elseif arg1.freestanding == false then
        v47_5(angles.freestanding[1], false)
        v47_5(angles.freestanding[2], "On hotkey")
      end
      v47_5(angles.roll, arg1.roll)
      return
    end
    setmetatable(v45_8, v48_3)
    v38_4.buffer = v45_8
  end
  local v46_3 = {}
  do
    local v47_6 = false
    local v48_4 = 0
    local v49_3 = function()
      v47_6 = not v47_6
      do return end
    end
    local v50_2 = function()
      v48_4 = v48_4 + 1
      do return end
    end
    local v51_2 = function(arg1)
      if arg1.force_target_yaw:get() then
        do
          local v27 = 9
          v27.yaw_left = -v27
        end
        v45_8.yaw_right = 6
        v45_8.body_yaw = "Static"
        local v27_2 = 1
        v27_2.body_yaw_offset = -v27_2
        return
      end
      return
    end
    local v52_2 = function(arg1, arg2)
      local v2 = arg2.pitch:get()
      local v3 = arg2.pitch_speed:get()
      local v4 = arg2.pitch_offset_1:get()
      local v5 = arg2.pitch_offset_2:get()
      if v2 == "off" then
        return
      end
      if v2 == "static" then
        arg1.pitch = "Custom"
        arg1.pitch_offset = v4
        return
      end
      if v2 == "jitter" then
        do
          local v6 = v47_6
          if v47_6 then
            v6 = v5
          else
            v6 = v6 or v4
          end
          arg1.pitch = "Custom"
          arg1.pitch_offset = v6
        end
        return
      end
      if v2 == "spin" then
        local lerp = v13_2.lerp(v4, v5, globals.curtime() * v3 * 0.1 % 1)
        arg1.pitch = "Custom"
        arg1.pitch_offset = lerp
        return
      end
      if v2 == "random" then
        arg1.pitch = "Custom"
        arg1.pitch_offset = v13_2.random_int(v4, v5)
        return
      end
      if v2 == "angelic" then
        arg1.pitch = "Custom"
        arg1.pitch_offset = v13_2.map(math.abs(globals.realtime() % 0.3 - 0.15), 0, 0.15, -89, 89)
        return
      end
      return
    end
    local v53_2 = function(arg1, arg2)
      local v2 = arg2.yaw_modifier:get()
      local v3 = arg2.modifier_offset:get()
      if v2 == "off" then
        return
      end
      if v2 == "offset" then
        do
          local yaw_offset = arg1.yaw_offset
          local v5 = v40_5
          if v40_5 then
            v5 = 0
          else
            v5 = v5 or v3
          end
          yaw_offset = yaw_offset + v5
          arg1.yaw_offset = yaw_offset
        end
        return
      end
      if v2 == "center" then
        if not arg2.delay_affect_modifier:get() then
          local v4 = bit.band(v48_4, 1)
          v4 = bit.band(v48_4, 1) ~= 0
          local yaw_offset_2 = arg1.yaw_offset
          local prod = v4
          if v4 then
            prod = v3 * 0.5
          elseif not prod then
            prod = -v3
            prod = prod * 0.5
          end
          yaw_offset_2 = yaw_offset_2 + prod
          arg1.yaw_offset = yaw_offset_2
        else
          arg1.yaw_left = arg1.yaw_left - v3 * 0.5
          arg1.yaw_right = arg1.yaw_right + v3 * 0.5
        end
        arg1.body_yaw = "Jitter"
        arg1.body_yaw_offset = 1
        return
      end
      if v2 == "skitter" then
        arg1.yaw_offset = arg1.yaw_offset + v3 * v43_4[v39_6 % #v43_4 + 1]
        return
      end
      return
    end
    local v54 = function(arg1, arg2)
      local sum_2, sum
      local v2 = arg2.yaw:get()
      local v3 = arg2.yaw_speed:get()
      sum_2 = arg2.yaw_offset
      local v4 = arg2.yaw_offset.get(sum_2)
      if v2 == "off" then
        return
      end
      arg1.freestanding = false
      arg1.yaw_left = 0
      arg1.yaw_right = 0
      arg1.yaw_offset = 0
      arg1.delay = 1
      arg1.yaw_jitter = "Off"
      arg1.jitter_offset = nil
      sum_2 = v51_2
      sum = arg2
      sum_2(sum)
      if v2 == "static" then
        arg1.yaw = "180"
        arg1.yaw_offset = v4
      end
      if v2 == "spin" then
        sum_2 = globals
        sum_2 = sum_2.curtime
        sum_2 = sum_2()
        sum_2 = sum_2 * v3
        sum_2 = sum_2 * 0.1
        do
          sum = v4 * 0.5
          sum = 180 + v13_2.lerp(-sum, sum, sum_2 % 1)
        end
        arg1.yaw = "180"
        arg1.yaw_offset = sum
      end
      if v2 == "random" then
        sum_2 = math
        sum_2 = sum_2.abs
        sum = v4 * 0.5
        do
          sum_2 = sum_2(sum)
          sum = v13_2
          sum = sum.random_int
          sum = sum(-sum_2, sum_2)
          sum_2 = 180 + sum
        end
        arg1.yaw = "180"
        arg1.yaw_offset = sum_2
      end
      if v2 == "left/right" then
        arg1.yaw = "180"
        arg1.yaw_offset = 0
        sum_2 = arg1.yaw_left
        sum = arg2.yaw_left
        sum = sum.get
        sum = sum(sum)
        sum_2 = sum_2 + sum
        arg1.yaw_left = sum_2
        sum_2 = arg1.yaw_right
        sum = arg2.yaw_right
        sum = sum.get
        sum = sum(sum)
        sum_2 = sum_2 + sum
        arg1.yaw_right = sum_2
      end
      if v2 == "side-based" then
        arg1.yaw = "180"
        arg1.yaw_offset = 0
        sum_2 = arg1.yaw_left
        sum_2 = sum_2 - 90
        sum = v13_2
        sum = sum.random_int
        sum = sum(-v4, v4)
        sum_2 = sum_2 + sum
        arg1.yaw_left = sum_2
        sum_2 = arg1.yaw_right
        sum_2 = sum_2 + 90
        sum = v13_2
        sum = sum.random_int
        sum = sum(-v4, v4)
        sum_2 = sum_2 + sum
        arg1.yaw_right = sum_2
      end
      sum_2 = v53_2
      sum = arg1
      sum_2(sum, arg2)
      return
    end
    local v55 = function(arg1, arg2)
      local v2 = 1
      if arg2.delay:get() then
        v2 = math.max(1, v13_2.random_int(arg2.delays[1]:get(), (arg2.delays[2]:get())))
      end
      arg1.delay = v2
      return
    end
    function v46_3.update(arg1, arg2)
      if arg2.chokedcommands == 0 then
        v49_3()
        v50_2()
      end
      return
    end
    function v46_3.apply(arg1, arg2, arg3)
      local is_double_tap_active, is_duck_peek_assist, v7 = arg3.force_break_lc, nil, nil
      if is_double_tap_active ~= nil then
        is_double_tap_active = arg3.force_break_lc
        is_duck_peek_assist = is_double_tap_active
        is_double_tap_active = is_double_tap_active.get
        is_double_tap_active = is_double_tap_active(is_duck_peek_assist)
        arg2.force_defensive = is_double_tap_active
      end
      is_double_tap_active = v14_2
      is_double_tap_active = is_double_tap_active.is_double_tap_active
      is_double_tap_active = is_double_tap_active()
      if not is_double_tap_active then
        is_double_tap_active = v14_2
        is_double_tap_active = is_double_tap_active.is_on_shot_antiaim_active
        is_double_tap_active = is_double_tap_active()
      end
      is_duck_peek_assist = v14_2
      is_duck_peek_assist = is_duck_peek_assist.is_duck_peek_assist
      is_duck_peek_assist = is_duck_peek_assist()
      if is_double_tap_active and not is_duck_peek_assist then
        v7 = v24_5.get().defensive.left
        v7 = v7 > 0
        if arg3.enabled:get() and v7 then
          local v8 = {}
          v52_2(v8, arg3)
          v54(v8, arg3)
          v55(v8, arg3)
          v45_8.defensive = v8
          return true
        end
        return false
      end
      return false
    end
  end
  local v47_7 = {}
  do
    local builder = v29_4.antiaim.builder
    local v49_4 = function(arg1)
      return (arg1:gsub("^%l", string.upper))
    end
    local v50_3 = function()
      local v0_2 = next(entity.get_players(true))
      v0_2 = next(entity.get_players(true)) == nil
      return v0_2
    end
    local v51_3 = function(arg1)
      if arg1.pitch == nil then
        return
      end
      local v1 = arg1.pitch:get()
      if v1 == "off" then
        v45_8.pitch = "Off"
        v45_8.pitch_offset = nil
        return
      end
      if v1 == "down" then
        v45_8.pitch = "Custom"
        v45_8.pitch_offset = 89
        return
      end
      if v1 == "up" then
        v45_8.pitch = "Custom"
        local v26 = 89
        v26.pitch_offset = -v26
        return
      end
      if v1 == "random" then
        v45_8.pitch = "Custom"
        v45_8.pitch_offset = v13_2.random_int(-89, 89)
        return
      end
      return
    end
    local v52_3 = function(arg1)
      if arg1.yaw_offset == nil then
        return
      end
      local v1 = arg1.yaw_offset:get()
      v45_8.yaw_left = 0
      v45_8.yaw_right = 0
      if arg1.add_yaw:get() then
        local v2 = arg1.yaw_random:get()
        local v3 = arg1.yaw_left:get()
        local v4 = arg1.yaw_right:get()
        if v2 > 0 then
          local prod = v2 * 0.01
          local random_float = client.random_float(-prod * 0.6, prod * 0.6)
          v3 = v3 + v3 * random_float
          v4 = v4 + v4 * random_float
        end
        v45_8.yaw_left = v3
        v45_8.yaw_right = v4
      end
      v45_8.yaw = "180"
      v45_8.yaw_offset = v1
      return
    end
    local v53_3 = function(arg1)
      if arg1.yaw_jitter == nil then
        return
      end
      local v1 = arg1.yaw_jitter:get()
      local v2 = arg1.jitter_offset:get()
      if v1 == "off" then
        v45_8.yaw_jitter = "Off"
        v45_8.jitter_offset = nil
        return
      end
      local v3 = true
      if v1 == "5-way" and arg1.way_method:get() == "custom" then
        v45_8.ways = {}
        for _FORV_7_ = 1, 5 do
          v45_8.ways[_FORV_7_] = arg1.ways[_FORV_7_]:get()
        end
        v3 = false
      end
      if v3 then
        local v4 = arg1.jitter_random:get()
        if v4 > 0 then
          local prod = v4 * 0.01
          v2 = v2 + v2 * client.random_float(-prod * 0.6, prod * 0.6)
        end
      end
      v45_8.yaw_jitter = v49_4(v1)
      v45_8.jitter_offset = v2
      return
    end
    local v54_2 = function(arg1)
      if arg1.body_yaw == nil then
        return
      end
      local v1 = arg1.body_yaw:get()
      local v2 = arg1.body_yaw_offset:get()
      v45_8.freestanding_body_yaw = false
      if v1 == "off" then
        v45_8.body_yaw = "Off"
        v45_8.body_yaw_offset = nil
        return
      end
      if v1 == "static" then
        v45_8.freestanding_body_yaw = arg1.freestanding_body_yaw:get()
      end
      if v1 == "min/max" then
        local v3 = arg1.body_yaw_offset_min:get()
        local v4 = arg1.body_yaw_offset_max:get()
        if v3 > v4 then
          local v5 = v4
          v4 = v3
          v3 = v5
        end
        v1 = "jitter"
        v2 = math.random(v3, v4)
      end
      v45_8.body_yaw = v49_4(v1)
      v45_8.body_yaw_offset = v2
      return
    end
    local v55_2 = function(arg1)
      if arg1.body_yaw == nil then
        return
      end
      local v1 = arg1.body_yaw:get()
      if v1 == "jitter" or v1 == "random" or v1 == "min/max" then
        local v3 = arg1.delay_mode:get()
        if v3 == "default" then
          v45_8.delay = v13_2.random_int(arg1.delays[1]:get(), (arg1.delays[2]:get()))
          return
        end
        if v3 == "custom" then
          local v6 = arg1.delays[math.random(1, (arg1.delay_count:get()))]
          if v6 ~= nil then
            v45_8.delay = v6:get()
          end
        end
        return
      end
      v45_8.delay = nil
      return
    end
    local v56 = function(arg1)
      if arg1.body_yaw == nil or arg1.invert_chance == nil then
        return
      end
      local v1 = arg1.body_yaw:get()
      if v1 == "jitter" or v1 == "random" or v1 == "min/max" then
        v45_8.invert_chance = arg1.invert_chance:get()
        return
      end
      return
    end
    function v47_7.get(arg1, arg2)
      return builder[arg2]
    end
    function v47_7.apply_ex(arg1, arg2)
      if arg2 == nil then
        return false
      end
      v45_8.enabled = true
      v45_8.pitch = "Down"
      v45_8.yaw_base = "At targets"
      v51_3(arg2)
      v52_3(arg2)
      v53_3(arg2)
      v54_2(arg2)
      v55_2(arg2)
      v56(arg2)
      return true
    end
    function v47_7.apply(arg1, arg2)
      local v2 = arg1:get(arg2)
      if v2 == nil then
        return nil
      end
      if v2.override == nil or v2.override:get() then
        if arg1:apply_ex(v2) then
          return v2
        end
        return nil
      end
      return nil
    end
    function v47_7.update(arg1)
      if v24_5.get().shift or arg1:apply("fakelag") == nil then
        if not v50_3() or arg1:apply("dormant") == nil then
          if arg1:apply(v25_6.get()[#v25_6.get()]) == nil then
            return arg1:apply("shared")
          end
          return (arg1:apply(v25_6.get()[#v25_6.get()]))
        end
        return (v25_6.get())
      end
      return (v25_6.get())
    end
  end
  local v48_5 = {}
  do
    local antibrute = v29_4.antiaim.antibrute
    local v50_4, v51_4, v52_4, v53_4
    local event_bus_2 = v20_4.get_event_bus()
    local v55_3 = function()
      if not antibrute.refresh_offset:get() then
        return nil
      end
      local random = math.random
      return random(-7, 13)
    end
    local v56_2 = function()
      local v0_2 = antibrute.refresh_modifier:get()
      if v0_2 == "increase" then
        local random = math.random
        return random(0, 5)
      end
      if v0_2 == "decrease" then
        local random_2 = math.random
        return random_2(-5, 0)
      end
      if v0_2 == "adaptive" then
        local random_3 = math.random
        return random_3(-3, 5)
      end
      return nil
    end
    local v57 = function()
      v50_4 = nil
      v51_4 = nil
      v52_4 = nil
      v53_4 = nil
      do return end
    end
    function v48_5.update()
      if antibrute.enabled:get() then
        if v50_4 ~= nil and globals.curtime() > v50_4 then
          v57()
          return false
        end
        if v51_4 ~= nil then
          v45_8.delay = v51_4
        end
        if v52_4 ~= nil and v45_8.yaw_offset ~= nil then
          v45_8.yaw_offset = v45_8.yaw_offset + v52_4
        end
        if v53_4 ~= nil and v45_8.jitter_offset ~= nil then
          v45_8.jitter_offset = v45_8.jitter_offset + v53_4
        end
        return true
      end
      do return false end
    end
    local v58 = function()
      local v0_2 = antibrute.duration:get()
      if v0_2 ~= 9 then
        v50_4 = globals.curtime() + v0_2 * 0.1
      end
      if antibrute.enforce_delay:get() then
        v51_4 = math.random(1, 5)
      end
      v52_4 = v55_3()
      v53_4 = v56_2()
      return
    end
    antibrute.enabled:set_callback(function(arg1)
      local v1 = arg1:get()
      if not v1 then
        v57()
      end
      event_bus_2.enemy_shot:set(v58, v1)
      return
    end, true)
  end
  local v49_5 = {}
  do
    local freestanding = v29_4.antiaim.settings.freestanding
    local v51_5, v52_5
    local v53_5 = function(arg1, arg2)
      local v2 = math.abs(arg2 - arg1)
      v2 = 2 >= math.abs(arg2 - arg1)
      return v2
    end
    local v54_3 = function()
      if v23_5.is_onground then
        if not v23_5.is_crouched then
          if not v23_5.is_moving then
            return "standing"
          end
          if not v14_2.is_slow_motion() then
            return "moving"
          end
          return "slow walk"
        end
        return "crouching"
      end
      do return "air" end
    end
    local v55_4 = function(arg1)
      local current_threat = client.current_threat()
      if current_threat == nil then
        return nil
      end
      return (vector(entity.get_origin(current_threat)) - vector(entity.get_origin(arg1))):angles() - 180
    end
    local v56_3 = function(arg1)
      if not v53_5(arg1, -90) then
        if not v53_5(arg1, 90) then
          return nil
        end
        return 90
      end
      return -90
    end
    local v57_2 = function()
      local me = entity.get_local_player()
      if me == nil then
        return nil
      end
      local entity_2_2 = entity_2(me)
      if entity_2_2 == nil then
        return nil
      end
      local v2 = entity_2_2:get_anim_state()
      if v2 == nil then
        return nil
      end
      local v55_4_2 = v55_4(me)
      if v55_4_2 == nil then
        return nil
      end
      local v56_3_2 = v56_3
      return v56_3_2(v13_2.normalize(v2.eye_angles_y - v55_4_2, -180, 180))
    end
    local v58_2 = function()
      local v0 = freestanding.disablers.get
      return v0(freestanding.disablers, v54_3())
    end
    local v59 = function()
      if freestanding.enabled:get() then
        if freestanding.hotkey:get() then
          return not v58_2()
        end
        return false
      end
      do return false end
    end
    local v60 = function(arg1)
      local v1 = v47_7:get("freestanding")
      if v1.override ~= nil and not v1.override:get() then
        v1 = nil
      end
      if v52_5 ~= nil then
        v45_8.pitch = "Default"
        if freestanding.options:get("disable yaw modifiers") then
          v45_8.yaw_left = 0
          v45_8.yaw_right = 0
          v45_8.yaw_jitter = "Off"
          v45_8.jitter_offset = 0
        end
        if freestanding.options:get("body freestanding") then
          v45_8.body_yaw = "Static"
          v45_8.body_yaw_offset = 180
          v45_8.freestanding_body_yaw = true
        end
        if v1 ~= nil then
          v47_7:apply_ex(v1)
        end
      end
      if v23_5.is_vulnerable and v1 ~= nil and v1.defensive ~= nil then
        if not v46_3:apply(arg1, v1.defensive) then
          if v52_5 ~= nil then
            v51_5 = v52_5
          end
        else
          local yaw_offset = v45_8.defensive.yaw_offset
          if yaw_offset ~= nil and v51_5 ~= nil then
            v45_8.defensive.yaw_offset = yaw_offset + v51_5
          end
        end
      end
      return
    end
    function v49_5.update(arg1, arg2)
      if v59() then
        if arg2.chokedcommands == 0 then
          v52_5 = v57_2()
        end
        v45_8.freestanding = true
        v60(arg2)
        return
      end
      v52_5 = nil
      return
    end
  end
  local v50_5 = {}
  do
    local v51_6 = false
    local v52_6 = function(arg1, arg2)
      local me = entity.get_local_player()
      if me == nil then
        return false
      end
      local player_weapon = entity.get_player_weapon(me)
      if player_weapon == nil then
        return false
      end
      local csgo_weapons_2 = csgo_weapons(player_weapon)
      if csgo_weapons_2 == nil then
        return false
      end
      local team_num = entity.get_prop(me, "m_iTeamNum")
      local vec = vector(entity.get_origin(me))
      do
        local v7 = csgo_weapons_2.idx
        v7 = csgo_weapons_2.idx == 49
        do
          local v8 = entity.get_prop(me, "m_bIsDefusing")
          v8 = entity.get_prop(me, "m_bIsDefusing") == 1
          local v9 = entity.get_prop(me, "m_bIsGrabbingHostage")
          v9 = entity.get_prop(me, "m_bIsGrabbingHostage") == 1
          local v10 = entity.get_prop(me, "m_bInBombZone")
          v10 = entity.get_prop(me, "m_bInBombZone") == 1
          if not v8 and not v9 then
            if not v10 or arg2.bomb_e_fix:get() and not v7 then
              if team_num == 3 and arg1.pitch > 15 then
                local all = entity.get_all("CPlantedC4")
                for _FORV_15_ = 1, #all do
                  if 3844 > (vector(entity.get_origin(all[_FORV_15_])) - vec):lengthsqr() then
                    return false
                  end
                end
              end
              local v12 = vector():init_from_angles(vector(client.camera_angles()):unpack())
              local vec_2 = vector(client.eye_position())
              local sum = vec_2 + v12 * 128
              local trace_line, trace_line_2 = client.trace_line(me, vec_2.x, vec_2.y, vec_2.z, sum.x, sum.y, sum.z)
              if trace_line ~= 1 then
                if trace_line_2 == -1 then
                  return true
                end
                local classname = entity.get_classname(trace_line_2)
                if classname == "CWorld" then
                  return true
                end
                if classname == "CFuncBrush" then
                  return true
                end
                if classname == "CCSPlayer" then
                  return true
                end
                if classname == "CHostage" and 7056 > vec_2:distsqr((vector(entity.get_origin(trace_line_2)))) then
                  return false
                end
                if not v51_6 then
                  v51_6 = true
                  return false
                end
              end
              return true
            end
            return false
          end
        end
      end
      return false
    end
    function v50_5.update(arg1, arg2)
      if arg2.in_use == 0 then
        v51_6 = false
        return false
      end
      local v2 = v47_7:get("on use")
      if v2 == nil then
        return false
      end
      if v2.override == nil or v2.override:get() then
        if v52_6(arg2, v2) then
          v47_7:apply_ex(v2)
          if v2 ~= nil and v2.defensive ~= nil then
            v46_3:apply(arg2, v2.defensive)
          end
          v45_8.pitch = "Custom"
          v45_8.pitch_offset = arg2.pitch
          v45_8.yaw_base = "Local view"
          v45_8.yaw_offset = v45_8.yaw_offset + 180
          v45_8.freestanding = false
          arg2.in_use = 0
          return true
        end
        return false
      end
      return false
    end
  end
  local v51_7 = {}
  do
    local manual_yaw = v29_4.antiaim.settings.manual_yaw
    local v53_6
    local v54_4 = {}
    local v55_5 = {}
    v55_5.left = -90
    v55_5.right = 90
    v55_5.forward = 180
    v55_5.backward = 0
    local v56_4 = function(arg1, arg2, arg3)
      if arg3 ~= 1 and arg3 ~= 2 then
        return false
      end
      local v3 = false
      v3 = arg1 ~= arg2
      return v3
    end
    local v57_3 = function(arg1, arg2, arg3)
      local v56_4_2 = v56_4(arg1.state, arg2, arg3)
      arg1.state = arg2
      return v56_4_2
    end
    local v58_3 = function(arg1, arg2)
      local v2, v3 = ui.get(arg1)
      if v54_4[arg1] == nil then
        v54_4[arg1] = {state = v2}
      end
      if v57_3(v54_4[arg1], v2, v3) then
        if v53_6 == arg2 then
          v53_6 = nil
        else
          v53_6 = arg2
        end
        return
      end
      return
    end
    local v59_2 = function()
      v58_3(manual_yaw.left_hotkey.ref, "left")
      v58_3(manual_yaw.right_hotkey.ref, "right")
      v58_3(manual_yaw.forward_hotkey.ref, "forward")
      v58_3(manual_yaw.backward_hotkey.ref, "backward")
      v58_3(manual_yaw.reset_hotkey.ref, nil)
      do return end
    end
    function v51_7.get()
      do return v53_6 end
    end
    function v51_7.update(arg1, arg2)
      local v2 = v55_5[v53_6]
      if v2 == nil then
        return false
      end
      local yaw_offset = v45_8.yaw_offset
      yaw_offset = yaw_offset or 0
      v45_8.enabled = true
      v45_8.yaw_offset = yaw_offset + v2
      v45_8.edge_yaw = false
      v45_8.freestanding = false
      v45_8.roll = 0
      if manual_yaw.options:get("disable yaw modifiers") then
        v45_8.yaw_offset = yaw_offset + v2
        v45_8.yaw_left = 0
        v45_8.yaw_right = 0
        v45_8.yaw_jitter = "Off"
        v45_8.jitter_offset = 0
      end
      if manual_yaw.options:get("body freestanding") then
        v45_8.body_yaw = "Static"
        v45_8.body_yaw_offset = 180
        v45_8.freestanding_body_yaw = true
      end
      local v4 = v47_7:apply("manual aa")
      if v4 ~= nil then
        v45_8.yaw_offset = v45_8.yaw_offset + v2
        if v4.defensive ~= nil and v46_3:apply(arg2, v4.defensive) then
          local yaw_offset_2 = v45_8.defensive.yaw_offset
          if yaw_offset_2 ~= nil then
            v45_8.defensive.yaw_offset = yaw_offset_2 + v2
          end
        end
      end
      v45_8.yaw_base = "Local view"
      return true
    end
    client.set_event_callback("paint_ui", v59_2)
    v38_4.manual_yaw = v51_7
  end
  local v52_7 = {}
  do
    local roll_antiaim = v29_4.antiaim.settings.roll_antiaim
    function v52_7.update(arg1, arg2)
      if roll_antiaim.enabled:get() then
        if roll_antiaim.hotkey:get() then
          arg2.roll = roll_antiaim.value:get()
          if roll_antiaim.change_on_fakelag:get() and not v24_5.get().shift then
            arg2.roll = roll_antiaim.fakelag_value:get()
          end
          return
        end
        return
      end
      return
    end
  end
  local v53_7 = {}
  do
    local safe_head = v29_4.antiaim.settings.safe_head
    local v55_6 = 0
    local v56_5 = function(arg1)
      local csgo_weapons_2 = csgo_weapons(arg1)
      if csgo_weapons_2 == nil then
        return false
      end
      local v2 = csgo_weapons_2.type
      v2 = csgo_weapons_2.type == "knife"
      if v2 then
        v2 = csgo_weapons_2.idx
        v2 = v2 ~= 31
      end
      return v2
    end
    local v57_4 = function(arg1, arg2)
      local player_weapon = entity.get_player_weapon(arg1)
      if player_weapon == nil then
        return nil
      end
      local diff = vector(entity.get_origin(arg2)) - vector(entity.get_origin(arg1))
      local v6 = -diff.z
      local v7 = diff:length2dsqr()
      if not v23_5.is_onground then
        if not v23_5.is_crouched or not v56_5(player_weapon) then
          return nil
        end
        return "air crouch knife"
      end
      if (not v23_5.is_moving or v23_5.is_crouched) and v6 >= 10 and v7 > 1000000 then
        return "distance"
      end
      if not v23_5.is_crouched then
        if not v23_5.is_moving and v6 >= 24 then
          do return "standing" end
          if v6 >= 48 then
            return "crouch"
          end
        end
      end
      return nil
    end
    local v58_4 = function(arg1)
      local player_weapon = entity.get_player_weapon(arg1)
      if player_weapon == nil then
        return nil
      end
      local csgo_weapons_2 = csgo_weapons(player_weapon)
      if csgo_weapons_2 == nil then
        return nil
      end
      local max_speed = csgo_weapons_2.max_speed
      max_speed = max_speed or 250
      if entity.get_prop(arg1, "m_bIsScoped") == 1 then
        local max_speed_alt = csgo_weapons_2.max_speed_alt
        max_speed_alt = max_speed_alt or 250
        max_speed = max_speed_alt
      end
      if 0.5 < entity.get_prop(arg1, "m_flDuckAmount") then
        max_speed = max_speed * 0.34
      end
      return max_speed
    end
    local v59_3 = function(arg1, arg2)
      local vec = vector(entity.get_origin(arg1))
      local vec_2 = vector(v13_2.get_eye_position(arg2))
      do
        local v4 = entity.get_prop(arg1, "m_flDuckAmount")
        v4 = 0.5 < entity.get_prop(arg1, "m_flDuckAmount")
        local z = vec.z
        local v6 = v4
        if v4 then
          v6 = 45
        else
          v6 = v6 or 60
        end
        z = z + v6
        vec.z = z
      end
      local ceil = math.ceil
      return ceil(vec.z - vec_2.z)
    end
    local v60_2 = function(arg1)
      if not v14_2.is_freestanding() then
        if arg1 == nil or not entity.is_dormant(arg1) then
          return false
        end
        return true
      end
      return true
    end
    local v61 = function(arg1)
      local v1 = vector(entity.get_prop(arg1, "m_vecVelocity")).length2d
      return v1((vector(entity.get_prop(arg1, "m_vecVelocity"))))
    end
    local v62 = function(arg1)
      local v2 = bit.band(entity.get_prop(arg1, "m_fFlags"), 1)
      v2 = bit.band(entity.get_prop(arg1, "m_fFlags"), 1) ~= 0
      return v2
    end
    local v63 = function(arg1, arg2)
      local health = entity.get_prop(arg2, "m_iHealth")
      if health == nil or health <= 0 then
        return false
      end
      local vec = vector(v13_2.get_eye_position(arg1))
      local vec_2 = vector(entity.get_prop(arg1, "m_vecVelocity"))
      local vec_3 = vector(entity.hitbox_position(arg2, 3))
      local trace_bullet, trace_bullet_2 = client.trace_bullet(arg1, vec.x, vec.y, vec.z, vec_3.x, vec_3.y, vec_3.z, false)
      if trace_bullet ~= arg2 then
        trace_bullet_2 = 0
      end
      if trace_bullet_2 ~= nil and health <= trace_bullet_2 then
        return true
      end
      local extrapolate = v13_2.extrapolate(vec, vec_2, 16)
      local trace_bullet_3, trace_bullet_4 = client.trace_bullet(arg1, extrapolate.x, extrapolate.y, extrapolate.z, vec_3.x, vec_3.y, vec_3.z, false)
      if trace_bullet_3 ~= arg2 then
        trace_bullet_4 = 0
      end
      if trace_bullet_4 ~= nil and health <= trace_bullet_4 then
        return true
      end
      return false
    end
    local v64 = function(arg1, arg2)
      local health = entity.get_prop(arg2, "m_iHealth")
      if health == nil or health <= 0 then
        return false
      end
      local vec = vector(v13_2.get_eye_position(arg1))
      local vec_2 = vector(entity.get_prop(arg1, "m_vecVelocity"))
      local vec_3 = vector(entity.hitbox_position(arg2, 0))
      local trace_bullet, trace_bullet_2 = client.trace_bullet(arg1, vec.x, vec.y, vec.z, vec_3.x, vec_3.y, vec_3.z, false)
      if trace_bullet ~= arg2 then
        trace_bullet_2 = 0
      end
      if trace_bullet_2 ~= nil and health <= trace_bullet_2 then
        return true
      end
      local extrapolate = v13_2.extrapolate(vec, vec_2, 32)
      local trace_bullet_3, trace_bullet_4 = client.trace_bullet(arg1, extrapolate.x, extrapolate.y, extrapolate.z, vec_3.x, vec_3.y, vec_3.z, false)
      if trace_bullet_3 ~= arg2 then
        trace_bullet_4 = 0
      end
      if trace_bullet_4 ~= nil and health <= trace_bullet_4 then
        return true
      end
      return false
    end
    local v65 = function(arg1, arg2)
      local v7, v10
      local v2 = entity.get_prop(arg1, "m_iTeamNum")
      v2 = entity.get_prop(arg1, "m_iTeamNum") == 3
      local v56_5_2 = v56_5((entity.get_player_weapon(arg1)))
      local is_onground = v23_5.is_onground
      if is_onground then
        is_onground = v23_5
        is_onground = is_onground.is_moving
        is_onground = not is_onground
        if is_onground then
          is_onground = v23_5
          is_onground = is_onground.is_crouched
          is_onground = not is_onground
        end
      end
      v7 = arg1
      local v59_3_2 = v59_3(v7, arg2)
      if v56_5_2 then
        v7 = v23_5
        v7 = v7.is_onground
        if not v7 then
          v7 = v23_5
          v7 = v7.is_crouched
        end
      elseif not v7 then
        v7 = is_onground
        if v7 then
          v7 = v2
          if v7 then
            v7 = -6
          else
            v7 = v7 or 20
          end
          v7 = v59_3_2 >= v7
        elseif not v7 then
          v7 = v23_5
          v7 = v7.is_crouched
          if v7 then
            v7 = v23_5
            v7 = v7.is_onground
            if v7 then
              v7 = v2
              if v7 then
                v7 = -20
              else
                v7 = v7 or -4
              end
              v7 = v59_3_2 >= v7
            end
          end
        end
        do
          local v61_2 = v61(arg2)
          v10 = arg2
          v10 = not v62(v10)
          if v10 then
            v10 = v61_2 > 75
          elseif not v10 then
            v10 = v63
            v10 = v10(arg2, arg1)
            v10 = not v10
          end
        end
        if not v7 or not v10 then
          return false
        end
        local tickcount = globals.tickcount()
        local v64_2 = v64(arg2, arg1)
        if v64_2 == false then
          v55_6 = tickcount + 16
          return true
        end
        if v64_2 == true then
          v55_6 = 0
          return false
        end
        local v13 = v55_6
        v13 = tickcount <= v55_6
        return v13
      end
      v7 = v2
      local v7_2 = v2
      if v7 then
        v7_2 = -35
      else
        v7_2 = v7_2 or -20
      end
      v7_2 = v59_3_2 > v7_2
      return v7_2
    end
    local v66 = function(arg1, arg2)
      local v3 = vector(entity.get_prop(arg1, "m_vecVelocity")):length()
      local v58_4_2 = v58_4(arg1)
      v58_4_2 = v58_4_2 or 250
      do
        local v5 = arg2.in_back
        v5 = arg2.in_back == 1
        if v5 then
          v5 = arg2.forwardmove
          v5 = v5 < 0
        end
        local v6 = arg2.in_forward
        v6 = arg2.in_forward == 1
        if v6 then
          v6 = arg2.forwardmove
          v6 = v6 > 0
        end
        local v7 = arg2.in_moveleft
        v7 = arg2.in_moveleft == 1
        if v7 then
          v7 = arg2.sidemove
          v7 = v7 < 0
        end
        local v8 = arg2.in_moveright
        v8 = arg2.in_moveright == 1
        if v8 then
          v8 = arg2.sidemove
          v8 = v8 > 0
        end
        do
          local v9 = entity.get_prop(arg1, "m_vecVelocity")
          v9 = v3 > 1.1001
          if v9 then
            v9 = v58_4_2 * 0.1
            v9 = v58_4_2 - v9
            v9 = v3 < v9
          end
          if not v23_5.is_onground or not not v23_5.is_moving or not not v23_5.is_crouched then
            if v23_5.is_onground then
              if not v6 then
                if not v5 then
                  local v11 = v8
                  if v8 then
                    v11 = 38
                  elseif not v11 then
                    v11 = v7
                    if v11 then
                      v11 = 20
                    else
                      v11 = v11 or 32
                    end
                  end
                  return v11
                end
                local v11_2 = v8
                if v8 then
                  v11_2 = 30
                elseif not v11_2 then
                  v11_2 = v7
                  if v11_2 then
                    v11_2 = 20
                  else
                    v11_2 = v11_2 or 30
                  end
                end
                return v11_2
              end
              if not v9 then
                local v11_3 = v8
                if v8 then
                  v11_3 = 38
                elseif not v11_3 then
                  v11_3 = v7
                  if v11_3 then
                    v11_3 = 14
                  else
                    v11_3 = v11_3 or 26
                  end
                end
                return v11_3
              end
              local v11_4 = v8
              if v8 then
                v11_4 = 33
              elseif not v11_4 then
                v11_4 = v7
                if v11_4 then
                  v11_4 = 20
                else
                  v11_4 = v11_4 or 20
                end
              end
              return v11_4
            end
            return 32
          end
        end
      end
      return 35
    end
    function v53_7.update(arg1, arg2)
      if safe_head.enabled:get() then
        local me = entity.get_local_player()
        local current_threat = client.current_threat()
        if me == nil or current_threat == nil then
          return false
        end
        local v57_4_2 = v57_4(me, current_threat)
        if v57_4_2 ~= nil and safe_head.states:get(v57_4_2) then
          if not v60_2() then
            if v65(me, current_threat) then
              v45_8.pitch = "Down"
              v45_8.yaw_base = "At targets"
              v45_8.yaw = "180"
              v45_8.yaw_offset = -v66(me, arg2) + 45
              v45_8.yaw_left = 0
              v45_8.yaw_right = 0
              v45_8.yaw_jitter = "Off"
              v45_8.jitter_offset = 0
              v45_8.body_yaw = "Static"
              v45_8.body_yaw_offset = 0
              v45_8.freestanding_body_yaw = false
              v45_8.roll = 0
              v45_8.defensive = nil
              return true
            end
            return
          end
          v55_6 = 0
          return false
        end
        return false
      end
      return false
    end
  end
  local v54_5 = {}
  do
    local avoid_backstab = v29_4.antiaim.settings.avoid_backstab
    local v56_6 = function(arg1)
      local csgo_weapons_2 = csgo_weapons(arg1)
      if csgo_weapons_2 == nil then
        return false
      end
      if csgo_weapons_2.idx == 31 then
        return false
      end
      local v2 = csgo_weapons_2.weapon_type_int
      v2 = csgo_weapons_2.weapon_type_int == 0
      return v2
    end
    local v57_5 = function(arg1)
      local player_weapon = entity.get_player_weapon(arg1)
      if player_weapon == nil then
        return false
      end
      local v56_6_2 = v56_6
      return v56_6_2(player_weapon)
    end
    local v58_5 = function(arg1, arg2)
      if v57_5(arg2) then
        local diff = vector(entity.get_origin(arg2)) - vector(entity.get_origin(arg1))
        return diff:lengthsqr(), diff
      end
      return math.huge, nil
    end
    function v54_5.update()
      if avoid_backstab.enabled:get() then
        local me = entity.get_local_player()
        if me == nil then
          return false
        end
        local current_threat = client.current_threat()
        if current_threat == nil then
          return false
        end
        local v58_5_2, v58_5_3 = v58_5(me, current_threat)
        if v58_5_3 == nil or v58_5_2 > 57600 then
          return false
        end
        v45_8.enabled = true
        v45_8.yaw_base = "Local view"
        v45_8.yaw = "Static"
        v45_8.yaw_offset = vector(v58_5_3:angles()).y
        v45_8.freestanding_body_yaw = false
        v45_8.edge_yaw = false
        v45_8.freestanding = false
        v45_8.roll = 0
        v45_8.defensive = nil
        return true
      end
      return false
    end
  end
  local v55_7 = {}
  do
    local force_break_lc_triggers = v29_4.antiaim.settings.force_break_lc_triggers
    local vtable_bind_2 = vtable_bind("client.dll", "VClientEntityList003", 3, "uint32_t(__thiscall*)(void*, int)")
    local v58_6 = function(arg1)
      if arg1 == nil then
        return nil
      end
      local vtable_bind_2_2 = vtable_bind_2(arg1)
      if vtable_bind_2_2 == nil then
        return nil
      end
      return ffi.cast("float*", vtable_bind_2_2 + 66656)[0]
    end
    local v59_4 = function(arg1)
      if arg1 == nil then
        return nil
      end
      local entity_2_2 = entity_2(arg1)
      if entity_2_2 == nil then
        return nil
      end
      local v2 = entity_2_2:get_anim_overlay(1)
      if v2 == nil or v2.entity == nil then
        return nil
      end
      if entity_2_2:get_sequence_activity(v2.sequence) ~= 967 then
        return nil
      end
      if v2.weight == 0 then
        return nil
      end
      return v2.cycle
    end
    local v60_3 = function(arg1)
      if arg1 == nil then
        return nil
      end
      local entity_2_2 = entity_2(arg1)
      if entity_2_2 == nil then
        return nil
      end
      local v2 = entity_2_2:get_anim_overlay(10)
      if v2 == nil then
        return nil
      end
      return v2.weight
    end
    local v61_2 = function(arg1)
      local v58_6_2 = v58_6(arg1)
      local v2 = arg1
      v2 = v58_6_2 ~= nil
      v2 = v2 and v58_6_2 > 0
      return v2
    end
    local v62_2 = function(arg1)
      local v1 = v59_4(arg1)
      v1 = v59_4(arg1) ~= nil
      return v1
    end
    local v63_2 = function(arg1)
      local v60_3_2 = v60_3(arg1)
      local v2 = arg1
      v2 = v60_3_2 ~= nil
      v2 = v2 and v60_3_2 ~= 0
      return v2
    end
    local v64_2 = function()
      if force_break_lc_triggers.enabled:get() then
        local me = entity.get_local_player()
        if me == nil then
          return false
        end
        if not force_break_lc_triggers.states:get("flashed") or not v61_2(me) then
          if not force_break_lc_triggers.states:get("reloading") or not v62_2(me) then
            if not force_break_lc_triggers.states:get("taking damage") or not v63_2(me) then
              return false
            end
            return true
          end
          return true
        end
        return true
      end
      return false
    end
    function v55_7.update(arg1, arg2)
      if v64_2() then
        arg2.force_defensive = 1
        return
      end
      return
    end
  end
  local v56_7 = {}
  do
    local defensive_flick = v29_4.antiaim.settings.defensive_flick
    local v58_7 = 0
    local v59_5 = function()
      if v23_5.is_onground then
        if not v23_5.is_crouched then
          if not v23_5.is_moving then
            return "standing"
          end
          if not v14_2.is_slow_motion() then
            return "moving"
          end
          return "slow walk"
        end
        if not v23_5.is_moving then
          return "crouching"
        end
        return "move-crouching"
      end
      if not v23_5.is_crouched then
        return "air"
      end
      do return "air-crouching" end
    end
    local v60_4 = function()
      if v24_5.get().shift then
        local me = entity.get_local_player()
        if me == nil then
          return false
        end
        local player_weapon = entity.get_player_weapon(me)
        if player_weapon == nil then
          return false
        end
        local csgo_weapons_2 = csgo_weapons(player_weapon)
        if csgo_weapons_2 ~= nil and not csgo_weapons_2.is_revolver then
          local v59_5_2 = v59_5()
          if v59_5_2 == nil then
            return false
          end
          local v5 = defensive_flick.states.get
          return v5(defensive_flick.states, v59_5_2)
        end
        return false
      end
      return false
    end
    local v61_3 = function(arg1, arg2)
      local vec = vector(entity.get_origin(arg1))
      local vec_2 = vector(entity.get_origin(arg2))
      local vector_2 = vector
      return vector_2((vec_2 - vec):angles())
    end
    local v62_3 = function()
      local me = entity.get_local_player()
      if me == nil then
        return
      end
      local current_threat = client.current_threat()
      if current_threat == nil then
        return
      end
      local v61_3_2 = v61_3(me, current_threat)
      local vec = vector(v13_2.get_eye_position(me))
      local vec_2 = vector(entity.hitbox_position(current_threat, 3))
      local v5 = vector():init_from_angles(0, v61_3_2.y + 90)
      local v6 = vector():init_from_angles(0, v61_3_2.y - 90)
      local sum = vec + v5 * 31
      local sum_2 = vec + v6 * 31
      local trace_bullet, trace_bullet_2 = client.trace_bullet(me, sum.x, sum.y, sum.z, vec_2.x, vec_2.y, vec_2.z, false)
      local trace_bullet_3, trace_bullet_4 = client.trace_bullet(me, sum_2.x, sum_2.y, sum_2.z, vec_2.x, vec_2.y, vec_2.z, false)
      if trace_bullet ~= current_threat then
        trace_bullet_2 = 0
      end
      if trace_bullet_3 ~= current_threat then
        trace_bullet_4 = 0
      end
      if (trace_bullet_2 > 0 or trace_bullet_4 > 0) and trace_bullet_2 ~= trace_bullet_4 then
        local v14 = sum_2.y
        if trace_bullet_2 > trace_bullet_4 then
          v14 = -1
        else
          v14 = v14 or 1
        end
        v58_7 = v14
      end
      return
    end
    function v56_7.update(arg1, arg2)
      local v2 = defensive_flick
      v2 = v2.enabled
      v2 = v2.get
      v2 = v2(v2)
      if v2 then
        v2 = v60_4
        v2 = v2()
        if v2 then
          v2 = v62_3
          v2(arg2)
          v2 = v58_7
          v2 = v2 == -1
          do
            local v4 = v24_5.get().defensive.left
            v4 = v24_5.get().defensive.left ~= 0
            do
              local v5 = arg2.command_number % 7
              v5 = arg2.command_number % 7 == 0
              arg2.force_defensive = v5
            end
            do
              local custom = v4
              if v4 then
                custom = "Custom"
              else
                custom = custom or "Default"
              end
              v45_8.pitch = custom
            end
            v45_8.pitch_offset = 0
            v45_8.yaw_base = "At targets"
            v45_8.yaw = "180"
            do
              local v5_2 = v4
              if v4 then
                v5_2 = 90
              else
                v5_2 = v5_2 or 0
              end
              v45_8.yaw_offset = v5_2
            end
            v45_8.yaw_left = 0
            v45_8.yaw_right = 0
            v45_8.yaw_jitter = "Off"
            v45_8.jitter_offset = 0
            v45_8.body_yaw = "Static"
            local v5_3 = v4
            if v4 then
              v5_3 = -1
            else
              v5_3 = v5_3 or 1
            end
            v45_8.body_yaw_offset = v5_3
          end
          v45_8.freestanding_body_yaw = false
          v45_8.edge_yaw = false
          v45_8.freestanding = false
          v45_8.roll = 0
          if v2 then
            v45_8.yaw_offset = -v45_8.yaw_offset
          end
          return
        end
        v2 = false
        return v2
      end
      v2 = false
      return v2
    end
  end
  local v57_6 = function()
    local defensive = v45_8.defensive
    local defensive_2 = v24_5.get().defensive
    if defensive ~= nil and defensive_2.left > 0 then
      v45_8:copy(defensive)
      return true
    end
    return false
  end
  local v58_8 = function(arg1)
    local max, v2 = v24_5, nil
    max = max.get
    max = max()
    max = max.shift
    if max then
      max = math
      max = max.max
      v2 = 1
      do
        local delay = v45_8.delay
        delay = delay or 1
        max = max(v2, delay)
        v2 = v44_7
        v2 = v2[arg1]
        v2 = v2 + 1
        v44_7[arg1] = v2
        v2 = v44_7
        v2 = v2[arg1]
      end
      if max > v2 then
        return
      end
    end
    local v1 = true
    v2 = v45_8
    v2 = v2.body_yaw
    if v2 == "Random" then
      v2 = v13_2
      v2 = v2.random_int
      v2 = v2(0, 1)
      v1 = v2 == 0
    end
    v2 = v45_8
    v2 = v2.invert_chance
    if v2 ~= nil then
      v2 = v45_8
      v2 = v2.invert_chance
      if v2 < v13_2.random_int(0, 100) then
        v1 = false
      end
    end
    v2 = v39_6
    v2 = v2 + 1
    v39_6 = v2
    if v1 then
      v2 = v40_5
      v2 = not v2
      v40_5 = v2
    end
    v44_7[arg1] = 0
    return
  end
  local v59_6 = function()
    if v45_8.body_yaw_offset == nil then
      return
    end
    if v45_8.yaw_left == nil or v45_8.yaw_right == nil then
      return
    end
    local yaw_offset = v45_8.yaw_offset
    yaw_offset = yaw_offset or 0
    if v45_8.body_yaw_offset < 0 then
      v45_8.yaw_offset = yaw_offset + v45_8.yaw_left
    end
    if v45_8.body_yaw_offset > 0 then
      v45_8.yaw_offset = yaw_offset + v45_8.yaw_right
    end
    return
  end
  local v60_5 = function()
    if v45_8.yaw_jitter == "Modern" then
      local jitter_offset = v45_8.jitter_offset
      local prod = globals.tickcount() * 0.25
      local skitter = "Skitter"
      local floor = math.floor(math.sin(prod) * jitter_offset)
      if 2 < globals.realtime() % 4 then
        skitter = "Offset"
      end
      v45_8.yaw_jitter = skitter
      v45_8.jitter_offset = floor
    end
    if v45_8.yaw_jitter == "Angelic" then
      local v0_2 = {
        "Offset",
        "Random",
        "Skitter",
        "Center"
      }
      local jitter_offset_2 = v45_8.jitter_offset
      if 0.15 < globals.realtime() - v42_5 then
        v42_5 = globals.realtime()
        v41_4 = v0_2[math.random(1, #v0_2)]
      end
      v45_8.yaw_jitter = v41_4
      v45_8.jitter_offset = math.floor(math.sin(globals.tickcount() * 0.2) * jitter_offset_2)
    end
    if v45_8.yaw_jitter == "Offset" then
      local yaw_offset = v45_8.yaw_offset
      yaw_offset = yaw_offset or 0
      local jitter_offset_3 = v45_8.jitter_offset
      v45_8.yaw_jitter = "Off"
      v45_8.jitter_offset = 0
      do
        local v2 = v40_5
        if v40_5 then
          v2 = jitter_offset_3
        else
          v2 = v2 or 0
        end
        v2 = yaw_offset + v2
        v45_8.yaw_offset = v2
      end
      return
    end
    if v45_8.yaw_jitter == "Center" then
      local yaw_offset_2 = v45_8.yaw_offset
      yaw_offset_2 = yaw_offset_2 or 0
      local jitter_offset_4 = v45_8.jitter_offset
      if not v40_5 then
        jitter_offset_4 = -jitter_offset_4
      end
      v45_8.yaw_jitter = "Off"
      v45_8.jitter_offset = 0
      v45_8.yaw_offset = yaw_offset_2 + jitter_offset_4 / 2
      return
    end
    if v45_8.yaw_jitter == "Skitter" then
      local v1 = v43_4[v39_6 % #v43_4 + 1]
      local yaw_offset_3 = v45_8.yaw_offset
      yaw_offset_3 = yaw_offset_3 or 0
      v45_8.yaw_jitter = "Off"
      v45_8.jitter_offset = 0
      v45_8.yaw_offset = yaw_offset_3 + v45_8.jitter_offset * v1
      return
    end
    if v45_8.yaw_jitter == "Spin" then
      local prod_2 = globals.curtime() * 3
      local yaw_offset_4 = v45_8.yaw_offset
      yaw_offset_4 = yaw_offset_4 or 0
      local jitter_offset_5 = v45_8.jitter_offset
      v45_8.yaw_jitter = "Off"
      v45_8.jitter_offset = 0
      v45_8.yaw_offset = yaw_offset_4 + v13_2.lerp(-jitter_offset_5, jitter_offset_5, prod_2 % 1)
      return
    end
    if v45_8.yaw_jitter == "5-way" then
      local yaw_offset_5 = v45_8.yaw_offset
      yaw_offset_5 = yaw_offset_5 or 0
      local jitter_offset_6 = v45_8.jitter_offset
      v45_8.yaw_jitter = "Off"
      v45_8.jitter_offset = 0
      local rem = v39_6 % 5
      if v45_8.ways == nil then
        v45_8.yaw_offset = yaw_offset_5 + v13_2.lerp(-jitter_offset_6, jitter_offset_6, rem / 4)
      else
        local v3 = v45_8.ways[rem + 1]
        if v3 ~= nil then
          v45_8.yaw_offset = yaw_offset_5 + v3
        end
      end
      return
    end
    return
  end
  local v61_4 = function()
    if v45_8.body_yaw == "Jitter" then
      local abs = math.abs(v45_8.body_yaw_offset)
      if abs == 0 then
        abs = 1
      end
      if not v40_5 then
        abs = -abs
      end
      v45_8.body_yaw = "Static"
      v45_8.body_yaw_offset = abs
    end
    if v45_8.body_yaw == "Random" then
      local body_yaw_offset = v45_8.body_yaw_offset
      if body_yaw_offset == 0 then
        body_yaw_offset = 1
      end
      v45_8.body_yaw = "Static"
      local v1 = v40_5
      if v40_5 then
        v1 = body_yaw_offset
      else
        v1 = v1 or -body_yaw_offset
      end
      v45_8.body_yaw_offset = v1
    end
    return
  end
  local v62_4 = function(arg1)
    v45_8.freestanding = false
    v46_3:update(arg1)
    local v1 = v47_7:update(arg1)
    v48_5:update(arg1)
    v55_7:update(arg1)
    if not v50_5:update(arg1) then
      if not v51_7:update(arg1) then
        if not v54_5:update() then
          if v1 ~= nil and v1.defensive ~= nil then
            v46_3:apply(arg1, v1.defensive)
          end
          v49_5:update(arg1)
          v53_7:update(arg1)
          v52_7:update(arg1)
          v56_7:update(arg1)
          return
        end
        return
      end
      return
    end
    return
  end
  local v63_3 = function(arg1)
    local default = "default"
    if v57_6(arg1) then
      default = "defensive"
    end
    if arg1.chokedcommands == 0 then
      v58_8(default)
    end
    v61_4()
    v60_5()
    v59_6()
    return
  end
  local v64_3 = function(arg1)
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    local player_weapon = entity.get_player_weapon(me)
    if player_weapon == nil then
      return
    end
    local csgo_weapons_2 = csgo_weapons(player_weapon)
    if csgo_weapons_2 == nil then
      return
    end
    local idx = csgo_weapons_2.idx
    local type_2 = csgo_weapons_2.type
    local defensive = v24_5.get().defensive
    do
      local v8
      v8 = type_2 == "grenade"
      local v9
      v9 = idx == 64
      local force_defensive = arg1.force_defensive
      if force_defensive then
        force_defensive = not v8
        force_defensive = force_defensive and not v9
      end
      defensive.force = force_defensive
    end
    return
  end
  local v65_2 = function()
    v45_8:clear()
    v45_8:unset()
    do return end
  end
  local v66_2 = function(arg1)
    v45_8:clear()
    v45_8:unset()
    v62_4(arg1)
    v63_3(arg1)
    v64_3(arg1)
    v45_8:set()
    return
  end
  client.set_event_callback("shutdown", v65_2)
  client.set_event_callback("setup_command", v66_2)
end

-- ===== блок 56 =====
do
  local vtable_bind_3 = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
  local vtable_thunk_2 = vtable_thunk(483, "float(__thiscall*)(void*)")
  local vtable_thunk_3 = vtable_thunk(453, "float(__thiscall*)(void*)")
  local v42_8 = function(arg1, arg2)
    return {
      x = arg1.x - arg2.x,
      y = arg1.y - arg2.y,
      z = arg1.z - arg2.z
    }
  end
  local v43_8 = function(arg1, arg2)
    return {
      x = arg1.y * arg2.z - arg1.z * arg2.y,
      y = arg1.z * arg2.x - arg1.x * arg2.z,
      z = arg1.x * arg2.y - arg1.y * arg2.x
    }
  end
  local v44_11 = function(arg1)
    local sqrt = math.sqrt
    return sqrt(arg1.x * arg1.x + arg1.y * arg1.y + arg1.z * arg1.z)
  end
  local v45_11 = function(arg1, arg2, arg3)
    local v43_8_2 = v43_8(arg3, (v42_8(arg1, arg2)))
    local v44_11_2 = v44_11
    return v44_11_2(v43_8_2)
  end
  local v46_5 = function()
    local current_threat = client.current_threat()
    if current_threat then
      local vec = vector(client.eye_position())
      local vec_2 = vector(entity.get_origin(current_threat))
      local diff = vec_2 - vec
      local vtable_bind_3_2 = vtable_bind_3((entity.get_player_weapon((entity.get_local_player()))))
      local v7, v8 = diff:vectors()
      local vtable_thunk_2_2 = vtable_thunk_2(vtable_bind_3_2)
      local vtable_thunk_3_2 = vtable_thunk_3(vtable_bind_3_2)
      local v11 = 0
      for _FORV_15_ = 1, 64 do
        local random_float = client.random_float(0, math.pi * 2)
        local random_float_2 = client.random_float(0, vtable_thunk_3_2)
        local random_float_3 = client.random_float(0, math.pi * 2)
        local random_float_4 = client.random_float(0, vtable_thunk_2_2)
        local vec_3 = vector(math.cos(random_float) * random_float_2 + math.cos(random_float_3) * random_float_4, math.sin(random_float) * random_float_2 + math.sin(random_float_3) * random_float_4)
        if v45_11(vec_2, vec, (vector(diff.x + vec_3.x * v7.x + vec_3.y * v8.x, diff.y + vec_3.x * v7.y + vec_3.y * v8.y, diff.z + vec_3.x * v7.z + vec_3.y * v8.z))) <= 16 then
          v11 = v11 + 1
        end
      end
      return v11 / 64 * math.random(80, 95)
    end
    return
  end
  do
    local ai_peek = v29_4.ragebot.ai_peek
    local v48_8 = {}
    v48_8.Head = {0}
    v48_8.Chest = {
      4,
      5,
      6
    }
    v48_8.Stomach = {2, 3}
    v48_8.Arms = {
      13,
      14,
      15,
      16,
      17,
      18
    }
    v48_8.Legs = {
      7,
      8,
      9,
      10
    }
    v48_8.Feet = {11, 12}
    local v49_8 = {
      0,
      5,
      2,
      15,
      17,
      9,
      10
    }
    local v50_8 = {}
    local v51_10 = false
    local v52_10 = false
    local v53_10 = false
    local v54_8 = false
    local v55_10 = false
    local v56_10 = false
    local v57_9 = {}
    v57_9.pos = {}
    v57_9.mid = vector()
    v57_9.active_point_index = 0
    v57_9.current_target = nil
    v57_9.draw_point = nil
    local v58_11 = {}
    v58_11.main = false
    v58_11.force_baim = false
    local v59_9 = function(arg1, arg2)
      local v2 = {}
      local v3 = ui.get(arg1)
      local v4 = {
        "Head",
        "Arms",
        "Legs",
        "Feet"
      }
      for _FORV_8_ = 1, #v3 do
        if not arg2 or not v11(v4, v3[_FORV_8_]) then
          local v9 = v48_8[v3[_FORV_8_]]
          for _FORV_13_ = 1, #v9 do
            local v14 = v9[_FORV_13_]
            if v11(v49_8, v14) then
              table.insert(v2, v14)
            end
          end
        end
      end
      v50_8 = v2
      return
    end
    ui.set_callback(v14_2.ragebot.aimbot.target_hitboxes, function(arg1)
      v59_9(arg1)
      return
    end, true)
    local v60_8 = function(arg1)
      if entity.get_classname(arg1) == "CCSPlayer" and entity.is_enemy(arg1) then
        return false
      end
      return true
    end
    local v61_6 = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
      local v9, extend_vector_2 = arg2, nil
      v9 = v9 and arg2 - arg6
      v9 = v9 or arg1
      extend_vector_2 = v13_2
      do
        extend_vector_2 = extend_vector_2.extend_vector
        extend_vector_2 = extend_vector_2(v9, arg5 == 0 and 0 or arg4, arg3)
      end
      local end_pos = trace.hull(v9, v9 + vector(0, 0, arg9), arg7, arg8, {skip = v60_8, mask = 33636363}).end_pos
      local end_pos_2 = trace.hull(vector(v9.x, v9.y, end_pos.z), vector(extend_vector_2.x, extend_vector_2.y, end_pos.z), arg7, arg8, {skip = v60_8, mask = 33636363}).end_pos
      if extend_vector_2:dist2d(end_pos_2) >= arg4 * 0.97 then
        return false
      end
      return trace.hull(end_pos_2, vector(end_pos_2.x, end_pos_2.y, arg1.z - 240), arg7, arg8, {skip = v60_8, mask = 33636363}).end_pos + arg6
    end
    local v62_6 = function(arg1, arg2, arg3, arg4, arg5)
      local v13
      v13 = entity.get_prop(arg1, "m_vecViewOffset")
      local vec = vector(entity.get_prop(arg1, "m_vecViewOffset"))
      v13 = entity.get_prop(arg1, "m_vecMins")
      local vec_2 = vector(entity.get_prop(arg1, "m_vecMins"))
      v13 = entity.get_prop(arg1, "m_vecMaxs")
      local vec_3 = vector(entity.get_prop(arg1, "m_vecMaxs"))
      v13 = arg5
      v57_9.pos[0] = v61_6(arg2, nil, 0, v13, 0, vec, vec_2, vec_3, arg5)
      for _FORV_11_ = 1, arg4 do
        local diff = _FORV_11_ % 2
        if _FORV_11_ % 2 == 0 then
          diff = arg3 - 90
        else
          diff = diff or arg3 + 90
        end
        v13 = v57_9
        do
          v13 = v13.pos
          v13 = v13[_FORV_11_ <= 2 and 0 or _FORV_11_ - 2]
        end
        if v13 then
          local v61_6_2 = v61_6(arg2, v13, diff, arg5, _FORV_11_, vec, vec_2, vec_3, arg5)
          if not v61_6_2 or v13 and arg5 < math.abs(v13.z - v61_6_2.z) then
            for _FORV_18_ = _FORV_11_, arg4, 2 do
              v57_9.pos[_FORV_18_] = false
            end
          end
          v57_9.pos[_FORV_11_] = v61_6_2
        end
      end
      return v57_9.pos
    end
    local v63_5 = function(arg1, arg2)
      local max, v5
      max = "m_flNextAttack"
      local next_attack = entity.get_prop(arg1, max)
      max = arg2
      v5 = "m_flNextPrimaryAttack"
      local next_primary_attack = entity.get_prop(max, v5)
      max = math
      max = max.max
      v5 = 0
      do
        local v6 = next_attack
        v6 = v6 or 0
        local v7 = next_primary_attack
        v7 = v7 or 0
        max = max(v5, v6, v7)
        v5 = globals
        v5 = v5.curtime
        v5 = v5()
      end
      if not (max > v5) and not (0 >= entity.get_prop(arg2, "m_iClip1")) then
        max = true
        return max
      end
      max = false
      return max
    end
    local v64_5 = {
      "CWeaponSSG08",
      "CWeaponAWP",
      "CWeaponG3SG1",
      "CWeaponSCAR20"
    }
    local v65_4 = function(arg1, arg2)
      if arg2 then
        local player_weapon = entity.get_player_weapon(arg1)
        if v63_5(arg1, player_weapon) then
          if not ui.get(v14_2.ragebot.aimbot.automatic_scope) and v11(v64_5, entity.get_classname(player_weapon)) and entity.get_prop(arg1, "m_bIsScoped") ~= 1 then
            return false
          end
          local v3 = v24_5.get()
          if not v14_2.is_double_tap_active() and not v14_2.is_on_shot_antiaim_active() or v3.shift then
            if entity.get_prop(arg1, "m_flVelocityModifier") ~= 1 then
              return false
            end
            local esp_data = entity.get_esp_data(arg2)
            if not esp_data then
              esp_data = {}
              esp_data.alpha = 0
            end
            if not (esp_data.alpha < 0.75) then
              return true
            end
            return false
          end
          return false
        end
        return false
      end
      return false
    end
    local v66_3 = function(arg1, arg2, arg3, arg4)
      local trace_bullet_2
      local is_override_minimum_damage = v14_2.is_override_minimum_damage()
      local health = entity.get_prop(arg3, "m_iHealth")
      do
        local override_damage = is_override_minimum_damage
        if is_override_minimum_damage then
          override_damage = v14_2
          override_damage = override_damage.get_override_damage
          override_damage = override_damage()
        elseif not override_damage then
          override_damage = v14_2
          override_damage = override_damage.get_minimum_damage
          override_damage = override_damage()
        end
        for _FORV_10_ = 1, #arg1 do
          local v11 = arg1[_FORV_10_]
          if v11 then
            for _FORV_15_ = 1, #arg4 do
              local v16 = arg4[_FORV_15_]
              trace_bullet_2 = arg3
              trace_bullet_2 = entity.hitbox_position(trace_bullet_2, v16)
              local vec = vector(entity.hitbox_position(trace_bullet_2, v16))
              do
                local trace_bullet = client.trace_bullet
                do
                  trace_bullet_2 = arg2
                  trace_bullet_2 = trace_bullet(trace_bullet_2, v11.x, v11.y, v11.z, vec.x, vec.y, vec.z, v16 == 0)
                end
                if v16 == 0 then
                  trace_bullet_2 = trace_bullet_2 * 4
                end
              end
              if trace_bullet_2 >= math.min(override_damage, health) and trace_bullet_2 > 0 then
                return v11, _FORV_10_
              end
            end
          end
        end
      end
      return nil, 0
    end
    local v67 = function(arg1)
      local csgo_weapons_2 = csgo_weapons(arg1)
      if csgo_weapons_2 == nil then
        return nil
      end
      local type_2 = csgo_weapons_2.type
      local idx = csgo_weapons_2.idx
      if type_2 == "pistol" then
        if idx == 1 then
          return "deagle"
        end
        if idx == 64 then
          return "revolver"
        end
        return "pistol"
      end
      if type_2 == "sniperrifle" then
        if idx == 40 then
          return "scout"
        end
        if idx == 9 then
          return "awp"
        end
        return "auto"
      end
      return nil
    end
    local v68 = function(arg1)
      local v5, v19
      local me = entity.get_local_player()
      if me == nil then
        return
      end
      local player_weapon = entity.get_player_weapon(me)
      if player_weapon == nil then
        return
      end
      local v67_2 = v67(player_weapon)
      if v67_2 ~= nil then
        v5 = ai_peek.weapon
        if ai_peek.weapon.get(v5, v67_2) then
          v5 = v14_2
          v5 = v5.ragebot
          v5 = v5.aimbot
          v5 = v5.target_hitboxes
          v59_9(v5)
          v5 = v14_2
          v5 = v5.ragebot
          v5 = v5.aimbot
          v5 = v5.force_baim
          local v4 = ui.get(v5)
          v5 = ai_peek
          v5 = v5.enabled
          v5 = v5.get
          v5 = v5(v5)
          if v5 then
            v5 = v14_2
            v5 = v5.is_quick_peek_assist
            v5 = v5()
          end
          if not v5 or v58_11.main then
            if not v5 and v58_11.main then
              v58_11.main = false
            end
          else
            local me_2 = entity.get_local_player()
            v19 = entity.get_origin(me_2)
            v57_9.mid = v13_2.extrapolate_position(me_2, vector(entity.get_origin(me_2)), 13, true)
            v58_11.main = true
          end
          if not v4 or v58_11.force_baim then
            if not v4 and v58_11.force_baim then
              v59_9(v14_2.ragebot.aimbot.target_hitboxes)
              v58_11.force_baim = false
            end
          else
            v59_9(v14_2.ragebot.aimbot.target_hitboxes, true)
            v58_11.force_baim = true
          end
          if v5 then
            local velocity2d_sqr = v23_5.velocity2d_sqr
            local tickcount = globals.tickcount()
            local me_3 = entity.get_local_player()
            do
              local v9 = bit.band(entity.get_prop(me_3, "m_fFlags"), 1)
              v9 = bit.band(entity.get_prop(me_3, "m_fFlags"), 1) ~= 1
              if not v9 then
                v9 = arg1.in_forward
                v9 = v9 == 1
              end
              if not v9 then
                v9 = arg1.in_moveleft
                v9 = v9 == 1
              end
              if not v9 then
                v9 = arg1.in_moveright
                v9 = v9 == 1
              end
              if not v9 then
                v9 = arg1.in_back
                v9 = v9 == 1
              end
              if not v9 then
                v9 = arg1.in_jump
                v9 = v9 == 1
              end
              v19 = entity.get_origin(me_3)
              local vec = vector(entity.get_origin(me_3))
              local mid = v57_9.mid
              local v12 = mid:dist2d(vec)
              if not v51_10 or velocity2d_sqr < 1.011 and velocity2d_sqr ~= 0 then
                v57_9.mid = vec
              end
              local current_threat = client.current_threat()
              v57_9.current_target = current_threat
              do
                local v14 = current_threat
                if v14 then
                  v14 = vector
                  v19 = entity.get_origin(current_threat)
                  v14 = v14(entity.get_origin(current_threat))
                end
                if not v14 then
                  v14 = vector
                  v14 = v14()
                end
                local v15 = current_threat
                if v15 then
                  v15 = vector
                  v19 = mid:to(v14):angles()
                  v15 = v15(mid:to(v14):angles())
                  v15 = v15.y
                end
                if not v15 then
                  v15 = vector
                  v19 = client.camera_angles()
                  v15 = v15(client.camera_angles())
                  v15 = v15.y
                end
                v19 = v15
                local v62_6_2 = v62_6(me_3, mid, v19, 4, 18)
                local v17
                local v18 = 0
                if not v9 then
                  v19 = v52_10
                  if not v19 then
                    v19 = v54_8
                    if not v19 then
                      v19 = v65_4
                      v19 = v19(me_3, current_threat)
                      if v19 then
                        v19 = v66_3
                        local v66_3_3 = v19(v62_6_2, me_3, current_threat, v50_8)
                        v18 = v66_3_3
                        v17 = v19
                      end
                    end
                  end
                end
                v19 = arg1.in_attack
                v19 = v19 == 1
                if v19 then
                  v19 = v63_5
                  v19 = v19(me_3, entity.get_player_weapon(me_3))
                end
                if v19 then
                  v54_8 = true
                  v53_10 = true
                end
                do
                  local v20 = me_3
                  v20 = v17 ~= nil
                  v51_10 = v20
                end
                v57_9.active_point_index = v18
                if not v51_10 then
                  if not v9 or v52_10 or v53_10 or v54_8 then
                    if not v53_10 and not v54_8 then
                      v57_9.draw_point = nil
                    else
                      v52_10 = true
                      v53_10 = false
                      v57_9.draw_point = nil
                      v55_10 = true
                    end
                  else
                    v52_10 = false
                    v53_10 = false
                    v57_9.draw_point = nil
                    v55_10 = false
                    v56_10 = false
                  end
                else
                  if v57_9.draw_point == nil then
                    v57_9.draw_point = v17
                  end
                  v13_2.set_movement(arg1, v17, me_3)
                  v52_10 = false
                  v53_10 = true
                  v55_10 = false
                  v56_10 = false
                end
              end
              if not v52_10 then
                v57_9.last_returning_time = tickcount
              end
              if v52_10 then
                if not (v12 < 0.15) then
                  if v55_10 then
                    if not v14_2.is_double_tap_active() or not v63_5(me_3, entity.get_player_weapon(me_3)) then
                      if not v14_2.is_double_tap_active() and v14_2.is_on_shot_antiaim_active() and 0 >= v24_5.get().defensive.left then
                        v55_10 = false
                        v56_10 = true
                        v30_4.set(v14_2.antiaimbot.other.on_shot_antiaim[1], false)
                      end
                    elseif tickcount - v57_9.last_returning_time == 1 then
                      arg1.force_defensive = true
                    elseif tickcount - v57_9.last_returning_time >= 7 then
                      v55_10 = false
                      v56_10 = false
                      v30_4.set(v14_2.ragebot.aimbot.double_tap[1], false)
                      v30_4.set(v14_2.antiaimbot.other.on_shot_antiaim[1], false)
                    end
                  end
                else
                  v52_10 = false
                  v54_8 = false
                  v55_10 = false
                  v56_10 = false
                end
              end
            end
            if not v52_10 then
              v30_4.unset(v14_2.ragebot.other.quick_peek_assist_mode)
            else
              v30_4.set(v14_2.ragebot.other.quick_peek_assist_mode, {
                "Retreat on shot",
                "Retreat on key release"
              })
            end
            if not v56_10 then
              v30_4.unset(v14_2.ragebot.aimbot.double_tap[1])
              v30_4.unset(v14_2.antiaimbot.other.on_shot_antiaim[1])
            else
              v30_4.set(v14_2.antiaimbot.other.on_shot_antiaim[1], false)
              v30_4.set(v14_2.ragebot.aimbot.double_tap[1], false)
            end
            return
          end
          v51_10 = false
          v52_10 = false
          v53_10 = false
          v54_8 = false
          v56_10 = false
          v57_9.draw_point = nil
          v55_10 = false
          v30_4.unset(v14_2.ragebot.other.quick_peek_assist_mode)
          v30_4.unset(v14_2.ragebot.aimbot.double_tap[1])
          v30_4.unset(v14_2.antiaimbot.other.on_shot_antiaim[1])
          return
        end
      end
      return
    end
    local v69 = {
      {1, 2},
      {2, 3},
      {3, 4},
      {4, 1},
      {5, 6},
      {6, 7},
      {7, 8},
      {8, 5},
      {1, 5},
      {2, 6},
      {3, 7},
      {4, 8}
    }
    local v70 = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
      if arg1 then
        local diff = arg1 - arg2
        local sum = diff + arg3
        local sum_2 = diff + arg4
        local v11 = {
          vector(sum.x, sum.y, sum.z),
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        }
        ;({
          vector(sum.x, sum.y, sum.z),
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[2] = vector(sum.x, sum_2.y, sum.z)
        ;({
          vector(sum.x, sum.y, sum.z),
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[3] = vector(sum_2.x, sum_2.y, sum.z)
        ;({
          vector(sum.x, sum.y, sum.z),
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[4] = vector(sum_2.x, sum.y, sum.z)
        ;({
          vector(sum.x, sum.y, sum.z),
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[5] = vector(sum.x, sum.y, sum_2.z)
        ;({
          vector(sum.x, sum.y, sum.z),
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[6] = vector(sum.x, sum_2.y, sum_2.z)
        ;({
          vector(sum.x, sum.y, sum.z),
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[7] = vector(sum_2.x, sum_2.y, sum_2.z)
        for _FORV_15_ = 1, #v69 do
          local v16 = v69[_FORV_15_]
          local v17 = v11[v16[1]]
          local v18 = v11[v16[2]]
          local world_to_screen, world_to_screen_2 = renderer.world_to_screen(v17.x, v17.y, v17.z)
          local world_to_screen_3, world_to_screen_4 = renderer.world_to_screen(v18.x, v18.y, v18.z)
          if world_to_screen and world_to_screen_2 and world_to_screen_3 and world_to_screen_4 then
            renderer.line(world_to_screen, world_to_screen_2, world_to_screen_3, world_to_screen_4, arg5, arg6, arg7, arg8)
          end
        end
        return
      end
      return
    end
    local v71 = function()
      if ai_peek.enabled:get() and v14_2.is_quick_peek_assist() then
        local me = entity.get_local_player()
        if me ~= nil and entity.is_alive(me) then
          if v51_10 and v57_9.draw_point then
            local vec = vector(entity.get_prop(me, "m_vecViewOffset"))
            local vec_2 = vector(entity.get_prop(me, "m_vecMins"))
            local vec_3 = vector(entity.get_prop(me, "m_vecMaxs"))
            if ui.get(v14_2.visual.effects.force_third_person[1]) and ui.get(v14_2.visual.effects.force_third_person[2]) then
              v70(v57_9.draw_point, vec, vec_2, vec_3, 255, 255, 255, 200)
            end
            return
          end
          return
        end
        return
      end
      return
    end
    client.set_event_callback("setup_command", v68)
    client.set_event_callback("paint", v71)
  end
  local v47_10 = {}
  do
    local teleport_fix = v29_4.ragebot.teleport_fix
    local v49_9 = function(arg1)
      local v1 = not arg1.is_revolver
      if v1 then
        v1 = arg1.type
        v1 = v1 ~= "grenade"
        if v1 then
          v1 = arg1.type
          v1 = v1 ~= "knife"
          if v1 then
            v1 = arg1.type
            v1 = v1 ~= "taser"
            if v1 then
              v1 = arg1.type
              v1 = v1 ~= "stackbleitem"
            end
          end
        end
      end
      return v1
    end
    local v50_9 = function()
      local me = entity.get_local_player()
      if me == nil then
        return false
      end
      local player_weapon = entity.get_player_weapon(me)
      if player_weapon == nil then
        return false
      end
      local csgo_weapons_2 = csgo_weapons(player_weapon)
      if csgo_weapons_2 == nil then
        return false
      end
      if v49_9(csgo_weapons_2) then
        local f_last_shot_time = entity.get_prop(player_weapon, "m_fLastShotTime")
        if f_last_shot_time == nil then
          return false
        end
        local diff = toticks(globals.curtime()) - toticks(f_last_shot_time)
        local max = math.max(25, toticks(csgo_weapons_2.cycletime) - 20)
        local v9 = 25
        v9 = diff > 1
        v9 = v9 and diff < max
        return v9
      end
      return false
    end
    local v51_11 = function()
      v31_5.set(v14_2.ragebot.aimbot.double_tap[1], false)
      do return end
    end
    function v47_10.update()
      if teleport_fix.enabled:get() then
        if v50_9() then
          v51_11()
          return
        end
        return
      end
      do return end
    end
  end
  do
    local air_autostop = v29_4.ragebot.air_autostop
    local v49_10 = function(arg1, arg2)
      local v2 = {}
      do
        local v3 = arg1
        v3 = v3 or 0
        v2.flags = v3
      end
      do
        local v3_2 = arg2
        if not v3_2 then
          v3_2 = vector
          v3_2 = v3_2()
        end
        v2.velocity = v3_2
      end
      return v2
    end
    local v50_10 = v49_10()
    local v51_12
    local v52_11 = function()
      if v51_12 == nil then
        return
      end
      v30_4.set(v14_2.misc.movement.strafe, v51_12)
      v51_12 = nil
      do return end
    end
    local v53_11 = cvar.cl_sidespeed
    local v54_9 = function(arg1)
      local me = entity.get_local_player()
      local v9 = me
      v9 = 0.65 < client.trace_line(me, entity.hitbox_position(me, 0))
      return v9
    end
    local v55_11 = function(arg1, arg2)
      local cos = math.cos(math.rad(arg2))
      local cos_2 = math.cos(math.rad(arg1))
      return cos_2 * cos, cos_2 * math.sin(math.rad(arg2)), -math.sin(math.rad(arg1))
    end
    local v56_11 = function(arg1, arg2)
      if entity.get_local_player() == nil then
        local v52_11_2 = v52_11
        return v52_11_2()
      end
      local velocity = v50_10.velocity
      local v4 = velocity:length2d()
      if arg2 ~= nil and arg2 > v4 then
        local v52_11_3 = v52_11
        return v52_11_3()
      end
      local vec = vector(velocity:angles())
      vec.y = vector(client.camera_angles()).y - vec.y
      local prod = -v53_11:get_float() * vector(v55_11(vec.x, vec.y))
      if v51_12 == nil then
        v51_12 = ui.get(v14_2.misc.movement.strafe)
      end
      v30_4.set(v14_2.antiaimbot.other.slow_motion[1], true)
      v30_4.set(v14_2.antiaimbot.other.slow_motion[2], "Always on")
      arg1.in_walk = 1
      v30_4.set(v14_2.misc.movement.strafe, false)
      client.exec("bind space +speed")
      client.exec("bindtoggle space +speed")
      arg1.in_speed = 1
      arg1.forwardmove = prod.x
      arg1.sidemove = prod.y
      return
    end
    local v57_10 = function()
      local me = entity.get_local_player()
      ui.set(v14_2.antiaimbot.other.slow_motion[2], "On hotkey")
      client.exec("bind space +jump")
      if me == nil then
        return
      end
      v50_10 = v49_10(entity.get_prop(me, "m_fFlags"), (vector(entity.get_prop(me, "m_vecVelocity"))))
      return
    end
    client.set_event_callback("predict_command", function(arg1)
      if not air_autostop.enabled:get() or not air_autostop.hotkey:get() then
        ui.set(v14_2.misc.movement.strafe, true)
      else
        v57_10(arg1)
      end
      return
    end)
    local v58_12 = function(arg1)
      local v1 = globals.curtime()
      v1 = globals.curtime() >= entity.get_prop(arg1, "m_flNextAttack")
      return v1
    end
    local v59_10 = function(arg1)
      local v1 = globals.curtime()
      v1 = globals.curtime() >= entity.get_prop(arg1, "m_flNextPrimaryAttack")
      return v1
    end
    local v60_9 = function(arg1)
      local prod
      if air_autostop.enabled:get() and air_autostop.hotkey:get() then
        local me = entity.get_local_player()
        if me == nil then
          local v52_11_2 = v52_11
          return v52_11_2()
        end
        local player_weapon = entity.get_player_weapon(me)
        if player_weapon ~= nil and v58_12(me) and v59_10(player_weapon) then
          local current_threat = client.current_threat()
          if current_threat == nil then
            local v52_11_3 = v52_11
            return v52_11_3()
          end
          prod = entity.hitbox_position(me, 0)
          local vec = vector(entity.hitbox_position(me, 0))
          prod = entity.hitbox_position(me, 2)
          local vec_2 = vector(entity.hitbox_position(me, 2))
          prod = entity.hitbox_position(current_threat, 0)
          local vec_3 = vector(entity.hitbox_position(current_threat, 0))
          prod = entity.hitbox_position(current_threat, 0)
          local vec_4 = vector(entity.hitbox_position(current_threat, 0))
          vec_3:dist(vec)
          prod = entity.get_prop(me, "m_vecVelocity")
          vector(entity.get_prop(me, "m_vecVelocity"))
          local v8 = entity_2(me):get_anim_state()
          if v8 ~= nil and not v8.on_ground then
            do
              local v10 = entity.get_prop(me, "m_bIsScoped")
              v10 = entity.get_prop(me, "m_bIsScoped") ~= 0
              local override_damage = v14_2.is_override_minimum_damage()
              if v14_2.is_override_minimum_damage() then
                override_damage = v14_2
                override_damage = override_damage.get_override_damage
                override_damage = override_damage()
              elseif not override_damage then
                override_damage = v14_2
                override_damage = override_damage.get_minimum_damage
                override_damage = override_damage()
              end
              local trace_bullet = client.trace_bullet(me, vec.x, vec.y, vec.z, vec_3.x, vec_3.y, vec_3.z)
              local trace_bullet_2 = client.trace_bullet(me, vec.x, vec.y, vec.z, vec_4.x, vec_4.y, vec_4.z)
              prod = vec_3.z
              local trace_bullet_3 = client.trace_bullet(me, vec_2.x, vec_2.y, vec_2.z, vec_3.x, vec_3.y, prod)
              prod = vec_4.x
              local trace_bullet_4 = client.trace_bullet(me, vec_2.x, vec_2.y, vec_2.z, prod, vec_4.y, vec_4.z)
              local health = entity.get_prop(current_threat, "m_iHealth")
              if override_damage >= 100 then
                override_damage = health + (override_damage - 100)
              end
              local classname = entity.get_classname(player_weapon)
              if classname ~= "CKnife" and classname ~= "CWeaponTaser" then
                prod = classname
                if not string.match(prod, "nade") then
                  if classname == "CWeaponSSG08" then
                    if arg1.quick_stop == false then
                      prod = v46_5
                      prod = prod()
                      if prod < ui.get(v14_2.ragebot.aimbot.minimum_hit_chance) then
                        local v52_11_4 = v52_11
                        do return v52_11_4() end
                        prod = ui
                        prod = prod.get
                        prod = prod(v14_2.ragebot.aimbot.minimum_hit_chance)
                        if v46_5() < prod then
                          local v52_11_5 = v52_11
                          return v52_11_5()
                        end
                      end
                    end
                  end
                  prod = current_threat
                  if v54_9(prod) then
                    prod = current_threat
                    if not entity.is_dormant(prod) then
                      prod = player_weapon
                      local csgo_weapons_2 = csgo_weapons(prod)
                      prod = v10
                      do
                        if prod then
                          prod = csgo_weapons_2.max_player_speed_alt
                        else
                          prod = prod or csgo_weapons_2.max_player_speed
                        end
                        prod = prod * 0.34
                      end
                      if trace_bullet < override_damage and trace_bullet_2 < override_damage and trace_bullet_3 < override_damage and trace_bullet_4 < override_damage then
                        local v52_11_6 = v52_11
                        return v52_11_6()
                      end
                      v56_11(arg1, prod)
                      return
                    end
                  end
                  local v52_11_7 = v52_11
                  return v52_11_7()
                end
              end
            end
            local v52_11_8 = v52_11
            return v52_11_8()
          end
          local v52_11_9 = v52_11
          return v52_11_9()
        end
        local v52_11_10 = v52_11
        return v52_11_10()
      end
      local v52_11_11 = v52_11
      return v52_11_11()
    end
    client.set_event_callback("setup_command", function(arg1)
      if not air_autostop.enabled:get() or not air_autostop.hotkey:get() then
        v30_4.set(v14_2.misc.movement.strafe, true)
      else
        v60_9(arg1)
      end
      return
    end)
  end
  local v48_9 = {}
  do
    local force_shot = v29_4.ragebot.force_shot
    local v50_11 = function()
      v31_5.set(v14_2.ragebot.aimbot.minimum_hit_chance, 0)
      do return end
    end
    local v51_13 = function()
      local me = entity.get_local_player()
      if me == nil then
        return false
      end
      local player_weapon = entity.get_player_weapon(me)
      if player_weapon == nil then
        return false
      end
      local v46_5_2 = v46_5()
      if v46_5_2 == nil then
        return false
      end
      local v3 = force_shot.hc:get()
      if vtable_thunk_2((vtable_bind_3(player_weapon))) <= 0.023 and v46_5_2 >= v3 then
        return true
      end
      return false
    end
    local v52_12 = function()
      if force_shot.indicator:get() then
        if force_shot.hotkey:get() then
          local me = entity.get_local_player()
          if me ~= nil and entity.is_alive(me) then
            return true
          end
          return false
        end
        return false
      end
      return false
    end
    local v53_12 = function()
      if not force_shot.enabled:get() then
        return
      end
      if not v52_12() then
        return
      end
      local r, g, b, a
      if not client.current_threat() then
        r, g, b, a = 255, 255, 255, 200
      elseif not v51_13() then
        r, g, b, a = 255, 10, 10, 255
      else
        r, g, b, a = 159, 202, 43, 255
      end
      renderer.indicator(r, g, b, a, "SHOT")
      return
    end
    client.set_event_callback("paint_ui", function()
      v53_12()
      do return end
    end)
    function v48_9.update()
      if force_shot.enabled:get() then
        if force_shot.hotkey:get() then
          if v51_13() then
            v50_11()
            return
          end
          return
        end
        return
      end
      do return end
    end
  end
  local v49_11 = {}
  do
    local auto_hide_shots = v29_4.ragebot.auto_hide_shots
    local v51_14 = function()
      if v23_5.is_onground then
        if not v23_5.is_crouched then
          if not v23_5.is_moving then
            return "standing"
          end
          if not v14_2.is_slow_motion() then
            return "moving"
          end
          return "slow walk"
        end
        if not v23_5.is_moving then
          return "crouching"
        end
        return "move-crouching"
      end
      if not v23_5.is_crouched then
        return "air"
      end
      do return "air-crouching" end
    end
    local v52_13 = function(arg1)
      local csgo_weapons_2 = csgo_weapons(arg1)
      if csgo_weapons_2 == nil then
        return nil
      end
      local type_2 = csgo_weapons_2.type
      local idx = csgo_weapons_2.idx
      if type_2 == "pistol" then
        if idx == 1 then
          return "deagle"
        end
        if idx == 64 then
          return "revolver"
        end
        return "pistol"
      end
      if type_2 == "sniperrifle" then
        if idx == 40 then
          return "scout"
        end
        if idx == 9 then
          return "awp"
        end
        return "auto"
      end
      return nil
    end
    local v53_13 = function()
      v31_5.set(v14_2.ragebot.aimbot.double_tap[1], false)
      v30_4.set(v14_2.antiaimbot.other.on_shot_antiaim[1], true)
      v30_4.set(v14_2.antiaimbot.other.on_shot_antiaim[2], "Always on")
      do return end
    end
    local v54_10 = function()
      if not ui.get(v14_2.ragebot.other.duck_peek_assist) then
        if not ui.get(v14_2.ragebot.other.quick_peek_assist[1]) or not ui.get(v14_2.ragebot.other.quick_peek_assist[2]) then
          if ui.get(v14_2.ragebot.aimbot.double_tap[2]) then
            local me = entity.get_local_player()
            if me == nil then
              return false
            end
            local player_weapon = entity.get_player_weapon(me)
            if player_weapon == nil then
              return false
            end
            local v52_13_2 = v52_13(player_weapon)
            if v52_13_2 ~= nil and auto_hide_shots.weapons:get(v52_13_2) then
              if auto_hide_shots.states:get((v51_14())) then
                return true
              end
              return false
            end
            return false
          end
          return false
        end
        return false
      end
      return false
    end
    function v49_11.update()
      if auto_hide_shots.enabled:get() then
        if v54_10() then
          v53_13()
          return
        end
        return
      end
      do return end
    end
  end
  local v50_12 = {}
  do
    local hide_shots_fix = v29_4.ragebot.hide_shots_fix
    function v50_12.update()
      if hide_shots_fix.enabled:get() then
        if not v14_2.is_double_tap_active() then
          if v14_2.is_on_shot_antiaim_active() then
            v30_4.set(v14_2.antiaimbot.fake_lag.enabled[1], false)
            return
          end
          return
        end
        return
      end
      do return end
    end
  end
  local v51_15 = {}
  do
    local allow_duck_on_fd = v29_4.ragebot.allow_duck_on_fd
    local v53_14 = false
    function v51_15.update(arg1, arg2)
      if allow_duck_on_fd.enabled:get() then
        local me = entity.get_local_player()
        if me == nil then
          return
        end
        local duck_amount = entity.get_prop(me, "m_flDuckAmount")
        if arg2.in_duck == 0 then
          v53_14 = false
        elseif duck_amount > 0.75 then
          v53_14 = true
        end
        if v53_14 then
          v30_4.set(v14_2.ragebot.other.duck_peek_assist, "On hotkey", 0)
          return
        end
        return
      end
      return
    end
  end
  do
    local interpolation = v29_4.ragebot.interpolation
    local v53_15 = cvar.cl_interpolate
    local v54_11 = cvar.cl_interp_ratio
    local v55_12 = cvar.cl_extrapolate_amount
    local v56_12, v57_11, v58_13
    local v59_11 = function()
      if interpolation.draw_indicator:get() then
        local me = entity.get_local_player()
        if me ~= nil and entity.is_alive(me) then
          local v1, v2 = interpolation.unsafe:get()
          if v1 and v2 ~= 0 then
            return true
          end
          local v3, v4 = interpolation.safe_mode:get()
          if v3 and v4 ~= 0 then
            return true
          end
          if not interpolation.force_extrapolation_hotkey:get() then
            return false
          end
          return true
        end
        return false
      end
      return false
    end
    local v60_10 = function()
      if v56_12 ~= nil then
        v53_15:set_int(v56_12)
        v53_15:set_raw_int(v56_12)
        v56_12 = nil
      end
      if v57_11 ~= nil then
        v54_11:set_float(v57_11)
        v54_11:set_raw_float(v57_11)
        v57_11 = nil
      end
      if v58_13 ~= nil then
        v55_12:set_float(v58_13)
        v58_13 = nil
      end
      do return end
    end
    local v61_7 = function()
      if not interpolation.unsafe:get() then
        if v56_12 ~= nil then
          v53_15:set_int(v56_12)
          v53_15:set_raw_int(v56_12)
          v56_12 = nil
        end
      else
        if v56_12 == nil then
          v56_12 = v53_15:get_int()
        end
        v53_15:set_int(0)
        v53_15:set_raw_int(0)
      end
      if not interpolation.safe_mode:get() then
        if v57_11 ~= nil then
          v54_11:set_float(v57_11)
          v54_11:set_raw_float(v57_11)
          v57_11 = nil
        end
      else
        if v57_11 == nil then
          v57_11 = v54_11:get_float()
        end
        v54_11:set_float(1)
        v54_11:set_raw_float(1)
      end
      if v58_13 == nil then
        v58_13 = v55_12:get_float()
      end
      local v0 = interpolation.extrapolation:get()
      if interpolation.force_extrapolation_hotkey:get() then
        v0 = interpolation.force_extrapolation:get()
      end
      cvar.cl_extrapolate_amount:set_float(v0 * 0.01)
      return
    end
    local v62_7 = function()
      if v59_11() then
        local v0_2 = 255
        local v1 = 255
        local v2 = 255
        local v3 = 200
        if interpolation.force_extrapolation_hotkey:get() then
          v3 = 255
          v2 = 43
          v1 = 202
          v0_2 = 159
        end
        renderer.indicator(v0_2, v1, v2, v3, "u.u")
        return
      end
      return
    end
    local v63_6 = function()
      v60_10()
      do return end
    end
    local v64_6 = function()
      v61_7()
      v62_7()
      do return end
    end
    local v65_5 = function()
      v60_10()
      v61_7()
      do return end
    end
    interpolation.enabled:set_callback(function(arg1)
      local v1 = arg1:get()
      if not v1 then
        v60_10()
      end
      v13_2.event_callback("shutdown", v63_6, v1)
      v13_2.event_callback("paint_ui", v64_6, v1)
      v13_2.event_callback("level_init", v65_5, v1)
      return
    end, true)
  end
  local v52_14 = {}
  do
    local fakelags = v29_4.fakelags
    local v54_12 = 0
    local v55_13 = function()
      v30_4.unset(v14_2.antiaimbot.fake_lag.enabled[1])
      v30_4.unset(v14_2.antiaimbot.fake_lag.enabled[2])
      v30_4.unset(v14_2.antiaimbot.fake_lag.amount)
      v30_4.unset(v14_2.antiaimbot.fake_lag.limit)
      v30_4.unset(v14_2.antiaimbot.fake_lag.variance)
      do return end
    end
    local v56_13 = function()
      v55_13()
      do return end
    end
    local v57_12 = function()
      v55_13()
      do return end
    end
    function v52_14.update(arg1, arg2)
      local v5_2
      if fakelags.enabled:get() then
        local me = entity.get_local_player()
        if me == nil then
          return
        end
        local player_weapon = entity.get_player_weapon(me)
        if player_weapon == nil then
          return
        end
        v5_2 = player_weapon
        local csgo_weapons_2 = csgo_weapons(v5_2)
        if csgo_weapons_2 == nil then
          return
        end
        do
          v5_2 = 0
          do
            local v10 = fakelags.limit:get()
            local v11 = fakelags.amount:get()
            if v11 == "angelic" then
              v5_2 = v10 - v54_12 % 5
            elseif v11 == "random" then
              v5_2 = v10 - v13_2.random_int(0, 5)
            end
            if v23_5.is_peeking then
              v5_2 = 15
            end
          end
          v5_2 = v13_2.clamp(v5_2, 1, 15)
        end
        if (not not v14_2.is_duck_peek_assist() or not v14_2.is_double_tap_active() and not v14_2.is_on_shot_antiaim_active()) and not (csgo_weapons_2.type == "grenade") then
          if v5_2 > arg2.chokedcommands then
            arg2.allow_send_packet = false
          else
            v54_12 = v54_12 + 1
            arg2.no_choke = true
          end
        end
        v30_4.set(v14_2.antiaimbot.fake_lag.enabled[1], true)
        v30_4.set(v14_2.antiaimbot.fake_lag.enabled[2], "Always on")
        v30_4.set(v14_2.antiaimbot.fake_lag.amount, is_grenade and "Dynamic" or "Maximum")
        v30_4.set(v14_2.antiaimbot.fake_lag.limit, 15)
        v30_4.set(v14_2.antiaimbot.fake_lag.variance, 100)
        return
      end
      return
    end
    fakelags.enabled:set_callback(function(arg1)
      local v1 = arg1:get()
      if not v1 then
        v55_13()
      end
      v13_2.event_callback("shutdown", v56_13, v1)
      v13_2.event_callback("paint", v57_12, v1)
      return
    end, true)
  end
  local v53_16 = function()
    v31_5.unset(v14_2.ragebot.aimbot.enabled[1])
    v31_5.unset(v14_2.ragebot.aimbot.double_tap[1])
    v31_5.unset(v14_2.ragebot.aimbot.minimum_hit_chance)
    v30_4.unset(v14_2.ragebot.other.duck_peek_assist)
    v30_4.unset(v14_2.antiaimbot.fake_lag.enabled[1])
    v30_4.unset(v14_2.antiaimbot.fake_lag.enabled[2])
    v30_4.unset(v14_2.antiaimbot.other.on_shot_antiaim[1])
    v30_4.unset(v14_2.antiaimbot.other.on_shot_antiaim[2])
    do return end
  end
  local v54_13 = function()
    v53_16()
    do return end
  end
  local v55_14 = function(arg1)
    v53_16()
    v52_14:update(arg1)
    v49_11:update(arg1)
    v47_10:update(arg1)
    v51_15:update(arg1)
    v48_9:update(arg1)
    v50_12:update(arg1)
    return
  end
  client.set_event_callback("shutdown", v54_13)
  client.set_event_callback("setup_command", v55_14)
end

-- ===== блок 67 =====
do
  local v40_18 = function(arg1)
    local csgo_weapons_2 = csgo_weapons(arg1)
    if csgo_weapons_2 == nil or csgo_weapons_2.type ~= "grenade" then
      return false
    end
    local f_throw_time = entity.get_prop(arg1, "m_fThrowTime")
    if f_throw_time == nil or f_throw_time == 0 then
      return false
    end
    return true
  end
  local v41_20 = function(arg1)
    local v7
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    if entity.get_prop(me, "m_movetype") == 9 and not v23_5.is_onground then
      arg1.yaw = math.floor(0.5 + arg1.yaw)
      arg1.roll = 0
      local player_weapon = entity.get_player_weapon(me)
      if player_weapon == nil then
        return
      end
      if not v40_18(player_weapon) then
        v7 = "m_vecLadderNormal"
        v7 = entity.get_prop(me, v7)
        local vec = vector(entity.get_prop(me, v7))
        if vec:lengthsqr() == 0 then
          return
        end
        v7 = client.camera_angles()
        local vec_2 = vector(client.camera_angles())
        v7 = vec.angles
        v7 = v7(vec)
        local vec_3 = vector(v7, v7(vec))
        v7 = vec_3.y
        v7 = v7 - vec_2.y
        do
          v7 = v7 + 180
          v7 = v13_2.normalize(v7, -180, 180)
        end
        local v8 = v13_2.clamp(vec_3.x - vec_2.x, -89, 89)
        local abs = math.abs(v7)
        local v10 = -90
        do
          local v11 = -89
          v11 = v8 < -45
          local v12 = 89
          v12 = v7 > 0
          local v13 = arg1.sidemove
          v13 = 0 < arg1.sidemove
          local v14 = arg1.forwardmove
          v14 = 0 < arg1.forwardmove
          if abs > 70 and abs < 135 then
            if arg1.forwardmove == 0 and arg1.sidemove ~= 0 then
              if not v12 then
                v10 = -v10
              elseif v12 then
                v13 = not v13
              end
              do
                local v15 = v13
                if v13 then
                  v15 = 1
                else
                  v15 = v15 or 0
                end
                arg1.in_back = v15
              end
              do
                local v15_2 = v13
                if v13 then
                  v15_2 = 0
                else
                  v15_2 = v15_2 or 1
                end
                arg1.in_forward = v15_2
              end
              if v12 then
                v13 = not v13
              end
              do
                local v15_3 = v13
                if v13 then
                  v15_3 = 1
                else
                  v15_3 = v15_3 or 0
                end
                arg1.in_moveleft = v15_3
              end
              do
                local v15_4 = v13
                if v13 then
                  v15_4 = 0
                else
                  v15_4 = v15_4 or 1
                end
                arg1.in_moveright = v15_4
              end
              arg1.pitch = 89
              arg1.yaw = v13_2.normalize(vec_3.y + v10, -180, 180)
              return
            end
            return
          end
          if arg1.sidemove == 0 and arg1.forwardmove ~= 0 then
            if not v12 then
              v10 = -v10
            end
            if not v11 then
              v14 = not v14
            end
            do
              local v15_5 = v14
              if v14 then
                v15_5 = 0
              else
                v15_5 = v15_5 or 1
              end
              arg1.in_back = v15_5
            end
            do
              local v15_6 = v14
              if v14 then
                v15_6 = 1
              else
                v15_6 = v15_6 or 0
              end
              arg1.in_forward = v15_6
            end
            if not v12 then
              v14 = not v14
            end
            do
              local v15_7 = v14
              if v14 then
                v15_7 = 1
              else
                v15_7 = v15_7 or 0
              end
              arg1.in_moveleft = v15_7
            end
            local v15_8 = v14
            if v14 then
              v15_8 = 0
            else
              v15_8 = v15_8 or 1
            end
            arg1.in_moveright = v15_8
            arg1.pitch = 89
            arg1.yaw = v13_2.normalize(vec_3.y + v10, -180, 180)
            return
          end
        end
        return
      end
      return
    end
    return
  end
  v29_4.misc.fast_ladder.enabled:set_callback(function(arg1)
    v13_2.event_callback("setup_command", v41_20, arg1:get())
    return
  end, true)
end

-- ===== блок 72 =====
do
  local animation_breaker = v29_4.misc.animation_breaker
  local v40_22 = {
    "Off",
    "Always slide",
    "Never slide"
  }
  local v41_25 = {}
  v41_25.layers = {
    [0] = {cycle = 0, weight = 0},
    [1] = {cycle = 0, weight = 0},
    [2] = {cycle = 0, weight = 0},
    [3] = {cycle = 0, weight = 0},
    [4] = {cycle = 0, weight = 0},
    [5] = {cycle = 0, weight = 0},
    [6] = {cycle = 0, weight = 0},
    [7] = {cycle = 0, weight = 0},
    [8] = {cycle = 0, weight = 0},
    [9] = {cycle = 0, weight = 0},
    [10] = {cycle = 0, weight = 0},
    [11] = {cycle = 0, weight = 0},
    [12] = {cycle = 0, weight = 0},
    [13] = {cycle = 0, weight = 0},
    [14] = {cycle = 0, weight = 0},
    [15] = {cycle = 0, weight = 0}
  }
  v41_25.server_anim_states = {}
  v41_25.last_sim_time = 0
  v41_25.last_velocity = 0
  v41_25.last_duck_amount = 0
  v41_25.last_weapon = nil
  vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
  do
    local find_signature = client.find_signature("client.dll", "U\139\236\131\228\204\131\236\204VW\139\249\137|$\204\131\191\204\204\204\204\204u")
    find_signature = find_signature or "Invalid ClampBonesInBBox signature"
    if not tonumber(ffi.cast("uintptr_t", find_signature)) then
      error("Invalid ClampBonesInBbox address")
    end
  end
  local v42_28 = function(arg1)
    if v23_5.is_onground then
      local v1 = animation_breaker.onground:get()
      if v1 == "static" then
        v30_4.set(v14_2.antiaimbot.other.leg_movement, "Always slide")
        entity.set_prop(arg1, "m_flPoseParameter", 0, 0)
        return
      end
      if v1 == "jitter" then
        v30_4.set(v14_2.antiaimbot.other.leg_movement, "Always slide")
        local set_prop = entity.set_prop
        local v3 = arg1
        local m_fl_pose_parameter = "m_flPoseParameter"
        local v5 = 1
        do
          local v6 = globals.tickcount() % 4
          if 1 < globals.tickcount() % 4 then
            v6 = 0.5
          else
            v6 = v6 or 1
          end
          set_prop(v3, m_fl_pose_parameter, v5, v6)
        end
        return
      end
      if v1 == "allah" then
        v30_4.set(v14_2.antiaimbot.other.leg_movement, "Never slide")
        entity.set_prop(arg1, "m_flPoseParameter", 0, 7)
        return
      end
      if v1 == "kangaroo" then
        entity.set_prop(arg1, "m_flPoseParameter", math.random(), 3)
        entity.set_prop(arg1, "m_flPoseParameter", math.random(), 7)
        entity.set_prop(arg1, "m_flPoseParameter", math.random(), 6)
      end
      if v1 == "angelic" then
        v30_4.set(v14_2.antiaimbot.other.leg_movement, v40_22[math.random(1, 3)])
        local sum = 0.5 + entity.get_prop(arg1, "m_flPoseParameter", 7)
        if sum > 1 then
          sum = sum - 1
        end
        if 2 < globals.tickcount() % 5 then
          entity.set_prop(arg1, "m_flPoseParameter", sum - v13_2.random_float(0, 0.1), 0)
        else
          entity.set_prop(arg1, "m_flPoseParameter", sum + v13_2.random_float(0, 0.2), 0)
        end
        return
      end
    end
    v30_4.unset(v14_2.antiaimbot.other.leg_movement)
    return
  end
  local v43_26 = function(arg1)
    local v1 = animation_breaker.in_air:get()
    if v1 == "off" then
      return
    end
    if not v23_5.is_onground then
      if v1 == "static" then
        entity.set_prop(arg1, "m_flPoseParameter", 1, 6)
        return
      end
      if v1 == "kangaroo" then
        entity.set_prop(arg1, "m_flPoseParameter", math.random(), 3)
        entity.set_prop(arg1, "m_flPoseParameter", math.random(), 7)
        entity.set_prop(arg1, "m_flPoseParameter", math.random(), 6)
        return
      end
      if v1 == "haram" then
        if v23_5.is_moving then
          local entity_2_2 = entity_2(arg1)
          if entity_2_2 == nil then
            return
          end
          local v3 = entity_2_2:get_anim_overlay(6)
          if v3 == nil then
            return
          end
          v3.weight = 1
          return
        end
        return
      end
      return
    end
    return
  end
  local v44_26 = function(arg1)
    local v1 = animation_breaker.body_lean:get()
    if v1 == 0 then
      return
    end
    local entity_2_2 = entity_2(arg1)
    if entity_2_2 == nil then
      return
    end
    local v3 = entity_2_2:get_anim_overlay(12)
    if v3 == nil then
      return
    end
    v3.weight = v1 * 0.1
    return
  end
  local v45_23 = function(arg1)
    if animation_breaker.pitch_on_land:get() then
      if v23_5.is_onground then
        local entity_2_2 = entity_2(arg1)
        if entity_2_2 == nil then
          return
        end
        local v2 = entity_2_2:get_anim_state()
        if v2 ~= nil and v2.hit_in_ground_animation then
          entity.set_prop(arg1, "m_flPoseParameter", 0.5, 12)
          return
        end
        return
      end
      return
    end
    return
  end
  local v46_16 = function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    local entity_2_2 = entity_2(me)
    if entity_2_2 == nil then
      return
    end
    if entity_2_2:get_anim_state() == nil then
      return
    end
    if not v23_5.is_onground then
      v43_26(me)
    else
      v42_28(me)
      v45_23(me)
    end
    local servertickcount = globals.servertickcount()
    local sqrt = math.sqrt(entity.get_prop(me, "m_vecVelocity") * entity.get_prop(me, "m_vecVelocity") + entity.get_prop(me, "m_vecVelocity") * entity.get_prop(me, "m_vecVelocity"))
    local duck_amount = entity.get_prop(me, "m_flDuckAmount")
    do
      local v8 = entity.get_prop(me, "m_bDucking")
      v8 = entity.get_prop(me, "m_bDucking") == 1
      local v9 = bit.band(entity.get_prop(me, "m_fFlags"), 1)
      v9 = bit.band(entity.get_prop(me, "m_fFlags"), 1) == 1
      local player_weapon = entity.get_player_weapon(me)
      if sqrt < 0.1 then
        sqrt = 0
      end
      local v11 = {}
      v11.layers = {}
      v11.time = servertickcount
      v11.ducking = v8
      v11.on_ground = v9
      v11.velocity = sqrt
      v11.duck_amount = duck_amount
      v11.weapon = player_weapon
      for _FORV_15_, _FORV_16_ in pairs(v41_25.layers) do
        _FORV_16_ = entity_2_2.get_anim_overlay
        _FORV_16_ = _FORV_16_(entity_2_2, _FORV_15_)
        if _FORV_16_ ~= nil then
          v11.layers[_FORV_15_] = {
            cycle = _FORV_16_.cycle,
            weight = _FORV_16_.weight
          }
        end
      end
      table.insert(v41_25.server_anim_states, v11)
    end
    if #v41_25.server_anim_states > 60 then
      table.remove(v41_25.server_anim_states, 1)
    end
    return
  end
  local v47_19 = function()
    if animation_breaker.smooth_animfix:get() then
      local me = entity.get_local_player()
      if me == nil then
        return
      end
      local entity_2_2 = entity_2(me)
      if entity_2_2 == nil then
        return
      end
      if entity_2_2:get_anim_state() == nil then
        return
      end
      local realtime = globals.realtime()
      local server_anim_states = v41_25.server_anim_states
      if not (#server_anim_states < 2) then
        local v5, v6
        for _FORV_10_ = #server_anim_states - 1, 1, -1 do
          if realtime >= server_anim_states[_FORV_10_].time and realtime <= server_anim_states[_FORV_10_ + 1].time then
            v5 = server_anim_states[_FORV_10_]
            v6 = server_anim_states[_FORV_10_ + 1]
          end
        end
        if not v5 or not v6 then
          v5 = server_anim_states[#server_anim_states - 1]
          v6 = server_anim_states[#server_anim_states]
        end
        local v7 = math.max(0, math.min((realtime - v5.time) / (v6.time - v5.time), 1))
        for _FORV_11_, _FORV_12_ in pairs(v41_25.layers) do
          _FORV_12_ = entity_2_2.get_anim_overlay
          _FORV_12_ = _FORV_12_(entity_2_2, _FORV_11_)
          if _FORV_12_ and v5.layers[_FORV_11_] and v6.layers[_FORV_11_] then
            local cycle = v5.layers[_FORV_11_].cycle
            local cycle_2 = v6.layers[_FORV_11_].cycle
            local weight = v5.layers[_FORV_11_].weight
            local weight_2 = v6.layers[_FORV_11_].weight
            if _FORV_11_ ~= 1 and _FORV_11_ ~= 2 or v5.weapon == v6.weapon then
              _FORV_12_.cycle = v13_2.lerp(cycle, cycle_2, v7)
              _FORV_12_.weight = v13_2.lerp(weight, weight_2, v7)
            else
              _FORV_12_.cycle = cycle_2
              _FORV_12_.weight = weight_2
            end
          end
        end
        v41_25.last_velocity = v13_2.lerp(v5.velocity, v6.velocity, v7)
        v41_25.last_duck_amount = v13_2.lerp(v5.duck_amount, v6.duck_amount, v7)
        v41_25.last_weapon = v5.weapon
        return
      end
      return
    end
    return
  end
  local v48_15 = function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    local movetype = entity.get_prop(me, "m_movetype")
    v47_19()
    if movetype == 2 then
      v42_28(me)
      v43_26(me)
      v45_23(me)
    end
    v44_26(me)
    return
  end
  local v49_17 = function(arg1)
    v13_2.event_callback("setup_command", v46_16, arg1:get())
    return
  end
  animation_breaker.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      v30_4.unset(v14_2.antiaimbot.other.leg_movement)
      v13_2.event_callback("setup_command", v46_16, false)
      if not v1 then
        animation_breaker.smooth_animfix:unset_callback(v49_17)
      end
    else
      animation_breaker.smooth_animfix:set_callback(v49_17, true)
    end
    v13_2.event_callback("pre_render", v48_15, v1)
    return
  end, true)
end

