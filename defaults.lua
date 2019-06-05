-- Duane's mapgen defaults.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = mapgen
local mod_name = 'mapgen'


mod.chunks = 0
mod.moria_chunks = 0
mod.chunksize = tonumber(minetest.settings:get("chunksize") or 5)
mod.max_height = 31000  -- maximum extent of the world
mod.multicolor = false

mod.chunk_offset = math.floor(mod.chunksize / 2) * 16;
mod.csize = {x=mod.chunksize * 16, y=mod.chunksize * 16, z=mod.chunksize * 16}
mod.schematics = {}
mod.spawn = {}
mod.terrain_scale = 100
mod.ground_offset = 1


mod.noise = {}

mod.noise['ground_1'] = { def = {offset = 20, scale = 10, seed = 4382, spread = {x = 23, y = 23, z = 23}, octaves = 2, persist = 0.5, lacunarity = 2.0} }
mod.noise['ground_2'] = { def = {offset = mod.ground_offset, scale = mod.terrain_scale, seed = 4382, spread = {x = 301, y = 301, z = 301}, octaves = 6, persist = 0.5, lacunarity = 2.0} }
mod.noise['road_1'] = { def = {offset = mod.ground_offset, scale = mod.terrain_scale, seed = 4382, spread = {x = 301, y = 301, z = 301}, octaves = 3, persist = 0.5, lacunarity = 2.0} }
mod.noise['heat_2'] = { def = {offset = 0, scale = 1, seed = 13, spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1.0, lacunarity = 2} }
mod.noise['humidity_1'] = { def = {offset = 50, scale = 50, seed = 842, spread = {x = 1000, y = 1000, z = 1000}, octaves = 3, persist = 0.5, lacunarity = 2} }
mod.noise['humidity_2'] = { def = {offset = 0, scale = 1.5, seed = 90003, spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1.0, lacunarity = 2} }
mod.noise['erosion'] = { def = {offset = 0, scale = 1.5, seed = -47383, spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1.0, lacunarity = 2} }
mod.noise['flat_cave_1'] = { def = {offset = 0, scale = 10, seed = 6386, spread = {x = 23, y = 23, z = 23}, octaves = 3, persist = 0.7, lacunarity = 1.8} }


mod.time_all = 0
mod.time_caves = 0
mod.time_deco = 0
mod.time_env_noise = 0
mod.time_moria = 0
mod.time_pass = 0
mod.time_pond = 0
mod.time_pyramid = 0
mod.time_ore = 0
mod.time_overhead = 0
mod.time_rb = 0
mod.time_terrain = 0
mod.time_trees = 0
mod.time_y_loop = 0
mod.time_zigg = 0
