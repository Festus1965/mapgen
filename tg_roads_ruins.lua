-- Duane's mapgen tg_roads_ruins.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod, layers_mod = mapgen, mapgen
local mod_name = mod.mod_name
local VN = vector.new
local FLATNESS = 3

local make_tracks = false
local road_w = 3

local node = layers_mod.node
local n_cobble = node['default:cobble']
local n_rail_power = node['carts:powerrail']
local n_rail = node['carts:rail']

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


function mod.generate_roads_ruins(params)
	local t_ruins = os.clock()

	mod.map_roads(params)
	mod.mark_plots(params)

	local minp, maxp = params.isect_minp, params.isect_maxp
	local csize, area = params.csize, params.area
	local data, p2data = params.data, params.vmparam2
	local surface = params.share.surface
	local roads = params.roads or {}
	local tracks = params.tracks or {}
	local water_level = params.sealevel

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = surface[z][x].top
			local ivm = area:index(x, height, z)

			if height <= water_level then
				--nop
			elseif tracks[index] then
				if x % 5 == 0 or z % 5 == 0 then
					data[ivm] = n_rail_power
				else
					data[ivm] = n_rail
				end
				p2data[ivm] = 0
			elseif roads[index] then
				data[ivm] = n_cobble
				data[ivm - area.ystride] = n_cobble
				p2data[ivm] = 0
				p2data[ivm - area.ystride] = 0
			end

			index = index + 1
		end
	end

	local hn = house_noise:get_2d({
		x = math.floor(minp.x / csize.x),
		y = math.floor(minp.z / csize.z),
	})
	if hn > 0 then
		mod.houses(params)
	end

	layers_mod.time_ruins = (layers_mod.time_ruins or 0) + os.clock() - t_ruins
end


-- check
function mod.map_roads(params)
	if not mod.registered_noises['road'] then
		params.share.has_roads = false
		params.roads = {}
		params.tracks = {}
		return
	end

	local roads = {}
	local tracks = {}
	local minp, maxp = params.isect_minp, params.isect_maxp
	if params.no_roads or params.share.no_roads
	or minp.y > params.sealevel or maxp.y < params.sealevel then
		params.roads = roads
		params.tracks = tracks
		return
	end

	local csize = params.csize
	local has_roads = false

	local rsize = vector.add(csize, road_w * 2)
	local road_map = layers_mod.get_noise2d({
		name = 'road',
		pos = { x = minp.x, y = minp.z },
		size = {x=rsize.x, y=rsize.z},
	})

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

	local water_level = params.sealevel
	local csize = params.csize
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
			local x = pr:next(2, csize.x - size.x - 3)
			local z = pr:next(2, csize.z - size.z - 3)
			local pos = VN(x, 20, z)
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
			local maxh, minh = -33000, 33000
			for z = pos.z, pos.z + size.z do
				for x = pos.x, pos.x + size.x do
					local index = z * csize.x + x + 1
					local height = params.share.surface[z + minp.z][x + minp.x].top
					if height > maxh then
						maxh = height
					end
					if height < minh then
						minh = height
					end

					if height <= water_level + 2
					or roads[index] then
						good = false
						break
					end
				end
				if not good then
					break
				end
			end

			good = good and (maxh - minh < FLATNESS)
			pos.y = math.floor((maxh + minh) / 2) - minp.y

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


-- The houses function takes very little cpu time.
-- check
function mod.houses(params)
	local minp = params.isect_minp
	local plots = params.share.plots
	local pr = params.gpr

	if params.no_houses or not plots then
		return
	end

	for _, box in pairs(plots) do
		local pos = vector.add(box.pos, -2)
		local size = vector.add(box.size, 4)
		local good = true

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
				pos = table.copy(box.pos)
				size = table.copy(box.size)
				size.y = 1
				geo:add({
					action = 'cube',
					node = 'default:stone',
					location = pos,
					intersect = 'air',
					size = size,
				})
			end

			geo:write_to_map(0)
		end

		for z = box.pos.z + minp.z + 1, box.pos.z + box.size.z + minp.z - 1 do
			for x = box.pos.x + minp.x + 1, box.pos.x + box.size.x + minp.x - 1 do
				params.share.surface[z][x].top = box.pos.y + minp.y
				params.share.surface[z][x].cave_in = true
			end
		end
	end
end


layers_mod.register_mapgen('tg_roads_ruins', mod.generate_roads_ruins)
