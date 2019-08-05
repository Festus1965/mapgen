-- Duane's mapgen dflat.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local altitude_cutoff_high = 30
local altitude_cutoff_low = -10
local altitude_cutoff_low_2 = 63
local water_diff = 8


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


local node
if layers_mod.mod_name == 'mapgen' then
	node = layers_mod.node
	clone_node = layers_mod.clone_node
else
	dofile(mod.path .. '/functions.lua')
	node = mod.node
	clone_node = mod.clone_node
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


function mod.generate_dflat(params)
	local minp, maxp = params.isect_minp, params.isect_maxp
	local water_level = params.sealevel
	local area, data, p2data = params.area, params.data, params.vmparam2

	local csize = vector.add(vector.subtract(maxp, minp), 1)
	local ystride = area.ystride

	local n_stone = node['default:stone']
	local n_air = node['air']
	local n_water = node['default:water_source']
	local n_ice = node['default:ice']

	local ps = PcgRandom(params.chunk_seed + 7712)

	local base_level = params.sealevel + water_diff

	-- just a few 2d noises
	local ground_noise_map = layers_mod.get_noise2d('dflat_ground', nil, nil, nil, {x=csize.x, y=csize.z}, { x = minp.x, y = minp.z })
	--local under_noise_map = layers_mod.get_noise2d('floaters_under', nil, nil, nil, {x=csize.x, y=csize.z}, { x = minp.x, y = minp.z })
	local base_noise_map = layers_mod.get_noise2d('erosion', nil, nil, nil, {x=csize.x, y=csize.z}, { x = minp.x, y = minp.z })

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
			local wtd = biome.node_water_top_depth or 0
			local grass_p2 = surface.grass_p2 or 0

			local fill_1 = height - depth_top
			local fill_2 = fill_1 - math.max(0, depth_filler)

			-- biome-determined nodes
			local stone = biome.node_stone or n_stone
			local filler = biome.node_filler or n_air
			local top = biome.node_top or n_air
			local riverbed = biome.node_riverbed
			local ww = biome.node_water or node['default:water_source']
			local wt = biome.node_water_top

			if ww == n_water then
				if surface.heat < 30 then
					wt = n_ice
					wtd = math.ceil(math.max(0, (30 - surface.heat) / 3))
				else
					wt = nil
				end
			end

			-- Start at the bottom and fill up.
			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				if y > height and y <= water_level then
					-- rivers or lakes
					if y > water_level - wtd then
						data[ivm] = wt
					else
						data[ivm] = ww
					end
					p2data[ivm] = 0
				elseif y == height and y <= water_level then
					-- river/lakebeds
					data[ivm] = riverbed
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
				--elseif y <= cave_high and y >= cave_low then
					-- This is a cave. (none here)
				elseif y <= height then
					-- Otherwise, it's stoned.
					data[ivm] = stone
					p2data[ivm] = 0
				end

				ivm = ivm + ystride
			end

			index = index +	1
		end
	end


	if layers_mod.place_all_decorations then
		layers_mod.place_all_decorations(params)

		if not params.share.no_dust and layers_mod.dust then
			layers_mod.dust(params)
		end
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

-- Define the noises.
layers_mod.register_noise( 'dflat_ground', { offset = 0, scale = 100, seed = 4382, spread = {x = 320, y = 320, z = 320}, octaves = 6, persist = 0.5, lacunarity = 2.0} )
layers_mod.register_noise( 'heat_blend', { offset = 0, scale = 4, seed = 5349, spread = {x = 10, y = 10, z = 10}, octaves = 3, persist = 0.5, lacunarity = 2, flags = 'eased' } )
layers_mod.register_noise( 'erosion', { offset = 0, scale = 1.5, seed = -47383, spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1.0, lacunarity = 2 } )

layers_mod.register_mapgen('tg_dflat', mod.generate_dflat)
if layers_mod.register_spawn then
	layers_mod.register_spawn('tg_dflat', mod.get_spawn_level)
end


--[[
local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

local Geomorph = geomorph.Geomorph

local math.abs = math.abs
local math.floor = math.floor
local math.max = math.max
local math.min = math.min
local node = layer_mod.node
local os_clock = os.clock
local VN = vector.new

local water_diff = 8


dofile(mod.path..'/dflat_biomes.lua')


-----------------------------------------------
-- DFlat_Mapgen class
-----------------------------------------------

local DFlat_Mapgen = layer_mod.subclass_mapgen()


function DFlat_Mapgen:_init()
	params.biomemap = {}
	params.heatmap = {}
	params.humiditymap = {}

	-- Roads needs this data.
	-- There really should be a better way of doing this.
	params.share.biomemap = params.biomemap
	params.share.humiditymap = params.humiditymap
end


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

	if do_ore then
		local t_ore = os_clock()
		mod.simple_ore()
		layer_mod.time_ore = layer_mod.time_ore + os_clock() - t_ore
	end
end


function DFlat_Mapgen:generate()
	mod.prepare()
	mod.map_height()
	mod.place_terrain()
	mod.after_terrain()
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
	geo:write_to_map(self)

	return true
end


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------

do
	local terrain_scale = 100

	local ether_div = 8
	local max_chunks = layer_mod.max_chunks
	local max_chunks_ether = math.floor(layer_mod.max_chunks / ether_div)

	local noises = {
		dflat_ground = { def = { offset = 0, scale = terrain_scale, seed = 4382, spread = {x = 320, y = 320, z = 320}, octaves = 6, persist = 0.5, lacunarity = 2.0}, },
		heat_blend = { def = { offset = 0, scale = 4, seed = 5349, spread = {x = 10, y = 10, z = 10}, octaves = 3, persist = 0.5, lacunarity = 2, flags = 'eased' }, },
		erosion = { def = { offset = 0, scale = 1.5, seed = -47383, spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1.0, lacunarity = 2 }, },
		--flat_cave_1 = { def = { offset = 0, scale = 10, seed = 6386, spread = {x = 23, y = 23, z = 23}, octaves = 3, persist = 0.7, lacunarity = 1.8 }, },
		--cave_heat = { def = { offset = 50, scale = 50, seed = 1578, spread = {x = 200, y = 200, z = 200}, octaves = 3, persist = 0.5, lacunarity = 2 }, },
	}

	local e_noises = { dflat_ground = table.copy(noises.dflat_ground) }
	e_noises.dflat_ground.def.spread = vector.divide(e_noises.dflat_ground.def.spread, ether_div)


	layer_mod.register_map({
		name = 'dflat',
		biomes = 'default',
		heat = 'base_heat',
		mapgen = DFlat_Mapgen,
		mapgen_name = 'dflat',
		map_minp = VN(-max_chunks, -4, -max_chunks),
		map_maxp = VN(max_chunks, 5, max_chunks),
		noises = noises,
		random_teleportable = true,
		water_level = 1,
	})

	layer_mod.register_map({
		name = 'ether',
		biomes = 'dflat_ether',
		div = ether_div,
		heat = 50,
		humidity = 50,
		mapgen = DFlat_Mapgen,
		mapgen_name = 'dflat_ether',
		map_minp = VN(-max_chunks_ether, -360, -max_chunks_ether),
		map_maxp = VN(max_chunks_ether, -350, max_chunks_ether),
		noises = e_noises,
		water_level = -28400,
	})
end
--]]
