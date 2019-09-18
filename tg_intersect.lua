-- Duane's mapgen tg_intersect.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

-- The basic algorithm comes from Paramat's Intersect mod,
--  but it's been through a couple of mods since.


tg_intersect = {}
local mod, layers_mod = tg_intersect, mapgen
local mod_name = 'tg_intersect'
local ground_c
local replace


function mod.generate_intersect(params)
	if params.share.disruptive then
		return
	end

				--local t_yloop = os.clock()
	local t_caves = os.clock()

	local minp, maxp = params.isect_minp, params.isect_maxp
	local area, data, p2data = params.area, params.data, params.vmparam2
	local csize = vector.add(vector.subtract(maxp, minp), 1)

	local node = layers_mod.node
	local n_air = node['air']
	local n_stone = node['default:stone']
	local n_ignore = node['ignore']
	local n_placeholder_lining = node[layers_mod.mod_name .. ':placeholder_lining']

	if not replace then
		replace = {
			[ n_stone ] = true,
			[ n_placeholder_lining ] = true,
			[ node['doors:door_wood_a'] ] = true,
			[ node['doors:door_wood_b'] ] = true,
			[ n_ignore ] = true,
		}
	end

	if not ground_c then
		ground_c = {
			[node['default:stone']] = true,
			[node['default:sandstone']] = true,
			[node['default:desert_stone']] = true,
			[node['default:cave_ice']] = true,
		}
	end

	params.share.propagate_shadow = true

	--[[
	if params.share.height_min and params.share.height_min > maxp.y then
		local skip
		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				local ivm = area:index(x, maxp.y + 1, z)
				if data[ivm] ~= n_air and data[ivm] ~= n_ignore then
					skip = true
					break
				end
			end

			if skip then
				break
			end
		end

		if not skip then
			for z = minp.z, maxp.z do
				for x = minp.x, maxp.x do
					local ivm = area:index(x, maxp.y + 1, z)
					data[ivm] = n_stone
				end
			end
		end
	end
	--]]

	--[[
	-- make a fake surface for biomes
	local surface = {}
	local height = math.floor((minp.y + maxp.y) / 2)
	for z = minp.z, maxp.z do
		surface[z] = {}
		for x = minp.x, maxp.x do
			surface[z][x] = {
				biome = layers_mod.undefined_biome,
				top = height,
				--cave_floor = cave_low,  -- Not cave_top; that's confusing.
				--cave_ceiling = cave_high,
			}
		end
	end
	params.share.cave_layer = {
		minp = minp,
	}

	-- Let realms do the biomes.
	params.share.surface = surface
	if params.biomefunc then
		layers_mod.rmf[params.biomefunc](params)
	end
	--]]

	local cave_noise_def_1 = {
		offset = 0,
		scale = 1,
		seed = -8402,
		spread = {x = 128, y = 64, z = 128},
		octaves = 3,
		persist = 0.5,
		lacunarity = 2,
	}
	local cave_noise_def_2 = {
		offset = 0,
		scale = 1,
		seed = 3944,
		spread = {x = 128, y = 64, z = 128},
		octaves = 3,
		persist = 0.5,
		lacunarity = 2,
	}
	local cave_noise_1 = minetest.get_perlin_map(cave_noise_def_1, csize):get3dMap_flat(minp)
	local cave_noise_2 = minetest.get_perlin_map(cave_noise_def_2, csize):get3dMap_flat(minp)

	local base_level = params.share.base_level
	local height_max = math.max(params.share.height_max - 20, (base_level or 8))
	local surface = params.share.surface
	local index3d = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = surface[z][x].top
			local ivm = area:index(x, minp.y, z)
			local index3d = (z - minp.z) * csize.y * csize.x + (x - minp.x) + 1
			local close = base_level and height <= base_level
			local border = (x == minp.x or x == maxp.x or z == minp.z or z == maxp.z)

			for y = minp.y, maxp.y do
				local n1 = (math.abs(cave_noise_1[index3d]) < 0.07)
				local n2 = (math.abs(cave_noise_2[index3d]) < 0.07)
				local n3 = (math.abs(cave_noise_1[index3d]) < 0.09)
				local n4 = (math.abs(cave_noise_2[index3d]) < 0.09)

				if n1 and n2 then
					surface[z][x].cave_in = true
					local skip
					if close or y > height_max then
						local depth = height - y
						if depth == 1 then
							skip = true
						elseif height ~= base_level
						and depth > 1 and depth <= 4 then
							skip = true
						end
					end

					--if replace[data[ivm]] and not skip then
					if not skip then
						data[ivm] = n_air
						p2data[ivm] = 0

						if border then
							params.share.intersected = true
						end
					end
				elseif n3 and n4 and not params.share.no_biome then
					local skip
					if close or y > height_max then
						local depth = height - y
						if depth < 20 then
							skip = true
						end
					end

					if replace[data[ivm]] and not skip then
						data[ivm] = n_placeholder_lining
						p2data[ivm] = 0

						if border then
							params.share.intersected = true
						end
					end
				end

				index3d = index3d + csize.x
				ivm = ivm + area.ystride
			end
		end
	end

	layers_mod.time_caves = layers_mod.time_caves + os.clock() - t_caves

				--layers_mod.time_y_loop = (layers_mod.time_y_loop or 0) + os.clock() - t_yloop
end


layers_mod.register_mapgen('tg_intersect', mod.generate_intersect)
