-- Duane's mapgen floaters.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'


local math_floor = math.floor
local math_abs = math.abs
local math_max = math.max
local math_min = math.min
local math_ceil = math.ceil
local os_clock = os.clock
local VN = vector.new


local node = layer_mod.node


do
	local newnode = mod.clone_node('default:dirt')
	newnode.description = 'Vines'
	newnode.tiles = {'default_leaves.png'}
	newnode.sunlight_propagates = true
	minetest.register_node(mod_name..':vines', newnode)
end


-----------------------------------------------
-- Floaters_Mapgen class
-----------------------------------------------

local Floaters_Mapgen = layer_mod.subclass_mapgen()


function Floaters_Mapgen:_init()
	self.ores = table.copy(self.ores)
	for _, v in pairs(self.ores) do
		v[2] = 0
	end

	table.insert( self.ores, 4, { 'default:water_source', 0, } )
end


function Floaters_Mapgen:generate()
	self:prepare()
	self:map_height()
	self:place_terrain()
	self:simple_ore()
end


function Floaters_Mapgen:map_height()
	local minp, maxp = self.minp, self.maxp
	local ground_noise_map = self.noises['floaters_over'].map
	local under_noise_map = self.noises['floaters_under'].map
	local base_noise_map = self.noises['floaters_base'].map
	local heightmap = self.heightmap
	local vinemap = self.vinemap
	self.reverse_heightmap = {}
	local reverse_heightmap = self.reverse_heightmap
	local base_level = self.base_level

	local height_min = layer_mod.max_height
	local height_max = -layer_mod.max_height

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			-- terrain height calculations
			base_level = self.base_level + math_abs(base_noise_map[index])
			local ground_1 = ground_noise_map[index]
			--local height = self:terrain_height(ground_1, base_level)
			local height = ground_1 + base_level
			local depth = base_level - under_noise_map[index]

			height = math_floor(height + 0.5)
			depth = math_floor(depth + 0.5)
			reverse_heightmap[index] = depth
			vinemap[index] = height
			if depth >= base_level then
				height = -layer_mod.max_height
			end
			heightmap[index] = height

			height_max = math_max(ground_1, height_max)
			height_min = math_min(ground_1, height_min)

			index = index + 1
		end
	end

	self.share.height_min = height_min
	self.share.height_max = height_max

	--[[
	local f1 = math_max(altitude_cutoff_high, height_max - minp.y)
	local f2 = math_min(altitude_cutoff_low, height_min - minp.y)
	if (f1 - altitude_cutoff_high) - (f2 - altitude_cutoff_low) < 3 then
		self.share.flattened = true
	end
	--]]
end


-- check
function Floaters_Mapgen:place_terrain()
	local area = self.area
	local data = self.data
	local vine_noise_map = self.noises['floaters_vines'].map
	local heightmap = self.heightmap
	local vinemap = self.vinemap
	local reverse_heightmap = self.reverse_heightmap
	local grassmap = self.grassmap
	local biomemap = self.biomemap
	local maxp = self.maxp
	local minp = self.minp
	local ystride = area.ystride
	local p2data = self.p2data
	local water_level = self.water_level
	local base_level = self.base_level
	local wisp_level = base_level + 30
	local wisp_map = self.noises['floaters_wisp'].map
	local ps = self.gpr

	local stone_layers = self.stone_layers

	self:map_height()
	if not (self.biome or self.share.biome) then
		self:map_heat_humidity()
		self:map_biomes()
	end

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = heightmap[index] or minp.y - 2
			local wisps = wisp_map[index]
			do
				local biome = self.biome or self.share.biome or biomemap[index] or {}

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

				local filler = biome.node_filler or 'air'
				filler = node[filler]
				local top = biome.node_top or 'air'
				top = node[top]
				local grass_p2 = grassmap[index]

				local riverbed = node[biome.node_riverbed]

				local ww = biome.water or 'default:river_water_source'
				local wt = biome.node_water_top
				local wtd = biome.node_water_top_depth or 0
				do
					local heat = self.heatmap[index]
					if heat < 28 and ((not wt and ww:find('water')) or wt:find('ice')) then
						wt = node['default:ice']
						wtd = math_ceil(math_max(0, (30 - heat) / 3))
					elseif wt then
						wt = node[wt]
					end
				end
				ww = node[ww]

				local fill_1 = height - depth_top
				local fill_2 = fill_1 - math_max(0, depth_filler)

				local t_y_loop = os_clock()

				if height < minp.y or math_abs(height - base_level) == math_abs(reverse_heightmap[index] - base_level) then
					water_level = -layer_mod.max_height
				else
					water_level = base_level + 14
					water_level = -layer_mod.max_height
				end

				local min_y = reverse_heightmap[index]
				local min_y_chunk = math_max(minp.y, min_y)
				local ivm = area:index(x, min_y_chunk, z)
				for y = min_y_chunk, maxp.y do
					if y < min_y then
						--nop
					elseif y > height and y <= water_level then
						if y > water_level - wtd then
							data[ivm] = wt
						else
							data[ivm] = ww
						end
						p2data[ivm] = 0
					elseif y == height and y <= water_level then
						data[ivm] = riverbed
						p2data[ivm] = 0
					elseif y <= height and y > fill_1 then
						data[ivm] = top
						p2data[ivm] = grass_p2 --  + 0
					elseif filler and y <= height and y > fill_2 then
						data[ivm] = filler
						p2data[ivm] = 0
					elseif y <= height then
						data[ivm] = stone
						p2data[ivm] = 0
					--elseif y <= wisp_level + wisps and y >= wisp_level - wisps then
					--	data[ivm] = node[mod_name..':wispy_cloud']
					--	p2data[ivm] = 0
					end

					ivm = ivm + ystride
				end
				mod.time_y_loop = mod.time_y_loop + os_clock() - t_y_loop

				if math_abs(vine_noise_map[index]) < 5 and vinemap[index] <= maxp.y and vinemap[index] >= minp.y then
					ivm = area:index(x, vinemap[index], z)
					if data[ivm] == node['air'] then
						data[ivm] = node[mod_name..':vines']
						p2data[ivm] = 0
					end
				end
			--else
				--[[
				local min_y = reverse_heightmap[index]
				local min_y_chunk = math_max(minp.y, min_y)
				local ivm = area:index(x, min_y_chunk, z)
				for y = min_y_chunk, maxp.y do
					if y <= wisps then
						data[ivm] = node[mod_name..':wispy_cloud']
						p2data[ivm] = 0
					end

					ivm = ivm + ystride
				end
				--]]
			end

			index = index + 1
		end
	end
end


function Floaters_Mapgen:prepare()
	local minp, maxp = self.minp, self.maxp
	local chunk_offset = self.chunk_offset

	self.gpr = PcgRandom(self.seed + 7712)
	self.vinemap = {}
	self.height_offset = 120
end


function Floaters_Mapgen:terrain_height(ground_1, base_level)
	-- terrain height calculations
	local height = base_level + ground_1
	--if height > base_level + 15 then
	--	height = height - 2 * (height - base_level - 15)
	--end
	return height
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
		floaters_base = { def = {offset = 0, scale = 50, seed = 2567, spread = {x = 250, y = 250, z = 250}, octaves = 3, persist = 0.5, lacunarity = 2}, },
		floaters_over = { def = {offset = -20, scale = 25, seed = 4877, spread = {x = 120, y = 120, z = 120}, octaves = 3, persist = 0.8, lacunarity = 2}, },
		floaters_under = { def = {offset = 0, scale = 75, seed = 4877, spread = {x = 120, y = 120, z = 120}, octaves = 6, persist = 0.6, lacunarity = 2}, },
		floaters_vines = { def = { offset = 0, scale = 100, seed = -6050, spread = {x = 512, y = 512, z = 512}, octaves = 5, persist = 0.6, lacunarity = 2.0} },
		floaters_wisp = { def = {offset = 0, scale = 1, seed = 5748, spread = {x = 40, y = 10, z = 40}, octaves = 3, persist = 1, lacunarity = 2}, },
		--floaters_rainbow = { def = {offset = 0, scale = 7, seed = 4877, spread = {x = 100, y = 100, z = 100}, octaves = 2, persist = 0.4, lacunarity = 2}, },
	}


	layer_mod.register_map({
		name = 'floaters',
		biomes = 'default',
		base_level = 5128,
		mapgen = Floaters_Mapgen,
		mapgen_name = 'floaters',
		map_minp = VN(-max_chunks, 63, -max_chunks),
		map_maxp = VN(max_chunks, 67, max_chunks),
		noises = noises,
		water_level = 5000,
	})
end
