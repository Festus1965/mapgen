-- Duane's mapgen city.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


tg_city = {}
local mod, layers_mod = tg_city, mapgen
local mod_name = 'tg_city'
local layers_name = 'mapgen'
local max_height = 31000
local node = layers_mod.node

--local Geomorph = geomorph.Geomorph

local math_abs = math.abs
local math_floor = math.floor
local math_max = math.max
local VN = vector.new

local road_w = 3
local side_w = 3
local water_diff = 8
local darkening = 0


do
	local newnode

	newnode = layers_mod.clone_node('default:stone')
	newnode.description = 'Concrete'
	newnode.is_ground_content = false
	newnode.drop = 'default:cobble'
	minetest.register_node(layers_name..':concrete', newnode)

	minetest.register_node(layers_name..':sidewalk', {
		description = 'Sidewalk',
		tiles = {'default_stone_block.png'},
		groups = {cracky = 3, level=1, stone = 1},
		drop = 'default:cobble',
		sounds = default.node_sound_stone_defaults(),
		is_ground_content = false,
	})

	minetest.register_node(layers_name..':road', {
		description = 'Road',
		tiles = {'mapgen_tarmac.png'},
		sounds = default.node_sound_stone_defaults(),
		groups = {cracky = 2, level = 1},
		is_ground_content = false,
	})

	minetest.register_node(layers_name..':road_yellow_line', {
		description = 'Road',
		tiles = {'mapgen_tarmac_yellow_line.png'},
		paramtype2 = 'facedir',
		sounds = default.node_sound_stone_defaults(),
		groups = {cracky = 2, level = 1},
		is_ground_content = false,
	})


	minetest.register_node(layers_name..':floor_ceiling', {
		description = 'Floor/Ceiling',
		tiles = {'mapgen_floor.png^[colorize:#000000:'..darkening, 'mapgen_ceiling.png', 'default_stone.png'},
		paramtype2 = 'facedir',
		groups = {cracky = 3, level=1, flammable = 3},
		drop = 'default:cobble',
		drop = {
			max_items = 3,
			items = {
				{
					items = {'default:cobble',},
					rarity = 1,
				},
				{
					items = {'default:steel_ingot',},
					rarity = 6,
				},
			},
		},
		sounds = default.node_sound_stone_defaults(),
		is_ground_content = false,
	})

	minetest.register_node(layers_name..':roof', {
		description = 'Roof',
		tiles = {'mapgen_tarmac.png', 'mapgen_ceiling.png', 'default_stone.png'},
		paramtype2 = 'facedir',
		groups = {cracky = 3, level=1, flammable = 3},
		drop = 'default:cobble',
		sounds = default.node_sound_stone_defaults(),
		is_ground_content = false,
	})

	minetest.register_node(layers_name..':plate_glass', {
		description = 'Plate Glass',
		drawtype = 'glasslike',
		paramtype = 'light',
		sunlight_propagates = true,
		tiles = {'mapgen_plate_glass.png'},
		light_source = 1,
		use_texture_alpha = 'blend',
		is_ground_content = false,
		groups = {cracky = 3, level=2},
		sounds = default.node_sound_stone_defaults(),
		is_ground_content = false,
	})

	minetest.register_node(layers_name..':light_panel', {
		description = 'Light Panel',
		tiles = {'default_sandstone.png'},
		light_source = 14,
		paramtype = 'light',
		paramtype2 = 'facedir',
		drawtype = 'nodebox',
		node_box = { type = 'fixed',
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.48, 0.5},
		} },
		groups = {cracky = 3, level=1, oddly_breakable_by_hand = 1},
		--drop = 'squaresville:light_panel_broken',
		on_place = minetest.rotate_and_place,
		sounds = default.node_sound_stone_defaults(),
		is_ground_content = false,
	})
end


-----------------------------------------------
-- City_Mapgen class
-----------------------------------------------

--local City_Mapgen = layers_mod.subclass_mapgen()


function mod.generate_city(params)
	local minp, maxp = params.isect_minp, params.isect_maxp
	local water_level = params.sealevel
	local area, data, p2data = params.area, params.data, params.vmparam2

	local csize = vector.add(vector.subtract(maxp, minp), 1)
	local ystride = area.ystride
	params.csize = csize

	local n_stone = node['default:stone']
	local n_air = node['air']
	local n_ignore = node['ignore']

	local base_level = params.sealevel + water_diff
	params.share.base_level = base_level

	local surface = {}
	for z = minp.z, maxp.z do
		surface[z] = {}
		for x = minp.x, maxp.x do
			local height = base_level

			surface[z][x] = {
				top = height,
				biome = layers_mod.undefined_biome,
			}

			-- Start at the bottom and fill up.
			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				if not (data[ivm] == n_air or data[ivm] == n_ignore) then
					-- nop
				elseif y <= height then
					-- Otherwise, it's stoned.
					data[ivm] = n_stone
					p2data[ivm] = 0
				end

				ivm = ivm + ystride
			end
		end
	end

	params.share.surface = surface
	params.share.height_min = base_level
	params.share.height_max = base_level
	params.share.flattened = true
end


layers_mod.register_mapgen('tg_city', mod.generate_city)
--if layers_mod.register_spawn then
--	layers_mod.register_spawn('tg_city', mod.get_spawn_level)
--end


function mod:_init()
	self.biomemap = {}
	self.heatmap = {}
	self.humiditymap = {}
end


function mod:generate()
	if self.share.disruptive then
		return
	end
	self.share.disruptive = 'city'

	self.gpr = PcgRandom(self.seed + 2565)

	self:prepare()
	self:map_height()
	self:place_terrain()
	self:place_building()
end


function mod:map_height()
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


function mod:build_walls_glass(geo, pos, size)
	geo:add({
		action = 'cube',
		node = layers_name .. ':plate_glass',
		location = VN(pos.x, pos.y, pos.z),
		size = table.copy(size),
	})

	geo:add({
		action = 'cube',
		node = 'air',
		location = VN(pos.x + 1, pos.y, pos.z + 1),
		size = VN(size.x - 2, size.y, size.z - 2),
	})

	for i = 0, size.x, 6 do
		geo:add({
			action = 'cube',
			node = layers_name..':concrete',
			location = VN(pos.x + i, pos.y, pos.z + size.z - 1),
			size = VN(1, size.y, 1),
		})

		geo:add({
			action = 'cube',
			node = layers_name..':concrete',
			location = VN(pos.x + i, pos.y, pos.z),
			size = VN(1, size.y, 1),
		})
	end

	for i = 0, size.z, 6 do
		geo:add({
			action = 'cube',
			node = layers_name..':concrete',
			location = VN(pos.x + size.x - 1, pos.y, pos.z + i),
			size = VN(1, size.y, 1),
		})

		geo:add({
			action = 'cube',
			node = layers_name..':concrete',
			location = VN(pos.x, pos.y, pos.z + i),
			size = VN(1, size.y, 1),
		})
	end
end


function mod:build_walls_simple(geo, pos, size)
	geo:add({
		action = 'cube',
		node = layers_name .. ':concrete',
		location = pos,
		size = table.copy(size),
	})

	geo:add({
		action = 'cube',
		node = 'air',
		location = VN(pos.x + 1, pos.y, pos.z + 1),
		size = VN(size.x - 2, size.y, size.z - 2),
	})

	for k = 1, size.y, 5 do
		for i = 2, size.x, 6 do
			geo:add({
				action = 'cube',
				node = layers_name..':plate_glass',
				location = VN(pos.x + i, pos.y + k, pos.z + size.z - 1),
				size = VN(3, 2, 1),
			})

			geo:add({
				action = 'cube',
				node = layers_name..':plate_glass',
				location = VN(pos.x + i, pos.y + k, pos.z),
				size = VN(3, 2, 1),
			})
		end

		for i = 2, size.z, 6 do
			geo:add({
				action = 'cube',
				node = layers_name..':plate_glass',
				location = VN(pos.x + size.z - 1, pos.y + k, pos.z + i),
				size = VN(1, 2, 3),
			})

			geo:add({
				action = 'cube',
				node = layers_name..':plate_glass',
				location = VN(pos.x, pos.y + k, pos.z + i),
				size = VN(1, 2, 3),
			})
		end
	end
end


function mod:build_walls_slots(geo, pos, size)
	geo:add({
		action = 'cube',
		node = layers_name .. ':concrete',
		location = pos,
		size = table.copy(size),
	})

	geo:add({
		action = 'cube',
		node = 'air',
		location = VN(pos.x + 1, pos.y, pos.z + 1),
		size = VN(size.x - 2, size.y, size.z - 2),
	})

	for k = 1, size.y, 5 do
		for i = 1, size.x - 1, 2 do
			geo:add({
				action = 'cube',
				node = layers_name..':plate_glass',
				location = VN(pos.x + i, pos.y + k, pos.z + size.z - 1),
				size = VN(1, 2, 1),
			})

			geo:add({
				action = 'cube',
				node = layers_name..':plate_glass',
				location = VN(pos.x + i, pos.y + k, pos.z),
				size = VN(1, 2, 1),
			})
		end

		for i = 1, size.z - 1, 2 do
			geo:add({
				action = 'cube',
				node = layers_name..':plate_glass',
				location = VN(pos.x + size.z - 1, pos.y + k, pos.z + i),
				size = VN(1, 2, 1),
			})

			geo:add({
				action = 'cube',
				node = layers_name..':plate_glass',
				location = VN(pos.x, pos.y + k, pos.z + i),
				size = VN(1, 2, 1),
			})
		end
	end
end


function mod:place_building()
	local minp = self.minp
	local ground_level = self.ground_level

	--local geo = Geomorph.new(params)
	local geo = Geomorph.new()

	local build_offset = road_w * 2 + 1 + side_w
	local build_width = 80 - build_offset - side_w

	local sr = self.gpr:next(1, 3)
	local stories = self.gpr:next(1, 7)
	local pos = VN(build_offset, ground_level + 1, build_offset)
	local size = VN(build_width, stories * 5, build_width)

	if sr == 1 then
		self:build_walls_glass(geo, pos, size)
	elseif sr == 2 then
		self:build_walls_simple(geo, pos, size)
	elseif sr == 3 then
		self:build_walls_slots(geo, pos, size)
	end

	local y = ground_level
	for s = 1, stories do
		geo:add({
			action = 'cube',
			node = layers_name .. ':floor_ceiling',
			location = VN(pos.x + 1, pos.y + (s - 1) * 5 - 1, pos.z + 1),
			size = VN(size.x - 2, 1, size.z - 2),
		})

		geo:add({
			action = 'cube',
			node = layers_name .. ':light_panel',
			location = VN(pos.x + 1, pos.y + (s - 1) * 5 + 3, pos.z + 1),
			size = VN(size.x - 2, 1, size.z - 2),
			param2 = 20,
			pattern = 1,
		})
	end

	geo:add({
		action = 'cube',
		node = layers_name .. ':roof',
		location = VN(pos.x + 1, pos.y + stories * 5 - 1, pos.z + 1),
		size = VN(size.x - 2, 1, size.z - 2),
	})

	geo:write_to_map(self, 0)
end


function mod:place_terrain()
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
			node = layers_name..':road',
			location = VN(0, ground_level, 0),
			size = VN(80, 1, 80),
		})

		local road_width = road_w * 2 + 1
		geo:add({
			action = 'cube',
			node = layers_name..':sidewalk',
			location = VN(road_width, ground_level - 1, road_width),
			size = VN(80 - road_width, 2, 80 - road_width),
		})

		local side_width = road_width + side_w
		geo:add({
			action = 'cube',
			node = layers_name..':concrete',
			location = VN(side_width, ground_level - 1, side_width),
			size = VN(80 - side_width - side_w, 2, 80 - side_width - side_w),
		})

		geo:add({
			action = 'cube',
			node = layers_name..':road_yellow_line',
			location = VN(road_w, ground_level, road_width),
			size = VN(1, 1, 80 - road_width),
		})

		geo:add({
			action = 'cube',
			node = layers_name..':road_yellow_line',
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


function mod:prepare()
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


--[[
do
	local terrain_scale = 100
	local max_chunks = layers_mod.max_chunks

	local chunksize = tonumber(minetest.settings:get("chunksize") or 5)
	local csize = { x=chunksize * 16, y=chunksize * 16, z=chunksize * 16 }
	local rsize = vector.add(csize, road_w * 2)

	local noises = {
		-----------------------------------------------
		-- Copy from terrain somehow?
		-----------------------------------------------
		road_1 = { def = { offset = 0, scale = terrain_scale, seed = 4382, spread = {x = 320, y = 320, z = 320}, octaves = 3, persist = 0.5, lacunarity = 2.0}, size = rsize, },
	}


	layers_mod.register_map({
		name = 'city',
		mapgen = City_Mapgen,
		mapgen_name = 'city',
		map_minp = VN(-2, 0, -2),
		map_maxp = VN(2, 2, 2),
		--map_minp = VN(-max_chunks, 70, -max_chunks),
		--map_maxp = VN(max_chunks, 72, max_chunks),
		noises = noises,
		water_level = 1,
		--water_level = 5569,
	})
end
--]]
