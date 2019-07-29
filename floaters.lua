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
local math_random = math.random
local os_clock = os.clock
local VN = vector.new


local node = layer_mod.node
local get_spawn_level
local floater_map
local mapgen_ref


local base_base_level = 563
local base_water_level = 500
local shore_adjust = -15
--local fraidy_cat = minetest.settings:get_bool('mapgen_fraidy_cat')
local make_vines = minetest.settings:get_bool('mapgen_make_floater_vines')
local fraidy_cat = false
local falling = {}
local shell_thick = 30


dofile(mod.path..'/cave_biomes.lua')
local cave_biomes = mod.cave_biomes


do
	local newnode = mod.clone_node('default:dirt')
	newnode.description = 'Vines'
	newnode.tiles = {'default_leaves.png'}
	newnode.sunlight_propagates = true
	minetest.register_node(mod_name..':vines', newnode)

	local newnode = mod.clone_node('air')
	newnode.description = 'Airy Barrier'
	newnode.walkable = true
	newnode.floodable = false
	minetest.register_node(mod_name..':airy_barrier', newnode)

	local range = 2000
	local newnode = mod.clone_node('default:diamondblock')
	newnode.description = 'Displacer Stone'
	newnode.drop = ''
	newnode.tiles = { 'default_diamond_block.png^[colorize:#606000:150' }
	newnode.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		if not (clicker and node and pos) then
			return
		end

		local meta = minetest.get_meta(pos)
		if not (meta and meta:contains('teleport_to')) then
			local npos
			for ct = 1, 10000 do
				npos = VN(
					pos.x + math_random(range) + math_random(range) - range,
					pos.y,
					pos.z + math_random(range) + math_random(range) - range
				)
				npos.y = get_spawn_level(mapgen_ref, floater_map, npos.x, npos.z)

				if npos.y and npos.y > -layer_mod.max_height
				and math_abs(npos.x) < layer_mod.max_height
				and math_abs(npos.z) < layer_mod.max_height then
					break
				end

				npos = nil
			end

			if npos then
				local npos_s = minetest.serialize(npos)
				meta:set_string('teleport_to', npos_s)
			end
		end

		if meta and meta:contains('teleport_to') then
			local npos_s = meta:get_string('teleport_to')
			local npos = minetest.deserialize(npos_s)
			if npos and npos.x and npos.y and npos.z then
				npos.y = npos.y + 2
				clicker:setpos(npos)
			end
		end
	end
	minetest.register_node(mod_name..':displacer', newnode)
end


-----------------------------------------------
-- Floaters_Mapgen class
-----------------------------------------------

local Floaters_Mapgen = layer_mod.subclass_mapgen()
mapgen_ref = Floaters_Mapgen


function Floaters_Mapgen:_init()
	self.ores = table.copy(self.ores)
	for _, v in pairs(self.ores) do
		v[2] = 0
	end

	table.insert( self.ores, 6, { 'default:water_source', 0, } )

	--self.share.propagate_shadow = true
	self.biomemap = {}
	self.heatmap = {}
	self.humiditymap = {}
	self.share.floaters = {}
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
	local reverse_heightmap = {}
	local base_level = self.base_level
	self.reverse_heightmap = reverse_heightmap
	self.share.floaters.heightmap = heightmap
	self.share.floaters.reverse_heightmap = reverse_heightmap

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
	local vine_noise_map = {}
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
	local n_stone = node['default:stone']
	local n_air = node['air']
	local n_water = node['default:water_source']
	local n_glass = node[mod_name..':airy_barrier']
	--n_glass = n_stone

	if make_vines then
		vine_noise_map = self.noises['floaters_vines'].map
	end

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
				if ps:next(1, 1000) == 1 then
					top = mod_name..':displacer'
				end
				top = node[top]
				local grass_p2 = grassmap[index]

				local riverbed = node[biome.node_riverbed]

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

				local t_y_loop = os_clock()

				if height < minp.y or math_abs(height - base_level) == math_abs(reverse_heightmap[index] - base_level) then
					water_level = -layer_mod.max_height
				else
					water_level = base_level + 14
					water_level = -layer_mod.max_height
				end

				local pheight = math_abs(math_floor((height - minp.y + math_abs(reverse_heightmap[index] - minp.y)) / 10) - 10)
				local min_y = reverse_heightmap[index]
				local min_y_chunk = math_max(minp.y, min_y)
				local cave_high = math_min(height - shell_thick, maxp.y - pheight)
				local cave_low = math_max(min_y + shell_thick, minp.y + pheight)

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
						if y == min_y and falling[top] then
							data[ivm] = n_stone
						else
							data[ivm] = top
						end
						p2data[ivm] = grass_p2 --  + 0
					elseif filler and y <= height and y > fill_2 then
						if y == min_y and falling[filler] then
							data[ivm] = n_stone
						else
							data[ivm] = filler
						end
						p2data[ivm] = 0
					elseif y <= cave_high and y >= cave_low then
						-- nop
					elseif y <= height then
						data[ivm] = stone
						p2data[ivm] = 0
					--elseif y <= wisp_level + wisps and y >= wisp_level - wisps then
					--	data[ivm] = node[mod_name..':wispy_cloud']
					--	p2data[ivm] = 0
					end

					ivm = ivm + ystride
				end

				if minp.y < self.water_level then
					local ivm = area:index(x, minp.y, z)
					for y = minp.y, self.water_level do
						if data[ivm] == n_air then
							if y == minp.y then
								data[ivm] = n_glass
							else
								data[ivm] = n_water
							end
							p2data[ivm] = 0
						end

						ivm = ivm + ystride
					end
				end
				mod.time_y_loop = mod.time_y_loop + os_clock() - t_y_loop

				if make_vines and math_abs(vine_noise_map[index]) < 3 and vinemap[index] <= maxp.y and vinemap[index] >= minp.y then
					ivm = area:index(x, vinemap[index], z)
					if data[ivm] == n_air or data[ivm] == n_water then
						data[ivm] = node[mod_name..':vines']
						p2data[ivm] = 0
					end
				elseif fraidy_cat and vinemap[index] <= maxp.y and vinemap[index] >= minp.y then
					ivm = area:index(x, vinemap[index], z)
					for i = 1, 3 do
						if data[ivm] == n_air then
							data[ivm] = node[mod_name..':airy_barrier']
							p2data[ivm] = 0
						end
						ivm = ivm - ystride
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
	self.height_offset = base_base_level - base_water_level + shore_adjust

	if not falling[node['default:sand']] then
		for k, v in pairs(minetest.registered_nodes) do
			if v.groups and v.groups.falling_node then
				falling[node[v.name]] = true
			end
		end
	end
end


function Floaters_Mapgen:get_spawn_level(map, x, z, force)
	local ground_noise = minetest.get_perlin(map.noises['floaters_over'].def)
	local base_noise = minetest.get_perlin(map.noises['floaters_base'].def)
	local under_noise = minetest.get_perlin(map.noises['floaters_under'].def)
	local ground = ground_noise:get_2d({x=x, y=z, z=z})
	local base = base_noise:get_2d({x=x, y=z, z=z})
	local under = under_noise:get_2d({x=x, y=z, z=z})

	local height = math_floor(self:terrain_height(ground, base, under))
	if not force and height <= map.water_level then
		return
	end

	return height
end
get_spawn_level = Floaters_Mapgen.get_spawn_level


function Floaters_Mapgen:terrain_height(ground_1, base_noise, under_noise)
	-- terrain height calculations
	local base_level = (self.base_level or base_base_level) + math_abs(base_noise)
	local height = ground_1 + base_level
	local depth = base_level - under_noise

	height = math_floor(height + 0.5)
	depth = math_floor(depth + 0.5)
	if depth >= height then
		height = -layer_mod.max_height
	end

	return height
end


-----------------------------------------------
-- Floaters_Caves_Mapgen class
-----------------------------------------------

local Floaters_Caves_Mapgen = layer_mod.subclass_mapgen()


function Floaters_Caves_Mapgen:_init()
	self.biomemap = {}
	self.heatmap = {}
	self.humiditymap = {}
end


function Floaters_Caves_Mapgen:generate()
	self:prepare()
	self:place_terrain()
end


-- check
function Floaters_Caves_Mapgen:place_terrain()
	local area = self.area
	local data = self.data
	local heightmap = self.heightmap
	local reverse_heightmap = self.reverse_heightmap
	local biomemap = self.biomemap
	local maxp = self.maxp
	local minp = self.minp
	local ystride = area.ystride
	local p2data = self.p2data
	local water_level = self.water_level
	local base_level = self.base_level
	local ps = self.gpr

	local n_stone = node['default:stone']

	if not (self.biome or self.share.biome) then
		self:map_heat_humidity()
		self:map_biomes()
	end

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = heightmap[index] or minp.y - 2
			do
				local biome = self.biome or self.share.biome or biomemap[index] or {}
				--[[
				biome = self.biomes['granite_lava']
				biomemap[index] = biome
				--]]

				local t_y_loop = os_clock()

				local pheight = math_abs(math_floor((height - minp.y + math_abs(reverse_heightmap[index] - minp.y)) / 10) - 10)
				local min_y = reverse_heightmap[index]
				local min_y_chunk = math_max(minp.y, min_y)

				local cave_high = math_min(height - shell_thick, maxp.y - pheight)
				local cave_low = math_max(min_y + shell_thick, minp.y + pheight)
				local lining = biome.node_lining
				local ceiling = lining or biome.node_ceiling
				local floor = lining or biome.node_floor
				local stone = biome.node_stone
				local surface_depth = biome.surface_depth or 1

				if biome.node_cave_liquid ~= 'default:water_source' and ps:next(1, 1000) == 1 then
					ceiling = biome.node_cave_liquid
					surface_depth = 1
				end

				floor = node[floor]
				ceiling = node[ceiling]
				stone = node[stone]

				local rock_high = cave_high + 5
				local rock_low = cave_low - 5
				local surface_high = cave_high + surface_depth
				local surface_low = cave_low - surface_depth
				local bound_high = maxp.y - pheight
				local bound_low = minp.y + pheight
				local bound_surf_high = bound_high + surface_depth
				local bound_surf_low = bound_low - surface_depth

				local ivm = area:index(x, min_y_chunk, z)
				for y = min_y_chunk, maxp.y do
					local is_stone = (data[ivm] == n_stone)
					if y < rock_low or y > rock_high then
						--nop
					elseif ceiling and y <= bound_surf_high and y >= bound_high and is_stone then
						data[ivm] = ceiling
						p2data[ivm] = 0
					elseif floor and y >= bound_surf_low and y <= bound_low and is_stone then
						data[ivm] = floor
						p2data[ivm] = 0
					elseif y <= cave_high and y >= cave_low then
						--nop
					elseif ceiling and y <= surface_high and y >= cave_high and is_stone then
						data[ivm] = ceiling
						p2data[ivm] = 0
					elseif floor and y >= surface_low and y <= cave_low and is_stone then
						data[ivm] = floor
						p2data[ivm] = 0
					elseif stone and y <= rock_high and y >= cave_high and is_stone then
						data[ivm] = stone
						p2data[ivm] = 0
					elseif stone and y >= rock_low and y <= cave_low and is_stone then
						data[ivm] = stone
						p2data[ivm] = 0
					end

					ivm = ivm + ystride
				end

				mod.time_y_loop = mod.time_y_loop + os_clock() - t_y_loop
			end

			index = index + 1
		end
	end
end


function Floaters_Caves_Mapgen:prepare()
	self.gpr = PcgRandom(self.seed + 7712)
	self.height_offset = 120
	self.share.cave_level = math_min((self.share.cave_level or 20), 19)

	self.heightmap = self.share.floaters.heightmap
	self.reverse_heightmap = self.share.floaters.reverse_heightmap
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
	local terrain_scale = 100

	local ether_div = 8
	local max_chunks = layer_mod.max_chunks
	local max_chunks_ether = math_floor(layer_mod.max_chunks / ether_div)

	local noises = {
		floaters_base = { def = {offset = 0, scale = 50, seed = 2567, spread = {x = 250, y = 250, z = 250}, octaves = 3, persist = 0.5, lacunarity = 2}, },
		floaters_over = { def = {offset = -20, scale = 25, seed = 4877, spread = {x = 200, y = 200, z = 200}, octaves = 4, persist = 0.8, lacunarity = 2}, },
		floaters_under = { def = {offset = 0, scale = 75, seed = 4877, spread = {x = 200, y = 200, z = 200}, octaves = 7, persist = 0.6, lacunarity = 2}, },
		floaters_vines = { def = { offset = 0, scale = 100, seed = -6050, spread = {x = 1024, y = 1024, z = 1024}, octaves = 5, persist = 0.6, lacunarity = 2.0} },
		floaters_wisp = { def = {offset = 0, scale = 1, seed = 5748, spread = {x = 40, y = 10, z = 40}, octaves = 3, persist = 1, lacunarity = 2}, },
		--floaters_rainbow = { def = {offset = 0, scale = 7, seed = 4877, spread = {x = 100, y = 100, z = 100}, octaves = 2, persist = 0.4, lacunarity = 2}, },
	}

	if not make_vines then
		noises['floaters_vines'] = nil
	end

	local def = {
		name = 'floaters',
		biomes = 'default',
		base_level = base_base_level,
		mapgen = Floaters_Mapgen,
		mapgen_name = 'floaters',
		map_minp = VN(-max_chunks, 6, -max_chunks),
		map_maxp = VN(max_chunks, 11, max_chunks),
		noises = noises,
		random_teleportable = true,
		water_level = base_water_level,
	}
	layer_mod.register_map(def)
	floater_map = def

	local biomes = level_biomes(base_base_level)
	layer_mod.register_map({
		name = 'floaters_caves',
		biomes = biomes,
		base_level = base_base_level,
		mapgen = Floaters_Caves_Mapgen,
		mapgen_name = 'floaters_caves',
		map_minp = VN(-max_chunks, 6, -max_chunks),
		map_maxp = VN(max_chunks, 11, max_chunks),
		noises = noises,
		water_level = base_water_level,
	})
end


minetest.register_lbm({
	label = 'change river water back',
	name = mod_name..':replace_river',
	nodenames = { 'default:river_water_source' },
	action = function(pos, node)
		if pos.y >= 448 and pos.y <= 927 then
			minetest.set_node(pos, { name = 'default:water_source' })
		end
	end,
})
