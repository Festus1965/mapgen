-- Duane's mapgen init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


mapgen = {}
local mod = mapgen
local mod_name = 'mapgen'

mod.version = '20190602'
mod.path = minetest.get_modpath(minetest.get_current_modname())
mod.world = minetest.get_worldpath()

minetest.set_mapgen_setting('mg_name', 'singlenode', true)
minetest.set_mapgen_setting('water_level', -31000, true)


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
mod.time_terrain = 0
mod.time_terrain_f = 0
mod.time_y_loop = 0


dofile(mod.path .. '/functions.lua')
dofile(mod.path .. '/nodes.lua')
dofile(mod.path .. '/plans.lua')
dofile(mod.path .. '/mapgen.lua')
dofile(mod.path .. '/dflat.lua')
dofile(mod.path .. '/valleys.lua')
dofile(mod.path .. '/pillars.lua')
dofile(mod.path .. '/city.lua')
dofile(mod.path .. '/cloudscape.lua')
dofile(mod.path .. '/floaters.lua')
dofile(mod.path .. '/scaves.lua')
dofile(mod.path .. '/roads.lua')
dofile(mod.path .. '/planets.lua')
dofile(mod.path .. '/spirals.lua')
