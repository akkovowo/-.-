local v0 = (...)
local ffi = require("ffi")
local vector = require("vector")
require("gamesense/inspect")
local offline_http_2 = offline_http
local base64 = require("gamesense/base64")
local images = require("gamesense/images")
local clipboard = require("gamesense/clipboard")
local trace = require("gamesense/trace")
local entity_2 = require("gamesense/entity")
local csgo_weapons = require("gamesense/csgo_weapons")
local v10 = function(...)
  local L1_1, L2_2, L3_3, L4_4, L5_5, L6_6
  L6_6 = ...
  return L1_1, L2_2, L3_3, L4_4, L5_5, L6_6
end
function math.round(arg1)
  if arg1 > 0 then
    arg1 = math.floor(arg1 + 0.5)
  else
    arg1 = math.ceil(arg1 - 0.5)
  end
  return arg1
end
local v11 = function(arg1, arg2)
  for _FORV_5_ = 1, #arg1 do
    if arg1[_FORV_5_] == arg2 then
      return _FORV_5_
    end
  end
  return nil
end
local v12 = {}
do
  do
    local v13, v14
    if _USER_NAME ~= nil then
      v13 = _USER_NAME
    end
    if _SCRIPT_NAME ~= nil then
      v14 = string.match(_SCRIPT_NAME, "angelwings (.*)")
    end
    if v13 == nil then
      v13 = "isabel"
    end
    if v14 == nil then
      v14 = "angel"
    end
    v12.name = "angelwings"
    v12.user = v13
    v12.build = v14
  end
end
local v13_2 = {}
function v13_2.clamp(arg1, arg2, arg3)
  local max = math.max
  return max(arg2, math.min(arg1, arg3))
end
function v13_2.extend_vector(arg1, arg2, arg3)
  local ratio = arg3 * math.pi / 180
  local vector_2 = vector
  return vector_2(arg1.x + math.cos(ratio) * arg2, arg1.y + math.sin(ratio) * arg2, arg1.z)
end
function v13_2.lerp(arg1, arg2, arg3)
  return arg1 + arg3 * (arg2 - arg1)
end
function v13_2.inverse_lerp(arg1, arg2, arg3)
  return (arg3 - arg1) / (arg2 - arg1)
end
function v13_2.map(arg1, arg2, arg3, arg4, arg5, arg6)
  if arg6 then
    arg1 = v13_2.clamp(arg1, arg2, arg3)
  end
  return (v13_2.lerp(arg4, arg5, (v13_2.inverse_lerp(arg2, arg3, arg1))))
end
function v13_2.normalize(arg1, arg2, arg3)
  local diff = arg3 - arg2
  while arg1 < arg2 do
    arg1 = arg1 + diff
  end
  while arg3 < arg1 do
    arg1 = arg1 - diff
  end
  return arg1
end
function v13_2.trim(arg1)
  return arg1
end
function v13_2.from_hex(arg1)
  arg1 = string.gsub(arg1, "#", "")
  local v8, v7, v6, v5 = tonumber(string.sub(arg1, 7, 8), 16), tonumber(string.sub(arg1, 5, 6), 16), tonumber(string.sub(arg1, 3, 4), 16), tonumber(string.sub(arg1, 1, 2), 16)
  local v6 = 16
  local v7 = 7
  local v8 = 8
  v8 = v8 or 255
  return v5, v6, v7, v8
end
function v13_2.to_hex(arg1, arg2, arg3, arg4)
  local format = string.format
  return format("%02x%02x%02x%02x", arg1, arg2, arg3, arg4)
end
function v13_2.event_callback(arg1, arg2, arg3)
  do
    local v3 = arg3
    if v3 then
      v3 = client
      v3 = v3.set_event_callback
    end
    if not v3 then
      v3 = client
      v3 = v3.unset_event_callback
    end
    v3(arg1, arg2)
  end
  return
end
function v13_2.get_eye_position(arg1)
  local origin, origin_2, origin_3 = entity.get_origin(arg1)
  local view_offset, view_offset_2, view_offset_3 = entity.get_prop(arg1, "m_vecViewOffset")
  if origin == nil or view_offset == nil then
    return nil
  end
  return origin + view_offset, origin_2 + view_offset_2, origin_3 + view_offset_3
end
function v13_2.closest_ray_point(arg1, arg2, arg3, arg4)
  local diff = arg3 - arg1
  local diff_2 = arg2 - arg1
  local ratio = (diff.x * diff_2.x + diff.y * diff_2.y) / (diff_2.x * diff_2.x + diff_2.y * diff_2.y)
  if arg4 then
    if ratio <= 0 then
      return arg1
    end
    if ratio >= 1 then
      return arg2
    end
  end
  return arg1 + ratio * diff_2
end
function v13_2.extrapolate(arg1, arg2, arg3)
  return arg1 + arg2 * arg3 * globals.tickinterval()
end
function v13_2.set_movement(arg1, arg2, arg3)
  local y = vector(vector(entity.get_origin(arg3)):to(arg2):angles()).y
  arg1.in_forward = 1
  arg1.in_back = 0
  arg1.in_moveleft = 0
  arg1.in_moveright = 0
  arg1.in_speed = 0
  arg1.forwardmove = 800
  arg1.sidemove = 0
  arg1.move_yaw = y
  return
end
do
  local sv_gravity = cvar.sv_gravity
  local sv_jump_impulse = cvar.sv_jump_impulse
  function v13_2.extrapolate_position(arg1, arg2, arg3, arg4)
    local tickinterval = globals.tickinterval()
    local prod = sv_gravity:get_float() * tickinterval
    local prod_2 = sv_jump_impulse:get_float() * tickinterval
    local v7 = arg2
    do
      local vec = vector(entity.get_prop(arg1, "m_vecVelocity"))
      local v10 = vec.z
      v10 = vec.z > 0
      v10 = v10 and -prod
      v10 = v10 or prod_2
      for _FORV_14_ = 1, arg3 do
        local v8 = v7
        local vector_2 = vector
        do
          local x = v7.x
          local v17 = arg4
          if v17 then
            v17 = vec.x
            v17 = v17 * tickinterval
            v17 = -v17
          end
          if not v17 then
            v17 = vec.x
            v17 = v17 * tickinterval
          end
          local sum = x + v17
        end
        do
          local y = v7.y
          local v18 = arg4
          if v18 then
            v18 = vec.y
            v18 = v18 * tickinterval
            v18 = -v18
          end
          if not v18 then
            v18 = vec.y
            v18 = v18 * tickinterval
          end
          local sum_2 = y + v18
        end
        local z = v7.z
        local v19 = arg4
        if v19 then
          v19 = vec.z
          v19 = v19 + v10
          v19 = v19 * tickinterval
          v19 = -v19
        end
        if not v19 then
          v19 = vec.z
          v19 = v19 + v10
          v19 = v19 * tickinterval
        end
        z = z + v19
        vector_2 = vector_2(sum, sum_2, z)
        v7 = vector_2
        if 0.99 >= client.trace_line(-1, v8.x, v8.y, v8.x, v7.x, v7.y, v7.x) then
          return v8
        end
      end
    end
    return v7
  end
  function v13_2.random_float(arg1, arg2)
    if arg2 < arg1 then
      local v2 = arg2
      arg2 = arg1
      arg1 = v2
    end
    local random_float = client.random_float
    return random_float(arg1, arg2)
  end
  function v13_2.random_int(arg1, arg2)
    if arg2 < arg1 then
      local v2 = arg2
      arg2 = arg1
      arg1 = v2
    end
    local random_int = client.random_int
    return random_int(arg1, arg2)
  end
  function v13_2.find_signature(arg1, arg2, arg3)
    local find_signature = client.find_signature(arg1, arg2)
    if find_signature == nil then
      return nil
    end
    if arg3 == nil then
      return find_signature
    end
    return ffi.cast("char*", find_signature) + arg3
  end
end
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
function v14_2.get_color(arg1)
  if not arg1 then
    local get = ui.get
    return get(v14_2.misc.settings.menu_color)
  end
  local to_hex = v13_2.to_hex
  return to_hex(ui.get(v14_2.misc.settings.menu_color))
end
function v14_2.get_override_damage()
  local get = ui.get
  return get(v14_2.ragebot.aimbot.minimum_damage_override[3])
end
function v14_2.get_minimum_damage()
  local get = ui.get
  return get(v14_2.ragebot.aimbot.minimum_damage)
end
function v14_2.is_slow_motion()
  local v0_2 = ui.get(v14_2.antiaimbot.other.slow_motion[1])
  if v0_2 then
    v0_2 = ui
    v0_2 = v0_2.get
    v0_2 = v0_2(v14_2.antiaimbot.other.slow_motion[2])
  end
  return v0_2
end
function v14_2.is_freestanding()
  local v0_2 = ui.get(v14_2.antiaimbot.angles.freestanding[1])
  if v0_2 then
    v0_2 = ui
    v0_2 = v0_2.get
    v0_2 = v0_2(v14_2.antiaimbot.angles.freestanding[2])
  end
  return v0_2
end
function v14_2.is_double_tap_active()
  local v0_2 = ui.get(v14_2.ragebot.aimbot.double_tap[1])
  if v0_2 then
    v0_2 = ui
    v0_2 = v0_2.get
    v0_2 = v0_2(v14_2.ragebot.aimbot.double_tap[2])
  end
  return v0_2
end
function v14_2.is_override_minimum_damage()
  local v0_2 = ui.get(v14_2.ragebot.aimbot.minimum_damage_override[1])
  if v0_2 then
    v0_2 = ui
    v0_2 = v0_2.get
    v0_2 = v0_2(v14_2.ragebot.aimbot.minimum_damage_override[2])
  end
  return v0_2
end
function v14_2.is_on_shot_antiaim_active()
  local v0_2 = ui.get(v14_2.antiaimbot.other.on_shot_antiaim[1])
  if v0_2 then
    v0_2 = ui
    v0_2 = v0_2.get
    v0_2 = v0_2(v14_2.antiaimbot.other.on_shot_antiaim[2])
  end
  return v0_2
end
function v14_2.is_duck_peek_assist()
  local get = ui.get
  return get(v14_2.ragebot.other.duck_peek_assist)
end
function v14_2.is_quick_peek_assist()
  local v0_2 = ui.get(v14_2.ragebot.other.quick_peek_assist[1])
  if v0_2 then
    v0_2 = ui
    v0_2 = v0_2.get
    v0_2 = v0_2(v14_2.ragebot.other.quick_peek_assist[2])
  end
  return v0_2
end
local v15 = {}
do
  local typeof = ffi.typeof([[
		struct {
			float x;
			float y;
			float z;
		}
	]])
  local v20 = ffi.cast("uintptr_t***", (v13_2.find_signature(unpack({
    "client.dll",
    "\185\204\204\204\204\139@8\255\208\132\192\015\133",
    1
  }))))[0]
  local cast = ffi.cast(ffi.typeof("$*(__thiscall*)(void*, int nSlot, int sequence_number)", (ffi.typeof([[
		struct {
			void     *vfptr;
			int      command_number;
			int      tickcount;
			$        viewangles;
			$        aimdirection;
			float    forwardmove;
			float    sidemove;
			float    upmove;
			int      buttons;
			uint8_t  impulse;
			int      weaponselect;
			int      weaponsubtype;
			int      random_seed;
			short    mousedx;
			short    mousedy;
			bool     hasbeenpredicted;
			$        headangles;
			$        headoffset;
			char	 pad_0x4C[0x18];
		}
	]], typeof, typeof, typeof, typeof))), v20[0][8])
  function v15.get_usercmd(arg1, arg2)
    if arg2 == 0 then
      return nil
    end
    local cast_2 = cast
    return cast_2(v20, arg1, arg2)
  end
end
local v16 = {}
do
  local v17 = function(arg1, arg2)
    for _FORV_5_ = 1, #arg1 do
      if arg2 == arg1[_FORV_5_] then
        return _FORV_5_
      end
    end
    return nil
  end
  local v18 = {}
  v18.__index = v18
  function v18.new(arg1)
    local setmetatable_2 = setmetatable
    return setmetatable_2({
      list = {},
      count = 0
    }, arg1)
  end
  function v18.__len(arg1)
    return arg1.count
  end
  function v18.__call(arg1, arg2, arg3)
    if arg3 == false then
      local v3 = arg1.unset
      return v3(arg1, arg2)
    end
    local v3_2 = arg1.set
    return v3_2(arg1, arg2)
  end
  function v18.unset(arg1, arg2)
    local v17_2 = v17(arg1.list, arg2)
    if v17_2 ~= nil then
      arg1.count = arg1.count - 1
      table.remove(arg1.list, v17_2)
    end
    return arg1
  end
  function v18.set(arg1, arg2, arg3)
    if arg3 == false then
      local v3 = arg1.unset
      return v3(arg1, arg2)
    end
    if not v17(arg1.list, arg2) then
      arg1.count = arg1.count + 1
      table.insert(arg1.list, arg2)
    end
    return arg1
  end
  function v18.fire(arg1, ...)
    local list = arg1.list
    for _FORV_6_ = 1, #list do
      list[_FORV_6_](...)
    end
    return arg1
  end
  local v19 = {}
  do
    local v20_2 = function(arg1, arg2)
      local rawget_2 = rawget(arg1, arg2)
      if rawget_2 == nil then
        rawget_2 = v18:new()
        rawset(arg1, arg2, rawget_2)
      end
      return rawget_2
    end
    function v19.new()
      local setmetatable_2 = setmetatable
      return setmetatable_2({}, {__index = v20_2})
    end
  end
  function v16.new()
    local v0 = v19.new
    return v0(v19)
  end
end
local v17_2 = {}
do
  local play = cvar.play
  local v19_2 = function(arg1, arg2, arg3)
    client.color_log(arg1, arg2, arg3, v12.name, "\000")
    client.color_log(255, 255, 255, " \194\183 ", "\000")
    return
  end
  function v17_2.success(arg1)
    v19_2(250, 137, 250)
    client.color_log(255, 255, 255, arg1)
    play:invoke_callback("ui\\beepclear.wav")
    return
  end
  function v17_2.error(arg1)
    v19_2(250, 0, 50)
    client.color_log(255, 255, 255, arg1)
    play:invoke_callback("resource\\warning.wav")
    return
  end
end
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
local v19_4 = {}
do
  local v21_2 = ({
    angel = -2,
    debug = -1,
    live = 0
  })[v12.build]
  if v21_2 == nil then
    error("LEVEL invalid")
  end
  local v22_2 = {}
  local v23 = function()
    for _FORV_3_ = 1, #v22_2 do
      local v4 = v22_2[_FORV_3_]
      v4.item:set(unpack(v4.value))
      v4.item:set_enabled(false)
    end
    return
  end
  function v19_4.force_update()
    v23()
    return
  end
  function v19_4.is_locked(arg1)
    if v21_2 == -2 then
      return false
    end
    if arg1 == -2 then
      return true
    end
    local v1 = v21_2
    v1 = arg1 < v21_2
    return v1
  end
  function v19_4.push(arg1, arg2, ...)
    if v19_4.is_locked(arg1) then
      local v3 = {
        ...
      }
      if select("#", ...) == 0 then
        v3 = {false}
      end
      table.insert(v22_2, {item = arg2, value = v3})
      arg2:set(unpack(v3))
      arg2:set_enabled(false)
      arg2:set_callback(v23)
      return arg2
    end
    return arg2
  end
  client.delay_call(0, v23)
  client.set_event_callback("post_config_load", v23)
end
local v20_4 = {}
do
  local v21_3 = v16:new()
  local v22_3 = {}
  local v23_2 = function(arg1)
    return {
      tick = globals.tickcount(),
      player = arg1,
      victim = nil,
      eye_pos = vector(v13_2.get_eye_position(arg1)),
      impacts = {},
      damage = nil,
      hitgroup = nil
    }
  end
  local v24 = function(arg1)
    local userid_to_entindex = client.userid_to_entindex(arg1.userid)
    if userid_to_entindex == nil then
      return
    end
    table.insert(v22_3, v23_2(userid_to_entindex))
    return
  end
  local v25 = function(arg1)
    local userid_to_entindex = client.userid_to_entindex(arg1.userid)
    local userid_to_entindex_2 = client.userid_to_entindex(arg1.attacker)
    if userid_to_entindex == nil or userid_to_entindex_2 == nil then
      return
    end
    for _FORV_6_ = #v22_3, 1, -1 do
      local v7 = v22_3[_FORV_6_]
      if v7.player == userid_to_entindex_2 then
        v7.victim = userid_to_entindex
        v7.damage = arg1.dmg_health
        v7.hitgroup = arg1.hitgroup
      end
    end
    return
  end
  local v26 = function(arg1)
    local userid_to_entindex = client.userid_to_entindex(arg1.userid)
    if userid_to_entindex == nil then
      return
    end
    for _FORV_5_ = #v22_3, 1, -1 do
      local v6 = v22_3[_FORV_5_]
      if v6.player == userid_to_entindex then
        table.insert(v6.impacts, (vector(arg1.x, arg1.y, arg1.z)))
      end
    end
    return
  end
  local v27 = function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    local v1
    if entity.is_alive(me) then
      v1 = vector(entity.hitbox_position(me, 0))
    end
    for _FORV_5_ = 1, #v22_3 do
      local v6 = v22_3[_FORV_5_]
      local len = #v6.impacts
      if len ~= 0 then
        local eye_pos = v6.eye_pos
        local v9 = v6.impacts[len]
        v21_3.player_shot:fire({
          tick = v6.tick,
          player = v6.player,
          victim = v6.victim,
          eye_pos = eye_pos,
          end_pos = v9,
          damage = v6.damage,
          hitgroup = v6.hitgroup
        })
        if v1 ~= nil and entity.is_enemy(v6.player) then
          local v11 = v1:distsqr((v13_2.closest_ray_point(eye_pos, v9, v1, true)))
          if v11 <= 6400 then
            v21_3.enemy_shot:fire({
              tick = v6.tick,
              distance = math.sqrt(v11),
              player = v6.player,
              victim = v6.victim,
              eye_pos = eye_pos,
              end_pos = v9,
              damage = v6.damage,
              hitgroup = v6.hitgroup
            })
          end
        end
      end
    end
    for _FORV_5_ = 1, #v22_3 do
      v22_3[_FORV_5_] = nil
    end
    return
  end
  function v20_4.get_event_bus()
    local L0_7, L1_8, L2_9, L3_10, L4_11, L5_12
    L0_7 = v21_3
    return L0_7
  end
  client.set_event_callback("weapon_fire", v24)
  client.set_event_callback("player_hurt", v25)
  client.set_event_callback("bullet_impact", v26)
  client.set_event_callback("net_update_start", v27)
end
local v21_4 = {}
do
  local v22_4 = v16:new()
  local v23_3 = {}
  v23_3.__index = v23_3
  do
    local v24_2 = function(arg1, ...)
      if arg1 then
        return ...
      end
      return nil
    end
    local v25_2 = function(arg1)
      return {
        v24_2(pcall(ui.get, arg1))
      }
    end
    local v26_2 = function(arg1)
      local v1 = {}
      for _FORV_5_ = 1, #arg1 do
        v1[arg1[_FORV_5_]] = _FORV_5_
      end
      return v1
    end
    local v27_2 = function(arg1, arg2)
      local v25_2_2 = v25_2(arg1.ref)
      arg1.value = v25_2_2
      if arg2 then
        arg1.default = v25_2_2
      end
      if arg1.type == "multiselect" then
        arg1.key_values = v26_2(unpack(v25_2_2))
      end
      return
    end
    function v23_3.new(arg1, arg2)
      local setmetatable_2 = setmetatable
      return setmetatable_2({
        ref = arg2,
        type = nil,
        list = {},
        value = {},
        default = {},
        key_values = {},
        callbacks = {}
      }, arg1)
    end
    function v23_3.init(arg1, ...)
      local v2 = function()
        v27_2(arg1, false)
        arg1:fire_events()
        v22_4.item_changed:fire(arg1)
        return
      end
      arg1.type = ui.type(arg1.ref)
      if arg1.type ~= "label" then
        v27_2(arg1, true)
        pcall(ui.set_callback, arg1.ref, v2)
      end
      if arg1.type == "multiselect" or arg1.type == "list" then
        arg1.list = select(4, ...)
      end
      if arg1.type == "button" then
        local select_2 = select(4, ...)
        if select_2 ~= nil then
          arg1:set_callback(select_2)
        end
      end
      v22_4.item_init:fire(arg1)
      return
    end
    function v23_3.get(arg1, arg2)
      if arg1.type ~= "hotkey" and arg1.type ~= "textbox" then
        if arg2 == nil then
          local unpack_2 = unpack
          return unpack_2(arg1.value)
        end
        local v2 = arg1.key_values[arg2]
        v2 = arg1.key_values[arg2] ~= nil
        return v2
      end
      local get = ui.get
      return get(arg1.ref)
    end
    function v23_3.set(arg1, ...)
      ui.set(arg1.ref, ...)
      v27_2(arg1, false)
      return
    end
    function v23_3.update(arg1, ...)
      ui.update(arg1.ref, ...)
      return
    end
    function v23_3.reset(arg1)
      pcall(ui.set, arg1.ref, unpack(arg1.default))
      return
    end
    function v23_3.set_enabled(arg1, arg2)
      local set_enabled = ui.set_enabled
      return set_enabled(arg1.ref, arg2)
    end
    function v23_3.set_visible(arg1, arg2)
      local set_visible = ui.set_visible
      return set_visible(arg1.ref, arg2)
    end
    function v23_3.set_callback(arg1, arg2, arg3)
      if v11(arg1.callbacks, arg2) == nil then
        table.insert(arg1.callbacks, arg2)
      end
      if arg3 then
        arg2(arg1)
      end
      return arg1
    end
    function v23_3.unset_callback(arg1, arg2)
      local v11_2 = v11(arg1.callbacks, arg2)
      if v11_2 ~= nil then
        table.remove(arg1.callbacks, v11_2)
      end
      return arg1
    end
    function v23_3.fire_events(arg1)
      local callbacks = arg1.callbacks
      for _FORV_5_ = 1, #callbacks do
        callbacks[_FORV_5_](arg1)
      end
      return
    end
  end
  function v21_4.new(arg1, ...)
    local v3 = v23_3:new((arg1(...)))
    v3:init(...)
    return v3
  end
  function v21_4.get_event_bus()
    local L0_13, L1_14, L2_15, L3_16, L4_17, L5_18
    L0_13 = v22_4
    return L0_13
  end
end
local v22_5 = {}
do
  local v23_4 = {}
  local v24_3 = {}
  local v25_3 = v16:new()
  function v22_5.get_event_bus()
    local L0_19, L1_20, L2_21, L3_22, L4_23, L5_24, L6_25, L7_26, L8_27, L9_28, L10_29, L11_30, L12_31, L13_32, L14_33, L15_34, L16_35, L17_36, L18_37, L19_38, L20_39, L21_40, L22_41, L23_42, L24_43, L25_44
    L0_19 = v25_3
    return L0_19
  end
  function v22_5.set(arg1, arg2)
    if arg1 == nil or arg1.ref == nil then
      return
    end
    v23_4[arg1.ref] = arg2
    return
  end
  function v22_5.force_update()
    for _FORV_3_ = 1, #v24_3 do
      local v4 = v24_3[_FORV_3_]
      if v4 ~= nil then
        local ref = v4.ref
        if ref ~= nil then
          local v6 = v23_4[ref]
          if v6 ~= nil then
            v4:set_visible(v6)
            v23_4[ref] = false
          end
        end
      end
    end
    return
  end
  local event_bus = v21_4.get_event_bus()
  local v28 = function(...)
    v25_3.update:fire(...)
    v22_5.force_update()
    return
  end
  event_bus.item_init:set(function(arg1)
    v23_4[arg1.ref] = false
    arg1:set_visible(false)
    table.insert(v24_3, arg1)
    return
  end)
  event_bus.item_changed:set(v28)
end
local v23_5 = {}
do
  local v24_4 = 0
  local v25_4 = 0
  v23_5.is_moving = false
  v23_5.is_onground = false
  v23_5.is_crouched = false
  v23_5.is_peeking = false
  v23_5.is_vulnerable = false
  v23_5.duck_amount = 0
  v23_5.velocity2d_sqr = 0
  v23_5.pose_body_yaw = 0
  local v26_3 = function(arg1)
    local v1 = false
    local v2 = false
    local vec = vector(entity.get_prop(arg1, "m_vecVelocity"))
    local extrapolate = v13_2.extrapolate(vector(client.eye_position()), vec, 14)
    local players = entity.get_players(true)
    for _FORV_10_ = 1, #players do
      local v11 = players[_FORV_10_]
      local esp_data = entity.get_esp_data(v11)
      if esp_data ~= nil then
        if bit.band(esp_data.flags, bit.lshift(1, 11)) ~= 0 then
          v2 = true
        else
          local extrapolate_2 = v13_2.extrapolate(vector(entity.hitbox_position(v11, 0)), vec, 4)
          local trace_bullet = client.trace_bullet(arg1, extrapolate.x, extrapolate.y, extrapolate.z, extrapolate_2.x, extrapolate_2.y, extrapolate_2.z)
          if trace_bullet ~= nil and trace_bullet > 0 then
            v1 = true
          end
        end
      end
    end
    return v1, v2
  end
  local v28_2 = function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    v25_4 = entity.get_prop(me, "m_fFlags")
    return
  end
  local v29 = function(arg1)
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    local v26_3_2, v26_3_3 = v26_3(me)
    do
      local v4 = bit.band(v24_4, 1)
      v4 = bit.band(v24_4, 1) ~= 0
      if v4 then
        v4 = bit
        v4 = v4.band
        v4 = v4(v25_4, 1)
        v4 = v4 ~= 0
      end
      local duck_amount = entity.get_prop(me, "m_flDuckAmount")
      local v7 = vector(entity.get_prop(me, "m_vecVelocity")):length2dsqr()
      do
        local v8 = vector(entity.get_prop(me, "m_vecVelocity"))
        v8 = v7 > 25
        v23_5.is_moving = v8
      end
      v23_5.is_onground = v4
      v23_5.is_peeking = v26_3_2
      v23_5.is_vulnerable = v26_3_3
      if arg1.chokedcommands == 0 then
        do
          local v8_2 = arg1.chokedcommands
          v8_2 = duck_amount > 0.5
          v23_5.is_crouched = v8_2
        end
        v23_5.duck_amount = duck_amount
        v23_5.pose_body_yaw = entity.get_prop(me, "m_flPoseParameter", 11)
      end
      v23_5.velocity2d_sqr = v7
    end
    return
  end
  client.set_event_callback("pre_predict_command", function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    v24_4 = entity.get_prop(me, "m_fFlags")
    return
  end)
  client.set_event_callback("predict_command", v28_2)
  client.set_event_callback("setup_command", v29)
end
local v24_5 = {}
do
  local v25_5 = 0
  local v26_4 = 0
  local v27_3 = {}
  v27_3.old_origin = vector()
  v27_3.old_simtime = 0
  v27_3.shift = false
  v27_3.breaking_lc = false
  v27_3.defensive = {
    force = false,
    left = 0,
    max = 0
  }
  v27_3.lagcompensation = {distance = 0, teleport = false}
  local v28_3 = function(arg1)
    do
      local v1 = globals.tickcount()
      v1 = globals.tickcount() > entity.get_prop(arg1, "m_nTickBase")
      v27_3.shift = v1
    end
    return
  end
  local v29_2 = function(arg1, arg2)
    local v3 = (arg2 - arg1):lengthsqr()
    do
      local v4 = arg2 - arg1
      v4 = v3 > 4096
      v27_3.breaking_lc = v4
      v27_3.lagcompensation.distance = v3
      v27_3.lagcompensation.teleport = v4
    end
    return
  end
  local v30 = function(arg1)
    local old_origin = v27_3.old_origin
    local old_simtime = v27_3.old_simtime
    local vec = vector(entity.get_origin(arg1))
    local toticks_2 = toticks(entity.get_prop(arg1, "m_flSimulationTime"))
    if old_simtime ~= nil then
      local diff = toticks_2 - old_simtime
      if diff < 0 or diff > 0 and diff <= 64 then
        v29_2(old_origin, vec)
      end
    end
    v27_3.old_origin = vec
    v27_3.old_simtime = toticks_2
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
      v27_3.breaking_lc = true
      v27_3.defensive.left = v2
      if v27_3.defensive.max == 0 then
        v27_3.defensive.max = v2
      end
    else
      v27_3.defensive.left = 0
      v27_3.defensive.max = 0
    end
    return
  end
  function v24_5.get()
    local L0_46, L1_47, L2_48, L3_49, L4_50, L5_51
    L0_46 = v27_3
    return L0_46
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
  client.set_event_callback("predict_command", function(arg1)
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    if arg1.command_number == v26_4 then
      v31(me)
      v26_4 = nil
    end
    return
  end)
  client.set_event_callback("setup_command", v33)
  client.set_event_callback("run_command", v34)
  client.set_event_callback("net_update_start", v35)
end
local v25_6 = {}
do
  local v26_5 = {}
  local v27_4 = 0
  local v28_4 = function(arg1)
    v27_4 = v27_4 + 1
    v26_5[v27_4] = arg1
    return
  end
  local v29_3 = function()
    local L0_52, L1_53, L2_54, L4_55, L5_56, L8_57, L9_58, L10_59, L11_60, L12_61
    for L4_55 = 1, v27_4 do
      L10_59 = v26_5
      L10_59[L4_55] = nil
    end
    L9_58 = 0
    v27_4 = L9_58
    return
  end
  local v30_2 = function()
    if v23_5.is_onground then
      if not v23_5.is_moving then
        v28_4("standing")
        return
      end
      v28_4("moving")
      if not v23_5.is_crouched then
        if v14_2.is_slow_motion() then
          v28_4("slow walk")
        end
        return
      end
      return
    end
    return
  end
  local v31_2 = function()
    if v23_5.is_crouched then
      v28_4("crouching")
      if v23_5.is_moving then
        v28_4("move-crouching")
      end
      return
    end
    return
  end
  local v32 = function()
    if not v23_5.is_onground then
      v28_4("air")
      if v23_5.is_crouched then
        v28_4("air-crouching")
      end
      return
    end
    return
  end
  function v25_6.get()
    local L0_62, L1_63, L2_64, L3_65, L4_66, L5_67
    L0_62 = v26_5
    return L0_62
  end
  client.set_event_callback("setup_command", function()
    v29_3()
    v30_2()
    v31_2()
    v32()
    return
  end)
end
local v26_6 = {}
do
  local v27_5 = function(arg1)
    local v1 = {}
    local v2 = 0
    for _FORV_6_, _FORV_7_ in string.gmatch(arg1, ".[\128-\191]*") do
      v2 = v2 + 1
      v1[v2] = _FORV_6_
    end
    return v1, v2
  end
  function v26_6.gradient(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
    local v10 = {}
    local v27_5_2, v27_5_3 = v27_5(arg1)
    local ratio = 1 / (v27_5_3 - 1)
    local diff = arg7 - arg3
    local diff_2 = arg8 - arg4
    local diff_3 = arg9 - arg5
    local diff_4 = arg10 - arg6
    for _FORV_21_ = 1, v27_5_3 do
      local v22 = v27_5_2[_FORV_21_]
      local rem = arg2 % 2
      if rem > 1 then
        rem = 2 - rem
      end
      local to_hex = v13_2.to_hex(arg3 + rem * diff, arg4 + rem * diff_2, arg5 + rem * diff_3, arg6 + rem * diff_4)
      table.insert(v10, "\a")
      table.insert(v10, to_hex)
      table.insert(v10, v22)
      arg2 = arg2 + ratio
    end
    local concat = table.concat
    return concat(v10)
  end
end
local v27_6 = {}
do
  local v28_5 = function(arg1)
    local v1 = {}
    local len = #arg1
    do
      local v3, v4 = arg1:find("\a", 1)
      if v3 == nil then
        table.insert(v1, {arg1, nil})
      end
      if v3 ~= nil and v3 > 1 then
        table.insert(v1, {
          arg1:sub(1, v3 - 1),
          nil
        })
      end
      while true do
        do
          do
            local v5, v6, v7 = table.insert, v1, {
              arg1:sub(1, v3 - 1),
              nil
            }
            if v3 ~= nil then
              v5 = nil
              v7 = arg1
              v6 = arg1.sub
              v6 = v6(v7, v4 + 1, v4 + 7)
              if v6 == "DEFAULT" then
                v4 = v4 + 8
              else
                v7 = arg1
                v6 = arg1.sub
                v6 = v6(v7, v4 + 1, v4 + 8)
                v5 = v6
                v4 = v4 + 9
              end
              v7 = arg1
              v6 = arg1.find
              v7 = v6(v7, "\a", v4)
              if v6 == nil then
                if len >= v4 then
                  table.insert(v1, {
                    arg1:sub(v4),
                    v5
                  })
                end
                v5 = v1
                return v5
              end
            end
          end
          table.insert(v1, {
            arg1:sub(v4, v6 - 1),
            v5
          })
          v4 = v7
        end
        v3 = v6
      end
    end
  end
  function v27_6.color(arg1)
    local v28_5_2 = v28_5(arg1)
    return v28_5_2, #v28_5_2
  end
end
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
  local v32_2 = function(arg1, arg2)
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
      local v2 = function(arg1)
        return arg1 .. ":defensive_" .. arg1
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
        local v6 = function(arg1)
          return arg1 .. ":" .. arg1
        end
        local v7 = function(arg1)
          local v31_3_2 = v31_3
          return v31_3_2(v30_3(arg1), v6(arg1))
        end
        if arg2 ~= nil then
          function v6(arg1)
            return arg1 .. ":" .. arg1 .. ":" .. arg2
          end
        end
        if not v3 then
          v2.override = v18_2.push("antiaim", v6("override"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("${" .. string.format("allow %s condition", arg1) .. "}"), v6("override"))))
        end
        if v4 then
          v2.bomb_e_fix = v18_2.push("antiaim", v6("bomb_e_fix"), v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  bomb e fix"), v6("bomb_e_fix"))))
        end
        if not v4 then
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
      v32_2(v41.states)
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
      v32_2(v42.states, {
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
      local v39_2 = {}
      ;({})[1] = "awp"
      ;({})[2] = "auto"
      ;({})[3] = "scout"
      ;({})[4] = "pistol"
      ;({})[5] = "deagle"
      v38_2.enabled = v18_2.push("ragebot", "ai_peek.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "ai-peek   "))
      v38_2.weapon = v18_2.push("ragebot", "ai_peek.weapons", v21_4.new(ui.new_multiselect, "AA", "Anti-Aimbot angles", v31_3(v30_3("  ${~}  weapons"), "ai_peek"), v39_2))
      v19_4.push(-2, v38_2.enabled)
      v36_2.ai_peek = v38_2
    end
    local v39_3 = {}
    do
      local v40_3 = function(arg1)
        local v2 = function(arg1)
          return arg1 .. ":" .. arg1
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
      local v46 = {}
      ;({})[1] = "awp"
      ;({})[2] = "auto"
      ;({})[3] = "scout"
      ;({})[4] = "pistol"
      ;({})[5] = "deagle"
      local v47 = {}
      ;({})[1] = "standing"
      ;({})[2] = "moving"
      ;({})[3] = "slow walk"
      ;({})[4] = "air"
      ;({})[5] = "air-crouching"
      ;({})[6] = "crouching"
      ;({})[7] = "move-crouching"
      v45_3.enabled = v18_2.push("ragebot", "auto_hide_shots.enabled", v21_4.new(ui.new_checkbox, "AA", "Anti-aimbot angles", "auto hide shots"))
      v45_3.weapons = v18_2.push("ragebot", "auto_hide_shots.weapons", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  weapons"), "auto_hide_shots"), v46))
      v45_3.states = v18_2.push("ragebot", "auto_hide_shots.states", v21_4.new(ui.new_multiselect, "AA", "Anti-aimbot angles", v31_3(v30_3("  ${~}  states"), "auto_hide_shots"), v47))
      v32_2(v45_3.weapons)
      v32_2(v45_3.states, {
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
    v32_2(v39_4.types, {"branded"})
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
    v32_2(v45_5.detections)
    v32_2(v45_5.list, {
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
        local decode = v18_2.decode(v49.data)
        if v18_2.decode(v49.data) then
          v49.data = decode
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
      return
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
        v45_6(v4_2.name, v4_2.data, false).data_index = _FORV_3_
        table.insert(v43_2, (v45_6(v4_2.name, v4_2.data, false)))
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
      local encode = v18_2.encode(v18_2.export())
      if v18_2.encode(v18_2.export()) then
        clipboard.set(encode)
        v17_2.success("config exported")
        return
      end
      return
    end)
    v39_5.import_button = v21_4.new(ui.new_button, "AA", "Anti-aimbot angles", "import", function()
      local decode = v18_2.decode(clipboard.get())
      if v18_2.decode(clipboard.get()) then
        v18_2.import(decode)
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
    return
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
local v30_4 = {}
do
  local v31_4 = {}
  local v32_3 = {}
  v32_3[0] = "Always on"
  v32_3[1] = "On hotkey"
  v32_3[2] = "Toggle"
  v32_3[3] = "Off hotkey"
  local v33_3 = function(arg1)
    local v2 = {
      ui.get(arg1)
    }
    if ui.type(arg1) == "hotkey" then
      local v3 = v32_3[v2[2]]
      local v4 = v2[3]
      v4 = v4 or 0
      return {v3, v4}
    end
    return v2
  end
  function v30_4.get(arg1)
    local v1 = v31_4[arg1]
    if v1 == nil then
      return nil
    end
    local unpack_2 = unpack
    return unpack_2(v1)
  end
  function v30_4.set(arg1, ...)
    if v31_4[arg1] == nil then
      v31_4[arg1] = v33_3(arg1)
    end
    ui.set(arg1, ...)
    return
  end
  function v30_4.unset(arg1)
    local v1 = v31_4[arg1]
    if v1 == nil then
      return
    end
    ui.set(arg1, unpack(v1))
    v31_4[arg1] = nil
    return
  end
end
local v31_5 = {}
do
  local v32_4 = {}
  local weapon_type_ref = ui.reference("Rage", "Weapon type", "Weapon type")
  local v34_3 = {}
  v34_3[0] = "Always on"
  v34_3[1] = "On hotkey"
  v34_3[2] = "Toggle"
  v34_3[3] = "Off hotkey"
  local v35_3 = function(arg1)
    local v2 = {
      ui.get(arg1)
    }
    if ui.type(arg1) == "hotkey" then
      local v3 = v34_3[v2[2]]
      local v4 = v2[3]
      v4 = v4 or 0
      return {v3, v4}
    end
    return v2
  end
  function v31_5.set(arg1, ...)
    local v2 = ui.get(weapon_type_ref)
    if v32_4[arg1] == nil then
      v32_4[arg1] = {}
    end
    local v3 = v32_4[arg1]
    if v3[v2] == nil then
      v3[v2] = {
        type = v2,
        value = v35_3(arg1)
      }
    end
    ui.set(arg1, ...)
    return
  end
  function v31_5.unset(arg1)
    local v1 = v32_4[arg1]
    if v1 == nil then
      return
    end
    local v2 = ui.get(weapon_type_ref)
    for _FORV_6_, _FORV_7_ in pairs(v1) do
      ui.set(weapon_type_ref, _FORV_7_.type)
      ui.set(arg1, unpack(_FORV_7_.value))
      v1[_FORV_6_] = nil
    end
    ui.set(weapon_type_ref, v2)
    v32_4[arg1] = nil
    return
  end
end
local v32_5 = {}
do
  local v33_4 = function(arg1, arg2, arg3, arg4)
    return arg3 * arg1 / arg4 + arg2
  end
  local v34_4 = function()
    local frametime = globals.frametime
    return frametime()
  end
  local v35_4 = function(arg1, arg2, arg3, arg4, arg5)
    if arg4 <= 0 then
      return arg3
    end
    if arg5 <= arg4 then
      return arg3
    end
    arg2 = arg1(arg4, arg2, arg3 - arg2, arg5)
    if type(arg2) == "number" then
      if not (0.001 > math.abs(arg3 - arg2)) then
        local rem = arg2 % 1
        if not (rem < 0.001) then
          if rem > 0.999 then
            local ceil = math.ceil
            do return ceil(arg2) end
            local floor = math.floor
            do return floor(arg2) end
            return arg3
          end
        end
      end
    end
    return arg2
  end
  function v32_5.interp(arg1, arg2, arg3, arg4)
    do
      local v4 = arg4
      v4 = v4 or v33_4
      arg4 = v4
    end
    if type(arg2) == "boolean" then
      local v4_2 = arg2
      v4_2 = v4_2 and 1
      v4_2 = v4_2 or 0
      arg2 = v4_2
    end
    local v35_4_2 = v35_4
    return v35_4_2(arg4, arg1, arg2, v34_4(), arg3)
  end
end
local v33_5 = ffi.typeof([[
        struct {
            unsigned char r;
            unsigned char g;
            unsigned char b;
            unsigned char a;
        }
    ]])
do
  local v34_5 = {}
  v34_5.__index = v34_5
  function v34_5.lerp(arg1, arg2, arg3)
    local v33_5_2 = v33_5
    return v33_5_2(arg1.r + arg3 * (arg2.r - arg1.r), arg1.g + arg3 * (arg2.g - arg1.g), arg1.b + arg3 * (arg2.b - arg1.b), arg1.a + arg3 * (arg2.a - arg1.a))
  end
  function v34_5.unpack(arg1)
    return arg1.r, arg1.g, arg1.b, arg1.a
  end
  function v34_5.clone(arg1)
    local v33_5_2 = v33_5
    return v33_5_2(arg1:unpack())
  end
  function v34_5.__tostring(arg1)
    local format = string.format
    return format("%i, %i, %i, %i", arg1:unpack())
  end
  ffi.metatype(v33_5, v34_5)
end
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
      v11 = v37_4
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
      local v12 = arg4
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
      renderer.rectangle(arg1 + v12 + arg10, arg2 + arg4, arg3 - prod_3 - prod_4, -prod_2, arg5, arg6, arg7, arg8)
    end
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
local v35_6 = {}
do
  local v36_4 = function(arg1)
    local v1 = type(arg1.type)
    v1 = type(arg1.type) == "string"
    if v1 then
      v1 = type
      v1 = v1(arg1.link)
      v1 = v1 == "string"
    end
    if v1 then
      v1 = type
      v1 = v1(arg1.width)
      v1 = v1 == "number"
    end
    if v1 then
      v1 = type
      v1 = v1(arg1.height)
      v1 = v1 == "number"
    end
    return v1
  end
  ;(function(arg1)
    return function(arg1)
      if v36_4(arg1) then
        local format = string.format("%s/%s.%s", v12.name, arg1, arg1.type)
        local readfile_2 = readfile(format)
        if readfile_2 == nil then
          offline_http_2.get(arg1.link, function(arg1, arg2)
            if arg1 then
              do
                local code = arg2.code
                do
                  local v3 = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                    do
                      local v7 = arg5 - arg7
                      v7 = arg2 > arg5 - arg7
                      v7 = v7 and arg3
                      v7 = v7 or arg3
                      v7 = v7 - arg4
                      do
                        local v7_2 = v7 - arg4
                        v7_2 = v7 ~= arg5
                        v7_2 = v7_2 and arg2
                        v7_2 = v7_2 or arg6
                        v7_2 = v7_2 - arg2
                        v7_2 = v7_2 + arg4
                        do
                          local v7_3 = v7_2 + arg4
                          v7_3 = arg1 > v7_2
                          v7_3 = v7_3 and arg4
                          v7_3 = v7_3 or arg6
                          v7_3 = v7_3 + arg5
                          v7_3 = v7_3 - arg1
                          do
                            local v7_4 = v7_3 - arg1
                            v7_4 = arg4 > v7_3
                            v7_4 = v7_4 and arg1
                            v7_4 = v7_4 or arg6
                            local sum = 528869958 + v7_4
                          end
                        end
                      end
                    end
                    do
                      local v8
                      v8 = arg1 == arg4
                      v8 = v8 and arg2
                      v8 = v8 or arg3
                      v8 = v8 + arg2
                      do
                        local v8_2 = v8 + arg2
                        v8_2 = arg7 >= v8
                        v8_2 = v8_2 and arg6
                        v8_2 = v8_2 or sum
                        v8_2 = v8_2 + arg3
                        do
                          local v8_3 = v8_2 + arg3
                          v8_3 = v8_2 == arg5
                          v8_3 = v8_3 and arg4
                          v8_3 = v8_3 or arg1
                          v8_3 = v8_3 + sum
                          do
                            local v8_4 = v8_3 + sum
                            v8_4 = arg4 <= v8_3
                            v8_4 = v8_4 and arg4
                            v8_4 = v8_4 or arg7
                            v8_4 = v8_4 - arg6
                            v8_4 = v8_4 + arg5
                            do
                              local v8_5 = v8_4 + arg5
                              v8_5 = arg4 >= v8_4
                              v8_5 = v8_5 and arg3
                              v8_5 = v8_5 or arg1
                              local sum_2 = 2943297423 + v8_5
                            end
                          end
                        end
                      end
                    end
                    do
                      local v9 = arg5 + arg6 - arg3 + arg2
                      v9 = arg5 + arg6 - arg3 + arg2 ~= arg1
                      v9 = v9 and arg1
                      v9 = v9 or arg7
                      v9 = v9 + arg2
                      v9 = v9 + sum_2
                      v9 = v9 + arg6
                      v9 = v9 + sum_2
                      v9 = v9 - arg2
                      do
                        local v9_2 = v9 - arg2
                        v9_2 = arg5 < v9
                        v9_2 = v9_2 and arg1
                        v9_2 = v9_2 or arg6
                        local sum_3 = 2293317259 + v9_2
                      end
                    end
                    do
                      local v10 = arg2 + sum - arg5
                      v10 = sum_3 > arg2 + sum - arg5
                      v10 = v10 and arg3
                      v10 = v10 or arg4
                      v10 = v10 + sum_3
                      v10 = v10 - sum
                      v10 = v10 + sum
                      do
                        local v10_2 = v10 + sum
                        v10_2 = v10 ~= sum_3
                        v10_2 = v10_2 and arg1
                        v10_2 = v10_2 or arg4
                        v10_2 = v10_2 - sum_3
                        v10_2 = v10_2 + arg3
                        v10_2 = v10_2 - sum_3
                        local sum_4 = 6160980146 + v10_2
                      end
                    end
                    do
                      local v11 = arg4 + arg1 + arg1
                      v11 = arg4 + arg1 + arg1 == arg4
                      v11 = v11 and arg2
                      v11 = v11 or arg5
                      v11 = v11 - arg7
                      v11 = v11 - sum_3
                      v11 = v11 + arg3
                      v11 = v11 - sum_2
                      v11 = v11 + arg6
                      v11 = v11 - arg3
                      v11 = v11 + sum_4
                      local sum_5 = 5429395615 + v11
                    end
                    local v12 = 0
                    do
                      local v13 = sum + arg1
                      v13 = arg3 <= sum + arg1
                      v13 = v13 and sum_5
                      v13 = v13 or arg2
                      v13 = v13 - arg1
                      v13 = v13 + arg6
                      v13 = v13 + sum_5
                      do
                        local v13_2 = v13 + sum_5
                        v13_2 = arg7 > v13
                        v13_2 = v13_2 and arg5
                        v13_2 = v13_2 or arg2
                        v13_2 = v13_2 - sum_5
                        do
                          local v13_3 = v13_2 - sum_5
                          v13_3 = arg4 < v13_2
                          v13_3 = v13_3 and sum_5
                          v13_3 = v13_3 or arg3
                          v13_3 = v13_3 - sum_4
                          do
                            local v13_4 = v13_3 - sum_4
                            v13_4 = sum_3 < v13_3
                            v13_4 = v13_4 and arg3
                            v13_4 = v13_4 or arg6
                            v13_4 = v13_4 - arg2
                            v13_4 = v13_4 - sum_2
                            v13_4 = v13_4 - sum_3
                            v13_4 = v13_4 - sum_2
                            do
                              local v13_5 = v13_4 - sum_2
                              v13_5 = v13_4 == arg1
                              v13_5 = v13_5 and arg2
                              v13_5 = v13_5 or sum_5
                              local v13_6 = sum_5
                            end
                          end
                        end
                      end
                    end
                    v13_6 = sum_2 > v13_5
                    v13_6 = v13_6 and arg4
                    v13_6 = v13_6 or sum_5
                    v13_6 = v13_6 - sum
                    v13_6 = v13_6 + sum
                    v13_6 = v13_6 - arg1
                    v13_6 = v13_6 + arg7
                    v12 = v12 + v13_6
                    v12 = -3391466715 + v12
                    return v12
                  end
                  do
                    local v4 = math.floor(math.pi)
                    v4 = 249 >= math.floor(math.pi)
                    v4 = v4 and 498
                    if not v4 then
                      v4 = math
                      v4 = v4.ceil
                      v4 = v4(math.pi)
                    end
                    v4 = v4 - 464
                    v4 = v4 + 299
                    v4 = v4 - 14
                    v4 = v4 - string.byte("\223\204", 1, 2)
                    local sum = -1203369932 + v4
                  end
                  do
                    local v5 = -174
                    v5 = 178 <= -174
                    v5 = v5 and 454
                    v5 = v5 or 39
                    v5 = v5 - 294
                    v5 = v5 - string.byte("\211l>\127\176", 5, 5)
                    v5 = v5 + math.ceil(math.pi)
                    local sum_2 = 1592821964 + v5
                  end
                  local sum_3 = -841141008 + (737 - 326 + string.byte("\219Q\006\182", 4, 4) + 366 + string.byte("\194R\233\190", 4, nil))
                  local sum_4 = 1791056282 + (string.len("\014") - string.len("\b") - string.byte("\177B\145\202&", 1, 1) - 90 + 60 + 47)
                  do
                    local v8 = math.modf(math.pi)
                    v8 = 105 < math.modf(math.pi)
                    v8 = v8 and 154
                    v8 = v8 or 429
                    v8 = v8 + 134
                    do
                      local v8_2 = v8 + 134
                      v8_2 = v8 < 207
                      if v8_2 then
                        v8_2 = string
                        v8_2 = v8_2.len
                        v8_2 = v8_2("\145")
                      end
                      if not v8_2 then
                        v8_2 = string
                        v8_2 = v8_2.byte
                        v8_2 = v8_2("\227\229\210", 2, nil)
                      end
                      v8_2 = v8_2 - 406
                      v8_2 = v8_2 + string.len("")
                      local sum_5 = -1289426561 + v8_2
                    end
                  end
                  local v9 = math.floor(math.pi) - 499 - 357
                  v9 = 118 > math.floor(math.pi) - 499 - 357
                  v9 = v9 and 323
                  v9 = v9 or 422
                  v9 = v9 - 189
                  v9 = v9 - 396
                  v9 = -802042871 + v9
                  v3 = v3(sum, sum_2, sum_3, sum_4, sum_5, v9, 397040296 + (276 + math.modf(math.pi) + 442 + 77 - 136 - string.len("\220")))
                end
              end
              if code == v3 then
                local body = v29_4.body
                v35_6[arg1] = renderer["load_" .. arg1.type](body, arg1.width, arg1.height)
                writefile(format, body)
                return
              end
            end
            return
          end)
        else
          v35_6[arg1] = renderer["load_" .. arg1.type](readfile_2, arg1.width, arg1.height)
        end
        return true
      end
      return false
    end
  end)("eva_small")({
    type = "png",
    width = 35,
    height = 35,
    link = (function(...)
      local L1_69
    end)("\020\r\153\160F\146h\031\146[\251\145\165\251\244\201\168\2021\146\185\171\237A;\188B\196a&b\195\231\210\160#0\206\205h\179\239\029\204\133\255\015\163\146\185^\222S\208\169\127dq6\027\129\002")
  })
end
local v36_5 = function()
  local v0 = v29_4.visuals.allow_dpi_scale.enabled.get
  return v0(v29_4.visuals.allow_dpi_scale.enabled)
end
local v37_5 = function(arg1)
  do
    local v1 = type(arg1)
    v1 = type(arg1) == "string"
    if v1 then
      v1 = arg1.gsub
      v1 = v1(arg1, "d", "")
    end
    v1 = v1 or ""
    arg1 = v1
  end
  if v36_5() then
    arg1 = arg1 .. "d"
  end
  return arg1
end
local v38_4 = {}
do
  local v39_6 = 0
  local v40_5 = false
  local v41_4
  local v42_5 = 0
  local v43_4 = {}
  ;({})[1] = -1
  ;({})[2] = 1
  ;({})[3] = 0
  ;({})[4] = -1
  ;({})[5] = 1
  ;({})[6] = 0
  ;({})[7] = -1
  ;({})[8] = 0
  ;({})[9] = 1
  ;({})[10] = -1
  ;({})[11] = 0
  ;({})[12] = 1
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
      return
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
      local L0_70, L1_71, L2_72, L3_73, L4_74, L5_75, L6_76
      L0_70 = v47_6
      L0_70 = not L0_70
      v47_6 = L0_70
      return
    end
    local v50_2 = function()
      local L0_77, L1_78, L2_79, L3_80, L4_81, L5_82, L6_83, L7_84, L8_85, L9_86, L10_87, L11_88, L12_89, L13_90, L14_91, L15_92, L16_93, L17_94, L18_95, L19_96, L20_97, L21_98, L22_99, L23_100, L24_101, L25_102, L26_103
      L0_77 = v48_4
      L0_77 = L0_77 + 1
      v48_4 = L0_77
      return
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
        local v47_6_2 = v47_6
        v47_6_2 = v47_6_2 and v5
        v47_6_2 = v47_6_2 or v4
        arg1.pitch = "Custom"
        arg1.pitch_offset = v47_6_2
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
          local v40_5_2 = v40_5
          v40_5_2 = v40_5_2 and 0
          v40_5_2 = v40_5_2 or v3
          yaw_offset = yaw_offset + v40_5_2
          arg1.yaw_offset = yaw_offset
        end
        return
      end
      if v2 == "center" then
        if not arg2.delay_affect_modifier:get() then
          local v4 = bit.band(v48_4, 1)
          v4 = bit.band(v48_4, 1) ~= 0
          local yaw_offset_2 = arg1.yaw_offset
          local v6 = v4
          v6 = v6 and v3 * 0.5
          if not v6 then
            v6 = -v3
            v6 = v6 * 0.5
          end
          yaw_offset_2 = yaw_offset_2 + v6
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
      local v2 = arg2.yaw:get()
      local v3 = arg2.yaw_speed:get()
      local v4 = arg2.yaw_offset:get()
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
      v51_2(arg2)
      if v2 == "static" then
        arg1.yaw = "180"
        arg1.yaw_offset = v4
      end
      if v2 == "spin" then
        do
          local prod = v4 * 0.5
          local sum = 180 + v13_2.lerp(-prod, prod, globals.curtime() * v3 * 0.1 % 1)
        end
        arg1.yaw = "180"
        arg1.yaw_offset = sum
      end
      if v2 == "random" then
        do
          local abs = math.abs(v4 * 0.5)
          local sum_2 = 180 + v13_2.random_int(-abs, abs)
        end
        arg1.yaw = "180"
        arg1.yaw_offset = sum_2
      end
      if v2 == "left/right" then
        arg1.yaw = "180"
        arg1.yaw_offset = 0
        arg1.yaw_left = arg1.yaw_left + arg2.yaw_left:get()
        arg1.yaw_right = arg1.yaw_right + arg2.yaw_right:get()
      end
      if v2 == "side-based" then
        arg1.yaw = "180"
        arg1.yaw_offset = 0
        arg1.yaw_left = arg1.yaw_left - 90 + v13_2.random_int(-v4, v4)
        arg1.yaw_right = arg1.yaw_right + 90 + v13_2.random_int(-v4, v4)
      end
      v53_2(arg1, arg2)
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
      if arg3.force_break_lc ~= nil then
        arg2.force_defensive = arg3.force_break_lc:get()
      end
      do
        local is_double_tap_active = v14_2.is_double_tap_active()
        if not is_double_tap_active then
          is_double_tap_active = v14_2
          is_double_tap_active = is_double_tap_active.is_on_shot_antiaim_active
          is_double_tap_active = is_double_tap_active()
        end
        local is_duck_peek_assist = v14_2.is_duck_peek_assist()
      end
      if is_double_tap_active and not is_duck_peek_assist then
        do
          local v7 = v24_5.get().defensive.left
          v7 = v24_5.get().defensive.left > 0
        end
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
      do
        local v2 = arg1.body_yaw
        v2 = v1 == "jitter"
        v2 = v2 or v1 == "random"
        v2 = v2 or v1 == "min/max"
      end
      if v2 then
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
      do
        local v2 = arg1.body_yaw
        v2 = v1 == "jitter"
        v2 = v2 or v1 == "random"
        v2 = v2 or v1 == "min/max"
      end
      if v2 then
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
      local L0_104, L1_105, L2_106, L3_107, L4_108, L5_109, L6_110, L7_111, L8_112, L9_113, L10_114, L11_115, L12_116, L13_117, L14_118, L15_119, L16_120, L17_121, L18_122, L19_123, L20_124, L21_125, L22_126, L23_127, L24_128
      L20_124 = nil
      v50_4 = L20_124
      L20_124 = nil
      v51_4 = L20_124
      L20_124 = nil
      v52_4 = L20_124
      L20_124 = nil
      v53_4 = L20_124
      return
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
      return false
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
      return "air"
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
      return false
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
              local vec_2 = vector(client.eye_position())
              local sum = vec_2 + vector():init_from_angles(vector(client.camera_angles()):unpack()) * 128
              local trace_line = client.trace_line(me, vec_2.x, vec_2.y, vec_2.z, sum.x, sum.y, sum.z)
              if client.trace_line(me, vec_2.x, vec_2.y, vec_2.z, sum.x, sum.y, sum.z) ~= 1 then
                if trace_line == -1 then
                  return true
                end
                local classname = entity.get_classname(trace_line)
                if classname == "CWorld" then
                  return true
                end
                if classname == "CFuncBrush" then
                  return true
                end
                if classname == "CCSPlayer" then
                  return true
                end
                if classname == "CHostage" and 7056 > vec_2:distsqr((vector(entity.get_origin(trace_line)))) then
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
      return
    end
    function v51_7.get()
      local L0_129, L1_130, L2_131, L3_132, L4_133, L5_134
      L0_129 = v53_6
      return L0_129
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
      do
        local v8 = not v23_5.is_moving
        if not v8 then
          v8 = v23_5
          v8 = v8.is_crouched
        end
      end
      if v8 and v6 >= 10 and v7 > 1000000 then
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
        v6 = v6 and 45
        v6 = v6 or 60
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
      local trace_bullet = client.trace_bullet(arg1, vec.x, vec.y, vec.z, vec_3.x, vec_3.y, vec_3.z, false)
      if client.trace_bullet(arg1, vec.x, vec.y, vec.z, vec_3.x, vec_3.y, vec_3.z, false) ~= arg2 then
        trace_bullet = 0
      end
      if trace_bullet ~= nil and health <= trace_bullet then
        return true
      end
      local extrapolate = v13_2.extrapolate(vec, vec_2, 16)
      local trace_bullet_2 = client.trace_bullet(arg1, extrapolate.x, extrapolate.y, extrapolate.z, vec_3.x, vec_3.y, vec_3.z, false)
      if client.trace_bullet(arg1, extrapolate.x, extrapolate.y, extrapolate.z, vec_3.x, vec_3.y, vec_3.z, false) ~= arg2 then
        trace_bullet_2 = 0
      end
      if trace_bullet_2 ~= nil and health <= trace_bullet_2 then
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
      local trace_bullet = client.trace_bullet(arg1, vec.x, vec.y, vec.z, vec_3.x, vec_3.y, vec_3.z, false)
      if client.trace_bullet(arg1, vec.x, vec.y, vec.z, vec_3.x, vec_3.y, vec_3.z, false) ~= arg2 then
        trace_bullet = 0
      end
      if trace_bullet ~= nil and health <= trace_bullet then
        return true
      end
      local extrapolate = v13_2.extrapolate(vec, vec_2, 32)
      local trace_bullet_2 = client.trace_bullet(arg1, extrapolate.x, extrapolate.y, extrapolate.z, vec_3.x, vec_3.y, vec_3.z, false)
      if client.trace_bullet(arg1, extrapolate.x, extrapolate.y, extrapolate.z, vec_3.x, vec_3.y, vec_3.z, false) ~= arg2 then
        trace_bullet_2 = 0
      end
      if trace_bullet_2 ~= nil and health <= trace_bullet_2 then
        return true
      end
      return false
    end
    local v65 = function(arg1, arg2)
      local v2 = entity.get_prop(arg1, "m_iTeamNum")
      v2 = entity.get_prop(arg1, "m_iTeamNum") == 3
      local v56_5_2 = v56_5((entity.get_player_weapon(arg1)))
      local is_onground = v23_5.is_onground
      if is_onground then
        is_onground = v23_5
        is_onground = is_onground.is_moving
        is_onground = not is_onground
      end
      if is_onground then
        is_onground = v23_5
        is_onground = is_onground.is_crouched
        is_onground = not is_onground
      end
      local v59_3_2 = v59_3(arg1, arg2)
      if not v56_5_2 or v23_5.is_onground or not v23_5.is_crouched then
        do
          local v7 = is_onground
          if v7 then
            v7 = v2
            v7 = v7 and -6
            v7 = v7 or 20
            v7 = v59_3_2 >= v7
          end
          if not v7 then
            v7 = v23_5
            v7 = v7.is_crouched
            if v7 then
              v7 = v23_5
              v7 = v7.is_onground
            end
            if v7 then
              v7 = v2
              v7 = v7 and -20
              v7 = v7 or -4
              v7 = v59_3_2 >= v7
            end
          end
          local v61_2 = v61(arg2)
          local v10 = not v62(arg2)
          v10 = v10 and v61_2 > 75
          if not v10 then
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
      local v7_2 = v2
      v7_2 = v7_2 and -35
      v7_2 = v7_2 or -20
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
          do
            local is_onground = v23_5.is_onground
            if is_onground then
              is_onground = v23_5
              is_onground = is_onground.is_moving
              is_onground = not is_onground
            end
            if is_onground then
              is_onground = v23_5
              is_onground = is_onground.is_crouched
              is_onground = not is_onground
            end
          end
          if not is_onground then
            if v23_5.is_onground then
              if not v6 then
                if not v5 then
                  local v11 = v8
                  v11 = v11 and 38
                  if not v11 then
                    v11 = v7
                    v11 = v11 and 20
                  end
                  v11 = v11 or 32
                  return v11
                end
                local v11_2 = v8
                v11_2 = v11_2 and 30
                if not v11_2 then
                  v11_2 = v7
                  v11_2 = v11_2 and 20
                end
                v11_2 = v11_2 or 30
                return v11_2
              end
              if not v9 then
                local v11_3 = v8
                v11_3 = v11_3 and 38
                if not v11_3 then
                  v11_3 = v7
                  v11_3 = v11_3 and 14
                end
                v11_3 = v11_3 or 26
                return v11_3
              end
              local v11_4 = v8
              v11_4 = v11_4 and 33
              if not v11_4 then
                v11_4 = v7
                v11_4 = v11_4 and 20
              end
              v11_4 = v11_4 or 20
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
      return "air-crouching"
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
      local vector_2 = vector
      return vector_2((vector(entity.get_origin(arg2)) - vector(entity.get_origin(arg1))):angles())
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
      local sum = vec + vector():init_from_angles(0, v61_3_2.y + 90) * 31
      local sum_2 = vec + vector():init_from_angles(0, v61_3_2.y - 90) * 31
      local trace_bullet = client.trace_bullet(me, sum.x, sum.y, sum.z, vec_2.x, vec_2.y, vec_2.z, false)
      local trace_bullet_2, trace_bullet_3 = client.trace_bullet(me, sum_2.x, sum_2.y, sum_2.z, vec_2.x, vec_2.y, vec_2.z, false)
      if client.trace_bullet(me, sum.x, sum.y, sum.z, vec_2.x, vec_2.y, vec_2.z, false) ~= current_threat then
        trace_bullet = 0
      end
      if trace_bullet_2 ~= current_threat then
        trace_bullet_3 = 0
      end
      do
        local v13 = sum_2.x
        v13 = trace_bullet > 0
        v13 = v13 or trace_bullet_3 > 0
        v13 = v13 and trace_bullet ~= trace_bullet_3
      end
      if v13 then
        local v14 = sum_2.y
        v14 = trace_bullet > trace_bullet_3
        v14 = v14 and -1
        v14 = v14 or 1
        v58_7 = v14
      end
      return
    end
    function v56_7.update(arg1, arg2)
      if defensive_flick.enabled:get() then
        if v60_4() then
          v62_3(arg2)
          do
            local v2 = v58_7
            v2 = v58_7 == -1
            do
              local v4 = v24_5.get().defensive.left
              v4 = v24_5.get().defensive.left ~= 0
              do
                local v5 = arg2.command_number % 7
                v5 = arg2.command_number % 7 == 0
                arg2.force_defensive = v5
              end
              do
                local v5_2 = v4
                v5_2 = v5_2 and "Custom"
                v5_2 = v5_2 or "Default"
                v45_8.pitch = v5_2
                v45_8.pitch_offset = 0
                v45_8.yaw_base = "At targets"
                v45_8.yaw = "180"
              end
              do
                local v5_3 = v4
                v5_3 = v5_3 and 90
                v5_3 = v5_3 or 0
                v45_8.yaw_offset = v5_3
                v45_8.yaw_left = 0
                v45_8.yaw_right = 0
                v45_8.yaw_jitter = "Off"
                v45_8.jitter_offset = 0
                v45_8.body_yaw = "Static"
              end
              local v5_4 = v4
              v5_4 = v5_4 and -1
              v5_4 = v5_4 or 1
              v45_8.body_yaw_offset = v5_4
            end
            v45_8.freestanding_body_yaw = false
            v45_8.edge_yaw = false
            v45_8.freestanding = false
            v45_8.roll = 0
          end
          if v2 then
            v45_8.yaw_offset = -v45_8.yaw_offset
          end
          return
        end
        return false
      end
      return false
    end
  end
  local v57_6 = function()
    local defensive = v45_8.defensive
    local defensive_2 = v24_5.get().defensive
    do
      local v3
      v3 = defensive ~= nil
      if v3 then
        v3 = defensive_2.left
        v3 = v3 > 0
      end
    end
    if v3 then
      v45_8:copy(defensive)
      return true
    end
    return false
  end
  local v58_8 = function(arg1)
    if v24_5.get().shift then
      do
        local max = math.max
        local v2 = 1
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
    if v45_8.body_yaw == "Random" then
      v1 = v13_2.random_int(0, 1) == 0
    end
    if v45_8.invert_chance ~= nil and v45_8.invert_chance < v13_2.random_int(0, 100) then
      v1 = false
    end
    v39_6 = v39_6 + 1
    if v1 then
      v40_5 = not v40_5
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
      local skitter = "Skitter"
      local floor = math.floor(math.sin(globals.tickcount() * 0.25) * v45_8.jitter_offset)
      if 2 < globals.realtime() % 4 then
        skitter = "Offset"
      end
      v45_8.yaw_jitter = skitter
      v45_8.jitter_offset = floor
    end
    if v45_8.yaw_jitter == "Angelic" then
      local v0_2 = {}
      ;({})[1] = "Offset"
      ;({})[2] = "Random"
      ;({})[3] = "Skitter"
      ;({})[4] = "Center"
      local jitter_offset = v45_8.jitter_offset
      if 0.15 < globals.realtime() - v42_5 then
        v42_5 = globals.realtime()
        v41_4 = v0_2[math.random(1, #v0_2)]
      end
      v45_8.yaw_jitter = v41_4
      v45_8.jitter_offset = math.floor(math.sin(globals.tickcount() * 0.2) * jitter_offset)
    end
    if v45_8.yaw_jitter == "Offset" then
      local yaw_offset = v45_8.yaw_offset
      yaw_offset = yaw_offset or 0
      local jitter_offset_2 = v45_8.jitter_offset
      v45_8.yaw_jitter = "Off"
      v45_8.jitter_offset = 0
      do
        local v40_5_2 = v40_5
        v40_5_2 = v40_5_2 and jitter_offset_2
        v40_5_2 = v40_5_2 or 0
        v40_5_2 = yaw_offset + v40_5_2
        v45_8.yaw_offset = v40_5_2
      end
      return
    end
    if v45_8.yaw_jitter == "Center" then
      local yaw_offset_2 = v45_8.yaw_offset
      yaw_offset_2 = yaw_offset_2 or 0
      local jitter_offset_3 = v45_8.jitter_offset
      if not v40_5 then
        jitter_offset_3 = -jitter_offset_3
      end
      v45_8.yaw_jitter = "Off"
      v45_8.jitter_offset = 0
      v45_8.yaw_offset = yaw_offset_2 + jitter_offset_3 / 2
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
      local prod = globals.curtime() * 3
      local yaw_offset_4 = v45_8.yaw_offset
      yaw_offset_4 = yaw_offset_4 or 0
      local jitter_offset_4 = v45_8.jitter_offset
      v45_8.yaw_jitter = "Off"
      v45_8.jitter_offset = 0
      v45_8.yaw_offset = yaw_offset_4 + v13_2.lerp(-jitter_offset_4, jitter_offset_4, prod % 1)
      return
    end
    if v45_8.yaw_jitter == "5-way" then
      local yaw_offset_5 = v45_8.yaw_offset
      yaw_offset_5 = yaw_offset_5 or 0
      local jitter_offset_5 = v45_8.jitter_offset
      v45_8.yaw_jitter = "Off"
      v45_8.jitter_offset = 0
      local rem = v39_6 % 5
      if v45_8.ways == nil then
        v45_8.yaw_offset = yaw_offset_5 + v13_2.lerp(-jitter_offset_5, jitter_offset_5, rem / 4)
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
      local v40_5_2 = v40_5
      v40_5_2 = v40_5_2 and body_yaw_offset
      v40_5_2 = v40_5_2 or -body_yaw_offset
      v45_8.body_yaw_offset = v40_5_2
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
    local defensive = v24_5.get().defensive
    do
      local v8
      v8 = csgo_weapons_2.type == "grenade"
      local v9
      v9 = idx == 64
      local force_defensive = arg1.force_defensive
      force_defensive = force_defensive and not v8
      force_defensive = force_defensive and not v9
      defensive.force = force_defensive
    end
    return
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
  client.set_event_callback("shutdown", function()
    v45_8:clear()
    v45_8:unset()
    return
  end)
  client.set_event_callback("setup_command", v66_2)
end
do
  local aim_tools = v29_4.ragebot.aim_tools
  local v40_6 = {}
  do
    local v41_5 = {}
    function v40_6.set(arg1, arg2, ...)
      if v41_5[arg1] == nil then
        v41_5[arg1] = {}
      end
      if v41_5[arg1][arg2] == nil then
        v41_5[arg1][arg2] = {
          plist.get(arg1, arg2)
        }
      end
      plist.set(arg1, arg2, ...)
      return
    end
    function v40_6.unset(arg1, arg2)
      local v2 = v41_5[arg1]
      if v2 == nil then
        return
      end
      local v3 = v2[arg2]
      if v3 == nil then
        return
      end
      plist.set(arg1, arg2, unpack(v3))
      v2[arg2] = nil
      return
    end
    function v40_6.override(arg1, arg2, ...)
      if (...) == nil then
        v40_6.unset(arg1, arg2)
      else
        v40_6.set(arg1, arg2, ...)
      end
      return
    end
  end
  local v41_6 = {}
  local v42_6 = function()
    local L0_135, L1_136, L2_137, L3_138, L4_139, L5_140, L6_141, L7_142, L8_143, L9_144, L10_145, L11_146, L12_147, L13_148, L14_149, L15_150, L16_151, L17_152, L18_153, L19_154, L20_155, L21_156, L22_157, L23_158, L24_159
    L0_135 = {}
    L0_135.misses = 0
    L0_135.hit_chance = nil
    L0_135.multipoints = nil
    L0_135.prefer_body = false
    L0_135.force_safe = false
    L1_136 = L0_135
    return L1_136
  end
  local v43_5 = function(arg1)
    return v41_6[arg1]
  end
  local v44_8 = function(arg1)
    local v43_5_2 = v43_5(arg1)
    if v43_5_2 == nil then
      v43_5_2 = v42_6()
      v41_6[arg1] = v43_5_2
    end
    return v43_5_2
  end
  local v45_9 = function(arg1)
    v41_6[arg1] = nil
    return
  end
  local v46_4 = function()
    local L0_160, L1_161, L2_162, L3_163
    for L3_163, _FORV_4_ in L0_160(L1_161) do
      _FORV_4_ = v45_9
      _FORV_4_(L3_163)
    end
    return
  end
  local v47_8 = function(arg1)
    if arg1 == 1 then
      return 4
    end
    if arg1 == 3 then
      return 1.25
    end
    if arg1 == 6 then
      return 0.75
    end
    if arg1 == 7 then
      return 0.75
    end
    return 1
  end
  local v48_6 = function(arg1, arg2, arg3, arg4)
    arg2 = arg2 * v47_8(arg3)
    local has_helmet = entity.get_prop(arg1, "m_bHasHelmet")
    if 0 < entity.get_prop(arg1, "m_ArmorValue") then
      if arg3 == 1 then
        if has_helmet ~= 0 then
          arg2 = arg2 * arg4 * 0.5
        end
      else
        arg2 = arg2 * arg4 * 0.5
      end
    end
    return arg2
  end
  local v49_6 = function(arg1, arg2, arg3, arg4, arg5)
    local csgo_weapons_2 = csgo_weapons(arg5)
    local armor_ratio = csgo_weapons_2.armor_ratio
    return (v48_6(arg3, csgo_weapons_2.damage * math.pow(csgo_weapons_2.range_modifier, math.min(csgo_weapons_2.range, (arg2 - arg1):length()) * 0.002), arg4, armor_ratio))
  end
  local v50_6 = function(arg1, arg2)
    local v4 = vector(entity.get_origin(arg1)).z - vector(entity.get_origin(arg2)).z
    v4 = 53 < vector(entity.get_origin(arg1)).z - vector(entity.get_origin(arg2)).z
    return v4
  end
  local v51_8 = function(arg1, arg2)
    local v4 = vector(entity.get_origin(arg2)).z - vector(entity.get_origin(arg1)).z
    v4 = 53 < vector(entity.get_origin(arg2)).z - vector(entity.get_origin(arg1)).z
    return v4
  end
  local v52_8 = function(arg1, arg2, arg3, arg4, arg5)
    local v7 = arg3
    v7 = v49_6(arg1, arg2, arg3, arg4, arg5) >= entity.get_prop(arg3, "m_iHealth")
    return v7
  end
  local v53_8 = function(arg1)
    local csgo_weapons_2 = csgo_weapons(arg1)
    if csgo_weapons_2 == nil then
      return nil
    end
    local idx = csgo_weapons_2.idx
    local type_2 = csgo_weapons_2.type
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
      if idx == 9 then
        return "awp"
      end
      if idx == 40 then
        return "scout"
      end
      return "auto"
    end
    return
  end
  local v54_6 = function(arg1, arg2, arg3, arg4)
    local v44_8_2 = v44_8(arg4)
    local vec = vector(client.eye_position())
    local vec_2 = vector(entity.hitbox_position(arg4, 5))
    local v7 = arg1.body_aim:get("higher than you")
    if v7 then
      v7 = v50_6
      v7 = v7(arg4, arg2)
    end
    if not v7 then
      v7 = arg1.body_aim
      v7 = v7.get
      v7 = v7(v7, "lower than you")
      if v7 then
        v7 = v51_8
        v7 = v7(arg4, arg2)
      end
    end
    if not v7 then
      v7 = arg1.body_aim
      v7 = v7.get
      v7 = v7(v7, "lethal")
      if v7 then
        v7 = v52_8
        v7 = v7(vec, vec_2, arg4, 3, arg3)
      end
    end
    if not v7 then
      v7 = arg1.body_aim
      v7 = v7.get
      v7 = v7(v7, "after x misses")
      if v7 then
        v7 = v44_8_2.misses
        v7 = v7 > arg1.body_misses:get()
      end
    end
    if not v7 then
      v7 = arg1.body_aim
      v7 = v7.get
      v7 = v7(v7, "hp lower than x")
      if v7 then
        v7 = entity
        v7 = v7.get_prop
        v7 = v7(arg4, "m_iHealth")
        v7 = v7 < arg1.body_hp:get()
      end
    end
    return v7
  end
  local v55_8 = function(arg1, arg2, arg3, arg4)
    local v44_8_2 = v44_8(arg4)
    local vec = vector(client.eye_position())
    local vec_2 = vector(entity.hitbox_position(arg4, 5))
    local v7 = arg1.safe_point:get("higher than you")
    if v7 then
      v7 = v50_6
      v7 = v7(arg4, arg2)
    end
    if not v7 then
      v7 = arg1.safe_point
      v7 = v7.get
      v7 = v7(v7, "lower than you")
      if v7 then
        v7 = v51_8
        v7 = v7(arg4, arg2)
      end
    end
    if not v7 then
      v7 = arg1.safe_point
      v7 = v7.get
      v7 = v7(v7, "lethal")
      if v7 then
        v7 = v52_8
        v7 = v7(vec, vec_2, arg4, 3, arg3)
      end
    end
    if not v7 then
      v7 = arg1.safe_point
      v7 = v7.get
      v7 = v7(v7, "after x misses")
      if v7 then
        v7 = v44_8_2.misses
        v7 = v7 > arg1.safe_misses:get()
      end
    end
    if not v7 then
      v7 = arg1.safe_point
      v7 = v7.get
      v7 = v7(v7, "hp lower than x")
      if v7 then
        v7 = entity
        v7 = v7.get_prop
        v7 = v7(arg4, "m_iHealth")
        v7 = v7 < arg1.safe_hp:get()
      end
    end
    return v7
  end
  local v56_8 = function()
    local players = entity.get_players(true)
    for _FORV_4_ = 1, #players do
      local v5 = players[_FORV_4_]
      v40_6.unset(v5, "Override prefer body aim")
      v40_6.unset(v5, "Override safe point")
      v45_9(v5)
    end
    return
  end
  local v57_7 = function()
    local me = entity.get_local_player()
    if me == nil then
      return false
    end
    local player_weapon = entity.get_player_weapon(me)
    if player_weapon == nil then
      return false
    end
    local v53_8_2 = v53_8(player_weapon)
    if v53_8_2 == nil then
      return false
    end
    local v3 = aim_tools[v53_8_2]
    if v3 == nil then
      return false
    end
    local players = entity.get_players(true)
    for _FORV_8_ = 1, #players do
      local v9 = players[_FORV_8_]
      local v44_8_2 = v44_8(v9)
      local v54_6_2 = v54_6(v3, me, player_weapon, v9)
      local v55_8_2 = v55_8(v3, me, player_weapon, v9)
      do
        local override = v40_6.override
        local v14 = v9
        local override_prefer_body_aim = "Override prefer body aim"
        local v16 = v54_6_2
        v16 = v16 and "Force"
        v16 = v16 or nil
        override(v14, override_prefer_body_aim, v16)
      end
      local override_2 = v40_6.override
      local v14_2 = v9
      local override_safe_point = "Override safe point"
      local v16_2 = v55_8_2
      v16_2 = v16_2 and "On"
      v16_2 = v16_2 or nil
      override_2(v14_2, override_safe_point, v16_2)
      v44_8_2.prefer_body = v54_6_2
      v44_8_2.force_safe = v55_8_2
    end
    return true
  end
  local v58_9 = function(arg1, arg2)
    local v43_5_2 = v43_5(arg1)
    if v43_5_2 == nil then
      return
    end
    local v3 = {}
    if v43_5_2.prefer_body then
      table.insert(v3, "BODY")
    end
    if v43_5_2.force_safe then
      table.insert(v3, "SAFE")
    end
    if next(v3) == nil then
      return
    end
    local bounding_box, bounding_box_2, bounding_box_3, bounding_box_4 = entity.get_bounding_box(arg1)
    if bounding_box == nil then
      return
    end
    local v37_5_2 = v37_5("")
    local concat = table.concat(v3, " + ")
    local vec = vector(renderer.measure_text(v37_5_2, concat))
    do
      local diff = bounding_box_2 - 12 * arg2
      diff = diff - vec.y
      renderer.text((bounding_box + bounding_box_3) / 2 - vec.x * 0.5, diff, 255, 255, 255, 200 * bounding_box_4, v37_5_2, nil, concat)
    end
    return
  end
  local v59_7 = function()
    v56_8()
    return
  end
  local v60_6 = function()
    local dpi = v14_2.get_dpi()
    local players = entity.get_players(true)
    for _FORV_5_ = 1, #players do
      v58_9(players[_FORV_5_], dpi)
    end
    return
  end
  local v61_5 = function()
    if not v57_7() then
      v56_8()
      return
    end
    return
  end
  local v62_5 = function(arg1)
    local target = arg1.target
    if target == nil then
      return
    end
    local v44_8_2 = v44_8(target)
    v44_8_2.misses = v44_8_2.misses + 1
    return
  end
  local v63_4 = function(arg1)
    local me = entity.get_local_player()
    local userid_to_entindex = client.userid_to_entindex(arg1.userid)
    if me == client.userid_to_entindex(arg1.attacker) and me ~= userid_to_entindex then
      v45_9(userid_to_entindex)
      return
    end
    return
  end
  local v64_4 = function(arg1)
    local userid_to_entindex = client.userid_to_entindex(arg1.userid)
    if userid_to_entindex == nil then
      return
    end
    v45_9(userid_to_entindex)
    return
  end
  local v65_2 = function(arg1)
    v13_2.event_callback("paint_ui", v60_6, arg1:get())
    return
  end
  aim_tools.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      aim_tools.esp_flag:unset_callback(v65_2)
    else
      aim_tools.esp_flag:set_callback(v65_2, true)
    end
    if not v1 then
      v46_4()
      v56_8()
      v13_2.event_callback("paint_ui", v60_6, false)
    end
    v13_2.event_callback("shutdown", v59_7, v1)
    v13_2.event_callback("run_command", v61_5, v1)
    v13_2.event_callback("aim_miss", v62_5, v1)
    v13_2.event_callback("player_death", v63_4, v1)
    v13_2.event_callback("player_spawn", v64_4, v1)
    return
  end, true)
end
do
  local aimbot_logs = v29_4.ragebot.aimbot_logs
  local v40_7 = v12.name:sub(1, 1):upper()
  local v41_7 = v12.name:lower()
  local v42_7 = {}
  local v43_6 = {}
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
  end
  local v45_10 = {}
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
  end
  local event_bus_3 = v20_4.get_event_bus()
  local v47_9 = function(arg1, arg2, arg3, arg4, arg5)
    if aimbot_logs.show_on_screen:get() then
      local sum = #v43_6 + 1
      v43_6[sum] = {
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
    local L0_164, L2_165, L4_166, L5_167, L6_168, L7_169, L8_170, L9_171, L10_172, L11_173, L12_174, L13_175, L14_176, L15_177, L16_178, L17_179, L18_180, L19_181, L20_182, L21_183, L22_184, L23_185, L24_186, L25_187, L26_188, L28_189, L29_190, L30_191, L31_192, L32_193
    for L5_167 = 1, #L2_165 do
      L30_191 = v43_6
      L30_191[L5_167] = nil
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
    local len = #v43_6
    local ratio = vector(client.screen_size()) / 2
    ratio.y = ratio.y + aimbot_logs.offset:get() * 5
    local v51_9_2 = v51_9((aimbot_logs.logo:get()))
    local v37_5_2 = v37_5("b")
    local vec = vector(renderer.measure_text(v37_5_2, v51_9_2))
    do
      local v12 = renderer.measure_text(v37_5_2, v51_9_2)
      v12 = v51_9_2 == "!"
      local v13 = renderer.measure_text(v37_5_2, v51_9_2)
      v13 = v51_9_2 ~= nil
      v13 = v13 and not v12
      for _FORV_17_ = len, 1, -1 do
        local v18 = v43_6[_FORV_17_]
        do
          local v19 = v18.time
          v19 = v18.time > 0
          if v19 then
            v19 = len - _FORV_17_
            v19 = v19 < 6
          end
          v18.alpha = v32_5.interp(v18.alpha, v19, 0.075)
        end
        if not v19 then
          if 0 >= v18.alpha then
            table.remove(v43_6, _FORV_17_)
          end
        else
          v18.time = v18.time - frametime
        end
      end
      local v37_5_3 = v37_5("")
      for _FORV_18_ = 1, #v43_6 do
        local v19_2 = v43_6[_FORV_18_]
        local unpack_2, unpack_3, unpack_4, unpack_5 = unpack(v19_2.color)
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
        ratio.y = ratio.y - math.round((sum.y + 5) * alpha)
      end
    end
    return
  end
  local v55_9 = function(arg1)
    local v1 = v42_7[arg1.id]
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
      local v14 = damage_2 - damage
      v14 = damage_2 - damage > 10
      local v15
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
        do
          local v17 = table.concat(v18, "  ")
          v16 = v49_7(v16, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")
          local v17_2 = v49_7(v17, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")
        end
      end
      v47_9(v3, v4, v5, v6, v16)
      v48_7(255, 255, 255, v17_2)
    end
    return
  end
  local v56_9 = function(arg1)
    local v1 = v42_7[arg1.id]
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
        do
          local v13 = table.concat(v14, "  ")
          v12 = v49_7(v12, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")
          local v13_3 = v49_7(v13, v13_2.to_hex(v3, v4, v5, v6), "c8c8c8ff")
        end
      end
      v47_9(v3, v4, v5, v6, v12)
      v48_7(200, 200, 200, v13_3)
    end
    return
  end
  local v57_8 = function(arg1)
    local diff = globals.tickcount() - arg1.tick
    local id = arg1.id
    local v4 = {}
    v4.aim = arg1
    do
      local v5
      v5 = plist.get(arg1.target, "Override safe point") == "On"
      v4.safe = v5
    end
    v4.history = diff
    v42_7[id] = v4
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
          do
            local v14 = table.concat(v15, "  ")
            v13 = v49_7(v13, v13_2.to_hex(v6, v7, v8, v9), "c8c8c8ff")
            local v14_2 = v49_7(v14, v13_2.to_hex(v6, v7, v8, v9), "c8c8c8ff")
          end
        end
        v47_9(v6, v7, v8, v9, v13)
        v48_7(255, 255, 255, v14_2)
      end
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
      v4 = v49_7
      v4 = v4(table.concat(v4, "  "), v13_2.to_hex(176, 198, 255, 255), "c8c8c8ff")
      v4 = v48_7
      v4(255, 255, 255, v4)
    end
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
do
  local angelic_tap_2 = v29_4.ragebot.angelic_tap
  local v40_8 = ffi.new("char[?]", 29)
  local v41_8 = ffi.new("char[?]", 29)
  local cast_2 = ffi.cast("uint8_t*", 1127923787)
  ffi.copy(v40_8, cast_2, 29)
  ffi.copy(v41_8, cast_2, 29)
  ffi.fill(v41_8, 24, 144)
  do
    local v109_6 = 24
    v41_8[v109_6] = 233
  end
  local v43_7 = function(arg1)
    local copy = ffi.copy
    local cast_2_2 = cast_2
    local v3 = arg1
    v3 = v3 and v41_8
    v3 = v3 or v40_8
    copy(cast_2_2, v3, 29)
    return
  end
  local v44_10 = function()
    v43_7(false)
    return
  end
  angelic_tap_2.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    v43_7(v1)
    v13_2.event_callback("shutdown", v44_10, v1)
    return
  end, true)
end
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
    local v44_11_2 = v44_11
    return v44_11_2((v43_8(arg3, (v42_8(arg1, arg2)))))
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
    local v49_8 = {}
    ;({})[1] = 0
    ;({})[2] = 5
    ;({})[3] = 2
    ;({})[4] = 15
    ;({})[5] = 17
    ;({})[6] = 9
    ;({})[7] = 10
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
      local v4 = {}
      ;({})[1] = "Head"
      ;({})[2] = "Arms"
      ;({})[3] = "Legs"
      ;({})[4] = "Feet"
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
      local v9 = arg2
      v9 = v9 and arg2 - arg6
      v9 = v9 or arg1
      do
        local extend_vector = v13_2.extend_vector
        local v11 = v9
        local v12
        v12 = arg5 == 0
        v12 = v12 and 0
        v12 = v12 or arg4
        local extend_vector_2 = extend_vector(v11, v12, arg3)
      end
      local end_pos = trace.hull(v9, v9 + vector(0, 0, arg9), arg7, arg8, {skip = v60_8, mask = 33636363}).end_pos
      local end_pos_2 = trace.hull(vector(v9.x, v9.y, end_pos.z), vector(extend_vector_2.x, extend_vector_2.y, end_pos.z), arg7, arg8, {skip = v60_8, mask = 33636363}).end_pos
      if extend_vector_2:dist2d(end_pos_2) >= arg4 * 0.97 then
        return false
      end
      return trace.hull(end_pos_2, vector(end_pos_2.x, end_pos_2.y, arg1.z - 240), arg7, arg8, {skip = v60_8, mask = 33636363}).end_pos + arg6
    end
    local v62_6 = function(arg1, arg2, arg3, arg4, arg5)
      local vec = vector(entity.get_prop(arg1, "m_vecViewOffset"))
      local vec_2 = vector(entity.get_prop(arg1, "m_vecMins"))
      local vec_3 = vector(entity.get_prop(arg1, "m_vecMaxs"))
      v57_9.pos[0] = v61_6(arg2, nil, 0, arg5, 0, vec, vec_2, vec_3, arg5)
      for _FORV_11_ = 1, arg4 do
        local v12 = _FORV_11_ % 2
        v12 = _FORV_11_ % 2 == 0
        v12 = v12 and arg3 - 90
        v12 = v12 or arg3 + 90
        do
          local pos = v57_9.pos
          local v14 = 0
          v14 = _FORV_11_ <= 2
          v14 = v14 and 0
          v14 = v14 or _FORV_11_ - 2
          local v13 = pos[v14]
        end
        if v13 then
          local v61_6_2 = v61_6(arg2, v13, v12, arg5, _FORV_11_, vec, vec_2, vec_3, arg5)
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
      local next_primary_attack = entity.get_prop(arg2, "m_flNextPrimaryAttack")
      do
        local max = math.max
        local v6, v5 = entity.get_prop(arg1, "m_flNextAttack"), 0
        local v6
        v6 = v6 or 0
        local v7 = next_primary_attack
        v7 = v7 or 0
        max = max(v5, v6, v7)
        v5 = globals
        v5 = v5.curtime
        v5 = v5()
      end
      if not (max > v5) and not (0 >= entity.get_prop(arg2, "m_iClip1")) then
        return true
      end
      return false
    end
    local v64_5 = {}
    ;({})[1] = "CWeaponSSG08"
    ;({})[2] = "CWeaponAWP"
    ;({})[3] = "CWeaponG3SG1"
    ;({})[4] = "CWeaponSCAR20"
    local v65_3 = function(arg1, arg2)
      if arg2 then
        local player_weapon = entity.get_player_weapon(arg1)
        if v63_5(arg1, player_weapon) then
          if not ui.get(v14_2.ragebot.aimbot.automatic_scope) and v11(v64_5, entity.get_classname(player_weapon)) and entity.get_prop(arg1, "m_bIsScoped") ~= 1 then
            return false
          end
          local v3 = v24_5.get()
          do
            local is_double_tap_active = v14_2.is_double_tap_active()
            if not is_double_tap_active then
              is_double_tap_active = v14_2
              is_double_tap_active = is_double_tap_active.is_on_shot_antiaim_active
              is_double_tap_active = is_double_tap_active()
            end
          end
          if not is_double_tap_active or v3.shift then
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
      local v6, health = v14_2.is_override_minimum_damage(), entity.get_prop(arg3, "m_iHealth")
      do
        local v6 = arg3
        if v6 then
          v6 = v14_2
          v6 = v6.get_override_damage
          v6 = v6()
        end
        if not v6 then
          v6 = v14_2
          v6 = v6.get_minimum_damage
          v6 = v6()
        end
        for _FORV_10_ = 1, #arg1 do
          local v11 = arg1[_FORV_10_]
          if v11 then
            for _FORV_15_ = 1, #arg4 do
              local v16 = arg4[_FORV_15_]
              local vec = vector(entity.hitbox_position(arg3, v16))
              do
                local trace_bullet = client.trace_bullet
                do
                  local v19 = arg2
                  local x = v11.x
                  local y = v11.y
                  local z = v11.z
                  local x_2 = vec.x
                  local y_2 = vec.y
                  local z_2 = vec.z
                  local v26 = entity.hitbox_position(arg3, v16)
                  v26 = v16 == 0
                  local trace_bullet_2 = trace_bullet(v19, x, y, z, x_2, y_2, z_2, v26)
                end
                if v16 == 0 then
                  trace_bullet_2 = trace_bullet_2 * 4
                end
              end
              if trace_bullet_2 >= math.min(v6, health) and trace_bullet_2 > 0 then
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
    local v69 = {}
    ;({})[1] = {1, 2}
    ;({})[2] = {2, 3}
    ;({})[3] = {3, 4}
    ;({})[4] = {4, 1}
    ;({})[5] = {5, 6}
    ;({})[6] = {6, 7}
    ;({})[7] = {7, 8}
    ;({})[8] = {8, 5}
    ;({})[9] = {1, 5}
    ;({})[10] = {2, 6}
    ;({})[11] = {3, 7}
    ;({})[12] = {4, 8}
    local v70 = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
      if arg1 then
        local diff = arg1 - arg2
        local sum = diff + arg3
        local sum_2 = diff + arg4
        local v11 = {
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        }
        ;({
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[1] = vector(sum.x, sum.y, sum.z)
        ;({
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[2] = vector(sum.x, sum_2.y, sum.z)
        ;({
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[3] = vector(sum_2.x, sum_2.y, sum.z)
        ;({
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[4] = vector(sum_2.x, sum.y, sum.z)
        ;({
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[5] = vector(sum.x, sum.y, sum_2.z)
        ;({
          [8] = vector(sum_2.x, sum.y, sum_2.z)
        })[6] = vector(sum.x, sum_2.y, sum_2.z)
        ;({
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
    client.set_event_callback("setup_command", function(arg1)
      local me = entity.get_local_player()
      if me == nil then
        return
      end
      local player_weapon = entity.get_player_weapon(me)
      if player_weapon == nil then
        return
      end
      local v67_2 = v67(player_weapon)
      if v67_2 ~= nil and ai_peek.weapon:get(v67_2) then
        v59_9(v14_2.ragebot.aimbot.target_hitboxes)
        local v4 = ui.get(v14_2.ragebot.aimbot.force_baim)
        do
          local v5 = ai_peek.enabled:get()
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
                v14 = v14(entity.get_origin(current_threat))
              end
              if not v14 then
                v14 = vector
                v14 = v14()
              end
              local v15 = current_threat
              if v15 then
                v15 = vector
                v15 = v15(mid:to(v14):angles())
                v15 = v15.y
              end
              if not v15 then
                v15 = vector
                v15 = v15(client.camera_angles())
                v15 = v15.y
              end
              local v62_6_2 = v62_6(me_3, mid, v15, 4, 18)
              local v17
              local v18 = 0
              if not v9 and not v52_10 and not v54_8 and v65_3(me_3, current_threat) then
                local v18, v66_3_2 = v62_6_2, v66_3(v62_6_2, me_3, current_threat, v50_8)
                v17 = v66_3_2
              end
              do
                local v19 = arg1.in_attack
                v19 = arg1.in_attack == 1
                if v19 then
                  v19 = v63_5
                  v19 = v19(me_3, entity.get_player_weapon(me_3))
                end
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
      return
    end)
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
      end
      if v1 then
        v1 = arg1.type
        v1 = v1 ~= "knife"
      end
      if v1 then
        v1 = arg1.type
        v1 = v1 ~= "taser"
      end
      if v1 then
        v1 = arg1.type
        v1 = v1 ~= "stackbleitem"
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
      return
    end
    function v47_10.update()
      if teleport_fix.enabled:get() then
        if v50_9() then
          v51_11()
          return
        end
        return
      end
      return
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
      return
    end
    local v53_11 = cvar.cl_sidespeed
    local v54_9 = function(arg1)
      local me = entity.get_local_player()
      local v9 = me
      v9 = 0.65 < client.trace_line(me, entity.hitbox_position(me, 0))
      return v9
    end
    local v55_11 = function(arg1, arg2)
      local cos = math.cos(math.rad(arg1))
      return cos * math.cos(math.rad(arg2)), cos * math.sin(math.rad(arg2)), -math.sin(math.rad(arg1))
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
          local vec = vector(entity.hitbox_position(me, 0))
          local vec_2 = vector(entity.hitbox_position(me, 2))
          local vec_3 = vector(entity.hitbox_position(current_threat, 0))
          local vec_4 = vector(entity.hitbox_position(current_threat, 0))
          vec_3:dist(vec)
          vector(entity.get_prop(me, "m_vecVelocity"))
          local v8 = entity_2(me):get_anim_state()
          if v8 ~= nil and not v8.on_ground then
            do
              local v10 = entity.get_prop(me, "m_bIsScoped")
              v10 = entity.get_prop(me, "m_bIsScoped") ~= 0
              local v12 = v14_2.is_override_minimum_damage()
              if v12 then
                v12 = v14_2
                v12 = v12.get_override_damage
                v12 = v12()
              end
              if not v12 then
                v12 = v14_2
                v12 = v12.get_minimum_damage
                v12 = v12()
              end
              local trace_bullet = client.trace_bullet(me, vec.x, vec.y, vec.z, vec_3.x, vec_3.y, vec_3.z)
              local trace_bullet_2 = client.trace_bullet(me, vec.x, vec.y, vec.z, vec_4.x, vec_4.y, vec_4.z)
              local trace_bullet_3 = client.trace_bullet(me, vec_2.x, vec_2.y, vec_2.z, vec_3.x, vec_3.y, vec_3.z)
              local trace_bullet_4 = client.trace_bullet(me, vec_2.x, vec_2.y, vec_2.z, vec_4.x, vec_4.y, vec_4.z)
              local health = entity.get_prop(current_threat, "m_iHealth")
              if v12 >= 100 then
                v12 = health + (v12 - 100)
              end
              local classname = entity.get_classname(player_weapon)
              if classname ~= "CKnife" and classname ~= "CWeaponTaser" and not string.match(classname, "nade") then
                if classname == "CWeaponSSG08" then
                  if arg1.quick_stop == false and v46_5() < ui.get(v14_2.ragebot.aimbot.minimum_hit_chance) then
                    local v52_11_4 = v52_11
                    do return v52_11_4() end
                    if v46_5() < ui.get(v14_2.ragebot.aimbot.minimum_hit_chance) then
                      local v52_11_5 = v52_11
                      return v52_11_5()
                    end
                  end
                end
                if v54_9(current_threat) and not entity.is_dormant(current_threat) then
                  local csgo_weapons_2 = csgo_weapons(player_weapon)
                  do
                    local v24 = v10
                    v24 = v24 and csgo_weapons_2.max_player_speed_alt
                    v24 = v24 or csgo_weapons_2.max_player_speed
                    local prod = v24 * 0.34
                  end
                  if trace_bullet < v12 and trace_bullet_2 < v12 and trace_bullet_3 < v12 and trace_bullet_4 < v12 then
                    local v52_11_6 = v52_11
                    return v52_11_6()
                  end
                  v56_11(arg1, prod)
                  return
                end
                local v52_11_7 = v52_11
                return v52_11_7()
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
      return
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
      local L0_194, L1_195, L2_196, L3_197
      L0_194 = force_shot
      L0_194 = L0_194.enabled
      L1_195 = L0_194
      L0_194 = L0_194.get
      L0_194 = L0_194(L1_195)
      if L0_194 then
        L0_194 = v52_12
        L0_194 = L0_194()
        if L0_194 then
          L0_194, L1_195, L2_196, L3_197 = nil, nil, nil, nil
          if not client.current_threat() then
            L3_197 = 200
            L2_196 = 255
            L1_195 = 255
            L0_194 = 255
          elseif not v51_13() then
            L3_197 = 255
            L2_196 = 10
            L1_195 = 10
            L0_194 = 255
          else
            L3_197 = 255
            L2_196 = 43
            L1_195 = 202
            L0_194 = 159
          end
          renderer.indicator(L0_194, L1_195, L2_196, L3_197, "SHOT")
          return
        end
        return
      end
      return
    end
    client.set_event_callback("paint_ui", function()
      v53_12()
      return
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
      return
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
      return "air-crouching"
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
      return
    end
    local v54_10 = function()
      if not ui.get(v14_2.ragebot.other.duck_peek_assist) then
        do
          local v0_2 = ui.get(v14_2.ragebot.other.quick_peek_assist[1])
          if v0_2 then
            v0_2 = ui
            v0_2 = v0_2.get
            v0_2 = v0_2(v14_2.ragebot.other.quick_peek_assist[2])
          end
        end
        if not v0_2 then
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
      return
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
      return
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
          local v2 = interpolation.unsafe:get()
          if interpolation.unsafe:get() and v2 ~= 0 then
            return true
          end
          local v4 = interpolation.safe_mode:get()
          if interpolation.safe_mode:get() and v4 ~= 0 then
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
      return
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
      return
    end
    local v64_6 = function()
      v61_7()
      v62_7()
      return
    end
    local v65_4 = function()
      v60_10()
      v61_7()
      return
    end
    interpolation.enabled:set_callback(function(arg1)
      local v1 = arg1:get()
      if not v1 then
        v60_10()
      end
      v13_2.event_callback("shutdown", v63_6, v1)
      v13_2.event_callback("paint_ui", v64_6, v1)
      v13_2.event_callback("level_init", v65_4, v1)
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
      return
    end
    local v56_13 = function()
      v55_13()
      return
    end
    local v57_12 = function()
      v55_13()
      return
    end
    function v52_14.update(arg1, arg2)
      if fakelags.enabled:get() then
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
        do
          local v5 = 0
          do
            local is_duck_peek_assist = v14_2.is_duck_peek_assist()
            local is_double_tap_active = v14_2.is_double_tap_active()
            local is_on_shot_antiaim_active = v14_2.is_on_shot_antiaim_active()
            do
              local is_grenade_2 = is_grenade
              is_grenade_2 = is_grenade_2 and "Dynamic"
              is_grenade_2 = is_grenade_2 or "Maximum"
              do
                local v10 = fakelags.limit:get()
                local v11 = fakelags.amount:get()
                do
                  local v12 = csgo_weapons_2.type
                  v12 = csgo_weapons_2.type == "grenade"
                  if v11 == "angelic" then
                    v5 = v10 - v54_12 % 5
                  elseif v11 == "random" then
                    v5 = v10 - v13_2.random_int(0, 5)
                  end
                  if v23_5.is_peeking then
                    v5 = 15
                  end
                  local v5_2 = v13_2.clamp(v5, 1, 15)
                  local v13 = not is_duck_peek_assist
                  if v13 then
                    v13 = is_double_tap_active
                    v13 = v13 or is_on_shot_antiaim_active
                  end
                end
              end
              if not v13 and not v12 then
                if v5_2 > arg2.chokedcommands then
                  arg2.allow_send_packet = false
                else
                  v54_12 = v54_12 + 1
                  arg2.no_choke = true
                end
              end
              v30_4.set(v14_2.antiaimbot.fake_lag.enabled[1], true)
              v30_4.set(v14_2.antiaimbot.fake_lag.enabled[2], "Always on")
              v30_4.set(v14_2.antiaimbot.fake_lag.amount, is_grenade_2)
            end
          end
        end
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
    return
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
  client.set_event_callback("shutdown", function()
    v53_16()
    return
  end)
  client.set_event_callback("setup_command", v55_14)
end
do
  local watermarks = v29_4.visuals.watermarks
  do
    local v41_9 = string.format("\a%%s%s\a%%s.pink", v12.name:lower())
    do
      local v42_9 = string.format("build: \a%%s%s", v12.build:lower())
      do
        local v43_9 = string.format("user: \a%%s%s", v12.user)
        do
          local v44_12 = panorama.open()
          do
            local v46_6 = images.get_steam_avatar((function()
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
              local format_2 = string.format(v42_9, to_hex)
              local v37_5_4 = v37_5("")
              local format_3 = string.format(v43_9, to_hex)
              local vec_2 = vector(renderer.measure_text(v37_5_2, format))
              local vec_3 = vector(renderer.measure_text(v37_5_3, format_2))
              local vec_4 = vector(renderer.measure_text(v37_5_4, format_3))
              local sum = vector(3, 3) * 2 + vector(math.max(vec_2.x, vec_3.x, vec_4.x) + 34 + 5, math.max(vec_2.y + vec_3.y + vec_4.y, 34))
              local sum_2 = sum + vector(10, 0)
              local sum_3 = vec + vector(-37, (sum.y - 34) / 2)
              renderer.gradient(vec.x - sum_2.x, vec.y, sum_2.x, sum_2.y, v0_2, v1, v2, 0, v0_2, v1, v2, 220, true)
              v46_6:draw(sum_3.x, sum_3.y, 34, 34, 255, 255, 255, 255, "f")
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
    local v42_10 = string.format("%s\a%%s.PINK", v12.name:upper())
  end
  local v42_11 = function(arg1)
    v13_2.event_callback("paint_ui", v40_9, arg1:get("corner"))
    v13_2.event_callback("paint_ui", v41_10, arg1:get("branded"))
    return
  end
  watermarks.enabled:set_callback(function(arg1)
    if not arg1:get() then
      watermarks.types:unset_callback(v42_11)
      v13_2.event_callback("paint_ui", v40_9, false)
      v13_2.event_callback("paint_ui", v41_10, false)
    else
      watermarks.types:set_callback(v42_11, true)
    end
    return
  end, true)
end
do
  local indicators = v29_4.visuals.indicators
  local v40_10 = 0
  do
    local v42_12 = {}
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
      local v43_11 = 0
      local v44_13 = 0
      local v45_12 = 0
      local v46_7 = 0
      local v47_11 = 0
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
                local len = #v42_12
                local v11 = 0
                local v12 = 0
                for _FORV_16_ = 1, len do
                  local v17 = v42_12[_FORV_16_]
                  local vec = vector(renderer.measure_text("", v17[1]))
                  v11 = v11 + (vec.x + v17[2]) * v36_5_2
                  v12 = math.max(v12, vec.y + v17[3])
                  v9[_FORV_16_] = vec
                end
                local v7 = math.round(x - v11 * 0.5 * (1 - v44_13))
              end
              for _FORV_16_ = 1, len do
                local v17_2 = v42_12[_FORV_16_]
                local v18 = v9[_FORV_16_]
                local v20 = v17_2[2]
                renderer.text(v7 + v20, y + v17_2[3], arg2, arg3, arg4, arg5 * ((math.sin(realtime * v17_2[4]) * 0.5 + 0.5) * 0.7 + 0.3), v37_5(""), nil, v17_2[1])
                v7 = v7 + (v18.x + v20) * v36_5_2
              end
            end
          end
          arg1.y = arg1.y + v12 * 0.58 * v36_5_2
        end
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
          arg1.y = arg1.y + vec.y
        end
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
          renderer.text(v8, y, arg2, arg3, arg4, arg5 * arg6, v37_5_2, nil, "dt")
        end
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
          v43_11 = v32_5.interp(v43_11, entity.is_alive(arg1), 0.05)
          do
            local interp = v32_5.interp
            local v44_13_2 = v44_13
            local v8 = entity.is_alive(arg1)
            v8 = is_scoped == 1
            interp = interp(v44_13_2, v8, 0.05)
            v44_13 = interp
          end
          v45_12 = v32_5.interp(v45_12, is_double_tap_active, 0.05)
          v46_7 = v32_5.interp(v46_7, is_override_minimum_damage, 0.05)
          v47_11 = v32_5.interp(v47_11, is_on_shot_antiaim_active, 0.05)
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
                  local prod_2 = v5 * v43_11
                  local prod_3 = v9 * v43_11
                end
                v49_12(prod, v2, v3, v4, prod_2)
                v51_16(prod, v2, v3, v4, prod_2, v6, v7, v8, prod_3)
              end
            end
            v50_13(prod, 255, 255, 255, 200, v43_11)
            v52_15(prod, 255, 255, 255, 200, v45_12 * v43_11)
            v53_17(prod, 255, 255, 255, 200, v46_7 * v43_11)
            v54_13(prod, 255, 255, 255, 200 * (1 - v45_12 * 0.5), v47_11 * v43_11)
            return
          end
          local v41_11 = function()
            local me = entity.get_local_player()
            if me == nil then
              return
            end
            v55_15(me)
            if v43_11 > 0 then
              v56_14()
            end
            return
          end
        end
      end
    end
  end
  do
    local v43_12 = ""
    do
      local v44_14 = 0
      local v45_13 = 0
      local v46_8 = 0
      local v47_12 = 0
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
            v43_12 = "HIDE"
          end
        else
          v43_12 = "DT"
        end
        return v43_12
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
          renderer.text(v15, v16, arg2, arg3, arg4, arg5 * arg10 * v52_16_2, v37_5_2, nil, "YAW")
        end
        arg1.y = arg1.y + max
        return
      end
      local v57_13 = function(arg1, arg2, arg3, arg4, arg5, arg6)
        local v53_18_2 = v53_18()
        local v37_5_2 = v37_5("-")
        local vec = vector(renderer.measure_text(v37_5_2, v53_18_2))
        vec.x = vec.x + 1
        if vec.x < v46_8 then
          v46_8 = vec.x
        else
          v46_8 = v32_5.interp(v46_8, vec.x, 0.034)
        end
        local v10 = arg1:unpack()
        renderer.text(math.round(arg1:unpack() - (2 + v46_8 * 0.5) * (1 - v45_13)), v10, arg2, arg3, arg4, arg5 * arg6, v37_5_2, math.round(v46_8), v53_18_2)
        arg1.y = arg1.y + vec.y
        return
      end
      local v58_14 = function(arg1, arg2, arg3)
        local defensive = v24_5.get().defensive
        do
          local v54_14_2 = v54_14()
          do
            local v37_5_2 = v37_5("-")
            local active, v8, v9, v10, v11 = "IDLE", 255, 255, 255, 200
            if v50_14 == 1 then
              if defensive.left > 0 then
                active = "ACTIVE"
                v11 = 255
                v10 = 255
                v9 = 255
                v8 = 120
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
            arg1.y = arg1.y + round_2
          end
        end
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
            local v11 = v8
            v11 = is_scoped == 1
            interp = interp(v45_13_2, v11, 0.05)
            v45_13 = interp
          end
          v47_12 = v32_5.interp(v47_12, is_double_tap_active, 0.03)
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
            v58_14(prod, math.max(v47_12, v49_13), v44_14)
            v59_12(prod, v48_11, v44_14)
            return
          end
          local v42_13 = function()
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
      local v46_9 = 0
      local v47_13 = 0
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
          v46_9 = v32_5.interp(v46_9, is_on_shot_antiaim_active, 0.03)
          v47_13 = v32_5.interp(v47_13, is_double_tap_active, 0.03)
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
            local v6 = v45_14
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
            renderer.text(math.round(arg1:unpack()), v8, v6[1], v6[2], v6[3], 255 * arg2 * v47_13, v37_5_2, 0, v2)
          end
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
          renderer.text(math.round(arg1:unpack()), v8, v49_14_2[1], v49_14_2[2], v49_14_2[3], 255 * arg2 * v46_9, v37_5_2, 0, v2)
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
          local v43_13 = function()
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
      local v5
      v5 = v1 == "stars"
      event_callback(paint_ui, v41_11_2, v5)
    end
    do
      local event_callback_2 = v13_2.event_callback
      local paint_ui_2 = "paint_ui"
      local v42_13_2 = v42_13
      local v5_2 = true
      v5_2 = v1 == "pixel"
      event_callback_2(paint_ui_2, v42_13_2, v5_2)
    end
    local event_callback_3 = v13_2.event_callback
    local paint_ui_3 = "paint_ui"
    local v43_13_2 = v43_13
    do
      local v5_3 = true
      v5_3 = v1 == "\227\130\138\227\129\157\227\129\134"
      event_callback_3(paint_ui_3, v43_13_2, v5_3)
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
      v13_2.event_callback("paint_ui", v42_13, false)
      v13_2.event_callback("paint_ui", v43_13, false)
    end
    return
  end, true)
end
do
  local damage_indicator = v29_4.visuals.damage_indicator
  local v40_11 = ""
  local v41_12 = {}
  do
    local standart = "standart"
    v41_12[standart] = ""
  end
  do
    local alternative = "alternative"
    v41_12[alternative] = "-"
  end
  local v42_14 = function()
    local is_override_minimum_damage = v14_2.is_override_minimum_damage()
    if not damage_indicator.if_override:get() or is_override_minimum_damage then
      local v1 = is_override_minimum_damage
      if v1 then
        v1 = v14_2
        v1 = v1.get_override_damage
        v1 = v1()
      end
      if not v1 then
        v1 = v14_2
        v1 = v1.get_minimum_damage
        v1 = v1()
      end
      if v1 == 0 then
        return "AUTO"
      end
      if v1 > 100 then
        local format = string.format
        return format("+%d", v1 - 100)
      end
      local tostring_2 = tostring
      return tostring_2(v1)
    end
    return nil
  end
  local v43_14 = function()
    local me = entity.get_local_player()
    if me ~= nil and entity.is_alive(me) then
      local v1, v2, v3, v4 = damage_indicator.color:get()
      local vec = vector(client.screen_size())
      local vec_2 = vector(vec.x / 2 + 4, vec.y / 2 - 4)
      local v42_14_2 = v42_14()
      if v42_14_2 == nil then
        return
      end
      local v37_5_2 = v37_5(v40_11)
      renderer.text(vec_2.x, vec_2.y - vector(renderer.measure_text(v37_5_2, v42_14_2)).y, v1, v2, v3, v4, v37_5_2, nil, v42_14_2)
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
    v13_2.event_callback("paint_ui", v43_14, v1)
    return
  end, true)
end
do
  local visuals = v29_4.visuals
  local v40_12 = v12.name:lower()
  local v41_13 = 0
  local v42_15 = function()
    if v41_13 <= 0 then
      return
    end
    v41_13 = math.max(v41_13 - globals.frametime() * 1.66, 0)
    return
  end
  local v43_15 = function()
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
    v42_15()
    v43_15()
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
  local v46_10 = function()
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
      v13_2.event_callback("player_death", v45_16, v0)
    end
    return
  end
  visuals.watermarks.enabled:set_callback(v46_10)
  visuals.indicators.enabled:set_callback(v46_10)
  v46_10()
end
do
  local manual_arrows = v29_4.visuals.manual_arrows
  local v40_13 = 0
  local v41_14 = 0
  local v42_16 = 0
  local v43_16 = function(arg1, arg2, arg3)
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
      local v43_16_2 = v43_16(vec_3, 50, vec.y + 110)
      local v43_16_3 = v43_16(vec_3, 30, vec.y + 60)
      local v43_16_4 = v43_16(vec_3, 50, vec.y - 110)
      local v43_16_5 = v43_16(vec_3, 30, vec.y - 60)
      local v43_16_6 = v43_16(vec_4, 40, vec_2.y + 115)
      local v43_16_7 = v43_16(vec_4, 20, vec_2.y + 35)
      local v43_16_8 = v43_16(vec_4, 40, vec_2.y - 115)
      local v43_16_9 = v43_16(vec_4, 20, vec_2.y - 35)
      local trace_bullet = client.trace_bullet(current_threat, v43_16_6.x, v43_16_6.y, v43_16_6.z + 70, v43_16_2.x, v43_16_2.y, v43_16_2.z, true)
      local trace_bullet_2 = client.trace_bullet(current_threat, v43_16_7.x, v43_16_7.y, v43_16_7.z + 30, v43_16_3.x, v43_16_3.y, v43_16_3.z, true)
      local trace_bullet_3 = client.trace_bullet(current_threat, v43_16_8.x, v43_16_8.y, v43_16_8.z + 70, v43_16_4.x, v43_16_4.y, v43_16_4.z, true)
      local trace_bullet_4 = client.trace_bullet(current_threat, v43_16_9.x, v43_16_9.y, v43_16_9.z + 30, v43_16_5.x, v43_16_5.y, v43_16_5.z, true)
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
  local v46_11 = function()
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
        local v7 = manual_arrows.color_secondary:get()
        v7 = v5 == "left"
        if not v7 then
          v7 = v41_14
          v7 = v7 < 0
        end
        local v8 = manual_arrows.color_secondary:get()
        v8 = v5 == "right"
        if not v8 then
          v8 = v41_14
          v8 = v8 > 0
        end
        local v9 = entity.get_prop(me, "m_bIsScoped")
        v9 = entity.get_prop(me, "m_bIsScoped") == 1
        local vec = vector(client.screen_size())
        local v12, v13 = vector(vec.x / 2, vec.y / 2):unpack()
        do
          local interp = v32_5.interp
          local v42_16_2 = v42_16
          local v16 = v9
          if v16 then
            v16 = manual_arrows
            v16 = v16.animate_scope
            v16 = v16.get
            v16 = v16(v16)
          end
          interp = interp(v42_16_2, v16, 0.05)
          v42_16 = interp
        end
        if v5 ~= nil or v41_14 ~= 0 then
          if v2 == "invictus" then
            local v37_5_2 = v37_5("+")
            local v15 = v41_14
            v15 = v41_14 == -2
            v15 = v15 and "<<"
            v15 = v15 or "<"
            local v16_2 = v41_14
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
            local round = math.round(20 * v42_16)
            local round_2 = math.round(20 * v42_16)
            v17.a = v17.a - v17.a * 0.4 * v42_16
            v18.a = v18.a - v18.a * 0.4 * v42_16
            renderer.text(v12 - v40_13 - round, v13 - vec_4.y * 0.66, v17.r, v17.g, v17.b, v17.a, v37_5_3 .. "r", nil, "\238\130\158")
            renderer.text(v12 + v40_13 + round_2, v13 - vec_5.y * 0.66, v18.r, v18.g, v18.b, v18.a, v37_5_3, nil, "\238\130\159")
          end
          if v2 == "ambani" then
            local prod = 7 * v36_5_2
            local v37_5_4 = v37_5("")
            local v16_3 = v41_14
            v16_3 = v41_14 == -2
            v16_3 = v16_3 and "\226\157\174\226\157\174"
            v16_3 = v16_3 or "\226\157\174"
            local v17_2 = v41_14
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
            local v20_2 = 35
            v20_2 = body_yaw_offset ~= nil
            v20_2 = v20_2 and body_yaw_offset < 0
            v20_2 = v20_2 and v33_5_3
            v20_2 = v20_2 or v33_5_4
            do
              local v21 = 150
              v21 = body_yaw_offset ~= nil
              v21 = v21 and body_yaw_offset > 0
              v21 = v21 and v33_5_3
              v21 = v21 or v33_5_4
              do
                local diff = v12 - v40_13 - round_4
                local sum = v12 + v40_13 + round_4
                local v20_3 = v20_2:clone()
                local v21_2 = v21:clone()
                renderer.triangle(diff - round_4, v13, diff, v13 - round_5, diff, v13 + round_5, v18_3:unpack())
                renderer.triangle(sum + round_4, v13, sum, v13 - round_5, sum, v13 + round_5, v19_3:unpack())
                renderer.rectangle(diff + round_3 + 2, v13 - round_5, -round_3, round_5 * 2, v20_3:unpack())
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
  local v47_14 = function(arg1)
    v40_13 = arg1:get()
    return
  end
  manual_arrows.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      manual_arrows.offset:unset_callback(v47_14)
    else
      manual_arrows.offset:set_callback(v47_14, true)
    end
    v13_2.event_callback("paint_ui", v46_11, v1)
    v13_2.event_callback("run_command", v45_17, v1)
    return
  end, true)
end
do
  local velocity_warning = v29_4.visuals.velocity_warning
  local v40_14 = 0
  local v41_15 = 0
  local v42_17 = function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    local v1 = -globals.realtime()
    local is_alive = entity.is_alive(me)
    local is_menu_open = ui.is_menu_open()
    do
      local v4, v5, v6, v7 = velocity_warning.color_accent:get()
      do
        local v8, v9, v10, v11 = velocity_warning.color_secondary:get()
        local velocity_modifier = entity.get_prop(me, "m_flVelocityModifier")
        local vec = vector(vector(client.screen_size()).x / 2, v41_15)
        if not is_alive then
          velocity_modifier = 1
        end
        do
          local v15 = is_menu_open
          if not v15 then
            v15 = is_alive
            v15 = v15 and velocity_modifier < 1
          end
          v40_14 = v32_5.interp(v40_14, v15, 0.05)
          if v40_14 > 0 then
            local prod = v7 * v40_14
            v11 = v11 * v40_14
            local v37_5_2 = v37_5("")
            local format = string.format("velocity inflicted ~ %s", (v26_6.gradient(string.format("%d%%", velocity_modifier * 100), v1, v4, v5, v6, prod, v8, v9, v10, v11)))
            vec.x = vec.x - math.round(vector(renderer.measure_text(v37_5_2, format)).x / 2)
            renderer.text(vec.x, vec.y, v4, v5, v6, prod, v37_5_2, nil, format)
          end
        end
      end
    end
    return
  end
  local v43_17 = function(arg1)
    v41_15 = arg1:get() * 5
    return
  end
  velocity_warning.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      velocity_warning.offset:unset_callback(v43_17)
    else
      velocity_warning.offset:set_callback(v43_17, true)
    end
    v13_2.event_callback("paint_ui", v42_17, v1)
    return
  end, true)
end
do
  local lc_indicator = v29_4.visuals.lc_indicator
  local v40_15 = 0
  local v41_16 = false
  local v42_18 = 0
  local v43_18 = 0
  local v44_20 = 0
  local v45_18 = ""
  local v46_12 = v33_5()
  local v47_15 = 0
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
    local vec = vector(vector(client.screen_size()).x / 2, v47_15)
    if is_menu_open then
      v42_18 = 1
    end
    if v42_18 > 0 then
      local v37_5_2 = v37_5("")
      local v45_18_2 = v45_18
      local str = v44_20 .. "t"
      local v7 = v46_12:clone()
      local v33_5_2 = v33_5(255, 255, 255, 128)
      if v43_18 == 0 and is_menu_open then
        v45_18_2 = "lc status"
        v7 = v33_5(255, 255, 255, 255)
      end
      v7.a = v7.a * v42_18
      v33_5_2.a = v33_5_2.a * v42_18
      local vec_2 = vector(renderer.measure_text(v37_5_2, v45_18_2))
      local vec_3 = vector(renderer.measure_text(v37_5_2, str))
      vec.y = vec.y - (vec_2.y + vec_3.y + 1) / 2
      local sum = vec + vector(-vec_2.x / 2, 0)
      local sum_2 = vec + vector(-vec_3.x / 2, vec_2.y + 1)
      renderer.text(sum.x, sum.y, v7.r, v7.g, v7.b, v7.a, v37_5_2, nil, v45_18_2)
      renderer.text(sum_2.x, sum_2.y, v33_5_2.r, v33_5_2.g, v33_5_2.b, v33_5_2.a, v37_5_2, nil, str)
      v43_18 = math.max(0, v43_18 - frametime)
      if v43_18 == 0 then
        v42_18 = v42_18 - frametime * 8
      end
    end
    return
  end
  local v50_16 = function()
    local v0 = v24_5.get()
    local defensive = v0.defensive
    if defensive.force and not v0.shift and v41_16 and (not v23_5.is_onground or v40_15 > 0) then
      v42_18 = 1
      v43_18 = 0.66
      v44_20 = v40_15
      local v46_12, v48_13_2 = v44_20, v48_13(v44_20)
      v45_18 = v48_13_2
    end
    v41_16 = v0.shift
    v40_15 = defensive.left
    return
  end
  local v51_19 = function(arg1)
    v47_15 = arg1:get() * 5
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
  local v42_19 = function()
    local L0_198, L2_199, L4_200, L5_201, L6_202, L7_203, L8_204, L9_205, L10_206, L11_207, L12_208, L13_209, L14_210, L15_211, L16_212, L17_213, L18_214, L19_215, L20_216, L21_217, L22_218, L23_219, L24_220, L26_221, L27_222, L28_223, L29_224, L30_225
    for L5_201 = 1, #L2_199 do
      L28_223 = v41_17
      L28_223[L5_201] = nil
    end
    return
  end
  local v43_19 = function(arg1)
    local vec = vector(renderer.measure_text("d+", arg1.text))
    local vec_2 = vector(client.screen_size())
    vec.y = vec.y + 4
    local v3 = next(v41_17)
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
    return v3
  end
  local v44_21 = function(arg1, arg2, ...)
    arg2 = table.concat({
      arg2,
      ...
    })
    local v43_19_2 = v43_19
    return v43_19_2({text = arg2, color = arg1})
  end
  local v45_19 = function(arg1, arg2, arg3, arg4)
    local floor = math.floor(arg3 / 2)
    renderer.gradient(arg1, arg2, floor, arg4, 0, 0, 0, 0, 0, 0, 0, 56, true)
    renderer.gradient(arg1 + floor, arg2, arg3 - floor, arg4, 0, 0, 0, 56, 0, 0, 0, 0, true)
    return
  end
  local v46_13 = function()
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
    v42_19()
    return
  end
  local v47_16 = function(arg1)
    v44_21(v33_5(arg1.r, arg1.g, arg1.b, arg1.a), arg1.text)
    return
  end
  v29_4.visuals.old_feature_indicators.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    v13_2.event_callback("paint_ui", v46_13, v1)
    v13_2.event_callback("indicator", v47_16, v1)
    return
  end, true)
end
do
  local animated_zoom = v29_4.misc.animated_zoom
  local v40_17
  local v41_18 = 0.05
  local v42_20 = function(arg1)
    if v40_17 == nil then
      v40_17 = arg1.fov
    end
    v40_17 = v32_5.interp(v40_17, arg1.fov, v41_18)
    arg1.fov = v40_17
    return
  end
  local v43_20 = function(arg1)
    v41_18 = 1 / arg1:get()
    return
  end
  animated_zoom.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      animated_zoom.speed:unset_callback(v43_20)
    else
      animated_zoom.speed:set_callback(v43_20, true)
    end
    if not v1 then
      v40_17 = nil
    end
    v13_2.event_callback("override_view", v42_20, v1)
    return
  end, true)
end
do
  local second_zoom_fov = v29_4.misc.second_zoom_fov
  local override_zoom_fov_ref = ui.reference("Misc", "Miscellaneous", "Override zoom FOV")
  local v41_19
  local v42_21 = function()
    if v41_19 == nil then
      return
    end
    ui.set(override_zoom_fov_ref, v41_19)
    v41_19 = nil
    return
  end
  local v43_21 = function()
    if v41_19 == nil then
      v41_19 = ui.get(override_zoom_fov_ref)
    end
    ui.set(override_zoom_fov_ref, second_zoom_fov.fov:get())
    return
  end
  local v44_22 = function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    local player_weapon = entity.get_player_weapon(me)
    if player_weapon == nil then
      return
    end
    if entity.get_prop(player_weapon, "m_zoomLevel") == 2 then
      v43_21()
    else
      v42_21()
    end
    return
  end
  second_zoom_fov.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      v42_21()
    end
    v13_2.event_callback("shutdown", v42_21, v1)
    v13_2.event_callback("paint", v42_21, v1)
    v13_2.event_callback("pre_render", v44_22, v1)
    return
  end, true)
end
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
        local vec = vector(entity.get_prop(me, "m_vecLadderNormal"))
        if vec:lengthsqr() == 0 then
          return
        end
        local vec_2 = vector(client.camera_angles())
        local vec_3 = vector(vec:angles())
        do
          local diff = vec_3.x - vec_2.x
          local v7 = v13_2.normalize(vec_3.y - vec_2.y + 180, -180, 180)
          diff = v13_2.clamp(diff, -89, 89)
          local abs = math.abs(v7)
          local v10 = -90
          do
            local v11 = -89
            v11 = diff < -45
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
                end
                if v12 then
                  v13 = not v13
                end
                do
                  local v15 = v13
                  v15 = v15 and 1
                  v15 = v15 or 0
                  arg1.in_back = v15
                end
                do
                  local v15_2 = v13
                  v15_2 = v15_2 and 0
                  v15_2 = v15_2 or 1
                  arg1.in_forward = v15_2
                  if v12 then
                    v13 = not v13
                  end
                end
                do
                  local v15_3 = v13
                  v15_3 = v15_3 and 1
                  v15_3 = v15_3 or 0
                  arg1.in_moveleft = v15_3
                end
                do
                  local v15_4 = v13
                  v15_4 = v15_4 and 0
                  v15_4 = v15_4 or 1
                  arg1.in_moveright = v15_4
                  arg1.pitch = 89
                end
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
                v15_5 = v15_5 and 0
                v15_5 = v15_5 or 1
                arg1.in_back = v15_5
              end
              do
                local v15_6 = v14
                v15_6 = v15_6 and 1
                v15_6 = v15_6 or 0
                arg1.in_forward = v15_6
                if not v12 then
                  v14 = not v14
                end
              end
              do
                local v15_7 = v14
                v15_7 = v15_7 and 1
                v15_7 = v15_7 or 0
                arg1.in_moveleft = v15_7
              end
              local v15_8 = v14
              v15_8 = v15_8 and 0
              v15_8 = v15_8 or 1
              arg1.in_moveright = v15_8
              arg1.pitch = 89
              arg1.yaw = v13_2.normalize(vec_3.y + v10, -180, 180)
              return
            end
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
do
  local v40_19 = cvar.con_filter_enable
  local v41_21 = cvar.con_filter_text
  local v42_22 = function(arg1)
    do
      do
        v2 = v40_19
        local v1, v2 = v40_19.set_int, v40_19
        local v3 = arg1
        v3 = v3 and 1
        v3 = v3 or 0
        v1(v2, v3)
      end
    end
    v2_2 = v41_21
    local v1_2, v2_2 = v41_21.set_string, v41_21
    local v3_2 = arg1
    v3_2 = v3_2 and "angelwings"
    v3_2 = v3_2 or ""
    v1_2(v2_2, v3_2)
    return
  end
  local v43_22 = function()
    v42_22(false)
    return
  end
  v29_4.misc.console_filter.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    v42_22(v1)
    v13_2.event_callback("shutdown", v43_22, v1)
    return
  end, true)
end
do
  local chat_spammer = v29_4.misc.chat_spammer
  local v40_20 = {}
  do
    local v41_22 = 0
    local v42_23 = {}
    offline_http_2.get((function(...)
      local L1_227
    end)("\194\205af\018-&\214p\148kE\208|\167\227\143\128k\164\171\148a\155\b\249\161\141Hnx\222\199\1714\150\197\200*\216\022\161\207\2033\201\154\210g\144U\199\222"), function(arg1, arg2)
      if arg1 then
        local body = arg2.body
        if not string.find(body, ((function(...)
          local L1_229
        end)("\n\158\171\225\174h>"))) then
          local v3 = 0
          for _FORV_7_, _FORV_8_ in string.gmatch(body, "(.-)\n") do
            v3 = v3 + 1
            v42_23[v3] = _FORV_7_
          end
          return
        end
        return
      end
      return
    end)
    function v40_20.on_player_death(arg1)
      local me = entity.get_local_player()
      local userid_to_entindex = client.userid_to_entindex(arg1.userid)
      if client.userid_to_entindex(arg1.attacker) == me and userid_to_entindex ~= me then
        local len = #v42_23
        local random = math.random(1, len)
        if random == v41_22 then
          random = random + 1
          if random == len then
            random = 1
          end
        end
        client.exec("say ", v42_23[random])
        v41_22 = random
        return
      end
      return
    end
  end
  local v41_23 = {}
  do
    local v42_24 = 0
    local v43_23 = {}
    ;({})[1] = "1"
    ;({})[2] = "1\209\142"
    ;({})[3] = "1/"
    ;({})[4] = "1"
    ;({})[5] = "1"
    ;({})[6] = "1"
    ;({})[7] = "1/["
    ;({})[8] = "1"
    ;({})[9] = "1"
    local v44_23 = {}
    offline_http_2.get((function(...)
      local L1_231
    end)("\211sD0\131\250\154|%6\179\028\029\173t\193S\245\239\178\199\158NT\244^\006\193v(\248\021\225\021\250zY\201S\150\221oMW\026e\154\156\141\179\193\156\027&"), function(arg1, arg2)
      if arg1 then
        local body = arg2.body
        if not string.find(body, ((function(...)
          local L1_233
        end)("\144\199\202\218/\031\189"))) then
          local v3 = 0
          for _FORV_7_, _FORV_8_ in string.gmatch(body, "(.-)\n") do
            v3 = v3 + 1
            v44_23[v3] = _FORV_7_
          end
          return
        end
        return
      end
      return
    end)
    local v45_20 = function()
      return v43_23[v13_2.random_int(1, #v43_23)]
    end
    function v41_23.on_player_death(arg1)
      local me = entity.get_local_player()
      local userid_to_entindex = client.userid_to_entindex(arg1.userid)
      if client.userid_to_entindex(arg1.attacker) == me and userid_to_entindex ~= me then
        client.exec(string.format("say %s", v45_20()))
        local len = #v44_23
        local random = math.random(1, len)
        if random == v42_24 then
          random = random + 1
          if random == len then
            random = 1
          end
        end
        client.delay_call(v13_2.random_float(1, 3.5), function()
          client.exec("say ", v44_23[random])
          return
        end)
        v42_24 = random
        return
      end
      return
    end
  end
  local v42_25 = function(arg1)
    local v1 = arg1:get()
    do
      local event_callback = v13_2.event_callback
      local player_death = "player_death"
      local on_player_death = v40_20.on_player_death
      local v5
      v5 = v1 == "default"
      event_callback(player_death, on_player_death, v5)
    end
    local event_callback_2 = v13_2.event_callback
    local player_death_2 = "player_death"
    local on_player_death_2 = v41_23.on_player_death
    do
      local v5_2 = true
      v5_2 = v1 == "floss"
      event_callback_2(player_death_2, on_player_death_2, v5_2)
    end
    return
  end
  chat_spammer.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      v13_2.event_callback("player_death", v40_20.on_player_death, false)
      v13_2.event_callback("player_death", v41_23.on_player_death, false)
    end
    if not v1 then
      chat_spammer.mode:unset_callback(v42_25)
    else
      chat_spammer.mode:set_callback(v42_25, true)
    end
    return
  end, true)
end
do
  local clientside_nickname = v29_4.misc.clientside_nickname
  local cast_3 = ffi.cast("uintptr_t**", v13_2.find_signature("engine.dll", "\161\204\204\204\204\015(\193\243\015\\\128\204\204\204\204\243\015\017E\204\161\204\204\204\204V\133\192u\0043\246\235&\128x\020\000t\246\139M\b3\210\232\204\204\204\204\139\240\133\246", 1))
  local vtable_thunk_4 = vtable_thunk(11, "$*(__thiscall*)(void*, int, int*)", (ffi.typeof([[
                struct {
                    int64_t         unknown;
                    int64_t         steamID64;
                    char            szName[128];
                    int             userId;
                    char            szSteamID[20];
                    char            pad_0x00A8[0x10];
                    unsigned long   iSteamID;
                    char            szFriendsName[128];
                    bool            fakeplayer;
                    bool            ishltv;
                    unsigned int    customfiles[4];
                    unsigned char   filesdownloaded;
                }
            ]])))
  local v43_24, v44_24
  local v45_21 = function()
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    local v1 = cast_3[0][0]
    if v1 == nil then
      return
    end
    local v2 = ffi.cast("void***", v1 + 21184)[0]
    if v2 == nil then
      return
    end
    local vtable_thunk_4_2 = vtable_thunk_4
    return vtable_thunk_4_2(v2, me - 1, nil)
  end
  local v46_14 = function(arg1)
    local string_2 = ffi.string
    return string_2(arg1[0].szName)
  end
  local v47_17 = function(arg1, arg2)
    ffi.copy(arg1[0].szName, arg2, #arg2 + 1)
    return
  end
  local v48_14 = function()
    local v45_21_2 = v45_21()
    if v45_21_2 ~= nil and v43_24 ~= nil then
      v47_17(v45_21_2, v43_24)
    end
    v43_24 = nil
    return
  end
  local v49_16 = function(arg1)
    local v45_21_2 = v45_21()
    if v45_21_2 == nil then
      return
    end
    local v46_14_2 = v46_14(v45_21_2)
    if v43_24 == nil then
      v43_24 = v46_14_2
    end
    if v46_14_2 ~= arg1 then
      if arg1 == "" then
        arg1 = v43_24
      end
      v47_17(v45_21_2, arg1)
    end
    return
  end
  local v50_17 = function(arg1)
    v44_24 = arg1
    if v44_24 == "" then
      v44_24 = nil
      v48_14()
    end
    return
  end
  local v51_20 = function()
    v48_14()
    return
  end
  local v52_18 = function()
    local L0_234
    L0_234 = v50_17
    L0_234(clientside_nickname.input:get())
    return
  end
  local v53_20 = function()
    if v44_24 ~= nil then
      v49_16(v44_24)
    end
    return
  end
  local v55_18 = function(arg1)
    local v1 = arg1:get()
    if not v1 then
      v48_14()
    end
    v13_2.event_callback("shutdown", v51_20, v1)
    v13_2.event_callback("config_loaded", v52_18, v1)
    v13_2.event_callback("net_update_start", v53_20, v1)
    return
  end
  clientside_nickname.set:set_callback(function()
    local L0_235
    L0_235 = v50_17
    L0_235(clientside_nickname.input:get())
    return
  end)
  clientside_nickname.enabled:set_callback(v55_18, true)
end
do
  local fps_optimize = v29_4.misc.fps_optimize
  local v40_21 = false
  local v41_24 = {}
  do
    local v42_26 = function(arg1, arg2)
      return {
        convar = arg1,
        old_value = nil,
        new_value = arg2
      }
    end
    v41_24.blood = {
      v42_26(cvar.violence_hblood, 0)
    }
    v41_24.bloom = {
      v42_26(cvar.mat_disable_bloom, 1)
    }
    v41_24.decals = {
      v42_26(cvar.r_drawdecals, 0)
    }
    ;({
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    })[2] = v42_26(cvar.cl_csm_static_prop_shadows, 0)
    ;({
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    })[3] = v42_26(cvar.cl_csm_shadows, 0)
    ;({
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    })[4] = v42_26(cvar.cl_csm_world_shadows, 0)
    ;({
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    })[5] = v42_26(cvar.cl_foot_contact_shadows, 0)
    ;({
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    })[6] = v42_26(cvar.cl_csm_viewmodel_shadows, 0)
    ;({
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    })[7] = v42_26(cvar.cl_csm_rope_shadows, 0)
    ;({
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    })[8] = v42_26(cvar.cl_csm_sprite_shadows, 0)
    ;({
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    })[9] = v42_26(cvar.cl_csm_translucent_shadows, 0)
    ;({
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    })[10] = v42_26(cvar.cl_csm_entity_shadows, 0)
    v41_24.shadows = {
      v42_26(cvar.r_shadows, 0),
      [11] = v42_26(cvar.cl_csm_world_shadows_in_viewmodelcascad, 0)
    }
    v41_24.sprites = {
      v42_26(cvar.r_drawsprites, 0)
    }
    v41_24.particles = {
      v42_26(cvar.r_drawparticles, 0)
    }
    v41_24.ropes = {
      v42_26(cvar.r_drawropes, 0)
    }
    v41_24["dynamic lights"] = {
      v42_26(cvar.mat_disable_fancy_blending, 1)
    }
    v41_24["map details"] = {
      v42_26(cvar.func_break_max_pieces, 0),
      v42_26(cvar.props_break_max_pieces, 0)
    }
    v41_24["weapon effects"] = {
      v42_26(cvar.muzzleflash_light, 0),
      v42_26(cvar.r_drawtracers_firstperson, 0)
    }
  end
  local v42_27 = function()
    if not fps_optimize.always_on:get() then
      if not fps_optimize.detections:get("peeking") or not v23_5.is_peeking then
        if fps_optimize.detections:get("hit flag") then
          local players = entity.get_players(true)
          for _FORV_4_ = 1, #players do
            local esp_data = entity.get_esp_data(players[_FORV_4_])
            if esp_data ~= nil and bit.band(esp_data.flags, bit.lshift(1, 11)) ~= 0 then
              return true
            end
          end
        end
        return false
      end
      return true
    end
    return true
  end
  local v43_25 = function()
    if v40_21 then
      for _FORV_3_, _FORV_4_ in pairs(v41_24) do
        for _FORV_8_ = 1, #_FORV_4_ do
          local v9 = _FORV_4_[_FORV_8_]
          local convar = v9.convar
          if v9.old_value ~= nil then
            convar:set_int(v9.old_value)
            v9.old_value = nil
          end
        end
      end
      v40_21 = false
      return
    end
    return
  end
  local v44_25 = function()
    if not v40_21 then
      local v0 = fps_optimize.list:get()
      for _FORV_4_ = 1, #v0 do
        local v6 = v41_24[v0[_FORV_4_]]
        for _FORV_10_ = 1, #v6 do
          local v11 = v6[_FORV_10_]
          local convar = v11.convar
          if convar ~= nil and v11.old_value == nil then
            v11.old_value = convar:get_int()
            convar:set_int(v11.new_value)
          end
        end
      end
      v40_21 = true
      return
    end
    return
  end
  local v45_22 = function()
    v43_25()
    return
  end
  local v46_15 = function()
    if v42_27() then
      v44_25()
      return
    end
    local v43_25_2 = v43_25
    return v43_25_2()
  end
  local v47_18 = function()
    v43_25()
    v44_25()
    return
  end
  fps_optimize.enabled:set_callback(function(arg1)
    local v1 = arg1:get()
    if not v1 then
      fps_optimize.list:unset_callback(v47_18)
    else
      fps_optimize.list:set_callback(v47_18, true)
    end
    if not v1 then
      v43_25()
    end
    v13_2.event_callback("shutdown", v45_22, v1)
    v13_2.event_callback("net_update_end", v46_15, v1)
    return
  end, true)
end
do
  local animation_breaker = v29_4.misc.animation_breaker
  local v40_22 = {}
  ;({})[1] = "Off"
  ;({})[2] = "Always slide"
  ;({})[3] = "Never slide"
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
          v6 = 1 < globals.tickcount() % 4
          v6 = v6 and 0.5
          v6 = v6 or 1
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
    end
    if not v1 then
      animation_breaker.smooth_animfix:unset_callback(v49_17)
    else
      animation_breaker.smooth_animfix:set_callback(v49_17, true)
    end
    v13_2.event_callback("pre_render", v48_15, v1)
    return
  end, true)
end
local v40_23 = bit.lshift(1, 3)
local v41_26 = bit.lshift(1, 4)
local v42_29 = bit.lshift(1, 9)
local v43_27 = bit.lshift(1, 10)
local v44_27 = function(arg1)
  if v14_2.is_quick_peek_assist() then
    local me = entity.get_local_player()
    if me == nil then
      return
    end
    if entity.get_prop(me, "m_movetype") ~= 2 then
      return
    end
    local usercmd = v15.get_usercmd(0, arg1.command_number)
    if usercmd == nil then
      return
    end
    usercmd.buttons = bit.band(usercmd.buttons, bit.bnot(v40_23))
    usercmd.buttons = bit.band(usercmd.buttons, bit.bnot(v41_26))
    usercmd.buttons = bit.band(usercmd.buttons, bit.bnot(v42_29))
    usercmd.buttons = bit.band(usercmd.buttons, bit.bnot(v43_27))
    return
  end
  return
end
v29_4.misc.never_slide.enabled:set_callback(function(arg1)
  v13_2.event_callback("finish_command", v44_27, arg1:get())
  return
end, true)
return
