-- Duane's mapgen flat_caves.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


tg_flat_caves = {}
local mod, layers_mod = tg_flat_caves, mapgen
local mod_name = 'tg_flat_caves'
local nodes_name = 'mapgen'

local max_height = 31000
local VN = vector.new
local node = layers_mod.node
local replace


function mod.generate_flat_caves(params)
	local t_caves = os.clock()

	params.share.propagate_shadow = true

	local minp, maxp = params.isect_minp, params.isect_maxp
	local area, data, p2data = params.area, params.data, params.vmparam2

	local csize = vector.add(vector.subtract(maxp, minp), 1)
	local ystride = area.ystride
	local ps = PcgRandom(params.chunk_seed + 7712)
	params.csize = csize

	local n_stone = node['default:stone']
	local n_air = node['air']
	local n_water = node['default:water_source']
	local n_ignore = node['ignore']
	local n_placeholder_lining = node[layers_mod.mod_name .. ':placeholder_lining']

	if not replace then
		replace = {
			[ n_stone ] = true,
			[ n_placeholder_lining ] = true,
			[ n_ignore ] = true,
		}
	end

	params.share.no_dust = true

	local bottom_fill
	local cave_layers = {}
	do
		local layer_min = params.realm_maxp.y
		local layer_max = layer_min
		local psh = PcgRandom(params.realm_seed + 6284)
		while layer_min > math.max(minp.y, params.realm_minp.y) do
			local h = psh:next(10, 50) + psh:next(10, 50)
			local dt = psh:next(1, 3)
			local d, wet
			if dt == 1 then
				d = psh:next(1, h)
				wet = true
			elseif dt == 2 then
				d = psh:next(8, 16)
			elseif dt == 3 then
				d = 1
			end

			layer_max = layer_min
			layer_min = layer_min - h
			if (layer_max >= minp.y and layer_max <= maxp.y)
			or (layer_min >= minp.y and layer_min <= maxp.y) then
				if layer_min > params.realm_minp.y then
					table.insert(cave_layers, {
						minp = VN(minp.x, layer_min + 1, minp.z),
						maxp = VN(maxp.x, layer_max, maxp.z),
						height = h,
						--lava = has_lava,
						water_level = layer_min + d - 1,
						wet = wet,
					})
				end
			end
		end

		if #cave_layers < 1 then
			bottom_fill = true
		else
			if layer_min < params.realm_minp.y then
				bottom_fill = true
			end
		end
	end

	for _, cl in pairs(cave_layers) do
		local water_level = cl.water_level
		local center = vector.divide(vector.add(cl.minp, cl.maxp), 2)
		params.share.wet_cave = cl.wet
		params.share.intersected = true
		--params.biome_height_offset = water_level

		-- just a few 2d noises
		local seedb = cl.minp.y % 1137
		local ground_noise_map = layers_mod.get_noise2d({
			name = 'flat_caves_terrain',
			seed = seedb,
			pos = { x = minp.x, y = minp.z },
			size = {x=csize.x, y=csize.z},
		})

		local surface = params.share.surface or {}

		local index = 1
		local min_y = math.max(minp.y, cl.minp.y)
		local max_y = math.min(maxp.y, cl.maxp.y)
		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				-- These calculations are very touchy.
				local ground = ground_noise_map[index]

				if ground < -10 then
					ground = ground + 10
					--ground = - (ground * ground) - 10
					ground = (ground * ground) + 10
				elseif ground > 0 then
					---------------------------
					-- cpu drain
					---------------------------
					ground = math.sqrt(ground)
					---------------------------
				end

				local diff = math.abs(ground) * cl.height / 40
				local floor = math.floor(cl.minp.y + diff + 5.5)

				if not surface[z][x] then
					surface[z][x] = {}
				end
				surface[z][x].cave_floor = params.realm_minp.y
				surface[z][x].cave_ceiling = params.realm_maxp.y

				local ground = center.y - floor

				local ivm = area:index(x, min_y, z)
				for y = min_y, max_y do
					local diff = math.abs(center.y - y)
					if not replace[data[ivm]] then
						-- nop
					elseif diff >= ground + 3 then
						-- nop
					elseif not params.share.no_biome and diff >= ground then
						data[ivm] = n_placeholder_lining
						p2data[ivm] = 0
						--[[
					elseif diff < ground then
						if y <= water_level then
							data[ivm] = n_air
							p2data[ivm] = 0
						end
					elseif data[ivm] == n_air then
						if diff < 10 then
							--data[ivm] = n_air
						else
							--data[ivm] = n_air
						end
						p2data[ivm] = 0
						--]]
					else
						data[ivm] = n_air
					end

					ivm = ivm + ystride
				end

				index = index + 1
			end
		end
	end

	if bottom_fill then
		local max_y
		if #cave_layers < 1 then
			max_y = maxp.y
		else
			max_y = cave_layers[#cave_layers].minp.y - 1
		end

		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				local ivm = area:index(x, minp.y, z)
				for y = minp.y, max_y do
					data[ivm] = n_stone
					p2data[ivm] = 0

					ivm = ivm + ystride
				end
			end
		end
	end

	layers_mod.time_caves = layers_mod.time_caves + os.clock() - t_caves
end


-- Define the noises.
layers_mod.register_noise( 'flat_caves_terrain', {offset = 0, scale = 10, seed = 6386, spread = {x = 23, y = 23, z = 23}, octaves = 3, persist = 0.7, lacunarity = 1.8} )

layers_mod.register_mapgen('tg_flat_caves', mod.generate_flat_caves)

--[[
if layers_mod.register_spawn then
	layers_mod.register_spawn('tg_dflat', mod.get_spawn_level)
end
--]]
