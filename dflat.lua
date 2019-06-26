-- Duane's mapgen dflat.lua
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


dofile(mod.path..'/dflat_biomes.lua')


-----------------------------------------------
-- DFlat_Mapgen class
-----------------------------------------------

local DFlat_Mapgen = layer_mod.subclass_mapgen()


function DFlat_Mapgen:after_terrain()
	local minp, maxp = self.minp, self.maxp
	local chunk_offset = self.chunk_offset
	local water_level = self.water_level
	local ground = (maxp.y >= water_level and minp.y <= water_level)

	local do_ore = true
	if (not self.div) and ground and self.share.flattened and self.gpr:next(1, 5) == 1 then
		local sr = self.gpr:next(1, 3)
		if sr == 1 then
			self:geomorph('pyramid_temple')
		elseif sr == 2 then
			self:geomorph('pyramid')
		else
			self:simple_ruin()
		end
		do_ore = false
		self.share.disruptive = true
	end

	if do_ore then
		local t_ore = os_clock()
		self:simple_ore()
		layer_mod.time_ore = layer_mod.time_ore + os_clock() - t_ore
	end
end


function DFlat_Mapgen:generate()
	self:prepare()
	self:map_height()
	self:place_terrain()
	self:after_terrain()
end


function DFlat_Mapgen:terrain_height(ground_1, base_level, div)
	-- terrain height calculations
	local height = base_level
	if ground_1 > altitude_cutoff_high then
		height = height + (ground_1 - altitude_cutoff_high) / (div or 1)
	elseif ground_1 < altitude_cutoff_low then
		local g = altitude_cutoff_low - ground_1
		if g < altitude_cutoff_low_2 then
			g = g * g * 0.01
		else
			g = (g - altitude_cutoff_low_2) * 0.5 + 40
		end
		height = height - g / (div or 1)
	end
	return height
end


function DFlat_Mapgen:map_height()
	local minp, maxp = self.minp, self.maxp
	local ground_noise_map = self.noise['dflat_ground'].map
	local heightmap = self.heightmap
	local base_level = self.share.base_level
	local div = self.div

	local height_min = layer_mod.max_height
	local height_max = -layer_mod.max_height

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			-- terrain height calculations
			local ground_1 = ground_noise_map[index]
			local height = self:terrain_height(ground_1, base_level, div)

			height = math_floor(height + 0.5)
			heightmap[index] = height
			height_max = math_max(ground_1, height_max)
			height_min = math_min(ground_1, height_min)

			index = index + 1
		end
	end

	self.share.height_min = height_min
	self.share.height_max = height_max

	local f1 = math_max(altitude_cutoff_high, height_max - minp.y)
	local f2 = math_min(altitude_cutoff_low, height_min - minp.y)
	if (f1 - altitude_cutoff_high) - (f2 - altitude_cutoff_low) < 3 then
		self.share.flattened = true
	end
end


function DFlat_Mapgen:prepare()
	local minp, maxp = self.minp, self.maxp
	local chunk_offset = self.chunk_offset

	self.gpr = PcgRandom(self.seed + 5107)

	if self.div then
		self.share.biome = layer_mod.biomes['ether']
	end

	local base_level = self.water_level + water_diff
	if self.div then
		base_level = self.water_level + 1
	end
	self.share.base_level = base_level

	local base_heat = 20 + math_abs(70 - ((((minp.z + chunk_offset + 1000) / 6000) * 140) % 140))
	self.share.base_heat = base_heat
end


function DFlat_Mapgen:get_spawn_level(map, x, z)
	local ground_noise = minetest.get_perlin(map.noises['dflat_ground'].def)
	local ground_1 = ground_noise:get_2d({x=x, y=z, z=z})
	local base_level = map.water_level + water_diff

	local height = math_floor(self:terrain_height(ground_1, base_level))
	if height <= map.water_level then
		return
	end

	return height
end


-- check
function DFlat_Mapgen:simple_ruin()
	if not self.share.flattened then
		return
	end

	local csize = self.csize
	local heightmap = self.heightmap
	local chunk_offset = self.chunk_offset
	local base_level = self.share.base_level + chunk_offset  -- Figure from height?
	local boxes = {}

	for _ = 1, 15 do
		local scale = self.gpr:next(2, 3) * 4
		local size = VN(self.gpr:next(1, 3), 1, self.gpr:next(1, 3))
		size.x = size.x * scale + 5
		size.y = size.y * 8
		size.z = size.z * scale + 5

		for _ = 1, 10 do
			local pos = VN(self.gpr:next(1, csize.x - size.x - 2), base_level, self.gpr:next(1, csize.z - size.z - 2))
			local good = true
			for _, box in pairs(boxes) do
				if box.pos.x + box.size.x < pos.x or pos.x + size.x < box.pos.x
				or box.pos.z + box.size.z < pos.z or pos.z + size.z < box.pos.z then
					-- nop
				else
					good = false
					break
				end
			end
			if good then
				table.insert(boxes, { pos = pos, size = size })
				break
			end
		end
	end
	local geo = Geomorph.new()
	local stone = 'default:sandstone_block'
	for _, box in pairs(boxes) do
		local pos = table.copy(box.pos)
		local size = table.copy(box.size)

		for z = pos.z, pos.z + size.z do
			local index = z * csize.x + pos.x + 1
			for _ = pos.x, pos.x + size.x do
				heightmap[index] = base_level
				index = index + 1
			end
		end

		-- foundation
		pos.y = pos.y - 8
		size.y = 6
		geo:add({
			action = 'cube',
			node = 'default:dirt',
			intersect = 'air',
			location = pos,
			size = size,
		})
		pos = table.copy(box.pos)
		size = table.copy(box.size)
		pos.y = pos.y - 2
		size.y = 3
		geo:add({
			action = 'cube',
			node = stone,
			location = pos,
			size = size,
		})

		pos = table.copy(pos)
		pos.y = pos.y + 3
		size = table.copy(size)
		size.y = 1
		geo:add({
			action = 'cube',
			node = 'air',
			location = pos,
			size = size,
		})

		box.pos.x = box.pos.x + 2
		box.pos.z = box.pos.z + 2
		box.size.x = box.size.x - 4
		box.size.z = box.size.z - 4

		pos = table.copy(box.pos)
		pos.y = pos.y + 8
		size = table.copy(box.size)
		size.y = 1
		geo:add({
			action = 'cube',
			node = stone,
			location = pos,
			size = size,
		})
		pos = vector.add(box.pos, 1)
		pos.y = pos.y + 8
		size = vector.add(box.size, -2)
		size.y = 1
		geo:add({
			action = 'cube',
			node = stone,
			location = pos,
			size = size,
		})
		pos = table.copy(pos)
		pos.y = pos.y - 1
		geo:add({
			action = 'cube',
			node = 'air',
			location = pos,
			size = size,
		})
		local pool = 14
		if box.size.x > pool and box.size.z > pool then
			pos = vector.add(box.pos, (pool / 2) - 1)
			pos.y = box.pos.y + 1
			size = vector.add(box.size, -(pool - 2))
			size.y = 1
			geo:add({
				action = 'cube',
				node = stone,
				location = pos,
				size = size,
			})
			pos = vector.add(box.pos, pool / 2)
			pos.y = box.pos.y + 1
			size = vector.add(box.size, -pool)
			size.y = 1
			geo:add({
				action = 'cube',
				node = 'default:water_source',
				location = pos,
				size = size,
			})
		end

		for z = box.pos.z, box.pos.z + box.size.z, 4 do
			for x = box.pos.x, box.pos.x + box.size.x, 4 do
				if x == box.pos.x or x == box.pos.x + box.size.x - 1
				or z == box.pos.z or z == box.pos.z + box.size.z - 1 then
					geo:add({
						action = 'cube',
						node = stone,
						location = VN(x, box.pos.y, z),
						size = VN(1, box.size.y, 1),
					})
				end
			end
		end
	end
	geo:write_to_map(self)

	return true
end


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------

do
	local terrain_scale = 100

	local ether_div = 8
	local max_chunks = layer_mod.max_chunks
	local max_chunks_ether = math_floor(layer_mod.max_chunks / ether_div)

	local noises = {
		dflat_ground = { def = { offset = 0, scale = terrain_scale, seed = 4382, spread = {x = 320, y = 320, z = 320}, octaves = 6, persist = 0.5, lacunarity = 2.0}, },
		heat_blend = { def = { offset = 0, scale = 4, seed = 5349, spread = {x = 10, y = 10, z = 10}, octaves = 3, persist = 0.5, lacunarity = 2, flags = 'eased' }, },
		erosion = { def = { offset = 0, scale = 1.5, seed = -47383, spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1.0, lacunarity = 2 }, },
		flat_cave_1 = { def = { offset = 0, scale = 10, seed = 6386, spread = {x = 23, y = 23, z = 23}, octaves = 3, persist = 0.7, lacunarity = 1.8 }, },
		cave_heat = { def = { offset = 50, scale = 50, seed = 1578, spread = {x = 200, y = 200, z = 200}, octaves = 3, persist = 0.5, lacunarity = 2 }, },
	}

	local e_noises = { dflat_ground = table.copy(noises.dflat_ground) }
	e_noises.dflat_ground.def.spread = vector.divide(e_noises.dflat_ground.def.spread, ether_div)


	--[[
	layer_mod.register_map({
		name = 'zero',
		biomes = 'default',
		heat = 'base_heat',
		mapgen = DFlat_Mapgen,
		mapgen_name = 'dflat',
		minp = VN(-max_chunks, -20, -max_chunks),
		maxp = VN(0, 15, max_chunks),
		noises = noises,
		params = {},
		water_level = 1,
	})
	--]]

	layer_mod.register_map({
		name = 'dflat',
		biomes = 'default',
		heat = 'base_heat',
		mapgen = DFlat_Mapgen,
		mapgen_name = 'dflat',
		minp = VN(-max_chunks, -20, -max_chunks),
		maxp = VN(max_chunks, 15, max_chunks),
		noises = noises,
		params = {},
		water_level = 1,
	})

	layer_mod.register_map({
		name = 'ether',
		biomes = 'dflat_ether',
		heat = 50,
		humidity = 50,
		mapgen = DFlat_Mapgen,
		mapgen_name = 'dflat_ether',
		minp = VN(-max_chunks_ether, -360, -max_chunks_ether),
		maxp = VN(max_chunks_ether, -350, max_chunks_ether),
		noises = e_noises,
		params = { div = ether_div },
		water_level = -28400,
	})
end
