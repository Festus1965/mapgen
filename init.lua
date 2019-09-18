-- Duane's mapgen init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


-- Prevents errors from indexing nested tables
--  that may or may not exist.
debug.setmetatable(nil, { __index=function () end })


mapgen = {}
local mod = mapgen
mod.mod_name = 'mapgen'
local mod_name = mod.mod_name

mod.version = '20190802'
mod.path = minetest.get_modpath(minetest.get_current_modname())
mod.world = minetest.get_worldpath()

--minetest.set_mapgen_setting('mg_name', 'singlenode', true)
--minetest.set_mapgen_setting('water_level', -31000, true)


mod.chunks = 0
mod.moria_chunks = 0
mod.chunksize = tonumber(minetest.settings:get("chunksize") or 5)
mod.max_height = 31000  -- maximum extent of the world
mod.multicolor = false

mod.schematics = {}


mod.stone_layer_noise = PerlinNoise({
	offset = 0,
	scale = 1,
	seed = 4587,
	spread = {x = 5, y = 10, z = 5},
	octaves = 2,
	persist = 0.5,
	lacunarity = 2.0
})


mod.time_all = 0
mod.time_caves = 0
mod.time_deco = 0
mod.time_ore = 0
mod.time_overhead = 0
mod.time_ponds = 0
mod.time_ruins = 0
mod.time_terrain = 0
mod.time_terrain_f = 0
mod.time_y_loop = 0


dofile(mod.path .. '/functions.lua')
dofile(mod.path .. '/nodes.lua')
dofile(mod.path .. '/geomorph.lua')
--dofile(mod.path .. '/plans.lua')
dofile(mod.path .. '/mapgen.lua')


minetest.register_on_shutdown(function()
  print('time caves: '..math.floor(1000 * mod.time_caves / mod.chunks))
  print('time decorations: '..math.floor(1000 * mod.time_deco / mod.chunks))
  print('time ore: '..math.floor(1000 * mod.time_ore / mod.chunks))
  print('time overhead: '..math.floor(1000 * mod.time_overhead / mod.chunks))
  print('time ponds: '..math.floor(1000 * mod.time_ponds / mod.chunks))
  print('time ruins: '..math.floor(1000 * mod.time_ruins / mod.chunks))
  print('time terrain: '..math.floor(1000 * mod.time_terrain / mod.chunks))
  print('time terrain_f: '..math.floor(1000 * mod.time_terrain_f / mod.chunks))
  print('time y loop: '..math.floor(1000 * mod.time_y_loop / mod.chunks))

  print('Total Time: '..math.floor(1000 * mod.time_all / mod.chunks))
  print('chunks: '..mod.chunks)
end)


mod.midnight_sun = minetest.setting_getbool('mapgen_midnight_sun')
if mod.midnight_sun == nil then
	mod.midnight_sun = true
end
if mod.midnight_sun then
	local NIGHT_LIGHT = 0.3
	local DAWN, DUSK = 0.2, 0.8
	local night_time
	minetest.register_globalstep(function(dtime)
		local clock = minetest.get_timeofday()
		if clock > DAWN and clock < DUSK then
			if night_time then
				night_time = nil
			else
				return
			end
		else
			if night_time then
				return
			else
				night_time = NIGHT_LIGHT
			end
		end

		local players = minetest.get_connected_players()
		if not (players and type(players) == 'table') then
			return
		end

		for i = 1, #players do
			local player = players[i]
			player:override_day_night_ratio(night_time)
			--print('override', night_time)
		end
	end)

	minetest.register_on_joinplayer(function(player)
		local clock = minetest.get_timeofday()
		if clock <= DAWN or clock >= DUSK then
			player:override_day_night_ratio(NIGHT_LIGHT)
		end
	end)
end


mod.soft_leaves = minetest.setting_getbool('mapgen_soft_leaves')
if mod.soft_leaves == nil then
	mod.soft_leaves = true
end
if mod.soft_leaves then
	for k, v in pairs(minetest.registered_nodes) do
		if v.groups.leaves then
			minetest.override_item(k, { walkable = false })
		end
	end
end
