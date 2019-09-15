-- Duane's mapgen tg_intersect.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

-- The basic algorithm comes from Paramat's Intersect mod,
--  but it's been through a couple of mods since.


local mod, layers_mod
if minetest.get_modpath('realms') then
	layers_mod = realms
	mod = floaters
else
	layers_mod = mapgen
	mod = mapgen
end

local mod_name = mod.mod_name
local ground_c, move_down


function mod.generate_intersect(params)
	local t_caves = os.clock()

	local minp, maxp = params.isect_minp, params.isect_maxp
	local area, data, p2data = params.area, params.data, params.vmparam2
	local csize = vector.add(vector.subtract(maxp, minp), 1)

	local node = layers_mod.node
	local n_air = node['air']
	local n_ignore = node['ignore']
	local n_water = node['default:water_source']
	local n_stone = node['default:stone']
	local n_lava = node['default:lava_source']
	local n_placeholder_lining = node[layers_mod.mod_name .. ':placeholder_lining']

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

	local cave_noise_1 = minetest.get_perlin_map({offset = 0, scale = 1, seed = -8402, spread = {x = 128, y = 64, z = 128}, octaves = 3, persist = 0.5, lacunarity = 2}, csize):get3dMap_flat(minp)
	local cave_noise_2 = minetest.get_perlin_map({offset = 0, scale = 1, seed = 3944, spread = {x = 128, y = 64, z = 128}, octaves = 3, persist = 0.5, lacunarity = 2}, csize):get3dMap_flat(minp)

	local base_level = params.share.base_level
	local height_max = math.max(params.share.height_max, (base_level or 8) + 20)
	local surface = params.share.surface
	local index3d = 0
	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			local close = height_max - y < 20

			for x = minp.x, maxp.x do
				index3d = index3d + 1
				local ivm = area:index(x, y, z)

				local n1 = (math.abs(cave_noise_1[index3d]) < 0.07)
				local n2 = (math.abs(cave_noise_2[index3d]) < 0.07)
				local n3 = (math.abs(cave_noise_1[index3d]) < 0.09)
				local n4 = (math.abs(cave_noise_2[index3d]) < 0.09)
				if n1 and n2 then
					local height = surface[z][x].top
					local skip
					if close or (base_level and height <= base_level) then
						local depth = height - y
						if depth == 1 then
							skip = true
						elseif height ~= base_level
						and depth > 1 and depth <= 4 then
							skip = true
						end
					end

					if data[ivm] == n_stone and not skip then
						local sr = 1000
						--if y > minp.y and data[area:index(x, y-1, z)] == n_stone then
						data[ivm] = n_air
						p2data[ivm] = 0

						if x == minp.x or x == maxp.x or z == minp.z or z == maxp.z then
							params.share.intersected = true
						end
					end
				elseif n3 and n4 then
					local height = surface[z][x].top
					local skip
					if close or (base_level and height <= base_level) then
						local depth = height - y
						if depth < 20 then
							skip = true
						end
					end

					if data[ivm] == n_stone and not skip then
						local sr = 1000
						data[ivm] = n_placeholder_lining
						p2data[ivm] = 0

						if x == minp.x or x == maxp.x or z == minp.z or z == maxp.z then
							params.share.intersected = true
						end
					end
				end
			end
		end
	end

	mod.time_caves = mod.time_caves + os.clock() - t_caves
end


layers_mod.register_mapgen('tg_intersect', mod.generate_intersect)
