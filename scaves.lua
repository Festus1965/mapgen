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

local cave_underground = 5


dofile(mod.path..'/cave_biomes.lua')
local cave_biomes = mod.cave_biomes


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

	local biomes = level_biomes(water_level)
	layer_mod.register_map({
		name = 'scaves',
		biomes = biomes,
		mapgen = SCaves_Mapgen,
		mapgen_name = 'scaves',
		map_minp = VN(-max_chunks, -4, -max_chunks),
		map_maxp = VN(max_chunks, 3, max_chunks),
		water_level = 1,
	})

	local biomes = level_biomes(water_level)
	layer_mod.register_map({
		name = 'scaves',
		biomes = biomes,
		mapgen = SCaves_Mapgen,
		mapgen_name = 'scaves',
		map_minp = VN(-max_chunks, 63, -max_chunks),
		map_maxp = VN(max_chunks, 76, max_chunks),
		water_level = 5680,
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
