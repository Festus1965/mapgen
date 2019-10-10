-- Duane's mapgen default_biomes.lua

-- This information was adapted from Minetest Game, distributed
--  under the LGPLv2.1, and copyrighted by:

-- Originally by celeron55, Perttu Ahola <celeron55@gmail.com> (LGPLv2.1+)
-- Various Minetest developers and contributors (LGPLv2.1+)


local mod = mapgen
local mod_name = 'mapgen'


mod.register_biome({
	y_min = 4,
	source = "default",
	node_dust = "default:snow",
	depth_filler = 3,
	node_filler = "default:dirt",
	depth_top = 1,
	y_max = 31000,
	name = "taiga",
	node_top = "default:dirt_with_snow",
	node_riverbed = "default:sand",
	heat_point = 25,
	depth_riverbed = 2,
	humidity_point = 70
})
mod.register_biome({
	humidity_point = 50,
	name = "underground",
	source = "default",
	y_min = -31000,
	y_max = -113,
	heat_point = 50
})
mod.register_biome({
	y_min = -112,
	source = "default",
	depth_filler = 3,
	vertical_blend = 1,
	node_filler = "default:sand",
	depth_top = 1,
	humidity_point = 65,
	heat_point = 86,
	node_top = "default:sand",
	node_riverbed = "default:sand",
	y_max = -2,
	depth_riverbed = 2,
	name = "rainforest_ocean"
})
mod.register_biome({
	y_min = -8,
	depth_water_top = 10,
	node_dust = "default:snowblock",
	depth_filler = 3,
	node_filler = "default:snowblock",
	depth_top = 1,
	node_top = "default:snowblock",
	node_water_top = "default:ice",
	node_river_water = "default:ice",
	node_stone = "default:cave_ice",
	y_max = 31000,
	heat_point = 0,
	source = "default",
	node_riverbed = "default:gravel",
	humidity_point = 73,
	depth_riverbed = 2,
	name = "icesheet"
})
mod.register_biome({
	y_min = -112,
	source = "default",
	depth_filler = 3,
	node_filler = "default:sand",
	humidity_point = 35,
	y_max = 3,
	name = "grassland_ocean",
	node_top = "default:sand",
	node_riverbed = "default:sand",
	heat_point = 50,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = 4,
	node_stone = "default:desert_stone",
	depth_filler = 1,
	source = "default",
	node_filler = "default:desert_sand",
	depth_top = 1,
	y_max = 31000,
	name = "desert",
	node_top = "default:desert_sand",
	node_riverbed = "default:sand",
	heat_point = 92,
	depth_riverbed = 2,
	humidity_point = 16
})
mod.register_biome({
	y_min = -112,
	source = "default",
	depth_filler = 3,
	vertical_blend = 1,
	node_filler = "default:sand",
	depth_top = 1,
	humidity_point = 40,
	heat_point = 0,
	node_top = "default:sand",
	node_riverbed = "default:gravel",
	y_max = -4,
	depth_riverbed = 2,
	name = "tundra_ocean"
})
mod.register_biome({
	y_min = -112,
	node_stone = "default:desert_stone",
	source = "default",
	depth_filler = 3,
	vertical_blend = 1,
	node_filler = "default:sand",
	depth_top = 1,
	humidity_point = 16,
	heat_point = 92,
	node_top = "default:sand",
	node_riverbed = "default:sand",
	y_max = 3,
	depth_riverbed = 2,
	name = "desert_ocean"
})
mod.register_biome({
	y_min = -112,
	depth_water_top = 10,
	node_dust = "default:snowblock",
	depth_filler = 3,
	node_filler = "default:sand",
	depth_top = 1,
	source = "default",
	name = "icesheet_ocean",
	node_top = "default:sand",
	node_water_top = "default:ice",
	y_max = -9,
	heat_point = 0,
	humidity_point = 73
})
mod.register_biome({
	y_min = -1,
	source = "default",
	depth_filler = 3,
	node_filler = "default:dirt",
	humidity_point = 65,
	y_max = 0,
	name = "rainforest_swamp",
	node_top = "default:dirt",
	node_riverbed = "default:sand",
	heat_point = 86,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = 2,
	source = "default",
	depth_filler = 1,
	vertical_blend = 4,
	node_filler = "default:permafrost",
	depth_top = 1,
	humidity_point = 40,
	heat_point = 0,
	node_top = "default:permafrost_with_stones",
	node_riverbed = "default:gravel",
	y_max = 46,
	depth_riverbed = 2,
	name = "tundra"
})
mod.register_biome({
	y_min = 1,
	source = "default",
	depth_filler = 3,
	node_filler = "default:dirt",
	humidity_point = 65,
	y_max = 31000,
	name = "rainforest",
	node_top = "default:dirt_with_rainforest_litter",
	node_riverbed = "default:sand",
	heat_point = 86,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = -112,
	source = "default",
	depth_filler = 3,
	vertical_blend = 1,
	node_filler = "default:sand",
	depth_top = 1,
	humidity_point = 0,
	heat_point = 40,
	node_top = "default:sand",
	node_riverbed = "default:sand",
	y_max = 3,
	depth_riverbed = 2,
	name = "cold_desert_ocean"
})
mod.register_biome({
	y_min = 4,
	source = "default",
	node_dust = "default:snow",
	depth_filler = 1,
	node_filler = "default:dirt",
	depth_top = 1,
	y_max = 31000,
	name = "snowy_grassland",
	node_top = "default:dirt_with_snow",
	node_riverbed = "default:sand",
	heat_point = 20,
	depth_riverbed = 2,
	humidity_point = 35
})
mod.register_biome({
	y_min = 1,
	source = "default",
	depth_filler = 1,
	node_filler = "default:dirt",
	humidity_point = 42,
	y_max = 31000,
	name = "savanna",
	node_top = "default:dirt_with_dry_grass",
	node_riverbed = "default:sand",
	heat_point = 89,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = -112,
	source = "default",
	depth_filler = 3,
	vertical_blend = 1,
	node_filler = "default:sand",
	depth_top = 1,
	humidity_point = 42,
	heat_point = 89,
	node_top = "default:sand",
	node_riverbed = "default:sand",
	y_max = -2,
	depth_riverbed = 2,
	name = "savanna_ocean"
})
mod.register_biome({
	y_min = 6,
	source = "default",
	depth_filler = 3,
	node_filler = "default:dirt",
	humidity_point = 70,
	y_max = 31000,
	name = "coniferous_forest",
	node_top = "default:dirt_with_coniferous_litter",
	node_riverbed = "default:sand",
	heat_point = 45,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = 4,
	source = "default",
	depth_filler = 1,
	node_filler = "default:silver_sand",
	humidity_point = 0,
	y_max = 31000,
	name = "cold_desert",
	node_top = "default:silver_sand",
	node_riverbed = "default:sand",
	heat_point = 40,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = 4,
	source = "default",
	depth_filler = 2,
	vertical_blend = 1,
	node_filler = "default:sand",
	depth_top = 1,
	humidity_point = 35,
	heat_point = 50,
	node_top = "default:sand",
	node_riverbed = "default:sand",
	y_max = 5,
	depth_riverbed = 2,
	name = "grassland_dunes"
})
mod.register_biome({
	y_min = -112,
	node_stone = "default:sandstone",
	depth_filler = 3,
	source = "default",
	node_filler = "default:sand",
	depth_top = 1,
	y_max = 3,
	name = "sandstone_desert_ocean",
	node_top = "default:sand",
	node_riverbed = "default:sand",
	heat_point = 60,
	depth_riverbed = 2,
	humidity_point = 0
})
mod.register_biome({
	y_min = 4,
	source = "default",
	depth_filler = 3,
	vertical_blend = 1,
	node_filler = "default:sand",
	depth_top = 1,
	humidity_point = 70,
	heat_point = 45,
	node_top = "default:sand",
	node_riverbed = "default:sand",
	y_max = 5,
	depth_riverbed = 2,
	name = "coniferous_forest_dunes"
})
mod.register_biome({
	y_min = -112,
	source = "default",
	depth_filler = 3,
	node_filler = "default:sand",
	humidity_point = 70,
	y_max = 3,
	name = "coniferous_forest_ocean",
	node_top = "default:sand",
	node_riverbed = "default:sand",
	heat_point = 45,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = 1,
	source = "default",
	depth_filler = 3,
	node_filler = "default:dirt",
	humidity_point = 68,
	y_max = 31000,
	name = "deciduous_forest",
	node_top = "default:dirt_with_grass",
	node_riverbed = "default:sand",
	heat_point = 60,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = 4,
	node_stone = "default:sandstone",
	depth_filler = 1,
	source = "default",
	node_filler = "default:sand",
	depth_top = 1,
	y_max = 31000,
	name = "sandstone_desert",
	node_top = "default:sand",
	node_riverbed = "default:sand",
	heat_point = 60,
	depth_riverbed = 2,
	humidity_point = 0
})
mod.register_biome({
	y_min = -3,
	source = "default",
	depth_filler = 2,
	vertical_blend = 1,
	node_filler = "default:gravel",
	depth_top = 1,
	humidity_point = 40,
	heat_point = 0,
	node_top = "default:gravel",
	node_riverbed = "default:gravel",
	y_max = 1,
	depth_riverbed = 2,
	name = "tundra_beach"
})
mod.register_biome({
	y_min = -1,
	source = "default",
	depth_filler = 3,
	node_filler = "default:dirt",
	humidity_point = 68,
	y_max = 0,
	name = "deciduous_forest_shore",
	node_top = "default:dirt",
	node_riverbed = "default:sand",
	heat_point = 60,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = 6,
	source = "default",
	depth_filler = 1,
	node_filler = "default:dirt",
	humidity_point = 35,
	y_max = 31000,
	name = "grassland",
	node_top = "default:dirt_with_grass",
	node_riverbed = "default:sand",
	heat_point = 50,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = -1,
	source = "default",
	depth_filler = 3,
	node_filler = "default:dirt",
	humidity_point = 42,
	y_max = 0,
	name = "savanna_shore",
	node_top = "default:dirt",
	node_riverbed = "default:sand",
	heat_point = 89,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = -112,
	source = "default",
	depth_filler = 3,
	vertical_blend = 1,
	node_filler = "default:sand",
	depth_top = 1,
	humidity_point = 68,
	heat_point = 60,
	node_top = "default:sand",
	node_riverbed = "default:sand",
	y_max = -2,
	depth_riverbed = 2,
	name = "deciduous_forest_ocean"
})
mod.register_biome({
	y_min = -112,
	source = "default",
	node_dust = "default:snow",
	depth_filler = 3,
	vertical_blend = 1,
	node_filler = "default:sand",
	humidity_point = 70,
	name = "taiga_ocean",
	heat_point = 25,
	node_top = "default:sand",
	node_riverbed = "default:sand",
	y_max = 3,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_biome({
	y_min = -112,
	source = "default",
	node_dust = "default:snow",
	depth_filler = 3,
	vertical_blend = 1,
	node_filler = "default:sand",
	humidity_point = 35,
	name = "snowy_grassland_ocean",
	heat_point = 20,
	node_top = "default:sand",
	node_riverbed = "default:sand",
	y_max = 3,
	depth_riverbed = 2,
	depth_top = 1
})
mod.register_decoration({
	y_min = -1,
	biomes = {
		"rainforest",
		"rainforest_swamp"
	},
	schematic = mod.path.."/schematics/jungle_tree.mts",
	y_max = 31000,
	source = "default",
	rotation = "random",
	place_on = {
		"default:dirt_with_rainforest_litter",
		"default:dirt"
	},
	name = "default:jungle_tree",
	fill_ratio = 0.1,
	sidelen = 80,
	deco_type = "schematic",
	flags = "place_center_x, place_center_z",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 254,
				ypos = 2
			},
			{
				prob = 254,
				ypos = 3
			},
			{
				prob = 254,
				ypos = 4
			},
			{
				prob = 254,
				ypos = 5
			},
			{
				prob = 190,
				ypos = 6
			},
			{
				prob = 190,
				ypos = 7
			},
			{
				prob = 190,
				ypos = 8
			},
			{
				prob = 190,
				ypos = 9
			},
			{
				prob = 190,
				ypos = 10
			},
			{
				prob = 254,
				ypos = 11
			},
			{
				prob = 254,
				ypos = 12
			},
			{
				prob = 254,
				ypos = 13
			},
			{
				prob = 254,
				ypos = 14
			},
			{
				prob = 254,
				ypos = 15
			},
			{
				prob = 254,
				ypos = 16
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 17,
			x = 5,
			z = 5
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.02,
		persist = 0.6,
		seed = 1220999,
		scale = 0.04,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:dandelion_yellow",
	name = "flowers:dandelion_yellow",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 4,
	biomes = {
		"desert"
	},
	noise_params = {
		offset = -0.0003,
		persist = 0.6,
		seed = 230,
		scale = 0.0009,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	source = "default",
	y_max = 31000,
	decoration = "default:cactus",
	name = "default:cactus",
	place_on = {
		"default:desert_sand"
	},
	height_max = 5,
	deco_type = "simple",
	height = 2,
	sidelen = 16
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"savanna"
	},
	noise_params = {
		offset = 0.03,
		persist = 0.6,
		seed = 329,
		scale = 0.03,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:dry_grass_4",
	name = "default:dry_grass_4",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_dry_grass"
	}
})
mod.register_decoration({
	y_min = 4,
	biomes = {
		"desert"
	},
	noise_params = {
		offset = -0.0003,
		persist = 0.6,
		seed = 230,
		scale = 0.0009,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/large_cactus.mts",
	rotation = "random",
	y_max = 31000,
	source = "default",
	name = "default:large_cactus",
	place_on = {
		"default:desert_sand"
	},
	sidelen = 16,
	deco_type = "schematic",
	flags = "place_center_x, place_center_z",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 126,
				ypos = 2
			},
			{
				prob = 254,
				ypos = 3
			},
			{
				prob = 254,
				ypos = 4
			},
			{
				prob = 254,
				ypos = 5
			},
			{
				prob = 254,
				ypos = 6
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 20,
				prob = 254,
				name = "default:cactus",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 20,
				prob = 254,
				name = "default:cactus",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 20,
				name = "default:cactus",
				prob = 254
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 7,
			x = 5,
			z = 5
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"savanna"
	},
	noise_params = {
		offset = -0.004,
		persist = 0.7,
		seed = 90155,
		scale = 0.01,
		spread = {
			y = 100,
			x = 100,
			z = 100
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/acacia_bush.mts",
	y_max = 31000,
	flags = "place_center_x, place_center_z",
	name = "default:acacia_bush",
	source = "default",
	sidelen = 16,
	deco_type = "schematic",
	place_on = {
		"default:dirt_with_dry_grass"
	},
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 254,
				ypos = 2
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_bush_stem",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_bush_leaves",
				prob = 62
			}
		},
		size = {
			y = 3,
			x = 3,
			z = 3
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = 0,
		persist = 0.6,
		seed = 329,
		scale = 0.06,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:grass_3",
	name = "default:grass_3",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.02,
		persist = 0.6,
		seed = 800081,
		scale = 0.04,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:chrysanthemum_green",
	name = "flowers:chrysanthemum_green",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	place_offset_y = -4,
	biomes = {
		"rainforest"
	},
	noise_params = {
		offset = 0,
		persist = 0.7,
		seed = 2685,
		scale = 0.0025,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/emergent_jungle_tree.mts",
	rotation = "random",
	source = "default",
	y_max = 32,
	place_on = {
		"default:dirt_with_rainforest_litter"
	},
	name = "default:emergent_jungle_tree",
	flags = "place_center_x, place_center_z",
	sidelen = 80,
	deco_type = "schematic",
	y_min = 1,
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 254,
				ypos = 2
			},
			{
				prob = 254,
				ypos = 3
			},
			{
				prob = 254,
				ypos = 4
			},
			{
				prob = 254,
				ypos = 5
			},
			{
				prob = 254,
				ypos = 6
			},
			{
				prob = 254,
				ypos = 7
			},
			{
				prob = 254,
				ypos = 8
			},
			{
				prob = 254,
				ypos = 9
			},
			{
				prob = 254,
				ypos = 10
			},
			{
				prob = 254,
				ypos = 11
			},
			{
				prob = 254,
				ypos = 12
			},
			{
				prob = 126,
				ypos = 13
			},
			{
				prob = 126,
				ypos = 14
			},
			{
				prob = 126,
				ypos = 15
			},
			{
				prob = 126,
				ypos = 16
			},
			{
				prob = 126,
				ypos = 17
			},
			{
				prob = 126,
				ypos = 18
			},
			{
				prob = 126,
				ypos = 19
			},
			{
				prob = 126,
				ypos = 20
			},
			{
				prob = 126,
				ypos = 21
			},
			{
				prob = 126,
				ypos = 22
			},
			{
				prob = 126,
				ypos = 23
			},
			{
				prob = 126,
				ypos = 24
			},
			{
				prob = 254,
				ypos = 25
			},
			{
				prob = 254,
				ypos = 26
			},
			{
				prob = 254,
				ypos = 27
			},
			{
				prob = 254,
				ypos = 28
			},
			{
				prob = 254,
				ypos = 29
			},
			{
				prob = 254,
				ypos = 30
			},
			{
				prob = 254,
				ypos = 31
			},
			{
				prob = 254,
				ypos = 32
			},
			{
				prob = 254,
				ypos = 33
			},
			{
				prob = 254,
				ypos = 34
			},
			{
				prob = 254,
				ypos = 35
			},
			{
				prob = 254,
				ypos = 36
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:jungletree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:jungleleaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 37,
			x = 7,
			z = 7
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"snowy_grassland"
	},
	noise_params = {
		offset = -0.004,
		persist = 0.7,
		seed = 697,
		scale = 0.01,
		spread = {
			y = 100,
			x = 100,
			z = 100
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/blueberry_bush.mts",
	flags = "place_center_x, place_center_z",
	y_max = 31000,
	source = "default",
	name = "default:blueberry_bush",
	place_on = {
		"default:dirt_with_grass",
		"default:dirt_with_snow"
	},
	sidelen = 16,
	deco_type = "schematic",
	place_offset_y = 1,
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			}
		},
		data = {
			{
				param2 = 0,
				name = "default:blueberry_bush_leaves_with_berries",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:blueberry_bush_leaves_with_berries",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:blueberry_bush_leaves_with_berries",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:blueberry_bush_leaves_with_berries",
				prob = 94
			},
			{
				param2 = 0,
				prob = 126,
				name = "default:blueberry_bush_leaves_with_berries",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:blueberry_bush_leaves_with_berries",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:blueberry_bush_leaves_with_berries",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:blueberry_bush_leaves_with_berries",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:blueberry_bush_leaves_with_berries",
				prob = 94
			}
		},
		size = {
			y = 1,
			x = 3,
			z = 3
		}
	}
})
mod.register_decoration({
	y_min = 6,
	biomes = {
		"coniferous_forest",
		"floatland_coniferous_forest"
	},
	noise_params = {
		offset = 0,
		persist = 0.7,
		seed = 5,
		scale = 0.2,
		spread = {
			y = 100,
			x = 100,
			z = 100
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:fern_1",
	name = "default:fern_1",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_coniferous_litter"
	}
})
mod.register_decoration({
	y_min = 4,
	biomes = {
		"taiga",
		"coniferous_forest",
		"floatland_coniferous_forest"
	},
	noise_params = {
		offset = 0.01,
		persist = 0.66,
		seed = 2,
		scale = -0.048,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/small_pine_tree.mts",
	y_max = 31000,
	flags = "place_center_x, place_center_z",
	name = "default:small_pine_tree",
	source = "default",
	sidelen = 16,
	deco_type = "schematic",
	place_on = {
		"default:dirt_with_snow",
		"default:dirt_with_coniferous_litter"
	},
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 126,
				ypos = 2
			},
			{
				prob = 126,
				ypos = 3
			},
			{
				prob = 126,
				ypos = 4
			},
			{
				prob = 254,
				ypos = 5
			},
			{
				prob = 254,
				ypos = 6
			},
			{
				prob = 254,
				ypos = 7
			},
			{
				prob = 254,
				ypos = 8
			},
			{
				prob = 254,
				ypos = 9
			},
			{
				prob = 254,
				ypos = 10
			},
			{
				prob = 254,
				ypos = 11
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 12,
			x = 5,
			z = 5
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"savanna"
	},
	noise_params = {
		offset = 0.09,
		persist = 0.6,
		seed = 329,
		scale = -0.03,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:dry_grass_1",
	name = "default:dry_grass_1",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_dry_grass"
	}
})
mod.register_decoration({
	y_min = 4,
	biomes = {
		"taiga",
		"snowy_grassland"
	},
	noise_params = {
		offset = -0.004,
		persist = 0.7,
		seed = 137,
		scale = 0.01,
		spread = {
			y = 100,
			x = 100,
			z = 100
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/pine_bush.mts",
	y_max = 31000,
	flags = "place_center_x, place_center_z",
	name = "default:pine_bush",
	source = "default",
	sidelen = 16,
	deco_type = "schematic",
	place_on = {
		"default:dirt_with_snow"
	},
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 254,
				ypos = 2
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_bush_stem",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_bush_needles",
				prob = 126
			}
		},
		size = {
			y = 3,
			x = 3,
			z = 3
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.02,
		persist = 0.6,
		seed = 19822,
		scale = 0.04,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:tulip",
	name = "flowers:tulip",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"deciduous_forest",
		"coniferous_forest",
		"floatland_coniferous_forest"
	},
	noise_params = {
		offset = 0,
		persist = 0.66,
		seed = 2,
		scale = 0.006,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:mushroom_red",
	name = "flowers:mushroom_red",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"deciduous_forest"
	},
	noise_params = {
		offset = 0,
		persist = 0.66,
		seed = 2,
		scale = -0.015,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/aspen_tree.mts",
	y_max = 31000,
	flags = "place_center_x, place_center_z",
	name = "default:aspen_tree",
	source = "default",
	sidelen = 16,
	deco_type = "schematic",
	place_on = {
		"default:dirt_with_grass"
	},
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 126,
				ypos = 2
			},
			{
				prob = 126,
				ypos = 3
			},
			{
				prob = 254,
				ypos = 4
			},
			{
				prob = 254,
				ypos = 5
			},
			{
				prob = 254,
				ypos = 6
			},
			{
				prob = 254,
				ypos = 7
			},
			{
				prob = 126,
				ypos = 8
			},
			{
				prob = 254,
				ypos = 9
			},
			{
				prob = 126,
				ypos = 10
			},
			{
				prob = 254,
				ypos = 11
			},
			{
				prob = 254,
				ypos = 12
			},
			{
				prob = 254,
				ypos = 13
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:aspen_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:aspen_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 14,
			x = 5,
			z = 5
		}
	}
})
mod.register_decoration({
	place_offset_y = 2,
	spawn_by = "group:flower",
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	},
	y_max = 31000,
	decoration = {
		"butterflies:butterfly_white",
		"butterflies:butterfly_red",
		"butterflies:butterfly_violet"
	},
	name = "butterflies:butterfly",
	fill_ratio = 0.005,
	sidelen = 80,
	num_spawn_by = 1,
	y_min = 1,
	deco_type = "simple"
})
mod.register_decoration({
	place_offset_y = -1,
	biomes = {
		"taiga_ocean",
		"snowy_grassland_ocean",
		"grassland_ocean",
		"coniferous_forest_ocean",
		"deciduous_forest_ocean",
		"sandstone_desert_ocean",
		"cold_desert_ocean"
	},
	noise_params = {
		offset = -0.04,
		persist = 0.7,
		seed = 87112,
		scale = 0.1,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	source = "default",
	place_on = {
		"default:sand"
	},
	y_min = -10,
	param2 = 48,
	decoration = "default:sand_with_kelp",
	name = "default:kelp",
	flags = "force_placement",
	sidelen = 16,
	deco_type = "simple",
	param2_max = 96,
	y_max = -5
})
mod.register_decoration({
	y_min = 0,
	biomes = {
		"rainforest_swamp",
		"savanna_shore",
		"deciduous_forest_shore"
	},
	noise_params = {
		offset = -0.12,
		persist = 0.7,
		seed = 33,
		scale = 0.3,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	source = "default",
	place_on = {
		"default:dirt"
	},
	y_max = 0,
	param2_max = 3,
	name = "default:waterlily",
	param2 = 0,
	sidelen = 16,
	deco_type = "simple",
	place_offset_y = 1,
	decoration = "flowers:waterlily"
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"savanna"
	},
	noise_params = {
		offset = 0.01,
		persist = 0.6,
		seed = 329,
		scale = 0.05,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:dry_grass_5",
	name = "default:dry_grass_5",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_dry_grass"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"deciduous_forest",
		"coniferous_forest",
		"floatland_coniferous_forest"
	},
	noise_params = {
		offset = 0,
		persist = 0.66,
		seed = 2,
		scale = 0.006,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:mushroom_brown",
	name = "flowers:mushroom_brown",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.02,
		persist = 0.6,
		seed = 42,
		scale = 0.04,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:tulip_black",
	name = "flowers:tulip_black",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.02,
		persist = 0.6,
		seed = 73133,
		scale = 0.04,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:dandelion_white",
	name = "flowers:dandelion_white",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 2,
	biomes = {
		"tundra"
	},
	noise_params = {
		offset = -0.8,
		persist = 1,
		seed = 53995,
		scale = 2,
		spread = {
			y = 100,
			x = 100,
			z = 100
		},
		octaves = 3
	},
	y_max = 50,
	decoration = "default:permafrost_with_moss",
	place_on = {
		"default:permafrost_with_stones"
	},
	source = "default",
	sidelen = 4,
	deco_type = "simple",
	place_offset_y = -1,
	flags = "force_placement"
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.02,
		persist = 0.6,
		seed = 36662,
		scale = 0.04,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:geranium",
	name = "flowers:geranium",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = 0.015,
		persist = 0.6,
		seed = 329,
		scale = 0.045,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:grass_2",
	name = "default:grass_2",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.004,
		persist = 0.7,
		seed = 137,
		scale = 0.01,
		spread = {
			y = 100,
			x = 100,
			z = 100
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/bush.mts",
	y_max = 31000,
	flags = "place_center_x, place_center_z",
	name = "default:bush",
	source = "default",
	sidelen = 16,
	deco_type = "schematic",
	place_on = {
		"default:dirt_with_grass"
	},
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 254,
				ypos = 2
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:bush_stem",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:bush_leaves",
				prob = 126
			}
		},
		size = {
			y = 3,
			x = 3,
			z = 3
		}
	}
})
mod.register_decoration({
	place_offset_y = 2,
	biomes = {
		"deciduous_forest",
		"coniferous_forest",
		"rainforest",
		"rainforest_swamp"
	},
	source = "default",
	y_max = 31000,
	decoration = "fireflies:hidden_firefly",
	name = "fireflies:firefly_low",
	fill_ratio = 0.0005,
	sidelen = 80,
	deco_type = "simple",
	place_on = {
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter",
		"default:dirt_with_rainforest_litter",
		"default:dirt"
	},
	y_min = -1
})
mod.register_decoration({
	place_offset_y = -1,
	biomes = {
		"desert_ocean",
		"savanna_ocean",
		"rainforest_ocean"
	},
	noise_params = {
		offset = -4,
		persist = 0.7,
		seed = 7013,
		scale = 4,
		spread = {
			y = 50,
			x = 50,
			z = 50
		},
		octaves = 3
	},
	source = "default",
	flags = "force_placement",
	decoration = {
		"default:coral_green",
		"default:coral_pink",
		"default:coral_cyan",
		"default:coral_brown",
		"default:coral_orange",
		"default:coral_skeleton"
	},
	name = "default:corals",
	place_on = {
		"default:sand"
	},
	sidelen = 4,
	deco_type = "simple",
	y_min = -8,
	y_max = -2
})
mod.register_decoration({
	place_offset_y = 3,
	biomes = {
		"deciduous_forest",
		"coniferous_forest",
		"rainforest",
		"rainforest_swamp"
	},
	source = "default",
	y_max = 31000,
	decoration = "fireflies:hidden_firefly",
	name = "fireflies:firefly_high",
	fill_ratio = 0.0005,
	sidelen = 80,
	deco_type = "simple",
	place_on = {
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter",
		"default:dirt_with_rainforest_litter",
		"default:dirt"
	},
	y_min = -1
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.02,
		persist = 0.6,
		seed = 1133,
		scale = 0.04,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:viola",
	name = "flowers:viola",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = 0.03,
		persist = 0.6,
		seed = 329,
		scale = 0.03,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:grass_1",
	name = "default:grass_1",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 4,
	biomes = {
		"coniferous_forest_dunes",
		"grassland_dunes"
	},
	noise_params = {
		offset = -0.4,
		persist = 0.5,
		seed = 513337,
		scale = 3,
		octaves = 1,
		spread = {
			y = 16,
			x = 16,
			z = 16
		},
		flags = "absvalue"
	},
	y_max = 6,
	decoration = {
		"default:marram_grass_1",
		"default:marram_grass_2",
		"default:marram_grass_3"
	},
	name = "default:marram_grass",
	sidelen = 4,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:sand"
	}
})
mod.register_decoration({
	y_min = 2,
	biomes = {
		"desert",
		"sandstone_desert",
		"cold_desert"
	},
	noise_params = {
		offset = 0,
		persist = 0.6,
		seed = 329,
		scale = 0.02,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:dry_shrub",
	name = "default:dry_shrub",
	source = "default",
	sidelen = 16,
	deco_type = "simple",
	place_on = {
		"default:desert_sand",
		"default:sand",
		"default:silver_sand"
	},
	param2 = 4
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.03,
		persist = 0.6,
		seed = 329,
		scale = 0.09,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:grass_5",
	name = "default:grass_5",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"rainforest"
	},
	y_max = 31000,
	decoration = "default:junglegrass",
	name = "default:junglegrass",
	fill_ratio = 0.1,
	sidelen = 80,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_rainforest_litter"
	}
})
mod.register_decoration({
	y_min = 6,
	biomes = {
		"coniferous_forest",
		"floatland_coniferous_forest"
	},
	noise_params = {
		offset = 0,
		persist = 0.7,
		seed = 801,
		scale = 0.2,
		spread = {
			y = 100,
			x = 100,
			z = 100
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:fern_2",
	name = "default:fern_2",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_coniferous_litter"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"deciduous_forest"
	},
	noise_params = {
		offset = 0.024,
		persist = 0.66,
		seed = 2,
		scale = 0.015,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/apple_tree.mts",
	rotation = "random",
	y_max = 31000,
	source = "default",
	name = "default:apple_tree",
	place_on = {
		"default:dirt_with_grass"
	},
	sidelen = 16,
	deco_type = "schematic",
	flags = "place_center_x, place_center_z",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 126,
				ypos = 2
			},
			{
				prob = 254,
				ypos = 3
			},
			{
				prob = 254,
				ypos = 4
			},
			{
				prob = 254,
				ypos = 5
			},
			{
				prob = 254,
				ypos = 6
			},
			{
				prob = 254,
				ypos = 7
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:apple",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:apple",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:apple",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:apple",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 8,
			x = 7,
			z = 7
		}
	}
})
mod.register_decoration({
	y_min = 4,
	biomes = {
		"taiga",
		"coniferous_forest",
		"floatland_coniferous_forest"
	},
	noise_params = {
		offset = 0.01,
		persist = 0.66,
		seed = 2,
		scale = 0.048,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/pine_tree.mts",
	y_max = 31000,
	flags = "place_center_x, place_center_z",
	name = "default:pine_tree",
	source = "default",
	sidelen = 16,
	deco_type = "schematic",
	place_on = {
		"default:dirt_with_snow",
		"default:dirt_with_coniferous_litter"
	},
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 126,
				ypos = 2
			},
			{
				prob = 126,
				ypos = 3
			},
			{
				prob = 126,
				ypos = 4
			},
			{
				prob = 126,
				ypos = 5
			},
			{
				prob = 254,
				ypos = 6
			},
			{
				prob = 254,
				ypos = 7
			},
			{
				prob = 254,
				ypos = 8
			},
			{
				prob = 126,
				ypos = 9
			},
			{
				prob = 254,
				ypos = 10
			},
			{
				prob = 254,
				ypos = 11
			},
			{
				prob = 126,
				ypos = 12
			},
			{
				prob = 254,
				ypos = 13
			},
			{
				prob = 254,
				ypos = 14
			},
			{
				prob = 254,
				ypos = 15
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:pine_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:pine_needles",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 16,
			x = 5,
			z = 5
		}
	}
})
mod.register_decoration({
	place_offset_y = 1,
	spawn_by = "default:dirt_with_rainforest_litter",
	biomes = {
		"rainforest",
		"rainforest_swamp"
	},
	y_max = 31000,
	source = "default",
	schematic = mod.path .. "/schematics/jungle_log.mts",
	place_on = {
		"default:dirt_with_rainforest_litter"
	},
	y_min = 1,
	rotation = "random",
	deco_type = "schematic",
	name = "default:jungle_log",
	fill_ratio = 0.005,
	sidelen = 80,
	num_spawn_by = 8,
	flags = "place_center_x",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			}
		},
		data = {
			{
				param2 = 12,
				name = "default:jungletree",
				prob = 126
			},
			{
				param2 = 12,
				name = "default:jungletree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:jungletree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:jungletree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:jungletree",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "flowers:mushroom_brown",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 2,
			x = 5,
			z = 1
		}
	}
})
mod.register_decoration({
	y_min = 6,
	biomes = {
		"coniferous_forest",
		"floatland_coniferous_forest"
	},
	noise_params = {
		offset = 0,
		persist = 0.7,
		seed = 14936,
		scale = 0.2,
		spread = {
			y = 100,
			x = 100,
			z = 100
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:fern_3",
	name = "default:fern_3",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_coniferous_litter"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.02,
		persist = 0.6,
		seed = 436,
		scale = 0.04,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "flowers:rose",
	name = "flowers:rose",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	place_offset_y = 1,
	spawn_by = "default:dirt_with_dry_grass",
	biomes = {
		"savanna"
	},
	rotation = "random",
	noise_params = {
		offset = 0,
		persist = 0.66,
		seed = 2,
		scale = 0.001,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/acacia_log.mts",
	source = "default",
	place_on = {
		"default:dirt_with_dry_grass"
	},
	y_max = 31000,
	y_min = 1,
	name = "default:acacia_log",
	deco_type = "schematic",
	sidelen = 16,
	num_spawn_by = 8,
	flags = "place_center_x",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			}
		},
		data = {
			{
				param2 = 12,
				name = "default:acacia_tree",
				prob = 126
			},
			{
				param2 = 12,
				name = "default:acacia_tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:acacia_tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:acacia_tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:acacia_tree",
				prob = 126
			}
		},
		size = {
			y = 1,
			x = 5,
			z = 1
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"grassland",
		"deciduous_forest",
		"floatland_grassland"
	},
	noise_params = {
		offset = -0.015,
		persist = 0.6,
		seed = 329,
		scale = 0.075,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:grass_4",
	name = "default:grass_4",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"savanna"
	},
	noise_params = {
		offset = 0.05,
		persist = 0.6,
		seed = 329,
		scale = 0.01,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:dry_grass_3",
	name = "default:dry_grass_3",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_dry_grass"
	}
})
mod.register_decoration({
	place_offset_y = 1,
	spawn_by = {
		"default:dirt_with_snow",
		"default:dirt_with_coniferous_litter"
	},
	biomes = {
		"taiga",
		"coniferous_forest",
		"floatland_coniferous_forest"
	},
	y_max = 31000,
	source = "default",
	schematic = mod.path .. "/schematics/pine_log.mts",
	place_on = {
		"default:dirt_with_snow",
		"default:dirt_with_coniferous_litter"
	},
	y_min = 4,
	rotation = "random",
	deco_type = "schematic",
	name = "default:pine_log",
	fill_ratio = 0.0018,
	sidelen = 80,
	num_spawn_by = 8,
	flags = "place_center_x",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			}
		},
		data = {
			{
				param2 = 12,
				name = "default:pine_tree",
				prob = 126
			},
			{
				param2 = 12,
				name = "default:pine_tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:pine_tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:pine_tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:pine_tree",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "flowers:mushroom_red",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 2,
			x = 5,
			z = 1
		}
	}
})
mod.register_decoration({
	place_offset_y = 1,
	spawn_by = "default:dirt_with_grass",
	biomes = {
		"deciduous_forest"
	},
	rotation = "random",
	noise_params = {
		offset = 0.0012,
		persist = 0.66,
		seed = 2,
		scale = 0.0007,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/apple_log.mts",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	},
	y_max = 31000,
	y_min = 1,
	name = "default:apple_log",
	deco_type = "schematic",
	sidelen = 16,
	num_spawn_by = 8,
	flags = "place_center_x",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			}
		},
		data = {
			{
				param2 = 12,
				name = "default:tree",
				prob = 126
			},
			{
				param2 = 12,
				name = "default:tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:tree",
				prob = 254
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "flowers:mushroom_brown",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 2,
			x = 4,
			z = 1
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"savanna"
	},
	noise_params = {
		offset = 0,
		persist = 0.66,
		seed = 2,
		scale = 0.002,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/acacia_tree.mts",
	rotation = "random",
	y_max = 31000,
	source = "default",
	name = "default:acacia_tree",
	place_on = {
		"default:dirt_with_dry_grass"
	},
	sidelen = 16,
	deco_type = "schematic",
	flags = "place_center_x, place_center_z",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 126,
				ypos = 2
			},
			{
				prob = 126,
				ypos = 3
			},
			{
				prob = 126,
				ypos = 4
			},
			{
				prob = 254,
				ypos = 5
			},
			{
				prob = 254,
				ypos = 6
			},
			{
				prob = 254,
				ypos = 7
			},
			{
				prob = 254,
				ypos = 8
			}
		},
		data = {
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:acacia_tree",
				force_place = true
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 126
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "default:acacia_leaves",
				prob = 94
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 9,
			x = 9,
			z = 9
		}
	}
})
mod.register_decoration({
	y_min = 0,
	biomes = {
		"savanna_shore"
	},
	noise_params = {
		offset = -0.3,
		persist = 0.7,
		seed = 354,
		scale = 0.7,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/papyrus.mts",
	y_max = 0,
	name = "default:papyrus",
	place_on = {
		"default:dirt"
	},
	sidelen = 16,
	deco_type = "schematic",
	source = "default",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			},
			{
				prob = 126,
				ypos = 2
			},
			{
				prob = 126,
				ypos = 3
			},
			{
				prob = 254,
				ypos = 4
			},
			{
				prob = 254,
				ypos = 5
			},
			{
				prob = 254,
				ypos = 6
			}
		},
		data = {
			{
				param2 = 0,
				prob = 254,
				name = "default:dirt",
				force_place = true
			},
			{
				param2 = 0,
				prob = 254,
				name = "default:dirt",
				force_place = true
			},
			{
				param2 = 0,
				name = "default:papyrus",
				prob = 254
			},
			{
				param2 = 0,
				name = "default:papyrus",
				prob = 254
			},
			{
				param2 = 0,
				name = "default:papyrus",
				prob = 254
			},
			{
				param2 = 0,
				name = "default:papyrus",
				prob = 254
			},
			{
				param2 = 0,
				name = "default:papyrus",
				prob = 254
			}
		},
		size = {
			y = 7,
			x = 1,
			z = 1
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"tundra",
		"tundra_beach"
	},
	noise_params = {
		offset = 0,
		persist = 1,
		seed = 172555,
		scale = 1,
		spread = {
			y = 100,
			x = 100,
			z = 100
		},
		octaves = 3
	},
	y_max = 50,
	decoration = "default:snow",
	place_on = {
		"default:permafrost_with_moss",
		"default:permafrost_with_stones",
		"default:stone",
		"default:gravel"
	},
	sidelen = 4,
	deco_type = "simple",
	source = "default"
})
mod.register_decoration({
	place_offset_y = 1,
	spawn_by = "default:dirt_with_grass",
	biomes = {
		"deciduous_forest"
	},
	rotation = "random",
	noise_params = {
		offset = 0,
		persist = 0.66,
		seed = 2,
		scale = -0.0008,
		spread = {
			y = 250,
			x = 250,
			z = 250
		},
		octaves = 3
	},
	schematic = mod.path .. "/schematics/aspen_log.mts",
	source = "default",
	place_on = {
		"default:dirt_with_grass"
	},
	y_max = 31000,
	y_min = 1,
	name = "default:aspen_log",
	deco_type = "schematic",
	sidelen = 16,
	num_spawn_by = 8,
	flags = "place_center_x",
	schematic_array = {
		yslice_prob = {
			{
				prob = 254,
				ypos = 0
			},
			{
				prob = 254,
				ypos = 1
			}
		},
		data = {
			{
				param2 = 12,
				name = "default:aspen_tree",
				prob = 126
			},
			{
				param2 = 12,
				name = "default:aspen_tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:aspen_tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:aspen_tree",
				prob = 254
			},
			{
				param2 = 12,
				name = "default:aspen_tree",
				prob = 126
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			},
			{
				param2 = 0,
				name = "flowers:mushroom_brown",
				prob = 62
			},
			{
				param2 = 0,
				name = "flowers:mushroom_red",
				prob = 62
			},
			{
				param2 = 0,
				name = "air",
				prob = 0
			}
		},
		size = {
			y = 2,
			x = 5,
			z = 1
		}
	}
})
mod.register_decoration({
	y_min = 1,
	biomes = {
		"savanna"
	},
	noise_params = {
		offset = 0.07,
		persist = 0.6,
		seed = 329,
		scale = -0.01,
		spread = {
			y = 200,
			x = 200,
			z = 200
		},
		octaves = 3
	},
	y_max = 31000,
	decoration = "default:dry_grass_2",
	name = "default:dry_grass_2",
	sidelen = 16,
	deco_type = "simple",
	source = "default",
	place_on = {
		"default:dirt_with_dry_grass"
	}
})
