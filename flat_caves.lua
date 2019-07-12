-- Duane's mapgen flat_caves.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

--local Geomorph = geomorph.Geomorph

local math_abs = math.abs
local math_floor = math.floor
local math_max = math.max
local math_min = math.min
local math_sqrt = math.sqrt
local node = layer_mod.node
local os_clock = os.clock
local VN = vector.new


dofile(mod.path..'/cave_biomes.lua')
local cave_biomes = mod.cave_biomes


-----------------------------------------------
-- Flat_Caves_Mapgen class
-----------------------------------------------

local Flat_Caves_Mapgen = layer_mod.subclass_mapgen()


function Flat_Caves_Mapgen:get_spawn_level(map, x, z)
	-- ?????????
end


-- This is only called for one point, so don't map it.
local flat_caves_heat = { def = { offset = 50, scale = 50, seed = 1578, spread = {x = 200, y = 200, z = 200}, octaves = 3, persist = 0.5, lacunarity = 2 }, }
function Flat_Caves_Mapgen:generate()
	if self.share.disruptive then
		return
	end

	local minp, maxp = self.minp, self.maxp
	local height_max = self.share.height_max
	local height_min = self.share.height_min

	if not (height_max and height_min) then
		-- nop
	elseif height_max < minp.y then
		return
	end

	--self.gpr = PcgRandom(self.seed + 5107)
	self.no_dust = true

	local t_cave = os_clock()
	self:map_height()
	self:map_heat_humidity()
	self:map_biomes()
	self:flat_cave()
	layer_mod.time_caves = layer_mod.time_caves + os_clock() - t_cave
end


function Flat_Caves_Mapgen:map_height()
	local minp, maxp = self.minp, self.maxp
	local heightmap = self.heightmap
	local center = vector.divide(vector.add(minp, maxp), 2)
	local csize = self.csize

	-- Note the peculiar seed noise.
	local ground_noise = { def = {offset = 0, scale = 10, seed = 6386, spread = {x = 23, y = 23, z = 23}, octaves = 3, persist = 0.7, lacunarity = 1.8} }
	ground_noise.def.seed = 6386 + math_floor(minp.y / csize.y)
	ground_noise.noise = minetest.get_perlin_map(ground_noise.def, {x=self.csize.x, y=self.csize.z})
	ground_noise.map = ground_noise.noise:get2dMap_flat({x=self.minp.x, y=self.minp.z}, ground_noise.map)

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local ground = ground_noise.map[index]

			if ground < -10 then
				ground = ground + 10
				ground = - (ground * ground) - 10
			elseif ground > 0 then
				---------------------------
				-- cpu drain
				---------------------------
				ground = math_sqrt(ground)
				---------------------------
			end
			ground = math_floor(ground)

			heightmap[index] = center.y - ground

			index = index + 1
		end
	end
end


function Flat_Caves_Mapgen:flat_cave()
	local minp, maxp = self.minp, self.maxp
	--local pr = self.gpr
	local csize = self.csize
	local data, p2data, area = self.data, self.p2data, self.area
	local center = vector.divide(vector.add(minp, maxp), 2)
	local heightmap = self.heightmap
	local biomemap = self.biomemap
	local ystride = area.ystride
	local n_air = layer_mod.node['air']
	local n_stone = node['default:stone']
	local n_gas = self.air_fill or n_air
	local base_level = 20
	local water_level = self.water_level

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local ground = center.y - heightmap[index]
			heightmap[index] = water_level

			local biome = biomemap[index]
			local n_b_stone = node[biome.node_stone] or n_stone
			local n_ceiling = node[biome.node_ceiling] or node[biome.node_lining]
			local n_floor = node[biome.node_floor] or node[biome.node_lining]
			local n_fluid = node[biome.node_cave_liquid]
			local surface_depth = biome.surface_depth or 1

			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				local diff = math_abs(center.y - y)
				if diff >= base_level + ground
				and diff < base_level + ground + surface_depth then
				--and data[ivm] == n_air then
					if y < center.y then
						data[ivm] = n_floor or n_b_stone
						p2data[ivm] = 0
					else
						data[ivm] = n_ceiling or n_b_stone
						p2data[ivm] = 0
					end
				elseif diff < base_level + ground then
				--elseif diff < base_level + ground and data[ivm] == n_air then
					if n_fluid and y <= center.y - base_level then
						data[ivm] = n_fluid
						p2data[ivm] = 0
					else
						data[ivm] = n_gas
						p2data[ivm] = 0
					end
				elseif data[ivm] == n_air then
					if diff < 10 then
						data[ivm] = n_floor or n_b_stone
					else
						data[ivm] = n_b_stone
					end
					p2data[ivm] = 0
				end

				ivm = ivm + ystride
			end

			index = index + 1
		end
	end
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
		name = 'flat_caves',
		biomes = biomes,
		mapgen = Flat_Caves_Mapgen,
		mapgen_name = 'flat_caves',
		map_minp = VN(-max_chunks, -30, -max_chunks),
		map_maxp = VN(max_chunks, -5, max_chunks),
		water_level = water_level,
	})
end
