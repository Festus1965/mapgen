-- Duane's mapgen zero.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

local math_abs = math.abs
local math_cos = math.cos
local math_ceil = math.ceil
local math_floor = math.floor
local math_max = math.max
local math_min = math.min
local math_pi = math.pi
local math_random = math.random
local math_sin = math.sin
local math_sqrt = math.sqrt
local node = layer_mod.node
local os_clock = os.clock
local VN = vector.new

local water_diff = 8

local altitude_cutoff_high = 30
local altitude_cutoff_low = -10
local altitude_cutoff_low_2 = 63
local cave_underground = 5

local n_air = node['air']
local n_ignore = node['ignore']
local n_stone = node['default:stone']


-----------------------------------------------
-- DFlat_Mapgen class
-----------------------------------------------

function dflat_mapgen(base_class)
	if not base_class then
		return
	end

	local new_class = {}
	local new_mt = { __index = new_class, }

	function new_class:new(mg)
		local new_inst = {}
		for k, v in pairs(mg) do
			new_inst[k] = v
		end

		new_inst.puzzle_boxes = {}

		setmetatable(new_inst, new_mt)
		return new_inst
	end

	setmetatable(new_class, { __index = base_class })

	return new_class
end

local DFlat_Mapgen = dflat_mapgen(layer_mod.Mapgen)


function DFlat_Mapgen:generate()
	local chunk_offset = self.chunk_offset
	local minp, maxp = self.minp, self.maxp
	local biomes = mod.biomes
	local water_level = self.water_level

	self.gpr = PcgRandom(self.seed + 5107)

	-------------------------------------------
	self:make_all_noises()
	-------------------------------------------

	local t_terrain = os_clock()

	local decorate = true
	local base_heat = 20 + math_abs(70 - ((((minp.z + chunk_offset + 1000) / 6000) * 140) % 140))
	self.base_heat = base_heat

	local ground = (maxp.y >= water_level and minp.y <= water_level)
	if ground then
		self:map_roads()
	end

	local t_terrain_f = os_clock()
	self:terrain()
	mod.time_terrain_f = mod.time_terrain_f + os_clock() - t_terrain_f

	local do_ore = true
	if ground and self.flattened and self.gpr:next(1, 5) == 1 then
		local sr = self.gpr:next(1, 3)
		if sr == 1 then
			self:dungeon('pyramid_temple')
		elseif sr == 2 then
			self:dungeon('pyramid')
		else
			self:simple_ruin()
		end
		do_ore = false
	else
		if self.height_max + 10 < minp.y then
			self:planets()
		end
		if ground then
			self:houses()
		end
	end

	if self.height_max >= minp.y
	and self.height_min > minp.y + cave_underground then
		local t_cave = os_clock()
		self:simple_cave()
		mod.time_caves = mod.time_caves + os_clock() - t_cave
	end

	if do_ore then
		local t_ore = os_clock()
		self:simple_ore()
		mod.time_ore = mod.time_ore + os_clock() - t_ore
	end
	mod.time_terrain = mod.time_terrain + os_clock() - t_terrain

	if decorate then
		local t_deco = os_clock()
		self:place_all_decorations()
		self:dust()
		mod.time_deco = mod.time_deco + os_clock() - t_deco
	end

	if #self.puzzle_boxes > 0 then
		self:place_puzzles()
	end

	self:save_map()

	mod.chunks = mod.chunks + 1
end


function DFlat_Mapgen:map_height()
	local minp, maxp = self.minp, self.maxp
	local ground_noise_map = self.noise['ground'].map
	local heightmap = self.heightmap
	local base_level = self.base_level

	local height_min = mod.max_height
	local height_max = -mod.max_height

	-----------------------------------------
	-- Fix this.
	-----------------------------------------
	if self.ether then
		ground_noise_map = self.noise['ground_ether'].map
	end
	-----------------------------------------

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			-- terrain height calculations
			local ground_1 = ground_noise_map[index]
			local height = base_level
			if ground_1 > altitude_cutoff_high then
				if self.ether then
					height = height + math_floor((ground_1 - altitude_cutoff_high) / 8 + 0.5)
				else
					height = height + ground_1 - altitude_cutoff_high
				end
			elseif ground_1 < altitude_cutoff_low then
				local g = altitude_cutoff_low - ground_1
				if g < altitude_cutoff_low_2 then
					g = g * g * 0.01
				else
					g = (g - altitude_cutoff_low_2) * 0.5 + 40
				end
				if self.ether then
					height = math_floor(height - math_floor(g / 8 + 0.5) + 0.5)
				else
					height = math_floor(height - g + 0.5)
				end
			end

			heightmap[index] = height
			height_max = math_max(ground_1, height_max)
			height_min = math_min(ground_1, height_min)

			index = index + 1
		end
	end

	self.height_min = height_min
	self.height_max = height_max

	if (math_max(altitude_cutoff_high, height_max) - altitude_cutoff_high)
	- (math_min(altitude_cutoff_low, height_min) - altitude_cutoff_low) < 3 then
		self.flattened = true
	end
end


-- check
function DFlat_Mapgen:terrain()
	local csize, area = self.csize, self.area
	local csize_y = csize.y
	local biomes = mod.biomes
	local cave_biomes = mod.cave_biomes
	local data = self.data
	local heightmap = self.heightmap
	local grassmap = self.grassmap
	local biomemap = self.biomemap
	local biomemap_cave = self.biomemap_cave
	local maxp = self.maxp
	local minp = self.minp
	local ystride = area.ystride
	local p2data = self.p2data

	local water_level = self.water_level
	local base_level = self.water_level + water_diff
	if self.ether then
		base_level = self.water_level + 1
	end
	self.base_level = base_level
	local ground = (maxp.y >= water_level and minp.y <= water_level)

	local stone_layers = self.stone_layers

	local n_cobble = node['default:cobble']
	local n_mossy = node['default:mossycobble']
	local n_rail_power = node['carts:powerrail']
	local n_rail = node['carts:rail']

	local roads = self.roads or {}
	local tracks = self.tracks or {}

	if self.ether then
		self.biome = biomes['ether']
	else
		self.biome = nil
	end

	self:map_height()
	self:map_heat_humidity()
	self:map_biomes()

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = heightmap[index]
			local biome, biome_cave

			if self.biome then
				biome = self.biome
				biome_cave = cave_biomes['stone']
			else
				biome = biomemap[index] or {}
				biome_cave = biomemap_cave[index] or {}
			end

			local depth_filler = biome.depth_filler or 0
			local depth_top = biome.depth_top or 0
			if depth_top > 0 then
				depth_top = self:erosion(height, index, depth_top, 100)
			end
			if depth_filler > 0 then
				depth_filler = self:erosion(height, index, depth_filler, 20)
			end

			local stone = node['default:stone']
			if biome.node_stone then
				stone = node[biome.node_stone] or stone
			end
			local stone_cave = node['default:stone']
			if biome_cave.node_stone then
				stone_cave = node[biome_cave.node_stone] or stone
			end

			local filler = biome.node_filler or 'air'
			filler = node[filler]
			local top = biome.node_top or 'air'
			top = node[top]
			local grass_p2 = 0
			if biome.node_top == 'default:dirt_with_dry_grass'
			or biome.node_top == 'default:dirt_with_grass' then
				grass_p2 = grassmap[index] or 0
			end

			local ww = node[biome.water or 'default:water_source']
			local wt = biome.node_water_top
			local wtd = biome.node_water_top_depth or 0
			do
				local heat = self.heatmap[index]
				if wt and wt:find('ice') then
					wt = node['default:ice']
					wtd = math_ceil(math_max(0, (30 - heat) / 3))
				elseif wt then
					wt = node[wt]
				end
			end

			local fill_1 = height - depth_top
			local fill_2 = fill_1 - math_max(0, depth_filler)

			local t_y_loop = os_clock()
			local hu2_check
			-----------------------------------------
			-- Fix this.
			-----------------------------------------
			do
				local humiditymap = self.humiditymap
				local humidity_2_map = self.noise['humidity_2'].map
				local hu2 = humidity_2_map[index]
				local humidity = humiditymap[index]
				if humidity and hu2 then
					hu2_check = (humidity > 70 and (hu2 > 1 or math_floor(hu2 * 1000) % 2 == 0))
				end
			end
			-----------------------------------------
			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				if ground and y == base_level + 1 and tracks[index] then
					if x % 5 == 0 or z % 5 == 0 then
						data[ivm] = n_rail_power
					else
						data[ivm] = n_rail
					end
				elseif ground and y >= base_level - 1 and y <= base_level and roads[index] then
					if hu2_check then
						data[ivm] = n_mossy
					else
						data[ivm] = n_cobble
					end
				elseif y > height and y <= water_level then
					--print('water '..dump(water_level))
					if y > water_level - wtd then
						data[ivm] = wt
					else
						data[ivm] = ww
					end
					p2data[ivm] = 0
				elseif y <= height and y > fill_1 then
					--print('fill_1 '..dump(fill_1))
					data[ivm] = top
					p2data[ivm] = 0 + grass_p2
				elseif filler and y <= height and y > fill_2 then
					--print('fill_2 '..dump(fill_2))
					data[ivm] = filler
					p2data[ivm] = 0
				elseif y < height - 20 then
					data[ivm] = stone_cave
					p2data[ivm] = 0
				elseif y <= height then
					--print('stone '..dump(stone))
					data[ivm] = stone
					if stone == n_stone then
						p2data[ivm] = stone_layers[y - minp.y]
					else
						p2data[ivm] = 0
					end
				end

				ivm = ivm + ystride
			end
			mod.time_y_loop = mod.time_y_loop + os_clock() - t_y_loop

			index = index + 1
		end
	end
end


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------

function zero_mapgen(mg, map, div)
	local mapgen = DFlat_Mapgen:new(mg)
	mapgen.map = map
	mapgen.water_level = map.water_level
	mapgen.div = div
	mapgen:generate()
end


function zero_mapgen_mini(mg, map)
	zero_mapgen(mg, 8)
end


local max_chunks = layer_mod.max_chunks
local max_chunks_8 = math_floor(layer_mod.max_chunks / 8)
layer_mod.register_map({
	name = 'zero',
	biomes = 'default',
	mapgen = zero_mapgen,
	mapgen_name = 'dflat',
	minp = VN(-max_chunks, -20, -max_chunks),
	maxp = VN(max_chunks, 15, max_chunks),
	water_level = 1,
})

layer_mod.register_map({
	name = 'ether',
	biomes = 'ether',
	mapgen = zero_mapgen_mini,
	mapgen_name = 'dflat',
	minp = VN(-max_chunks_8, -363, -max_chunks_8),
	maxp = VN(max_chunks_8, -350, max_chunks_8),
	water_level = 29521,
})
