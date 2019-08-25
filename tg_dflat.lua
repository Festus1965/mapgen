-- Duane's mapgen dflat.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local altitude_cutoff_high = 30
local altitude_cutoff_low = -10
local altitude_cutoff_low_2 = 63
local water_diff = 8
local VN = vector.new
local chunksize = tonumber(minetest.settings:get('chunksize') or 5)
local chunk_offset = math.floor(chunksize / 2) * 16;
local div


local mod, layers_mod
if minetest.get_modpath('realms') then
	layers_mod = realms
	mod = floaters
else
	layers_mod = mapgen
	mod = mapgen
end

local mod_name = mod.mod_name

local max_height = 31000
local make_roads = true
local make_tracks = false
local road_w = 3

local n_cobble = layers_mod.node['default:cobble']
local n_mossy = layers_mod.node['default:mossycobble']

local n_rail_power = layers_mod.node['carts:powerrail']
local n_rail = layers_mod.node['carts:rail']

local house_materials = {
	'sandstonebrick',
	'desert_stonebrick',
	'stonebrick',
	'brick',
	'wood',
	'junglewood',
}

local house_noise = PerlinNoise({
	offset = 0,
	scale = 1,
	seed = 1585,
	spread = {x = 2, y = 2, z = 2},
	octaves = 2,
	persist = 0.5,
	lacunarity = 2.0
})

local node
if layers_mod.mod_name == 'mapgen' then
	node = layers_mod.node
	clone_node = layers_mod.clone_node
else
	dofile(mod.path .. '/functions.lua')
	node = mod.node
	clone_node = mod.clone_node
end


function mod.generate_dflat(params)
	local minp, maxp = params.isect_minp, params.isect_maxp
	local water_level = params.sealevel
	local area, data, p2data = params.area, params.data, params.vmparam2

	local csize = vector.add(vector.subtract(maxp, minp), 1)
	local ystride = area.ystride
	params.csize = csize

	local n_stone = node['default:stone']
	local n_air = node['air']
	local n_water = node['default:water_source']
	local n_ice = node['default:ice']
	local n_ignore = node['ignore']

	local ps = PcgRandom(params.chunk_seed + 7712)

	local base_level = params.sealevel + water_diff

	-- just a few 2d noises
	local ground_noise_map = layers_mod.get_noise2d('dflat_ground', nil, nil, nil, {x=csize.x, y=csize.z}, { x = minp.x, y = minp.z })

	local height_min = max_height
	local height_max = max_height
	local surface = {}

	local index = 1
	for z = minp.z, maxp.z do
		surface[z] = {}
		for x = minp.x, maxp.x do
			-- terrain height calculations
			local ground_1 = ground_noise_map[index]
			local height = mod.terrain_height(ground_1, base_level)

			height = math.floor(height + 0.5)
			height_max = math.max(height, height_max)
			height_min = math.min(height, height_min)

			-- Using surface instead of flat maps results in about
			-- 128 Mb of memory used on the same chunks that take
			-- only 92 Mb with flat maps. Memory could be an issue,
			-- especially with luajit.
			-- However, having all the data for that point in one
			-- table makes it easier to keep track of.
			-- The first rule of optimizing is: Don't.

			surface[z][x] = {
				top = height,
				--cave_floor = cave_low,  -- Not cave_top; that's confusing.
				--cave_ceiling = cave_high,
			}

			if height > params.sealevel then
				surface[z][x].biome = layers_mod.undefined_biome
			else
				surface[z][x].biome = layers_mod.undefined_underwater_biome
			end

			index = index + 1
		end
	end

	params.share.height_min = height_min
	params.share.height_max = height_max

	if height_max - height_min < 3 and height_max > water_level then
		params.share.flattened = true
	end

	-- Let realms do the biomes.
	params.share.surface=surface
	if params.biomefunc then
		layers_mod.rmf[params.biomefunc](params)
	end

	local t_ruins = os.clock()
	mod.map_roads(params)
	mod.mark_plots(params)
	local roads = params.roads or {}

	local hn = house_noise:get_2d({
		x = math.floor(minp.x / csize.x),
		y = math.floor(minp.z / csize.z),
	})
	if hn > 0 then
		mod.houses(params)
	end
	layers_mod.time_ruins = (layers_mod.time_ruins or 0) + os.clock() - t_ruins

	-- Loop through every horizontal space.
	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local surface = params.share.surface[z][x]
			local height = surface.top
			local depth = surface.bottom
			local biome = surface.biome or {}

			-- depths
			local depth_top = surface.top_depth or biome.depth_top or 0  -- 1?
			local depth_filler = surface.filler_depth or biome.depth_filler or 0  -- 6?!
			local erosion = surface.erosion or 0
			local wtd = biome.node_water_top_depth or 0
			local grass_p2 = surface.grass_p2 or 0

			height = height - erosion
			surface.top = height
			local fill_1 = height - depth_top
			local fill_2 = fill_1 - depth_filler

			-- biome-determined nodes
			local stone = biome.node_stone or n_stone
			local filler = biome.node_filler or n_air
			local top = biome.node_top or n_air
			local riverbed = biome.node_riverbed
			local ww = biome.node_water or node['default:water_source']
			local wt = biome.node_water_top

			if ww == n_water and surface.heat
			and not params.share.disable_icing then
				if surface.heat < 30 then
					wt = n_ice
					wtd = math.ceil(math.max(0, (30 - surface.heat) / 3))
				else
					wt = nil
				end
			end

			local hu2_check
			local hu2 = surface.humidity_blend
			if (not hu2 or hu2 > 1 or math.floor(hu2 * 1000) % 2 == 0)
			and surface.humidity and surface.humidity > 70 then
				hu2_check = true
			end

			-- Start at the bottom and fill up.
			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				if not (data[ivm] == n_air or data[ivm] == n_ignore) then
					-- nop
				elseif make_tracks and (not div)
				and y == height and tracks[index] then
					if x % 5 == 0 or z % 5 == 0 then
						data[ivm] = n_rail_power
					else
						data[ivm] = n_rail
					end
				elseif make_roads and (not div)
				and y >= height - 1 and y <= height
				and roads[index] then
					if hu2_check then
						data[ivm] = n_mossy
					else
						data[ivm] = n_cobble
					end
				elseif y > height and y <= water_level then
					if y > water_level - wtd then
						data[ivm] = wt
					else
						data[ivm] = ww
					end
					p2data[ivm] = 0
				elseif y <= height and y > fill_1 then
					-- topping up
					data[ivm] = top

					-- decorate
					if biome.decorate and y == height then
						biome.decorate(x,y+1,z, biome, params)
					end

					p2data[ivm] = grass_p2 --  + 0
				elseif filler and y <= height and y > fill_2 then
					-- filling
					data[ivm] = filler
					p2data[ivm] = 0
				elseif y <= height then
					-- Otherwise, it's stoned.
					data[ivm] = stone
					--[[
					if stone == n_stone then
						p2data[ivm] = stone_layers[y - minp.y]
					else
					--]]
						p2data[ivm] = 0
					--end
				end

				ivm = ivm + ystride
			end

			index = index +	1
		end
	end

	if not params.no_passages then
		mod.passages(params)
	end

	if not params.no_ponds then
		local t_ponds = os.clock()
		mod.ponds(params)
		layers_mod.time_ponds = (layers_mod.time_ponds or 0) + os.clock() - t_ponds
	end

	if layers_mod.place_all_decorations then
		layers_mod.place_all_decorations(params)

		if not params.share.no_dust and layers_mod.dust then
			layers_mod.dust(params)
		end
	end

	if layers_mod.simple_ore then
		layers_mod.simple_ore(params)
	end
end


function mod.get_spawn_level(realm, x, z, force)
	local ground_noise = minetest.get_perlin(mod.registered_noises['dflat_ground'])
	local ground_1 = ground_noise:get_2d({x=x, y=z})
	local base_level = realm.sealevel + water_diff

	local height = math.floor(mod.terrain_height(ground_1, base_level))
	if not force and height <= realm.sealevel then
		return
	end

	return height
end


-- The houses function takes very little cpu time.
-- check
function mod.houses(params)
	local minp, maxp = params.isect_minp, params.isect_maxp
	local csize = params.csize
	local plots = params.share.plots
	local pr = params.gpr
	--local base_level = params.share.base_level or params.sealevel + water_diff
	local base_level = params.sealevel + water_diff

	if params.no_houses or not plots then
		return
	end

	for _, box in pairs(plots) do
		local pos = vector.add(box.pos, -2)
		local size = vector.add(box.size, 4)
		local good = true

		for z = pos.z, pos.z + size.z do
			for x = pos.x, pos.x + size.x do
				local surface = params.share.surface[minp.z + z][minp.x + x]
				if surface.top < base_level - 1 or surface.top > base_level + 1 then
					good = false
					break
				end
			end
			if not good then
				break
			end
		end

		if good then
			local walls, roof
			while walls == roof do
				walls = (house_materials)[pr:next(1, #house_materials)]
				roof = (house_materials)[pr:next(1, #house_materials)]
			end
			local walls1 = 'default:'..walls
			local roof1 = 'default:'..roof
			local geo = Geomorph.new(params)
			local lev = pr:next(1, 4) - 2
			lev = math.max(1, lev)

			-- foundation
			pos = table.copy(box.pos)
			pos.y = pos.y - 1
			size = table.copy(box.size)
			size.y = 1
			geo:add({
				action = 'cube',
				node = 'default:cobble',
				location = pos,
				size = size,
			})

			pos = table.copy(box.pos)
			pos.y = pos.y + lev * 5
			size = table.copy(box.size)
			if pr:next(1, 3) == 1 then
				size.y = 1
				geo:add({
					action = 'cube',
					node = roof1,
					location = pos,
					size = size,
				})
			elseif box.size.x <= box.size.z then
				size.x = math.floor(size.x / 2)

				local pos2 = table.copy(pos)
				pos2.x = pos2.x + size.x
				pos2.y = pos2.y + size.x - 1

				pos = table.copy(pos)
				pos.x = pos.x + box.size.x - size.x
			else
				size.z = math.floor(size.z / 2)

				local pos2 = table.copy(pos)
				pos2.z = pos2.z + size.z
				pos2.y = pos2.y + size.z - 1

				pos = table.copy(pos)
				pos.z = pos.z + box.size.z - size.z
			end
			pos = table.copy(box.pos)
			pos.y = box.pos.y
			size = table.copy(box.size)
			size.y = lev * 5
			geo:add({
				action = 'cube',
				node = walls1,
				location = pos,
				size = size,
			})
			for y = 0, lev - 1 do
				local pos2 = vector.add(pos, 1)
				local sz2 = vector.add(size, -2)
				pos2.y = box.pos.y + y * 5 + 1
				sz2.y = 4
				geo:add({
					action = 'cube',
					node = 'air',
					location = pos2,
					size = sz2,
				})
			end

			for y = 0, lev - 1 do
				for z = box.pos.z + 2, box.pos.z + box.size.z, 4 do
					geo:add({
						action = 'cube',
						node = 'air',
						location = VN(box.pos.x, box.pos.y + y * 5 + 2, z),
						size = VN(box.size.x, 2, 2),
					})
				end
				for x = box.pos.x + 2, box.pos.x + box.size.x, 4 do
					geo:add({
						action = 'cube',
						node = 'air',
						location = VN(x, box.pos.y + y * 5 + 2, box.pos.z),
						size = VN(2, 2, box.size.z),
					})
				end
			end

			do
				local l = math.max(box.size.x, box.size.z)
				local f = pr:next(0, 2)
				pos = vector.round(vector.add(box.pos, vector.divide(box.size, 2)))
				pos = vector.subtract(pos, math.floor(l / 2 + 0.5) - f)
				pos.y = pos.y + lev * 5
				geo:add({
					action = 'sphere',
					node = 'air',
					intersect = {walls1, roof1},
					location = pos,
					size = VN(l - 2 * f, 20, l - 2 * f),
				})

				for _ = 1, 3 do
					local pos2 = table.copy(pos)
					pos2.x = pos2.x + pr:next(0, box.size.x) - math.floor(box.size.x / 2)
					pos2.z = pos2.z + pr:next(0, box.size.z) - math.floor(box.size.z / 2)

					geo:add({
						action = 'sphere',
						node = 'air',
						intersect = {walls1, roof1},
						location = pos2,
						size = VN(l, 20, l),
					})
				end
			end

			do
				local ff_alt = math.max(0, pr:next(1, 6) + pr:next(1, 6) - 7)
				local ore = layers_mod.get_ore(params.gpr, ff_alt)
				pos = table.copy(box.pos)
				size = table.copy(box.size)

				geo:add({
					action = 'cube',
					node = ore,
					intersect = {walls1, roof1},
					location = pos,
					size = size,
					random = 300,
				})
			end

			do
				local surface = params.share.surface[minp.z + pos.z][minp.x + pos.x]
				local biome = surface.biome
				local dirt = 'default:dirt'
				if biome and biome.node_top then
					dirt = minetest.get_name_from_content_id(biome.node_top)
				end

				local ivm = params.area:indexp(vector.add(minp, box.pos))
				local grass_p2 = 0
				if dirt == 'default:dirt_with_grass'
				or dirt == 'default:dirt_with_dry_grass' then
					grass_p2 = surface.grass_p2 
				end

				pos = table.copy(box.pos)
				size = table.copy(box.size)
				size.y = 1
				geo:add({
					action = 'cube',
					node = dirt,
					location = pos,
					intersect = 'air',
					param2 = grass_p2,
					size = size,
				})
			end

			geo:write_to_map(0)
		end
	end
end


-- This is a simple, breadth-first search, for checking whether
-- a depression in the ground is enclosed (for placing ponds).
-- It is cpu-intensive, but also easy to code.
local function height_search(params, ri)
	local csize = params.csize
	local minp, maxp = params.isect_minp, params.isect_maxp

	params.share.propagate_shadow = true

	if ri < 1 or ri > csize.z * csize.x then
		return
	end

	local rx = ri % csize.x
	local rz = math.floor(ri / csize.x)
	local height_ri = params.share.surface[rz + minp.z][rx + minp.x].top

	local s = {}
	local q = {}
	s[ri] = true
	q[#q+1] = ri

	while #q > 0 do
		local ci = q[#q]
		q[#q] = nil
		local cx = ci % csize.x
		local cz = math.floor(ci / csize.x)
		if ((cx <= 1 or cx >= csize.x - 2) or (cz <= 1 or cz >= csize.z - 2)) then
			return
		end
		for zo = -1, 1 do
			for xo = -1, 1 do
				if zo ~= xo then
					local ni = ci + (zo * csize.x) + xo
					local height_ni = params.share.surface[cz + zo + minp.z][cx + xo + minp.x].top
					if not s[ni] and height_ni <= height_ri then
						s[ni] = true
						q[#q+1] = ni
					end
				end
			end
		end
	end
	return height_ri
end


-- check
function mod.map_roads(params)
	local roads = {}
	local tracks = {}
	local minp, maxp = params.isect_minp, params.isect_maxp
	if params.no_roads or minp.y > params.sealevel
	or maxp.y < params.sealevel then
		params.roads = roads
		params.tracks = tracks
		return
	end

	local csize = params.csize
	local has_roads = false

	local rsize = vector.add(csize, road_w * 2)
	local road_map = layers_mod.get_noise2d('road', nil, nil, nil, {x=rsize.x, y=rsize.z}, { x = minp.x, y = minp.z })

	local index
	local road_ws = road_w * road_w
	for x = -road_w, csize.x + road_w - 1 do
		index = x + road_w + 1
		local l_road = road_map[index]
		for z = -road_w, csize.z + road_w - 1 do
			local road_1 = road_map[index]
			if (l_road < 0) ~= (road_1 < 0) then
				local index2 = z * csize.x + x + 1
				if make_tracks then
					tracks[index2] = true
				end
				for zo = -road_w, road_w do
					local zos = zo * zo
					for xo = -road_w, road_w do
						if x + xo >= 0 and x + xo < csize.x
						and z + zo >= 0 and z + zo < csize.z then
							if xo * xo + zos < road_ws then
								roads[index2 + zo * csize.x + xo] = true
								has_roads = true
							end
						end
					end
				end
			end
			l_road = road_1
			index = index + csize.x + road_w * 2
		end
	end

	-- Mark the road locations.
	index = 1
	for z = -road_w, csize.z + road_w - 1 do
		local l_road = road_map[index]
		for x = -road_w, csize.x + road_w - 1 do
			local road_1 = road_map[index]
			if (l_road < 0) ~= (road_1 < 0) then
				local index2 = z * csize.x + x + 1
				if make_tracks then
					tracks[index2] = true
				end
				for zo = -road_w, road_w do
					local zos = zo * zo
					for xo = -road_w, road_w do
						if x + xo >= 0 and x + xo < csize.x and z + zo >= 0 and z + zo < csize.z then
							if xo * xo + zos < road_ws then
								roads[index2 + zo * csize.x + xo] = true
								has_roads = true
							end
						end
					end
				end
			end
			l_road = road_1
			index = index + 1
		end
	end

	if make_tracks then
		for z = -1, csize.z + 1 do
			for x = -1, csize.x + 1 do
				index = z * csize.x + x + 1
				if tracks[index] then
					for zo = -1, 1 do
						for xo = -1, 1 do
							local index2 = (z + zo) * csize.x + (x + xo) + 1
							if tracks[index2] then
								if xo == 0 and zo == 0 then
									-- nop
								elseif math.abs(xo) == math.abs(zo) then
									local index3 = (z + 0) * csize.x + (x + xo) + 1
									local index4 = (z + zo) * csize.x + (x + 0) + 1
									if tracks[index3] or tracks[index4] then
										-- nop
									else
										tracks[index3] = true
									end
								end
							end
						end
					end
				end
			end
		end
	end

	params.share.has_roads = has_roads
	params.roads = roads
	params.tracks = tracks
end


function mod.mark_plots(params)
	local plots = {}
	local minp, maxp = params.isect_minp, params.isect_maxp
	if minp.y > params.sealevel or maxp.y < params.sealevel then
		params.share.plots = plots
		return
	end

	local csize = params.csize
	--local base_level = (params.share.base_level or 9) + chunk_offset  -- Figure from height?
	local base_level = params.sealevel + water_diff + chunk_offset
	local roads = params.roads
	local pr = params.gpr

	-- Generate plots for constructions.
	for _ = 1, 15 do
		local scale = pr:next(1, 2) * 4
		local size = VN(pr:next(1, 2), 1, pr:next(1, 2))
		size.x = size.x * scale + 9
		size.y = size.y * 8
		size.z = size.z * scale + 9

		for _ = 1, 10 do
			local pos = VN(pr:next(2, csize.x - size.x - 3), base_level, pr:next(2, csize.z - size.z - 3))
			local good = true
			for _, box in pairs(plots) do
				if box.pos.x + box.size.x < pos.x
				or pos.x + size.x < box.pos.x
				or box.pos.z + box.size.z < pos.z
				or pos.z + size.z < box.pos.z then
					-- nop
				else
					good = false
					break
				end
			end
			for z = pos.z, pos.z + size.z do
				for x = pos.x, pos.x + size.x do
					local index = z * csize.x + x + 1
					if roads[index] then
						good = false
						break
					end
				end
				if not good then
					break
				end
			end
			if good then
				pos.y = pos.y - 2
				table.insert(plots, {
					pos = vector.add(pos, 2),
					size = vector.add(size, -4)
				})
				break
			end
		end
	end

	params.share.plots = plots
end


function mod.ponds(params)
	local minp, maxp = params.isect_minp, params.isect_maxp
	local csize = params.csize

	local ahu = 0
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			if not params.share.surface[z][x].humidity then
				ahu = 50 * csize.z * csize.x
				break
			end
			ahu = ahu + params.share.surface[z][x].humidity
		end
	end
	ahu = ahu / (csize.z * csize.x)
	if ahu < 30 then
		return
	end

	local n_air = node['air']
	local n_water = node['default:water_source']
	local n_ice = node['default:ice']
	local n_clay = node['default:clay']

	local area = params.area
	local checked = {}
	local data = params.data
	local lilies = {
		['deciduous_forest'] = true,
		['savanna'] = true,
		['rainforest'] = true,
	}

	-- Erosion and ponds don't mix well.
	local pond_max = params.sealevel + 75
	local pond_min = params.sealevel + 12
	local ps = PcgRandom(params.chunk_seed + 93)

	-- Check for depressions every eight meters.
	for z = 4, csize.z - 5, 8 do
		for x = 4, csize.x - 5, 8 do
			local p = {x=x+minp.x, z=z+minp.z}
			local index = z * csize.x + x + 1
			local height = params.share.surface[p.z][p.x].top + 1
			if height > pond_min and height < pond_max and height >= minp.y - 1 and height <= maxp.y + 1 then
				local search = {}
				local highest = 0
				local h1 = height_search(params, index)
				-- If a depression is there, look at all the adjacent squares.
				if h1 then
					for zo = -6, 6 do
						for xo = -6, 6 do
							local subindex = index + zo * csize.x + xo
							if not checked[subindex] then
								h1 = height_search(params, subindex)
								-- Mark this as already searched.
								checked[subindex] = true
								if h1 then
									if h1 > highest then
										highest = h1
									end
									-- Store depressed positions.
									search[#search+1] = {x=x+xo, z=z+zo, h=h1}
								end
							end
						end
					end

					for _, p2 in ipairs(search) do
						local index = p2.z * csize.x + p2.x + 1

						p2.x = p2.x + minp.x
						p2.z = p2.z + minp.z

						local biome = params.share.surface[p2.z][p2.x].biome or {}
						local heat = params.share.surface[p2.z][p2.x].heat or 60

						-- Place water and lilies.
						local ivm = area:index(p2.x, p2.h-1, p2.z)
						data[ivm] = n_clay
						for h = p2.h, highest do
							ivm = ivm + area.ystride
							data[ivm] = node[biome.node_water_top] or n_water
							if not params.share.disable_icing
							and data[ivm] == n_water
							and heat < 30 and highest - h < 3 then
								data[ivm] = n_ice
							end
						end
						ivm = ivm + area.ystride
						if lilies[biome.name] and ps:next(1, 13) == 1 then
							data[ivm] = node['flowers:waterlily']
						else
							data[ivm] = n_air
						end
					end
				end
			end
		end
	end
end


local passages_replace_nodes = {
	'default:stone',
	'default:dirt',
	'default:dirt_with_grass',
	'default:dirt_with_dry_grass',
	'default:dirt_with_snow',
	'default:dirt_with_coniferous_litter',
	'default:dirt_with_rainforest_litter',
	'default:cobble',
	'default:mossycobble',
	layers_mod.mod_name .. ':granite',
	layers_mod.mod_name .. ':basalt',
	layers_mod.mod_name .. ':stone_with_algae',
	layers_mod.mod_name .. ':stone_with_moss',
	layers_mod.mod_name .. ':stone_with_lichen',
	'default:dirt',
	'default:sand',
	'default:gravel',
	'default:clay',
	'default:stone_with_coal',
	'default:stone_with_iron',
	'default:stone_with_gold',
	'default:stone_with_diamond',
	'default:stone_with_mese',
	'default:cave_ice',
	'default:ice',
	'default:snowblock',
	'default:snow',
}


local passages_replace_nodes = {
	'group:soil',
	'group:stone',
	'group:sand',
	'group:ore',
	'default:cobble',
	'default:mossycobble',
	'default:gravel',
	'default:clay',
	'default:cave_ice',
	'default:ice',
	'default:snowblock',
	'default:snow',
	'default:sandstone',
}


function mod.passages(params)
	if params.share.height_min and params.share.height_min < params.sealevel then
		return
	end

	local node = layers_mod.node
	local replace = mod.passages_replace

	local minp, maxp = params.isect_minp, params.isect_maxp
	local data, p2data = params.data, params.p2data
	local area = params.area
	local csize = params.csize
	local seed = params.map_seed
	local ps = params.gpr

	local meet_at = vector.new(24, 0, 49)
	local divs = vector.floor(vector.divide(csize, 4))

	local geo = Geomorph.new(params)
	local surface = params.share.surface
	local x, z, l, pos, size = 6, 12
	local lx, ly, lz, ll
	local alt = 0
	local div_size = 4
	local up
	for y = math.floor(csize.y / (div_size * 2)) * div_size * 2, 0, - div_size * 2 do
		local num = ps:next(2, 6)
		local join
		local bct = 0
		for ct = 1, num do
			bct = bct + 1
			if alt % 2 == 0 then
				if lz then
					z = ps:next(lz, lz + ll - 1)
					--z = lz
					if ly ~= y then
						join = vector.new(x * div_size, y, z * div_size)
					end
				else
					z = ps:next(1, divs.z - 2)
				end
				x = ps:next(1, 4)
				l = ps:next(1, divs.x - x - 2)
				if lz and x + l < lx then
					l = lx - x + 1
				end
				pos = vector.new(x * div_size, y, z * div_size)
				size = vector.new(l * div_size, div_size, div_size)
			else
				if lx then
					x = ps:next(lx, lx + ll - 1)
					--x = lx
					if ly ~= y then
						join = vector.new(x * div_size, y, z * div_size)
					end
				else
					x = ps:next(1, divs.x - 2)
				end
				z = ps:next(1, 4)
				l = ps:next(1, divs.z - z - 2)
				if lx and z + l < lz then
					l = lz - z + 1
				end
				pos = vector.new(x * div_size, y, z * div_size)
				size = vector.new(div_size, div_size, l * div_size)
			end

			local good = true
			for z = pos.z, pos.z + size.z do
				if not good then
					break
				end

				if z < 0 or z >= csize.z then
					good = false
					join = nil
					break
				end

				for x = pos.x, pos.x + size.x do
					if x < 0 or x >= csize.x then
						good = false
						join = nil
						break
					end

					local sur = surface[minp.z + z][minp.x + x]
					if not sur or sur.top <= minp.y + pos.y + size.y + 2 then
						good = false
						join = nil
						break
					end
				end
			end

			if good then
				lx, ly, lz, ll = x, y, z, l
				alt = alt + 1

				geo:add({
					action = 'cube',
					node = 'air',
					location = table.copy(pos),
					size = table.copy(size),
				})

				if join then
					geo:add({
						action = 'cube',
						node = 'air',
						location = table.copy(join),
						size = vector.new(div_size, div_size * 2, div_size),
					})
					join = nil
				end
			elseif bct < 1000 then
				ct = ct - 1
			end
		end

		if bct > 999 then
			return
		end

		if params.passages_entrances and math.abs(params.passages_entrances - minp.y - y) <= div_size then
			geo:add({
				action = 'cube',
				node = 'air',
				location = vector.new(0, y, 11 * div_size),
				size = vector.new(csize.x, div_size, div_size),
				intersect = passages_replace_nodes,
				move_earth = true,
			})
			geo:add({
				action = 'cube',
				node = 'air',
				location = vector.new(6 * div_size, y, 0),
				size = vector.new(div_size, div_size, csize.z),
				intersect = passages_replace_nodes,
				move_earth = true,
			})
		end
	end

	if minp.y == params.realm_minp.y then
		geo:add({
			action = 'cube',
			node = 'air',
			location = vector.new(6 * 4, 0, 11 * 4),
			size = vector.new(div_size * 2, div_size * 2, div_size * 2),
		})
		geo:add({
			action = 'cube',
			node = 'air',
			location = vector.new(0, 0, 11 * 4),
			size = vector.new(csize.x, div_size, div_size * 2),
		})
		geo:add({
			action = 'cube',
			node = 'air',
			location = vector.new(6 * 4, 0, 0),
			size = vector.new(div_size * 2, div_size, csize.z),
		})
	end

	geo:write_to_map(0)
end


function mod.terrain_height(ground_1, base_level, div)
	-- terrain height calculations
	local height = base_level
	if ground_1 > altitude_cutoff_high then
		height = height + (ground_1 - altitude_cutoff_high) / (div or 1)
	elseif ground_1 < altitude_cutoff_low then
		local g = altitude_cutoff_low - ground_1
		if g < altitude_cutoff_low_2 then
			g = g * g * 0.01
		else
			g = (g - altitude_cutoff_low_2) * 0.5 + 40
		end
		height = height - g / (div or 1)
	end
	return height
end


-- Define the noises.
layers_mod.register_noise( 'dflat_ground', {
	offset = 0,
	scale = 100,
	seed = 4382,
	spread = {x = 320, y = 320, z = 320},
	octaves = 6,
	persist = 0.5,
	lacunarity = 2.0
} )

layers_mod.register_noise( 'road', {
	offset = 0,
	scale = 100,
	seed = 4382,
	spread = {x = 320, y = 320, z = 320},
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0,
} )

layers_mod.register_mapgen('tg_dflat', mod.generate_dflat)
if layers_mod.register_spawn then
	layers_mod.register_spawn('tg_dflat', mod.get_spawn_level)
end


--[[
function DFlat_Mapgen:after_terrain()
	local minp, maxp = params.minp, params.maxp
	local chunk_offset = params.chunk_offset
	local water_level = params.water_level
	local ground = (maxp.y >= water_level and minp.y <= water_level)

	local do_ore = true
	if (not params.div) and ground and params.share.flattened and params.gpr:next(1, 5) == 1 then
		local sr = params.gpr:next(1, 3)
		if sr == 1 then
			mod.geomorph('pyramid_temple')
		elseif sr == 2 then
			mod.geomorph('pyramid')
		else
			mod.simple_ruin()
		end
		do_ore = false
		params.share.disruptive = true
	end


-- check
function DFlat_Mapgen:simple_ruin()
	if not params.share.flattened then
		return
	end

	local csize = params.csize
	local chunk_offset = params.chunk_offset
	local base_level = params.share.base_level + chunk_offset  -- Figure from height?
	local boxes = {}

	for _ = 1, 15 do
		local scale = params.gpr:next(2, 3) * 4
		local size = VN(params.gpr:next(1, 3), 1, params.gpr:next(1, 3))
		size.x = size.x * scale + 5
		size.y = size.y * 8
		size.z = size.z * scale + 5

		for _ = 1, 10 do
			local pos = VN(params.gpr:next(1, csize.x - size.x - 2), base_level, params.gpr:next(1, csize.z - size.z - 2))
			local good = true
			for _, box in pairs(boxes) do
				if box.pos.x + box.size.x < pos.x or pos.x + size.x < box.pos.x
				or box.pos.z + box.size.z < pos.z or pos.z + size.z < box.pos.z then
					-- nop
				else
					good = false
					break
				end
			end
			if good then
				table.insert(boxes, { pos = pos, size = size })
				break
			end
		end
	end
	local geo = Geomorph.new()
	local stone = 'default:sandstone_block'
	for _, box in pairs(boxes) do
		local pos = table.copy(box.pos)
		local size = table.copy(box.size)

		-- foundation
		pos.y = pos.y - 8
		size.y = 6
		geo:add({
			action = 'cube',
			node = 'default:dirt',
			intersect = 'air',
			location = pos,
			size = size,
		})
		pos = table.copy(box.pos)
		size = table.copy(box.size)
		pos.y = pos.y - 2
		size.y = 3
		geo:add({
			action = 'cube',
			node = stone,
			location = pos,
			size = size,
		})

		pos = table.copy(pos)
		pos.y = pos.y + 3
		size = table.copy(size)
		size.y = 1
		geo:add({
			action = 'cube',
			node = 'air',
			location = pos,
			size = size,
		})

		box.pos.x = box.pos.x + 2
		box.pos.z = box.pos.z + 2
		box.size.x = box.size.x - 4
		box.size.z = box.size.z - 4

		pos = table.copy(box.pos)
		pos.y = pos.y + 8
		size = table.copy(box.size)
		size.y = 1
		geo:add({
			action = 'cube',
			node = stone,
			location = pos,
			size = size,
		})
		pos = vector.add(box.pos, 1)
		pos.y = pos.y + 8
		size = vector.add(box.size, -2)
		size.y = 1
		geo:add({
			action = 'cube',
			node = stone,
			location = pos,
			size = size,
		})
		pos = table.copy(pos)
		pos.y = pos.y - 1
		geo:add({
			action = 'cube',
			node = 'air',
			location = pos,
			size = size,
		})
		local pool = 14
		if box.size.x > pool and box.size.z > pool then
			pos = vector.add(box.pos, (pool / 2) - 1)
			pos.y = box.pos.y + 1
			size = vector.add(box.size, -(pool - 2))
			size.y = 1
			geo:add({
				action = 'cube',
				node = stone,
				location = pos,
				size = size,
			})
			pos = vector.add(box.pos, pool / 2)
			pos.y = box.pos.y + 1
			size = vector.add(box.size, -pool)
			size.y = 1
			geo:add({
				action = 'cube',
				node = 'default:water_source',
				location = pos,
				size = size,
			})
		end

		for z = box.pos.z, box.pos.z + box.size.z, 4 do
			for x = box.pos.x, box.pos.x + box.size.x, 4 do
				if x == box.pos.x or x == box.pos.x + box.size.x - 1
				or z == box.pos.z or z == box.pos.z + box.size.z - 1 then
					geo:add({
						action = 'cube',
						node = stone,
						location = VN(x, box.pos.y, z),
						size = VN(1, box.size.y, 1),
					})
				end
			end
		end
	end
	geo:write_to_map()

	return true
end
--]]
