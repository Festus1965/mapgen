-- Duane's mapgen dflat.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


tg_dflat = {}
local mod, layers_mod = tg_dflat, mapgen
local mod_name = 'tg_dflat'
local max_height = 31000
local node = layers_mod.node


local altitude_cutoff_high = 30
local altitude_cutoff_low = -10
local altitude_cutoff_low_2 = 63
local water_diff = 8


function mod.generate_dflat(params)
				--local t_yloop = os.clock()
	local minp, maxp = params.isect_minp, params.isect_maxp
	local water_level = params.sealevel
	local area, data, p2data = params.area, params.data, params.vmparam2

	local csize = vector.add(vector.subtract(maxp, minp), 1)
	local ystride = area.ystride
	params.csize = csize

	local n_stone = node['default:stone']
	local n_air = node['air']
	local n_ignore = node['ignore']

	local base_level = params.sealevel + water_diff

	-- just a few 2d noises
	local ground_noise_map = layers_mod.get_noise2d({
			name = 'dflat_ground',
			pos = { x = minp.x, y = minp.z },
			size = {x=csize.x, y=csize.z},
		})

	local height_min = max_height
	local height_max = - max_height
	local surface = {}

	params.share.base_level = base_level

	-- for placing dungeon decor
	if not mod.carpetable then
		mod.carpetable = {
			[node['default:stone']] = true,
			[node['default:sandstone']] = true,
			[node['default:desert_stone']] = true,
			[node['default:cobble']] = true,
			[node['default:mossycobble']] = true,
		}
	end

	-- for placing cobwebs, etc.
	if not mod.sides then
		mod.sides = {
			{ i = -1, p2 = 3 },
			{ i = 1, p2 = 2 },
			{ i = - area.zstride, p2 = 5 },
			{ i = area.zstride, p2 = 4 },
			{ i = - area.ystride, p2 = 1 },
			{ i = area.ystride, p2 = 0 },
		}
	end

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

			-- Start at the bottom and fill up.
			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				if not (data[ivm] == n_air or data[ivm] == n_ignore) then
					-- nop
				elseif y <= height then
					-- Otherwise, it's stoned.
					data[ivm] = n_stone
					p2data[ivm] = 0
				end

				ivm = ivm + ystride
			end

			index = index + 1
		end
	end

	params.share.height_min = height_min
	params.share.height_max = height_max

	if height_max - height_min < 3 and height_max > water_level then
		params.share.flattened = true
	end

	params.share.surface = surface

				--layers_mod.time_y_loop = (layers_mod.time_y_loop or 0) + os.clock() - t_yloop
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
