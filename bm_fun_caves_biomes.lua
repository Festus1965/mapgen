-- Duane's mapgen bm_fun_caves_biomes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


bm_fun_caves_biomes = {}
local mod, layers_mod = bm_fun_caves_biomes, mapgen
local biomes = layers_mod.registered_biomes
local VN = vector.new
local CAVE_UNDERGROUND = 5
local DIRT_CHANCE = 10
local node = layers_mod.node


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
	biome = biome or layers_mod.registered_biomes['stone']
	--biome = layers_mod.registered_biomes['basalt_lava']
	return biome
end


local default_sources = {
	['fun_caves'] = true,
}

local chunk_heat_noise = PerlinNoise(layers_mod.registered_noises['heat'])
local chunk_humidity_noise = PerlinNoise(layers_mod.registered_noises['humidity'])

function mod.bm_fun_caves_biomes(params)
				--local t_yloop = os.clock()
	local minp, maxp = params.isect_minp, params.isect_maxp
	local area, data, p2data = params.area, params.data, params.p2data
	local csize = params.csize
	local ystride = area.ystride
	local biomes_i = {}
	local pr = params.gpr

	local n_stone = node['default:stone']
	local n_dirt = node['default:dirt']
	local n_air = node['air']
	local n_ignore = node['ignore']
	local n_sand = node['default:sand']
	local n_placeholder_lining = node[layers_mod.mod_name .. ':placeholder_lining']

	local empty = {
		[n_air] = true,
		[n_ignore] = true,
	}

	if not params.share.biomes_here then
		params.share.biomes_here = {}
	end

	-- Biome selection is expensive. This helps a bit.
	for _, b in pairs(biomes) do
		if default_sources[b.source] and b.wet ~= params.share.intersected then
			table.insert(biomes_i, b)
		end
	end

	local cl_min_y, seedb, heat_map, humidity_map
	if params.share.cave_layer then
		cl_min_y = params.share.cave_layer.minp.y
		seedb = cl_min_y % 1137
		heat_map = layers_mod.get_noise2d({
			name = 'fun_caves_heat',
			seed = seedb,
			pos = { x = minp.x, y = minp.z },
			size = {x=csize.x, y=csize.z},
		})
		humidity_map = layers_mod.get_noise2d({
			name = 'fun_caves_humidity',
			seed = seedb,
			pos = { x = minp.x, y = minp.z },
			size = {x=csize.x, y=csize.z},
		})
	else
		local heat = chunk_heat_noise:get_3d({ x = minp.x, y = minp.y, z = minp.z })
		local humidity = chunk_humidity_noise:get_3d({ x = minp.x, y = minp.y, z = minp.z })
		local biome = mod.get_biome(biomes_i, heat, humidity, minp.y)
		biome = biome or layers_mod.registered_biomes['stone']
		--biome = layers_mod.registered_biomes['mossy']
		params.share.cave_biome = biome
	end

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local surface = params.share.surface[z][x]
			local height = surface.top
			local biome

			if heat_map and humidity_map then
				biome = layers_mod.registered_biomes['stone']
				local heat = heat_map[index]
				local humidity = humidity_map[index]

				if height - 20 >= minp.y then
					biome = mod.get_biome(biomes_i, heat, humidity, height)
					--biome = layers_mod.registered_biomes['coal']
				end
			else
				biome = params.share.cave_biome
			end

			do
				if params.share.biomes_here[biome.name] == true then
					params.share.biomes_here[biome.name] = 1
				end
				params.share.biomes_here[biome.name] = (params.share.biomes_here[biome.name] or 0) + 1

				-- Surface depth is ignored for expediency.
				biome = biome or {}
				local n_b_stone = node[biome.node_stone] or n_stone
				local n_ceiling = node[biome.node_ceiling] or node[biome.node_lining] or n_b_stone
				local n_floor = node[biome.node_floor] or node[biome.node_lining] or n_b_stone
				--local n_fluid = node[biome.node_cave_liquid] or n_water
				--local n_gas = node[biome.node_air] or n_air

				-- This depends on the cave mods to drop a placeholder
				--  node where the ceilings and floors should be.
				-- It's faster and prettier, if not as precise.
				local ivm = area:index(x, minp.y, z)
				for y = minp.y, maxp.y do
					local depth = height - y
					if y > height - 20 then
						if data[ivm] == n_placeholder_lining then
							if pr:next(1, DIRT_CHANCE) == 1 then
								data[ivm] = n_dirt
							else
								data[ivm] = n_stone
							end
							p2data[ivm] = 0
						end
					elseif data[ivm] == n_placeholder_lining then
						if n_floor == n_sand and empty[data[ivm - ystride]] then
							data[ivm] = n_ceiling
						elseif pr:next(1, DIRT_CHANCE) == 1 then
							data[ivm] = n_dirt
						else
							data[ivm] = n_floor
						end
						p2data[ivm] = 0
					elseif data[ivm] == n_stone and depth > 20 then
						data[ivm] = n_b_stone
						p2data[ivm] = 0
					end

					ivm = ivm + ystride
				end
			end

			index = index + 1
		end
	end

	if not params.share.intersected and maxp.y <= params.sealevel then
		local biome = params.share.cave_biome or {}
		local liquid = biome.node_cave_liquid or 'default:water_source'
		local geo = Geomorph.new(params)
		local cave_water_level = pr:next(1, 26) + pr:next(1, 26) + pr:next(1, 26)
		params.share.cave_water_level = cave_water_level + minp.y

		if liquid then
			geo:add({
				action = 'cube',
				node = liquid,
				location = VN(1, 1, 1),
				underground = CAVE_UNDERGROUND,
				intersect = 'air',
				size = VN(78, cave_water_level, 78)
			})
		end

		geo:write_to_map(0)
	end

				--layers_mod.time_y_loop = (layers_mod.time_y_loop or 0) + os.clock() - t_yloop
end


layers_mod.register_noise( 'fun_caves_heat', {
	offset = 50,
	scale = 50,
	spread = {x = 700, y = 700, z = 700},
	seed = 4512,
	octaves = 3,
	persistence = 0.5,
	lacunarity = 2.0,
	flags = 'eased'
} )
layers_mod.register_noise( 'fun_caves_humidity', {
	offset = 50,
	scale = 50,
	seed = 168,
	spread = {x = 700, y = 700, z = 700},
	octaves = 3,
	persist = 0.5,
	lacunarity = 2,
	flags = 'eased'
} )


dofile(layers_mod.path .. '/fun_caves_biomes.lua')

layers_mod.register_mapfunc('bm_fun_caves_biomes', mod.bm_fun_caves_biomes)
