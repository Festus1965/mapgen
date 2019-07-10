-- Duane's mapgen scaves.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

local Geomorph = geomorph.Geomorph

local math_abs = math.abs
local math_floor = math.floor
local math_max = math.max
local math_min = math.min
local node = layer_mod.node
local os_clock = os.clock
local VN = vector.new

local water_diff = 8

local altitude_cutoff_high = 30
local altitude_cutoff_low = -10
local altitude_cutoff_low_2 = 63
local cave_underground = 5


--dofile(mod.path..'/scaves_biomes.lua')


local cave_biomes = {}
function mod.register_cave_biome(def)
	def.underground = true
	cave_biomes[def.name] = def
end

do
    mod.register_cave_biome({
        name = 'stone',
        heat_point = 30,
        humidity_point = 50,
    })

    mod.register_cave_biome({
        name = 'wet_stone',
        node_cave_liquid = 'default:water_source',
        heat_point = 100,
        humidity_point = 100,
    })

    mod.register_cave_biome({
        name = 'sea_cave',
        node_gas = 'default:water_source',
        heat_point = 50,
        humidity_point = 115,
    })

    mod.register_cave_biome({
        name = 'lichen',
        node_cave_liquid = 'default:water_source',
        node_lining = mod_name..':stone_with_lichen',
        heat_point = 15,
        humidity_point = 20,
    })

    mod.register_cave_biome({
        name = 'algae',
        node_lining = mod_name..':stone_with_algae',
        node_cave_liquid = 'default:water_source',
        heat_point = 65,
        humidity_point = 75,
    })

    mod.register_cave_biome({
        name = 'mossy',
        node_lining = mod_name..':stone_with_moss',
        node_cave_liquid = 'default:water_source',
        heat_point = 25,
        humidity_point = 75,
    })

    mod.register_cave_biome({
        name = 'granite_lava',
        node_stone = mod_name..':granite',
        node_cave_liquid = 'default:lava_source',
        heat_point = 105,
        humidity_point = 70,
    })

    mod.register_cave_biome({
        name = 'salt',
        node_lining = mod_name..':stone_with_salt',
		surface_depth = 2,
        heat_point = 50,
        humidity_point = -5,
    })

    mod.register_cave_biome({
        name = 'basalt',
        node_lining = mod_name..':basalt',
        heat_point = 60,
        humidity_point = 50,
    })

    mod.register_cave_biome({
        name = 'sand',
        node_ceiling = 'default:sandstone',
        node_floor = 'default:sand',
		surface_depth = 2,
        heat_point = 70,
        humidity_point = 25,
    })

    mod.register_cave_biome({
        name = 'coal',
        node_lining = mod_name..':black_sand',
		node_stone = mod_name..':basalt',
		surface_depth = 2,
        heat_point = 110,
        humidity_point = 0,
    })

    mod.register_cave_biome({
        name = 'hot',
        node_floor = mod_name..':hot_rock',
		node_stone = mod_name..':granite',
        node_cave_liquid = 'default:lava_source',
        heat_point = 120,
        humidity_point = 35,
    })

    mod.register_cave_biome({
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


-----------------------------------------------
-- SCaves_Mapgen class
-----------------------------------------------

local SCaves_Mapgen = layer_mod.subclass_mapgen()


function SCaves_Mapgen:get_spawn_level(map, x, z)
	-- ?????????
end


-- This is only called for one point, so don't map it.
local scaves_heat = { def = { offset = 50, scale = 50, seed = 1578, spread = {x = 200, y = 200, z = 200}, octaves = 3, persist = 0.5, lacunarity = 2 }, }
function SCaves_Mapgen:generate()
	if self.share.disruptive then
		--print(self.share.disruptive, ' calls disruptive')
		return
	end

	local minp, maxp = self.minp, self.maxp
	local height_max = self.share.height_max
	local height_min = self.share.height_min

	if not (height_max and height_min) then
		self.stone_fill = true
		local csize = self.csize
		local max_height = layer_mod.max_height
		local heightmap = self.heightmap
		for i = 1, csize.z * csize.x do
			heightmap[i] = max_height
		end
	elseif height_max < minp.y then
		return
	end

	local csize = self.csize
	local water_level = self.water_level

	self.gpr = PcgRandom(self.seed + 5107)
	self.no_dust = true

	local center = vector.add(minp, vector.divide(csize, 2))
	local heat = minetest.get_perlin(scaves_heat.def):get2d({x=center.x, y=center.z})
	local cave_depth_mod = -10 - math_floor((minp.y - water_level + self.chunk_offset) / 80) * 5
	heat = heat + cave_depth_mod
	--local humidity = self.humiditymap[(csize.z / 2) * csize.x + csize.x / 2 + 1] or self.gpr:next(1, 100)
	local humidity = self.gpr:next(1, 100)
	local biome_height = center.y - water_level

	local biomes_i = {}
	for _, b in pairs(self.biomes) do
		table.insert(biomes_i, b)
	end
	self.biome = self:get_biome(biomes_i, heat, humidity, biome_height)

	local t_cave = os_clock()
	self:simple_caves()
	layer_mod.time_caves = layer_mod.time_caves + os_clock() - t_cave
end


-- check
local cave_underground = 5
function SCaves_Mapgen:simple_caves()
	local minp, maxp = self.minp, self.maxp
	local pr = self.gpr
	local csize = self.csize

	local geo = Geomorph.new()

	local biome = self.biome
	local liquid = biome.node_cave_liquid

	if self.stone_fill then
		geo:add({
			action = 'cube',
			node = biome.node_stone or 'default:stone',
			location = VN(0,0,0),
			size = csize,
		})
	elseif biome.node_stone then
		geo:add({
			action = 'cube',
			node = biome.node_stone,
			location = VN(0,0,0),
			intersect = 'default:stone',
			underground = 20,
			size = csize,
		})
	end

	for _ = 1, 40 do
		local size = VN(
			pr:next(9, 25),
			pr:next(9, 25),
			pr:next(9, 25)
		)
		local big = pr:next(1, 10)
		if big == 1 then
			size.x = pr:next(9, 78)
		elseif big == 2 then
			size.y = pr:next(9, 78)
		elseif big == 3 then
			size.z = pr:next(9, 78)
		end

		local pos = VN(
			pr:next(1, 79 - size.x),
			pr:next(1, 79 - size.y),
			pr:next(1, 79 - size.z)
		)

		local index = pos.z * csize.x + pos.x + 1

		if maxp.y < self.water_level or pos.y <= self.heightmap[index] then
			if biome.node_floor or biome.node_ceiling then
				local hpos = vector.add(pos, -(biome.surface_depth or 1))
				local hsize = vector.add(size, (2 * (biome.surface_depth or 1)))
				local hy = math_floor(hsize.y / 2)
				if biome.node_floor then
					geo:add({
						action = 'sphere',
						node = biome.node_floor,
						location = hpos,
						intersect = { biome.node_stone or 'default:stone' },
						underground = cave_underground,
						size = hsize,
					})
					geo:add({
						action = 'cube',
						node = biome.node_stone or 'default:stone',
						location = VN(hpos.x, hpos.y + hy, hpos.z),
						intersect = { biome.node_floor },
						underground = cave_underground,
						size = VN(hsize.x, hy, hsize.z)
					})
				end
				if biome.node_ceiling then
					geo:add({
						action = 'sphere',
						node = biome.node_ceiling,
						location = hpos,
						intersect = { biome.node_stone or 'default:stone' },
						underground = cave_underground,
						size = hsize,
					})
					geo:add({
						action = 'cube',
						node = biome.node_stone or 'default:stone',
						location = VN(hpos.x, hpos.y, hpos.z),
						intersect = { biome.node_ceiling },
						underground = cave_underground,
						size = VN(hsize.x, hy, hsize.z)
					})
				end
			elseif biome.node_lining then
				geo:add({
					action = 'sphere',
					node = biome.node_lining,
					location = vector.add(pos, -(biome.surface_depth or 1)),
					intersect = { biome.node_stone or 'default:stone' },
					underground = cave_underground,
					size = vector.add(size, (2 * (biome.surface_depth or 1))),
				})
			end

			geo:add({
				action = 'sphere',
				node = 'air',
				location = vector.add(pos, 1),
				underground = cave_underground,
				size = vector.add(size, -2),
			})
			geo:add({
				action = 'sphere',
				node = 'air',
				random = 6,
				location = pos,
				underground = cave_underground,
				size = size,
			})
		end
	end

	if minp.y < self.water_level and liquid then
		geo:add({
			action = 'cube',
			node = liquid,
			location = VN(1, 1, 1),
			underground = cave_underground,
			intersect = 'air',
			size = VN(78, pr:next(10, 40), 78),
		})
	end

	geo:write_to_map(self)
end


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------

local function level_biomes(water_level)
	local biomes = {}
	for n, v in pairs(cave_biomes) do
		local def = table.copy(v)
		if def.y_max then
			def.y_max = def.y_max + water_level - 1
		end
		if def.y_min then
			def.y_min = def.y_min + water_level - 1
		end
		biomes[n] = def
	end
	return biomes
end

do
	local max_chunks = layer_mod.max_chunks

	local water_level = 1
	local biomes = level_biomes(water_level)
	layer_mod.register_map({
		name = 'scaves',
		biomes = biomes,
		mapgen = SCaves_Mapgen,
		mapgen_name = 'scaves',
		map_minp = VN(-max_chunks, -20, -max_chunks),
		map_maxp = VN(max_chunks, 3, max_chunks),
		water_level = water_level,
	})

	water_level = 2000
	local biomes = level_biomes(water_level)
	layer_mod.register_map({
		name = 'scaves',
		biomes = biomes,
		mapgen = SCaves_Mapgen,
		mapgen_name = 'scaves',
		map_minp = VN(-max_chunks, 17, -max_chunks),
		map_maxp = VN(max_chunks, 30, max_chunks),
		water_level = water_level,
	})

	layer_mod.register_map({
		name = 'scaves',
		biomes = biomes,
		mapgen = SCaves_Mapgen,
		mapgen_name = 'scaves',
		map_minp = VN(-max_chunks, 47, -max_chunks),
		map_maxp = VN(max_chunks, 57, max_chunks),
		water_level = 4640,
	})
end
