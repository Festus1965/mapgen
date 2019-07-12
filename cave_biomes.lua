-- Duane's mapgen cave_biomes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

if mod.registered_cave_biomes then
	return
end


local cave_biomes = {}
mod.cave_biomes = cave_biomes

function register_cave_biome(def)
	def.underground = true
	mod.cave_biomes[def.name] = def
end
mod.register_cave_biome = register_cave_biome

do
    register_cave_biome({
        name = 'stone',
        heat_point = 30,
        humidity_point = 50,
    })

    register_cave_biome({
        name = 'wet_stone',
        node_cave_liquid = 'default:water_source',
        heat_point = 100,
        humidity_point = 100,
    })

    register_cave_biome({
        name = 'sea_cave',
        node_gas = 'default:water_source',
        heat_point = 50,
        humidity_point = 115,
    })

    register_cave_biome({
        name = 'lichen',
        node_cave_liquid = 'default:water_source',
        node_lining = mod_name..':stone_with_lichen',
        heat_point = 15,
        humidity_point = 20,
    })

    register_cave_biome({
        name = 'algae',
        node_lining = mod_name..':stone_with_algae',
        node_cave_liquid = 'default:water_source',
        heat_point = 65,
        humidity_point = 75,
    })

    register_cave_biome({
        name = 'mossy',
        node_lining = mod_name..':stone_with_moss',
        node_cave_liquid = 'default:water_source',
        heat_point = 25,
        humidity_point = 75,
    })

    register_cave_biome({
        name = 'granite_lava',
        node_stone = mod_name..':granite',
        node_cave_liquid = 'default:lava_source',
        heat_point = 105,
        humidity_point = 70,
    })

    register_cave_biome({
        name = 'salt',
        node_lining = mod_name..':stone_with_salt',
		surface_depth = 2,
        heat_point = 50,
        humidity_point = -5,
    })

    register_cave_biome({
        name = 'basalt',
        node_lining = mod_name..':basalt',
        heat_point = 60,
        humidity_point = 50,
    })

    register_cave_biome({
        name = 'sand',
        node_ceiling = 'default:sandstone',
        node_floor = 'default:sand',
		surface_depth = 2,
        heat_point = 70,
        humidity_point = 25,
    })

    register_cave_biome({
        name = 'coal',
        node_lining = mod_name..':black_sand',
		node_stone = mod_name..':basalt',
		surface_depth = 2,
        heat_point = 110,
        humidity_point = 0,
    })

    register_cave_biome({
        name = 'hot',
        node_floor = mod_name..':hot_rock',
		node_stone = mod_name..':granite',
        node_cave_liquid = 'default:lava_source',
        heat_point = 120,
        humidity_point = 35,
    })

    register_cave_biome({
		--deco = mod_name..':will_o_wisp_glow',
        name = 'ice',
        node_lining = 'default:ice',
		surface_depth = 4,
        heat_point = -15,
        humidity_point = 50,
    })
end


do
	local huge_mushroom_sch = {
		size = { x=1, y=3, z=1 },
		data = {
			{ name = 'default:dirt', force_place = true, },
			{ name = mod_name..':giant_mushroom_stem', },
			{ name = mod_name..':huge_mushroom_cap', },
		},
	}

	local giant_mushroom_sch = {
		size = { x=1, y=4, z=1 },
		data = {
			{ name = 'default:dirt', force_place = true, },
			{ name = mod_name..':giant_mushroom_stem', },
			{ name = mod_name..':giant_mushroom_stem', },
			{ name = mod_name..':giant_mushroom_cap', },
		},
	}

	minetest.register_decoration({
		deco_type = 'schematic',
		place_on = { 'group:natural_stone', },
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = 30,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'stone', 'algae', 'lichen', },
		schematic = huge_mushroom_sch,
		name = 'huge_mushroom',
		flags = 'all_floors',
	})

	minetest.register_decoration({
		deco_type = 'schematic',
		place_on = { 'group:natural_stone', },
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = 20,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'stone', 'algae', 'lichen', },
		schematic = giant_mushroom_sch,
		name = 'giant_mushroom',
		flags = 'all_floors',
	})

	minetest.register_node(mod_name..':glow_worm', {
		description = 'Glow worm',
		tiles = { 'mapgen_glow_worm.png' },
		selection_box = {
			type = 'fixed',
			fixed = {
				{ 0.1, -0.5, 0.1, -0.1, 0.5, -0.1, },
			},
		},
		color = '#DDEEFF',
		use_texture_alpha = true,
		light_source = 6,
		paramtype2 = 'facedir',
		walkable = false,
		groups = { oddly_breakable_by_hand=1, dig_immediate=2 },
		drawtype = 'plantlike',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:natural_stone', },
		height_max = 6,
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = 52,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'stone', 'algae', 'lichen', },
		decoration = mod_name..':glow_worm',
		name = 'glow_worm',
		flags = 'all_ceilings',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:natural_stone', },
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = -18,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'sea_cave', 'wet_stone', 'mossy', },
		decoration = mod_name..':glowing_fungal_stone',
		place_offset_y = -1,
		name = 'glowing_fungal_stone',
		flags = 'all_ceilings, all_floors',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:sand', },
		sidelen = 16,
		noise_params = {
			offset = 0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = -17,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'sand', 'sandstone', },
		decoration = mod_name..':glowing_gem',
		name = 'glowing_gem',
		flags = 'all_floors',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:natural_stone', },
		sidelen = 16,
		noise_params = {
			offset = 0.025,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = -10,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'sea_cave', },
		decoration = mod_name..':glowing_fungal_stone',
		place_offset_y = -1,
		name = 'glowing_fungal_stone_wet',
		flags = 'all_ceilings, all_floors, force_placement',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { mod_name..':granite', mod_name..':basalt', },
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.02,
			spread = { x = 200, y = 200, z = 200 },
			seed = -13,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'granite_lava', 'basalt_lava', },
		decoration = 'default:lava_source',
		name = 'lava_flow',
		place_offset_y = -1,  -- This fails in C.
		flags = 'all_ceilings',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { mod_name..':black_sand', },
		sidelen = 16,
		noise_params = {
			offset = 0.02,
			scale = 0.04,
			spread = { x = 200, y = 200, z = 200 },
			seed = -70,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'coal', },
		decoration = 'fire:permanent_flame',
		name = 'Gas Flame',
		flags = 'all_floors',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { mod_name..':black_sand', },
		sidelen = 16,
		fill_ratio = 0.04,
		place_offset_y = -1,
		biomes = { 'coal', },
		decoration = 'default:coalblock',
		name = 'Coal Seam',
		flags = 'all_floors, all_ceilings',
	})

	-- Make these grow, eventually.
	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { mod_name..':hot_rock', },
		sidelen = 16,
		fill_ratio = 0.04,
		biomes = { 'hot', },
		decoration = {
			mod_name..':hot_spike',
			mod_name..':hot_spike_2',
			mod_name..':hot_spike_3',
			mod_name..':hot_spike_4',
			mod_name..':hot_spike_5',
		},
		name = 'Hot Spike',
		flags = 'all_floors',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:natural_stone', },
		sidelen = 16,
		noise_params = {
			offset = 0.025,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = -31,
			octaves = 3,
			persist = 0.6
		},
		biomes = { 'stone', 'wet_stone', 'lichen', 'sea_cave',
			'mossy', 'algae', 'salt', 'basalt', 'sand', 'coal' },
		decoration = mod_name..':pretty_crystal',
		name = 'Pretty Crystal',
		flags = 'all_ceilings, all_floors, random_color_floor_ceiling',
	})

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'group:natural_stone', mod_name..':granite', mod_name..':hot_rock', },
		sidelen = 16,
		fill_ratio = 0.16,
		biomes = { 'granite_lava', 'hot' },
		decoration = mod_name..':pretty_crystal',
		name = 'Pretty Crystal',
		flags = 'all_ceilings, all_floors, random_color_floor_ceiling',
	})
end

mod.registered_cave_biomes = true
