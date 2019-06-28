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
		groups = {snappy=3,flammable=2,flora=1,attached_node=1},
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


	--register_flower('orchid', 'Orchid', {'rainforest', 'rainforest_swamp'}, 0.025)
	--register_flower('bird_of_paradise', 'Bird of Paradise', {'rainforest', 'desertstone_grassland'}, 0.025)
	--register_flower('gerbera', 'Gerbera', {'savanna', 'rainforest', 'desertstone_grassland'}, 0.005)


	mod.water_plants = {}
	local function register_water_plant(desc)
		if not (desc and type(desc) == 'table') then
			return
		end

		mod.water_plants[#mod.water_plants+1] = desc
	end


	plantlist = {
		{name='water_plant_1',
		 desc='Water Plant',
		 water=true,
		},
	}


	for _, plant in ipairs(plantlist) do
		if plant.coral then
			groups = {cracky=3, stone=1, attached_node=1}
		else
			groups = {snappy=3,flammable=2,flora=1,attached_node=1}
		end
		if plant.groups then
			for k,v in pairs(plant.groups) do
				groups[k] = v
			end
		end

		minetest.register_node(mod_name..':'..plant.name, {
			description = plant.desc,
			drawtype = 'plantlike',
			tiles = {'mapgen_'..plant.name..'.png'},
			waving = plant.wave,
			sunlight_propagates = plant.light,
			paramtype = 'light',
			walkable = false,
			groups = groups,
			sounds = default.node_sound_leaves_defaults(),
			selection_box = {
				type = 'fixed',
				fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
			},
		})

		if plant.water then
			local def = {
				description = plant.desc,
				drawtype = 'nodebox',
				node_box = {type='fixed', fixed={{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, {-0.5, 0.5, -0.001, 0.5, 1.5, 0.001}, {-0.001, 0.5, -0.5, 0.001, 1.5, 0.5}}},
				drop = mod_name..':'..plant.name,
				tiles = { 'default_sand.png', 'mapgen_'..plant.name..'.png',},
				--tiles = { 'default_dirt.png', 'mapgen_'..plant.name..'.png',},
				sunlight_propagates = plant.light,
				--light_source = 14,
				paramtype = 'light',
				light_source = plant.light_source,
				walkable = true,
				groups = groups,
				selection_box = {
					type = 'fixed',
					fixed = {-0.5, 0.5, -0.5, 0.5, 11/16, 0.5},
				},
				sounds = plant.sounds or default.node_sound_leaves_defaults(),
				after_dig_node = function(pos, oldnode, oldmetadata, digger)
					if not (pos and oldnode) then
						return
					end

					local replacement = oldnode.name:gsub('.*_water_(.*)', 'default:%1')
					if replacement:find('cloud$') then
						replacement = replacement:gsub('^default', 'fun_caves')
					end
					minetest.set_node(pos, {name = replacement})
				end,
			}
			minetest.register_node(mod_name..':'..plant.name..'_water_sand', def)
			def2 = table.copy(def)
			def2.tiles = { 'default_dirt.png', 'mapgen_'..plant.name..'.png',}
			minetest.register_node(mod_name..':'..plant.name..'_water_dirt', def2)
			def2 = table.copy(def)
			def2.tiles = { 'mapgen_cloud.png', 'mapgen_'..plant.name..'.png',}
			minetest.register_node(mod_name..':'..plant.name..'_water_cloud', def2)
			def2 = table.copy(def)
			def2.tiles = { 'mapgen_storm_cloud.png', 'mapgen_'..plant.name..'.png',}
			minetest.register_node(mod_name..':'..plant.name..'_water_storm_cloud', def2)
		end
	end


	do
		-- Water Plant
		local water_plant_1_def_sand = {
			fill_ratio = 0.05,
			place_on = {'group:sand'},
			decoration = {mod_name..':water_plant_1_water_sand'},
			--biomes = {'sandstone_grassland', 'stone_grassland', 'coniferous_forest', 'deciduous_forest', 'desert', 'savanna', 'rainforest', 'rainforest_swamp', },
			biomes = {'sandstone_grassland', 'stone_grassland', 'coniferous_forest', 'deciduous_forest', 'savanna', 'rainforest', 'rainforest_swamp','sandstone_grassland_ocean', 'stone_grassland_ocean', 'coniferous_forest_ocean', 'deciduous_forest_ocean', 'desert_ocean', 'savanna_ocean', 'desertstone_grassland', },
			y_max = 60,
		}
		if not mod.use_bi_hi then
			water_plant_1_def_sand.biomes = nil
		end

		local water_plant_1_def_dirt = table.copy(water_plant_1_def_sand)
		water_plant_1_def_dirt.place_on = {'group:soil'}
		water_plant_1_def_dirt.decoration = {mod_name..':water_plant_1_water_dirt',}
		local water_plant_1_def_cloud = table.copy(water_plant_1_def_sand)
		water_plant_1_def_cloud.place_on = {'group:cloud'}
		water_plant_1_def_cloud.decoration = {mod_name..':water_plant_1_water_cloud',}
		local water_plant_1_def_storm_cloud = table.copy(water_plant_1_def_sand)
		water_plant_1_def_storm_cloud.place_on = {'group:cloud'}
		water_plant_1_def_storm_cloud.decoration = {mod_name..':water_plant_1_water_storm_cloud',}

		register_water_plant(water_plant_1_def_sand)
		register_water_plant(water_plant_1_def_dirt)
		register_water_plant(water_plant_1_def_cloud)
		register_water_plant(water_plant_1_def_storm_cloud)
	end


	-- Get the content ids for all registered water plants.
	for _, desc in pairs(mod.water_plants) do
		if type(desc.decoration) == 'string' then
			desc.content_id = minetest.get_content_id(desc.decoration)
		elseif type(desc.decoration) == 'table' then
			desc.content_id = minetest.get_content_id(desc.decoration[1])
		end
	end
end


--[[
do
	minetest.register_biome({
		name = 'cloud_sunny',
		heat_point = 60,
		humidity_point = 50,
		node_stone = mod_name..':cloud',
		source = 'cloudscape',
	})

	minetest.register_biome({
		name = 'cloud_storm',
		heat_point = 30,
		humidity_point = 50,
		node_stone = mod_name..':storm_cloud',
		source = 'cloudscape',
	})
end
--]]


-----------------------------------------------
-- Cloudscape_Mapgen class
-----------------------------------------------

local Cloudscape_Mapgen = layer_mod.subclass_mapgen()


function Cloudscape_Mapgen:generate()
	self:prepare()
	self:map_height()
	self:place_terrain()
	--self:after_terrain()
end


function Cloudscape_Mapgen:map_height()
	local minp, maxp = self.minp, self.maxp
	local ground_noise_map = self.noise['cloudscape_1'].map
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
			heightmap[index] = height
			reverse_heightmap[index] = depth
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
	local wisp_map = self.noise['cloudscape_2'].map

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
			local wisps = height + 10
			if reverse_heightmap[index] < base_level then
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
				if biome.node_top == 'default:dirt_with_dry_grass'
				or biome.node_top == 'default:dirt_with_grass' then
					grass_p2 = grassmap[index] or 0
				end

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

				if math_abs(height - base_level) == math_abs(reverse_heightmap[index] - base_level) then
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
					elseif y <= height and y > fill_1 then
						data[ivm] = top
						p2data[ivm] = 0 + grass_p2
					elseif filler and y <= height and y > fill_2 then
						data[ivm] = filler
						p2data[ivm] = 0
					elseif y <= height then
						data[ivm] = stone
						p2data[ivm] = 0
					elseif y <= wisps then
						data[ivm] = node[mod_name..':wispy_cloud']
						p2data[ivm] = 0
					end

					ivm = ivm + ystride
				end
				mod.time_y_loop = mod.time_y_loop + os_clock() - t_y_loop
	else
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
			source = 'cloudscape',
		},
		{
			name = 'cloud_storm',
			heat_point = 30,
			humidity_point = 50,
			node_stone = mod_name..':storm_cloud',
			source = 'cloudscape',
		},
	}

	local noises = {
		cloudscape_1 = { def = {offset = 10, scale = 10, seed = 4877, spread = {x = 120, y = 120, z = 120}, octaves = 3, persist = 1, lacunarity = 2}, },
		cloudscape_2 = { def = {offset = 0, scale = 1, seed = 5748, spread = {x = 40, y = 10, z = 40}, octaves = 3, persist = 1, lacunarity = 2}, },
	}


	layer_mod.register_map({
		name = 'cloudscape',
		biomes = biomes,
		mapgen = Cloudscape_Mapgen,
		mapgen_name = 'cloudscape',
		minp = VN(-max_chunks, 2, -max_chunks),
		maxp = VN(max_chunks, 4, max_chunks),
		noises = noises,
		params = { cloud_level = 168 },
		water_level = 1,
	})
end
