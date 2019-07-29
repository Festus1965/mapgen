-- Duane's mapgen valleys.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Large portions copyright Gael-de-Sailly and vlapsley
--  https://forum.minetest.net/viewtopic.php?f=9&t=11430&hilit=valleys
-- Distributed under the GPLv3 (http://www.gnu.org/licenses/gpl-3.0.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

local math_abs = math.abs
local math_ceil = math.ceil
local math_max = math.max
local node = layer_mod.node
local os_clock = os.clock
local VN = vector.new

local water_diff = 8

local cave_underground = 5


-----------------------------------------------
-- Valleys_Mapgen class
-----------------------------------------------


local Valleys_Mapgen = layer_mod.subclass_mapgen()


function Valleys_Mapgen:_init()
	self.biomemap = {}
	self.heatmap = {}
	self.humiditymap = {}
end


local river_size = 5 / 100
local river_depth = 5
function Valleys_Mapgen:calculate_terrain_at_point(base_ground, v2, v3, v4, v5, suppress)
	v2 = math.abs(v2) - river_size
	local river = v2 < 0
	if river and not suppress then
		local depth = river_depth * math.sqrt(1 - (v2 / river_size + 1) ^ 2)
		local mountain_ground = math.min(math.max(base_ground - depth, -5), base_ground)
		return mountain_ground, 0, river, v2
	end

	local valleys = v3 * (1 - math.exp(- (v2 / v4) ^ 2))
	local mountain_ground = base_ground + valleys
	local slopes = v5 * valleys
	return mountain_ground, slopes, river, v2
end


function Valleys_Mapgen:map_height()
	local minp, maxp = self.minp, self.maxp
	local area, csize = self.area, self.csize
	local heightmap = self.heightmap
	local water_level = self.water_level
	local max_height = layer_mod.max_height

	local n1 = self.noises['valleys_v1'].map
	local n2 = self.noises['valleys_v2'].map
	local n3 = self.noises['valleys_v3'].map
	local n4 = self.noises['valleys_v4'].map
	local n5 = self.noises['valleys_v5'].map
	local n6 = self.noises['valleys_v6'].map

	local height_max = -max_height
	local height_min = max_height
	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local v1 = n1[index]
			local v2 = n2[index]
			local v3 = n3[index]
			local v4 = n4[index]
			local v5 = n5[index]
			local mountain_ground, slopes, river

			v3 = v3 * v3
			local base_ground = v1 + v3
			mountain_ground, slopes, river, v2 = self:calculate_terrain_at_point(base_ground, v2, v3, v4, v5)

			local index3d = ((z - minp.z) * (csize.y + 6) + 85) * csize.x + (x - minp.x) + 1
			for y = maxp.y + 6, minp.y, -1 do
				local v6 = n6[index3d]
				local in_ground = v6 * slopes > y - mountain_ground - water_level
				if y <= maxp.y and in_ground then
					if heightmap[index] == -max_height then
						heightmap[index] = y
						if height_max < y then
							height_max = y
						end
						if height_min > y then
							height_min = y
						end
					end
					break
				end
				index3d = index3d - csize.x
			end

			if heightmap[index] == -max_height then
				heightmap[index] = minp.y - 2
			end
			index = index + 1
		end
	end

	self.share.height_max = height_max
	self.share.height_min = height_min
end


--[[
-- This can't work without much more 3d noise than is practical.

function Valleys_Mapgen:mini()
	local minp, maxp = self.minp, self.maxp
	local area, csize = self.area, self.csize
	local ystride = area.ystride
	local data = self.data
	local heightmap = self.heightmap
	local biomes = mod.biomes
	local p2data = self.p2data
	local div = self.div
	local water_level = self.water_level
	local stone_layers = self.stone_layers

	div = 1

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local biome = biomes['ether']

			local height = math_floor((heightmap[index] - water_level) / (div or 1) + 0.5) + water_level
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
			local river_bot = node[biome.node_riverbed or 'default:sand']
			local river_w = node[biome.node_river_water or 'default:river_water_source']

			local ww = biome.water or 'default:water_source'
			local wt = biome.node_water_top
			local wtd = biome.node_water_top_depth or 0
			if wt then
				wt = node[wt]
			end
			ww = node[ww]

			local fill_1 = height - depth_top
			local fill_2 = fill_1 - math_max(0, depth_filler)

			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				if y > height and y <= water_level then
					if y > water_level - wtd then
						data[ivm] = wt
					else
						data[ivm] = ww
					end
					p2data[ivm] = 0
				elseif y <= height and y > fill_1 then
					data[ivm] = top
					p2data[ivm] = 0 + grass_p2
				elseif filler and y <= height and y > fill_2 then
					data[ivm] = filler
					p2data[ivm] = 0
				elseif y <= height then
					data[ivm] = stone
					p2data[ivm] = 0
				end

				ivm = ivm + ystride
			end

			index = index + 1
		end
	end
end
--]]


function Valleys_Mapgen:terrain()
	local minp, maxp = self.minp, self.maxp
	local area, csize = self.area, self.csize
	local ystride = area.ystride
	local data = self.data
	local heightmap = self.heightmap
	local grassmap = self.grassmap
	local biomemap = self.biomemap
	local p2data = self.p2data
	local water_level = self.water_level
	local stone_layers = self.stone_layers

	local n_stone = self.node['default:stone']

	local n1 = self.noises['valleys_v1'].map
	local n2 = self.noises['valleys_v2'].map
	local n3 = self.noises['valleys_v3'].map
	local n4 = self.noises['valleys_v4'].map
	local n5 = self.noises['valleys_v5'].map
	local n6 = self.noises['valleys_v6'].map

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local biome
			if self.share.biome then
				biome = self.share.biome
			else
				biome = biomemap[index] or {}
			end

			local height = heightmap[index]
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
			local grass_p2 = 0
			if biome.node_top == 'default:dirt_with_dry_grass'
			or biome.node_top == 'default:dirt_with_grass' then
				grass_p2 = grassmap[index] or 0
			end
			local river_bot = node[biome.node_riverbed or 'default:sand']
			local river_w = node[biome.node_river_water or 'default:river_water_source']

			local ww = biome.water or 'default:water_source'
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

			local v1 = n1[index]
			local v2 = n2[index]
			local v3 = n3[index]
			local v4 = n4[index]
			local v5 = n5[index]
			local mountain_ground, slopes, river

			v3 = v3 * v3
			local base_ground = v1 + v3
			mountain_ground, slopes, river, v2 = self:calculate_terrain_at_point(base_ground, v2, v3, v4, v5)

			local index3d = ((z - minp.z) * (csize.y + 6) + 85) * csize.x + (x - minp.x) + 1
			local ivm = area:index(x, maxp.y + 6, z)
			for y = maxp.y + 6, minp.y, -1 do
				local v6 = n6[index3d]
				local in_ground = v6 * slopes > y - mountain_ground - water_level
				if y <= maxp.y then
					if in_ground then
						if river and y > height - 2 then
							data[ivm] = river_bot
						elseif y > fill_1 then
							data[ivm] = top
							p2data[ivm] = 0 + grass_p2
						elseif filler and y > fill_2 then
							data[ivm] = filler
							p2data[ivm] = 0
						else
							data[ivm] = stone
							if stone == n_stone then
								p2data[ivm] = stone_layers[y - minp.y]
							else
								p2data[ivm] = 0
							end
						end
					elseif y <= water_level then
						if y > water_level - wtd then
							data[ivm] = wt
						else
							data[ivm] = ww
						end
						p2data[ivm] = 0
					elseif river and y - water_level + 1 < base_ground then
						data[ivm] = river_w
					end
				end
				ivm = ivm - ystride
				index3d = index3d - csize.x
			end

			index = index + 1
		end
	end
end


function Valleys_Mapgen:generate()
	local water_level = self.water_level

	self:prepare()
	self:map_height()

	self:map_heat_humidity()
	if not self.share.biome then
		self:map_biomes()
	end

	self:terrain()
	self:after_terrain()
end


function Valleys_Mapgen:after_terrain()
	local minp = self.minp

	local do_ore = false

	if do_ore then
		local t_ore = os_clock()
		self:simple_ore()
		layer_mod.time_ore = layer_mod.time_ore + os_clock() - t_ore
	end
end


function Valleys_Mapgen:prepare()
	local minp = self.minp
	local chunk_offset = self.chunk_offset

	self.gpr = PcgRandom(self.seed + 8048)

	local base_level = self.water_level + water_diff
	self.share.base_level = base_level

	local base_heat = 20 + math_abs(70 - ((((minp.z + chunk_offset + 1000) / 6000) * 140) % 140))
	self.share.base_heat = base_heat
end


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------


do
	local max_chunks = layer_mod.max_chunks

	local chunksize = tonumber(minetest.settings:get("chunksize") or 5)
	local v6_size = { x=chunksize * 16, y=chunksize * 16, z=chunksize * 16 }
	v6_size.y = v6_size.y + 6

	local noises = {
		valleys_v1 = { def = { offset = -10, scale = 50, seed = 5202, spread = {x = 1024, y = 1024, z = 1024}, octaves = 6, persist = 0.4, lacunarity = 2.0} },
		valleys_v2 = { def = { offset = 0, scale = 1, seed = -6050, spread = {x = 512, y = 512, z = 512}, octaves = 5, persist = 0.6, lacunarity = 2.0} },
		valleys_v3 = { def = { offset = 5, scale = 4, seed = -1914, spread = {x = 512, y = 512, z = 512}, octaves = 1, persist = 1, lacunarity = 2.0} },
		valleys_v4 = { def = { offset = 0.6, scale = 0.5, seed = 777, spread = {x = 512, y = 512, z = 512}, octaves = 1, persist = 1, lacunarity = 2.0} },
		valleys_v5 = { def = { offset = 0.5, scale = 0.5, seed = 746, spread = {x = 128, y = 128, z = 128}, octaves = 1, persist = 1, lacunarity = 2.0} },
		valleys_v6 = { def = { offset = 0, scale = 1, seed = 1993, spread = {x = 256, y = 512, z = 256}, octaves = 6, persist = 0.8, lacunarity = 2.0 }, is3d = true, size = v6_size },
	}

	--[[
	layer_mod.register_map({
		name = 'valleys',
		biomes = 'default',
		heat = 'base_heat',
		mapgen = Valleys_Mapgen,
		mapgen_name = 'dflat',
		map_minp = VN(1, -20, -max_chunks),
		map_maxp = VN(max_chunks, 15, max_chunks),
		noises = noises,
		water_level = 1,
	})
	--]]

	layer_mod.register_map({
		name = 'valleys',
		biomes = 'default',
		heat = 'base_heat',
		mapgen = Valleys_Mapgen,
		mapgen_name = 'valleys',
		map_minp = VN(-max_chunks, 63, -max_chunks),
		map_maxp = VN(max_chunks, 76, max_chunks),
		noises = noises,
		random_teleportable = true,
		water_level = 5680,
	})
end
