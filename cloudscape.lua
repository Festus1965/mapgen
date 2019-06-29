-- Duane's mapgen mod.lua
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
	newnode.description = 'Cloud'
	newnode.tiles = {'mapgen_cloud.png'}
	newnode.sunlight_propagates = true
	minetest.register_node(mod_name..':cloud', newnode)

	local newnode = mod.clone_node('default:sand')
	newnode.description = 'Wet Cloud'
	newnode.tiles = {'mapgen_wet_cloud.png'}
	newnode.sunlight_propagates = true
	minetest.register_node(mod_name..':wet_cloud', newnode)

	newnode = mod.clone_node('default:dirt')
	newnode.description = 'Storm Cloud'
	newnode.sunlight_propagates = true
	newnode.tiles = {'mapgen_storm_cloud.png'}
	--newnode.sunlight_propagates = true
	minetest.register_node(mod_name..':storm_cloud', newnode)

	minetest.register_node(mod_name..':wispy_cloud', {
		description = 'Wispy Cloud',
		tiles = {'mapgen_wisp.png'},
		sunlight_propagates = true,
		use_texture_alpha = true,
		drawtype = 'glasslike',
		paramtype = 'light',
		walkable = false,
		buildable_to = true,
		pointable = false,
	})

	minetest.register_node(mod_name..':moon_weed', {
		description = 'Moon Weed',
		drawtype = 'plantlike',
		tiles = {'mapgen_moon_weed.png'},
		inventory_image = 'mapgen_moon_weed.png',
		waving = false,
		sunlight_propagates = true,
		paramtype = 'light',
		light_source = 8,
		walkable = false,
		--groups = {snappy=3, flammable=2, flora=1, attached_node=1}, 
		groups = {snappy=3, flammable=2, flora=1}, 
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = 'fixed',
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
	})

	minetest.register_node(mod_name..':leaves_lumin', {
		description = 'Leaves',
		drawtype = 'allfaces_optional',
		waving = 1,
		visual_scale = 1.3,
		tiles = {'default_leaves.png^[colorize:#FFDF00:150'},
		special_tiles = {'default_leaves_simple.png^[colorize:#FFDF00:150'},
		paramtype = 'light',
		is_ground_content = false,
		light_source = 8,
		sunlight_propagates = true,
		groups = {snappy = 3, leafdecay = 4, flammable = 2, leaves = 1},
		drop = {
			max_items = 1,
			items = {
				--{
				--	-- player will get sapling with 1/20 chance
				--	items = {'default:sapling'},
				--	rarity = 20,
				--},
				{
					-- player will get leaves only if he get no saplings,
					-- this is because max_items is 1
					items = {mod_name..':leaves_lumin'},
				}
			}
		},
		sounds = default.node_sound_leaves_defaults(),

		after_place_node = default.after_place_leaves,
	})

	minetest.register_node(mod_name..':lumin_tree', {
		description = 'Lumin Tree',
		tiles = {
			'default_tree_top.png', 'default_tree_top.png', 'mapgen_lumin_tree.png'
		},
		paramtype = 'light',
		sunlight_propagates = true,
		drawtype = 'nodebox',
		node_box = {
			type = 'fixed', 
			fixed = { {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}, }
		},
		paramtype2 = 'facedir',
		is_ground_content = false,
		groups = {tree = 1, choppy = 2, flammable = 2},
		sounds = default.node_sound_wood_defaults(),

		on_place = minetest.rotate_node
	})

	newnode = mod.clone_node('default:stone_with_iron')
	newnode.description = 'Silver Lining'
	newnode.tiles = {'mapgen_cloud.png^default_mineral_coal.png^[colorize:#FFFFFF:175'}
	newnode.drop = mod_name..':silver_lump'
	minetest.register_node(mod_name..':silver_lining', newnode)

	minetest.register_craftitem(mod_name..':silver_lump', {
		description = 'Lump of Silver',
		inventory_image = 'default_coal_lump.png^[colorize:#FFFFFF:175',
	})

	minetest.register_craftitem(mod_name..':silver_ingot', {
		description = 'Silver Ingot',
		inventory_image = 'default_steel_ingot.png^[colorize:#FFFFFF:175',
	})

	minetest.register_craft({
		type = 'cooking',
		output = mod_name..':silver_ingot',
		recipe = mod_name..':silver_lump',
	})


	newnode = mod.clone_node('default:river_water_source')
	newnode.sunlight_propagates = true
	minetest.register_node(':default:river_water_source', newnode)

	newnode = mod.clone_node('default:ice')
	newnode.sunlight_propagates = true
	minetest.register_node(':default:ice', newnode)


	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { mod_name..':cloud', mod_name..':storm_cloud' },
		sidelen = 16,
		fill_ratio = 0.005,
		--[[
		noise_params = {
			offset = -0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = 3874,
			octaves = 3,
			persist = 0.6
		},
		--]]
		biomes = { 'cloud_sunny', 'cloud_storm' },
		y_min = 100,
		decoration = mod_name..':moon_weed',
		name = 'moon_weed',
		flower = true,
	})
end


do
	local aspen_deco
	local grasses = {}
	for _, v in pairs(mod.decorations) do
		if v.name == 'default:aspen_tree' then
			aspen_deco = v
		elseif v.name:find('default:grass_[0-9]') then
			table.insert(grasses, v)
		end
	end

	if aspen_deco and aspen_deco.schematic_array and aspen_deco.schematic_array.data then
		local def = table.copy(aspen_deco)

		def.noise_params.seed = 754
		def.noise_params.offset = def.noise_params.offset - 0.005
		def.schematic = nil
		def.name = mod_name..':lumin_tree'
		def.schematic_array = table.copy(aspen_deco.schematic_array)
		for _, v in pairs(def.schematic_array.data) do
			if v.name == 'default:aspen_leaves' then
				v.name = mod_name..':leaves_lumin'
			end
			if v.name == 'default:aspen_tree' then
				v.name = mod_name..':lumin_tree'
			end
		end
		def.place_on = { mod_name..':cloud', }
		def.biomes = { 'cloud_sunny', }
		minetest.register_decoration(def)
	end

	for _, v in ipairs(grasses) do
		local def = table.copy(minetest.registered_nodes[v.decoration])
		local num = def.name:gsub('.*([0-9]).*', '%1')
		num = tonumber(num)
		local new_name = mod_name..':rainbow_grass_'..num
		local tile_name = 'mapgen_gray_grass_'..num..'.png^[brighten'
		def.description = 'Rainbow Grass'
		def.drop = nil
		def.palette = 'mapgen_palette_rainbow_1.png'
		def.tiles = { tile_name }
		minetest.register_node(new_name, def)
		layer_mod.grass_nodes[new_name] = true

		def = table.copy(v)
		def.place_on = { mod_name..':cloud', mod_name..':storm_cloud', }
		def.biomes = { 'cloud_sunny', mod_name..':storm_cloud', }
		def.decoration = new_name
		minetest.register_decoration(def)
	end
end


-----------------------------------------------
-- Cloudscape_Mapgen class
-----------------------------------------------

local Cloudscape_Mapgen = layer_mod.subclass_mapgen()


function Cloudscape_Mapgen:_init()
	self.ores = {
		{ mod_name..':silver_lining', 0, },
	}
	self.ore_intersect = {
		mod_name..':cloud',
		mod_name..':storm_cloud',
	}
end


function Cloudscape_Mapgen:generate()
	self:prepare()
	self:map_height()
	self:place_terrain()
	self:simple_ore(1)
end


function Cloudscape_Mapgen:map_height()
	local minp, maxp = self.minp, self.maxp
	local ground_noise_map = self.noises['cloudscape_1'].map
	local heightmap = self.heightmap
	self.reverse_heightmap = {}
	local reverse_heightmap = self.reverse_heightmap
	local base_level = self.cloud_level

	local height_min = layer_mod.max_height
	local height_max = -layer_mod.max_height

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			-- terrain height calculations
			local ground_1 = ground_noise_map[index]
			local height = self:terrain_height(ground_1, base_level)
			local depth = base_level - ground_1

			height = math_floor(height + 0.5)
			depth = math_floor(depth + 0.5)
			reverse_heightmap[index] = depth
			if depth >= base_level then
				height = minp.y - 2
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
function Cloudscape_Mapgen:place_terrain()
	local area = self.area
	local cave_biomes = mod.cave_biomes
	local data = self.data
	local heightmap = self.heightmap
	local reverse_heightmap = self.reverse_heightmap
	local grassmap = self.grassmap
	local biomemap = self.biomemap
	local maxp = self.maxp
	local minp = self.minp
	local ystride = area.ystride
	local p2data = self.p2data
	local water_level = self.water_level
	local base_level = self.cloud_level
	local wisp_level = base_level + 30
	local wisp_map = self.noises['cloudscape_2'].map
	local rainbow_map = self.noises['cloudscape_rainbow'].map
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
				local biome = self.biome or self.share.biome or biomemap[index]

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
				grass_p2 = rainbow_map[index] or 0
				grass_p2 = (math_floor(math_abs(grass_p2) + 0.5) % 8) * 32

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
					water_level = self.water_level
				else
					water_level = base_level + 14
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
						p2data[ivm] = 0 + grass_p2
					elseif filler and y <= height and y > fill_2 then
						data[ivm] = filler
						p2data[ivm] = 0
					elseif y <= height then
						data[ivm] = stone
						p2data[ivm] = 0
					elseif y <= wisp_level + wisps and y >= wisp_level - wisps then
						data[ivm] = node[mod_name..':wispy_cloud']
						p2data[ivm] = 0
					end

					ivm = ivm + ystride
				end
				mod.time_y_loop = mod.time_y_loop + os_clock() - t_y_loop
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


function Cloudscape_Mapgen:prepare()
	local minp, maxp = self.minp, self.maxp
	local chunk_offset = self.chunk_offset

	self.gpr = PcgRandom(self.seed + 7712)

	local base_level = self.cloud_level
	self.base_level = base_level

	self.height_offset = base_level
end


function Cloudscape_Mapgen:terrain_height(ground_1, base_level)
	-- terrain height calculations
	local height = base_level + ground_1
	if height > base_level + 15 then
		height = height - 2 * (height - base_level - 15)
	end
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

	local biomes = {
		{
			name = 'cloud_sunny',
			heat_point = 60,
			humidity_point = 50,
			node_stone = mod_name..':cloud',
			node_top = mod_name..':cloud',
			depth_top = 1,
			node_riverbed = mod_name..':wet_cloud',
			source = 'cloudscape',
		},
		{
			name = 'cloud_storm',
			heat_point = 30,
			humidity_point = 50,
			node_stone = mod_name..':storm_cloud',
			node_top = mod_name..':storm_cloud',
			depth_top = 1,
			node_riverbed = mod_name..':wet_cloud',
			source = 'cloudscape',
		},
	}

	local noises = {
		cloudscape_1 = { def = {offset = 0, scale = 10, seed = 4877, spread = {x = 120, y = 120, z = 120}, octaves = 3, persist = 1, lacunarity = 2}, },
		cloudscape_2 = { def = {offset = 0, scale = 1, seed = 5748, spread = {x = 40, y = 10, z = 40}, octaves = 3, persist = 1, lacunarity = 2}, },
		cloudscape_rainbow = { def = {offset = 0, scale = 7, seed = 4877, spread = {x = 100, y = 100, z = 100}, octaves = 2, persist = 0.4, lacunarity = 2}, },
	}


	layer_mod.register_map({
		name = 'cloudscape',
		biomes = biomes,
		cloud_level = 168,
		mapgen = Cloudscape_Mapgen,
		mapgen_name = 'cloudscape',
		map_minp = VN(-max_chunks, 2, -max_chunks),
		map_maxp = VN(max_chunks, 3, max_chunks),
		noises = noises,
		water_level = 1,
	})
end
