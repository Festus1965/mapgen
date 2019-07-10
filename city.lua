-- Duane's mapgen city.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

local Geomorph = geomorph.Geomorph

local math_abs = math.abs
local math_floor = math.floor
local math_max = math.max
local node = layer_mod.node
local VN = vector.new

local road_w = 3
local water_diff = 8


do
	local newnode

	newnode = layer_mod.clone_node('default:stone')
	newnode.description = 'Concrete'
	newnode.is_ground_content = false
	newnode.drop = 'default:cobble'
	minetest.register_node(mod_name..':concrete', newnode)

	minetest.register_node(mod_name..':sidewalk', {
		description = 'Sidewalk',
		tiles = {'default_stone_block.png'},
		groups = {cracky = 3, level=1, stone = 1},
		drop = 'default:cobble',
		sounds = default.node_sound_stone_defaults(),
		is_ground_content = false,
	})

	minetest.register_node(mod_name..':road', {
		description = 'Road',
		tiles = {'mapgen_tarmac.png'},
		sounds = default.node_sound_stone_defaults(),
		groups = {cracky = 2, level = 1},
		is_ground_content = false,
	})

	minetest.register_node(mod_name..':road_yellow_line', {
		description = 'Road',
		tiles = {'mapgen_tarmac_yellow_line.png'},
		paramtype2 = 'facedir',
		sounds = default.node_sound_stone_defaults(),
		groups = {cracky = 2, level = 1},
		is_ground_content = false,
	})
end


-----------------------------------------------
-- City_Mapgen class
-----------------------------------------------

local City_Mapgen = layer_mod.subclass_mapgen()


function City_Mapgen:generate()
	if self.share.disruptive then
		return
	end
	self.share.disruptive = 'city'

	self.gpr = PcgRandom(self.seed + 2565)

	self:prepare()
	self:map_height()
	self:place_terrain()
	--self:place_building()
end


function City_Mapgen:map_height()
	local minp, maxp = self.minp, self.maxp
	local heightmap = self.heightmap
	local base_level = self.share.base_level

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			heightmap[index] = base_level
			index = index + 1
		end
	end

	self.share.height_min = base_level
	self.share.height_max = base_level

	self.share.flattened = true
end


function City_Mapgen:place_building()
	local minp = self.minp
	local ground_level = self.ground_level

	local geo = Geomorph.new()

	local pos = VN(5, ground_level - 1, 5)
	local size = VN(70, 19, 70)
	geo:add({
		action = 'cube',
		node = mod_name .. ':concrete',
		location = pos,
		size = size,
	})
	pos = vector.add(pos, 1)
	size = vector.add(size, -2)
	geo:add({
		action = 'cube',
		node = 'air',
		location = pos,
		size = size,
	})

	geo:write_to_map(self, 0)
end


function City_Mapgen:place_terrain()
	local minp = self.minp
	local ground_level = self.ground_level

	local geo = Geomorph.new()


	-- ground level is relative to this cube. (so, inverted)
	if ground_level >= 0 then
		geo:add({
			action = 'cube',
			node = 'default:stone',
			location = VN(0, 0, 0),
			size = VN(80, 80, 80),
		})
	end

	if ground_level >= 0 and ground_level <= 80 then
		geo:add({
			action = 'cube',
			node = 'air',
			location = VN(0, ground_level + 1, 0),
			size = VN(80, 80 - ground_level - 1, 80),
		})

		geo:add({
			action = 'cube',
			node = 'default:dirt',
			location = VN(0, ground_level - 1, 0),
			size = VN(80, 1, 80),
		})

		local road_width = road_w * 2 + 1
		geo:add({
			action = 'cube',
			node = mod_name..':road',
			location = VN(0, ground_level, 0),
			size = VN(80, 1, 80),
		})

		local road_width = road_w * 2 + 1
		geo:add({
			action = 'cube',
			node = mod_name..':sidewalk',
			location = VN(road_width, ground_level - 1, road_width),
			size = VN(80 - road_width, 2, 80 - road_width),
		})

		local side_width = road_width + 2
		geo:add({
			action = 'cube',
			node = mod_name..':concrete',
			location = VN(side_width, ground_level - 1, side_width),
			size = VN(80 - side_width - 2, 2, 80 - side_width - 2),
		})

		geo:add({
			action = 'cube',
			node = mod_name..':road_yellow_line',
			location = VN(road_w, ground_level, road_width),
			size = VN(1, 1, 80 - road_width),
		})

		geo:add({
			action = 'cube',
			node = mod_name..':road_yellow_line',
			location = VN(road_width, ground_level, road_w),
			size = VN(80 - road_width, 1, 1),
			param2 = 1,
		})

		geo:add({
			action = 'cube',
			node = 'air',
			location = VN(road_w, ground_level - 14, road_w),
			size = VN(1, 15, 1),
		})

		geo:add({
			action = 'cube',
			node = 'doors:trapdoor_steel',
			location = VN(road_w, ground_level + 1, road_w),
			size = VN(1, 1, 1),
			param2 = 0,
		})

		geo:add({
			action = 'cube',
			node = 'air',
			location = VN(0, ground_level - 14, 0),
			size = VN(road_width, road_width, 80),
		})

		geo:add({
			action = 'cube',
			node = 'air',
			location = VN(0, ground_level - 14, 0),
			size = VN(80, road_width, road_width),
			param2 = 1,
		})

		geo:add({
			action = 'cube',
			node = 'default:water_source',
			location = VN(0, ground_level - 14, 0),
			size = VN(road_width, 1, 80),
		})

		geo:add({
			action = 'cube',
			node = 'default:water_source',
			location = VN(0, ground_level - 14, 0),
			size = VN(80, 1, road_width),
			param2 = 1,
		})

		geo:add({
			action = 'ladder',
			node = 'default:ladder_steel',
			location = VN(road_w, ground_level - 14, road_w),
			size = VN(1, 15, 1),
			param2 = 4,
		})
	end

	geo:write_to_map(self, 0)
end


function City_Mapgen:prepare()
	local minp = self.minp

	local base_level = self.water_level + water_diff
	self.share.base_level = base_level

	local chunk_offset = self.chunk_offset
	local ground_level = (self.share.base_level or 10) - minp.y - self.water_level
	self.ground_level = ground_level
end


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------


do
	local terrain_scale = 100
	local max_chunks = layer_mod.max_chunks

	local chunksize = tonumber(minetest.settings:get("chunksize") or 5)
	local csize = { x=chunksize * 16, y=chunksize * 16, z=chunksize * 16 }
	local rsize = vector.add(csize, road_w * 2)

	local noises = {
		-----------------------------------------------
		-- Copy from terrain somehow?
		-----------------------------------------------
		road_1 = { def = { offset = 0, scale = terrain_scale, seed = 4382, spread = {x = 320, y = 320, z = 320}, octaves = 3, persist = 0.5, lacunarity = 2.0}, size = rsize, },
	}


	layer_mod.register_map({
		name = 'city',
		mapgen = City_Mapgen,
		mapgen_name = 'city',
		map_minp = VN(-2, 0, -2),
		map_maxp = VN(2, 15, 2),
		--map_minp = VN(-max_chunks, 70, -max_chunks),
		--map_maxp = VN(max_chunks, 72, max_chunks),
		noises = noises,
		water_level = 1,
		--water_level = 5569,
	})
end
