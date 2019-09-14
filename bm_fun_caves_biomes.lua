-- Duane's mapgen bm_fun_caves_biomes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


bm_fun_caves_biomes = {}
local mod, layers_mod = bm_fun_caves_biomes, mapgen
local biomes = layers_mod.registered_biomes
local chunksize = tonumber(minetest.settings:get('chunksize') or 5)
local chunk_offset = math.floor(chunksize / 2) * 16;

local node
if layers_mod.mod_name == 'mapgen' then
	node = layers_mod.node
	clone_node = layers_mod.clone_node
else
	dofile(mod.path .. '/functions.lua')
	node = mod.node
	clone_node = mod.clone_node
end


-----------------------------------------------
--
-----------------------------------------------

-- FIX: water biomes
-- FIX: ore generation


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


local default_sources = {
	['fun_caves'] = true,
}

function mod.bm_fun_caves_biomes(params)
	local offset = params.biome_height_offset or 0
	local water_level = params.sealevel
	local minp, maxp = params.isect_minp, params.isect_maxp
	local area, data, p2data = params.area, params.data, params.p2data
	local csize = params.csize
	local ystride = area.ystride
	local biomes_i = {}

	local n_stone = node['default:stone']
	local n_desert_stone = node['default:desert_stone']
	local n_air = node['air']
	local n_water = node['default:water_source']
	local n_ice = node['default:ice']
	local n_ignore = node['ignore']
	local n_sand = node['default:sand']
	local n_clay = node['default:clay']

	local empty = {
		[n_air] = true,
		[n_ignore] = true,
	}

	if not params.biomes_here then
		params.biomes_here = {}
	end

	-- Biome selection is expensive. This helps a bit.
	for _, b in pairs(biomes) do
		if default_sources[b.source] and b.wet == params.share.wet_cave then
			table.insert(biomes_i, b)
		end
	end

	local cl_min_y
	if params.share.cave_layer then
		cl_min_y = params.share.cave_layer.minp.y
	else
		cl_min_y = params.isect_minp.y
	end
	local seedb = cl_min_y % 1137
	local heat_map = layers_mod.get_noise2d('fun_caves_heat', nil, seedb, nil, {x=csize.x, y=csize.z}, { x = minp.x, y = minp.z })
	local humidity_map = layers_mod.get_noise2d('fun_caves_humidity', nil, seedb, nil, {x=csize.x, y=csize.z}, { x = minp.x, y = minp.z })

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local surface = params.share.surface[z][x]

			local biome
			local heat = heat_map[index]
			local humidity = humidity_map[index]
			local height = surface.top

			if height - 20 >= minp.y then
				biome = mod.get_biome(biomes_i, heat, humidity, height)
				--biome = layers_mod.registered_biomes['coal']

				local grass_p2 = math.floor((humidity - (heat / 2) + 9) / 3)
				grass_p2 = (7 - math.min(7, math.max(0, grass_p2))) * 32
				surface.grass_p2 = grass_p2
			end

			if biome then
				--surface.biome = biome
				if params.biomes_here[biome.name] == true then
					params.biomes_here[biome.name] = 1
				end
				params.biomes_here[biome.name] = (params.biomes_here[biome.name] or 0) + 1

				local n_b_stone = biome.node_stone or n_stone
				local n_ceiling = biome.node_ceiling or biome.node_lining
				local n_floor = biome.node_floor or biome.node_lining
				local n_fluid = biome.node_cave_liquid or n_water
				local surface_depth = biome.surface_depth or 1
				local n_gas = biome.node_air or n_air

				local fill_1, fill_2
				local ivm = area:index(x, minp.y, z)
				for y = minp.y, maxp.y do
					local depth = height - y
					if y > height - 20 then
						-- nop
					elseif n_floor and empty[data[ivm]] and data[ivm - ystride] == n_stone then
						-- floor
						data[ivm - ystride] = n_floor
						if surface_depth > 1 then
							data[ivm - ystride * 2] = n_ceiling
						end
					elseif n_ceiling and empty[data[ivm]] and data[ivm + ystride] == n_stone then
						-- ceiling
						data[ivm + ystride] = n_ceiling
						if surface_depth > 1 then
							data[ivm + ystride * 2] = n_floor
						end
					elseif data[ivm] == n_stone and depth > 20 then
						data[ivm] = n_b_stone
					end

					ivm = ivm + ystride
				end
			end

			index = index + 1
		end
	end
end


layers_mod.register_noise( 'fun_caves_heat', { offset = 50, scale = 50, spread = {x = 700, y = 700, z = 700}, seed = 4512, octaves = 3, persistence = 0.5, lacunarity = 2.0, flags = 'eased' } )
layers_mod.register_noise( 'fun_caves_humidity', { offset = 50, scale = 50, seed = 168, spread = {x = 700, y = 700, z = 700}, octaves = 3, persist = 0.5, lacunarity = 2, flags = 'eased' } )


dofile(layers_mod.path .. '/fun_caves_biomes.lua')

layers_mod.register_mapfunc('bm_fun_caves_biomes', mod.bm_fun_caves_biomes)
