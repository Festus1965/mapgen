-- Duane's mapgen pillars.lua
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


-----------------------------------------------
-- Pillars_Mapgen class
-----------------------------------------------

local Pillars_Mapgen = layer_mod.subclass_mapgen()


function Pillars_Mapgen:after_terrain()
	local minp, maxp = self.minp, self.maxp

	if not (self.coop or self.abort) then
		local t_ore = os_clock()
		self:simple_ore()
		layer_mod.time_ore = layer_mod.time_ore + os_clock() - t_ore
	end
end


function Pillars_Mapgen:generate()
	local water_level = self.water_level
	if self.share.height_max and self.share.height_min then
		self.coop = true

		if self.share.height_max - water_level > -80
		or self.share.height_min - water_level < -500 then
			self.abort = true
			return
		end
	end

	self:prepare()
	self:place_terrain()
	self:after_terrain()
end


function Pillars_Mapgen:map_height()
	local water_level = self.water_level
	local max_height = layer_mod.max_height

	local minp, maxp = self.minp, self.maxp
	local csize = self.csize
	local ground_noise_map = self.noises['pillars_ground'].map
	local heightmap = self.heightmap
	local base_level = self.share.base_level
	local div = self.div
	local ps = self.gpr

	local height_min = layer_mod.max_height
	-----------------------------
	local height_max = -layer_mod.max_height
	-----------------------------

	local index = 1
	if not self.coop then
		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				if heightmap[index] == -max_height then
					heightmap[index] = math_max(water_level - 30, water_level + math_floor(self.noises['pillars_ground'].map[index]))
				end

				index = index + 1
			end
		end

		self.share.height_min = water_level - 10
		if water_level < minp.y or water_level > maxp.y then
			self.share.height_max = water_level - 10
			return
		end
		self.share.height_max = water_level + 20
	end

	local hts = {}
	for _ = 1, 25 do
		local h = ps:next(1, 10) + ps:next(1, 10) + ps:next(1, 10) - 8
		table.insert(hts, h)
		table.sort(hts)
	end

	for _, h in ipairs(hts) do
		local c = VN(ps:next(10, csize.x - 10), 0, ps:next(10, csize.z - 10))
		local r = ps:next(5, 10)

		local r2 = r * r
		local min = vector.add(c, -r)
		local max = vector.add(c, r)
		for z = min.z, max.z do
			local dz = z - c.z
			index = z * csize.x + min.x + 1
			for x = min.x, max.x do
				local dx = x - c.x

				if dz * dz + dx * dx < r2 then
					heightmap[index] = water_level + h
				end

				index = index + 1
			end
		end
	end

	if not self.coop then
		local f1 = math_max(altitude_cutoff_high, height_max - minp.y)
		local f2 = math_min(altitude_cutoff_low, height_min - minp.y)
		if (f1 - altitude_cutoff_high) - (f2 - altitude_cutoff_low) < 3 then
			self.share.flattened = true
		end
	end
end


function Pillars_Mapgen:prepare()
	local minp, maxp = self.minp, self.maxp
	local chunk_offset = self.chunk_offset

	self.gpr = PcgRandom(self.seed + 4731)

	if not self.coop then
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
		pillars_ground = { def = { offset = -5, scale = 20, seed = -4620, spread = {x = 320, y = 320, z = 320}, octaves = 6, persist = 0.5, lacunarity = 2.0}, },
		heat_blend = { def = { offset = 0, scale = 4, seed = 5349, spread = {x = 10, y = 10, z = 10}, octaves = 3, persist = 0.5, lacunarity = 2, flags = 'eased' }, },
		--flat_cave_1 = { def = { offset = 0, scale = 10, seed = 6386, spread = {x = 23, y = 23, z = 23}, octaves = 3, persist = 0.7, lacunarity = 1.8 }, },
		--cave_heat = { def = { offset = 50, scale = 50, seed = 1578, spread = {x = 200, y = 200, z = 200}, octaves = 3, persist = 0.5, lacunarity = 2 }, },
	}

	--[[
	local e_noises = { ground = table.copy(noises.ground) }
	e_noises.ground.def.spread = vector.divide(e_noises.ground.def.spread, ether_div)
	--]]


	layer_mod.register_map({
		name = 'pillars',
		biomes = 'default',
		heat = 'base_heat',
		mapgen = Pillars_Mapgen,
		mapgen_name = 'pillars',
		map_minp = VN(-max_chunks, 47, -max_chunks),
		map_maxp = VN(max_chunks, 62, max_chunks),
		noises = noises,
		water_level = 4640,
	})

	layer_mod.register_map({
		name = 'pillars',
		mapgen = Pillars_Mapgen,
		mapgen_name = 'pillars',
		map_minp = VN(-max_chunks, 0, -max_chunks),
		map_maxp = VN(max_chunks, 0, max_chunks),
		noises = noises,
		water_level = 1,
	})

	--[[
	layer_mod.register_map({
		name = 'ether',
		biomes = 'ether',
		heat = 50,
		humidity = 50,
		mapgen = Pillars_Mapgen,
		mapgen_name = 'pillars',
		minp = VN(-max_chunks_ether, -360, -max_chunks_ether),
		maxp = VN(max_chunks_ether, -350, max_chunks_ether),
		noises = e_noises,
		params = { div = ether_div },
		water_level = -28400,
	})
	--]]
end
