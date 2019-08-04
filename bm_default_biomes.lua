-- Duane's mapgen bm_default_biomes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


bm_default_biomes = {}
local mod, layers_mod = bm_default_biomes, mapgen
local biomes = layers_mod.registered_biomes


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

	local heat_map = layers_mod.get_noise2d('heat', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	local heat_blend_map = layers_mod.get_noise2d('heat_blend', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	local humidity_map = layers_mod.get_noise2d('humidity', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	local humidity_blend_map = layers_mod.get_noise2d('humidity_blend', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local surface = params.share.surface[z][x]
			local height = (surface.top or minp.y - 2) - water_level - offset
			local heat, heat_blend, humidity, humidity_blend
			local heat = heat_map[index]
			local heat_blend = heat_blend_map[index]
			local humidity = humidity_map[index]
			local humidity_blend = humidity_blend_map[index]

			heat = heat + heat_blend
			humidity = humidity + humidity_blend

			if height > water_level + 25 then
				local h2 = height - water_level - 25
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


layers_mod.register_mapfunc('bm_default_biomes', mod.bm_default_biomes)
