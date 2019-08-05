-- Duane's mapgen bm_default_biomes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


bm_default_biomes = {}
local mod, layers_mod = bm_default_biomes, mapgen
local biomes = layers_mod.registered_biomes
local chunksize = tonumber(minetest.settings:get('chunksize') or 5)
local chunk_offset = math.floor(chunksize / 2) * 16;


function mod.get_biome(biomes_i, heat, humidity, height)
	local biome, biome_diff
	for _, b in ipairs(biomes_i) do
		if b and (not b.y_max or b.y_max >= height)
		and (not b.y_min or b.y_min <= height) then
			local diff_he = b.heat_point - heat
			local diff_hu = b.humidity_point - humidity
			local diff = diff_he * diff_he + diff_hu * diff_hu
			if ((not biome_diff) or diff < biome_diff) then
				biome_diff = diff
				biome = b
			end
		end
	end
	return biome
end


function mod.bm_default_biomes(params)
	local offset = params.biome_height_offset or 0
	local water_level = params.sealevel
	local minp, maxp = params.isect_minp, params.isect_maxp
	local csize = params.csize
	local biomes_i = {}

	if not params.biomes_here then
		params.biomes_here = {}
	end

	-- Biome selection is expensive. This helps a bit.
	for _, b in pairs(biomes) do
		table.insert(biomes_i, b)
	end

	local heat_map
	if not params.geographic_heat then
		heat_map = layers_mod.get_noise2d('heat', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	end
	local heat_blend_map = layers_mod.get_noise2d('heat_blend', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	local humidity_map = layers_mod.get_noise2d('humidity', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	local humidity_blend_map = layers_mod.get_noise2d('humidity_blend', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })

	local index = 1
	for z = minp.z, maxp.z do
		local heat_base
		if params.geographic_heat then
			heat_base = 15 + math.abs(70 - ((((z + 1000) / 6000) * 140) % 140))
		end
		for x = minp.x, maxp.x do
			local surface = params.share.surface[z][x]
			local height = (surface.top or minp.y - 2) - water_level - offset
			local heat, heat_blend, humidity, humidity_blend

			if params.geographic_heat then
				heat = heat_base
			else
				heat = heat_map[index]
			end
			heat_blend = heat_blend_map[index]
			humidity = humidity_map[index]
			humidity_blend = humidity_blend_map[index]

			heat = heat + heat_blend
			humidity = humidity + humidity_blend

			if height > 25 then
				local t = heat
				local h2 = height - 25
				heat = heat - h2 * h2 * 0.005
			end

			surface.heat = heat
			surface.humidity = humidity

			local grass_p2 = math.floor((humidity - (heat / 2) + 9) / 3)
			grass_p2 = (7 - math.min(7, math.max(0, grass_p2))) * 32
			surface.grass_p2 = grass_p2

			local biome = mod.get_biome(biomes_i, heat, humidity, height)

			if biome then
				surface.biome = biome
				if params.biomes_here[biome.name] == true then
					params.biomes_here[biome.name] = 1
				end
				params.biomes_here[biome.name] = (params.biomes_here[biome.name] or 0) + 1
			end

			index = index + 1
		end
	end
end


do
	-- This tries to determine which biomes are default.
	local default_biome_names = {
		['cold_desert_ocean'] = true,
		['cold_desert'] = true,
		['coniferous_forest_dunes'] = true,
		['coniferous_forest_ocean'] = true,
		['coniferous_forest'] = true,
		['deciduous_forest_ocean'] = true,
		['deciduous_forest_shore'] = true,
		['deciduous_forest'] = true,
		['desert_ocean'] = true,
		['desert'] = true,
		['grassland_dunes'] = true,
		['grassland_ocean'] = true,
		['grassland'] = true,
		['icesheet_ocean'] = true,
		['icesheet'] = true,
		['rainforest_ocean'] = true,
		['rainforest_swamp'] = true,
		['rainforest'] = true,
		['sandstone_desert_ocean'] = true,
		['sandstone_desert'] = true,
		['savanna_ocean'] = true,
		['savanna_shore'] = true,
		['savanna'] = true,
		['snowy_grassland_ocean'] = true,
		['snowy_grassland'] = true,
		['taiga_ocean'] = true,
		['taiga'] = true,
		['tundra_beach'] = true,
		['tundra_highland'] = true,
		['tundra_ocean'] = true,
		['tundra'] = true,
		['underground'] = true,
	}

	for _, v in pairs(minetest.registered_biomes) do
		if default_biome_names[v.name] then
			layers_mod.register_biome(v, 'default')
		else
			layers_mod.register_biome(v, v.source)
		end
	end
end


do
	mod.decorations = {}
	for _, v in pairs(minetest.registered_decorations) do
		layers_mod.register_decoration(v)
	end

	-- Catch any registered by other mods.
	local old_register_decoration = minetest.register_decoration
	minetest.register_decoration = function (def)
		layers_mod.register_decoration(def)
		old_register_decoration(def)
	end


	local old_clear_registered_decorations = minetest.clear_registered_decorations
	minetest.clear_registered_decorations = function ()
		layers_mod.decorations = {}
		old_clear_registered_decorations()
	end


	local old_register_biome = minetest.register_biome
	minetest.register_biome = function (def)
		layers_mod.register_biome(def)
		old_register_biome(def)
	end


	local old_clear_registered_biomes = minetest.clear_registered_biomes
	minetest.clear_registered_biomes = function ()
		layers_mod.biomes = {}
		old_clear_registered_biomes()
	end
end


layers_mod.register_mapfunc('bm_default_biomes', mod.bm_default_biomes)
