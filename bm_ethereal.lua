-- Duane's mapgen bm_ethereal.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


bm_ethereal = {}
local mod, layers_mod = bm_ethereal, mapgen
local biomes = layers_mod.registered_biomes


if not minetest.get_modpath('ethereal') then
	minetest.log(layers_mod.mod_name .. ': * The Ethereal mod is not selected. Biomes will be disabled.')
	return
end


-----------------------------------------------
--
-----------------------------------------------


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


function mod.bm_ethereal(params)
	local offset = params.biome_height_offset or 0
	local water_level = params.sealevel
	local minp, maxp = params.isect_minp, params.isect_maxp
	local csize = params.csize
	local biomes_i = {}

	params.share.disable_icing = true

	if not params.biomes_here then
		params.biomes_here = {}
	end

	-- Biome selection is expensive. This helps a bit.
	for _, b in pairs(biomes) do
		if b.source == 'ethereal' then
			table.insert(biomes_i, b)
		end
	end

	local heat_map = layers_mod.get_noise2d({
		name = 'heat',
		pos = { x = minp.x, y = minp.z },
		size = {x=csize.x, y=csize.z},
	})
	local heat_blend_map = layers_mod.get_noise2d({
		name = 'heat_blend',
		pos = { x = minp.x, y = minp.z },
		size = {x=csize.x, y=csize.z},
	})
	local humidity_map = layers_mod.get_noise2d({
		name = 'humidity',
		pos = { x = minp.x, y = minp.z },
		size = {x=csize.x, y=csize.z},
	})
	local humidity_blend_map = layers_mod.get_noise2d({
		name = 'humidity_blend',
		pos = { x = minp.x, y = minp.z },
		size = {x=csize.x, y=csize.z},
	})

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local surface = params.share.surface[z][x]
			local height = (surface.top or minp.y - 2) - water_level - offset + 1
			local heat, heat_blend, humidity, humidity_blend

			surface.biome_height = height

			heat = heat_map[index]
			heat_blend = heat_blend_map[index]
			humidity = humidity_map[index]
			humidity_blend = humidity_blend_map[index]

			heat = heat + heat_blend
			humidity = humidity + humidity_blend

			if height > 25 then
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


dofile(layers_mod.path .. '/ethereal_biomes.lua')


layers_mod.register_mapfunc('bm_ethereal', mod.bm_ethereal)
