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

dofile(mod.path .. '/functions.lua')
dofile(mod.path .. '/defaults.lua')
dofile(mod.path .. '/nodes.lua')
dofile(mod.path .. '/decorations.lua')
dofile(mod.path .. '/plans.lua')
dofile(mod.path .. '/mapgen.lua')
dofile(mod.path .. '/zero.lua')
dofile(mod.path .. '/roads.lua')
