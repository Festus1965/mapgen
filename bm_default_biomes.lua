-- Duane's mapgen bm_default_biomes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


bm_default_biomes = {}
local mod, layers_mod = bm_default_biomes, mapgen
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


-- , st, st, st, ss, ds, st, st, ss, ss, st, st, ss, ss, ss, ds, ds, ds, st, ds, ss, ss, st, ss, ds, st, ds, ds, st, st, ss
local sandy_nodes, stone_layers

do
	local st = node['default:stone']
	local ss = node['default:sandstone']
	local ds = node['default:desert_stone']
	local s = ''
	stone_layers = { ds, ds, ds, st, ds, ss, ss, ds, ds, ss, st, st, ds, ss, ds, st, ss, st, ss, st, ds, st, ds, ss, ss, st, ss, ss, st, st }

	if false then
		stone_layers = {}
		for i = 1, 30 do
			local j = math.random(3)
			if j == 1 then
				s = s .. ', st'
				table.insert(stone_layers, st)
			elseif j == 2 then
				s = s .. ', ss'
				table.insert(stone_layers, ss)
			else
				s = s .. ', ds'
				table.insert(stone_layers, ds)
			end
		end
		print(s)
	end
end

local default_sources = {
	['default'] = true,
	['dflat'] = true,
}


local default_noises = {
	filler_depth = { offset = 0, scale = 1.5, seed = -47383, spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1.0, lacunarity = 2 },
	geographic_heat_blend = { offset = 0, scale = 4, seed = 5349, spread = {x = 10, y = 10, z = 10}, octaves = 3, persist = 0.5, lacunarity = 2, flags = 'eased' },
	heat = { offset = 50, scale = 50, spread = {x = 1000, y = 1000, z = 1000}, seed = 5349, octaves = 3, persistence = 0.5, lacunarity = 2.0, flags = 'eased' },
	heat_blend = { offset = 0, scale = 1.5, spread = {x = 8, y = 8, z = 8}, seed = 13, octaves = 2, persistence = 1.0, lacunarity = 2.0, flags = 'eased' },
	humidity = { offset = 50, scale = 50, seed = 842, spread = {x = 1000, y = 1000, z = 1000}, octaves = 3, persist = 0.5, lacunarity = 2, flags = 'eased' },
	humidity_blend = { offset = 0, scale = 1.5, seed = 90003, spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1.0, lacunarity = 2, flags = 'eased' },
}


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
	--return mapgen.registered_biomes['desert']
	return biome
end


function mod.bm_default_biomes(params)
	local offset = params.biome_height_offset or 0
	local water_level = params.sealevel
	local minp, maxp = params.isect_minp, params.isect_maxp
	local area, data, p2data = params.area, params.data, params.p2data
	local ystride = area.ystride
	local csize = params.csize
	local biomes_i = {}

	local n_stone = node['default:stone']
	local n_desert_stone = node['default:desert_stone']
	local n_air = node['air']
	local n_water = node['default:water_source']
	local n_ice = node['default:ice']
	local n_ignore = node['ignore']
	local n_sand = node['default:sand']
	local n_clay = node['default:clay']
	local n_placeholder_lining = node[layers_mod.mod_name .. ':placeholder_lining']

	local replace = {
		[ n_stone ] = true,
		[ n_ignore ] = true,
		[ n_placeholder_lining ] = true,
	}

	if not params.share.biomes_here then
		params.share.biomes_here = {}
	end

	if not sandy_nodes then
		sandy_nodes = {}
		for k, v in pairs(minetest.registered_nodes) do
			if v.groups and v.groups.sand then
				sandy_nodes[params.node[k]] = true
			end
		end
	end

	-- Biome selection is expensive. This helps a bit.
	for _, b in pairs(biomes) do
		if default_sources[b.source] then
			table.insert(biomes_i, b)
		end
	end

	local heat_map, heat_blend_map
	if params.geographic_heat then
		heat_blend_map = layers_mod.get_noise2d('geographic_heat_blend', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	else
		heat_map = layers_mod.get_noise2d('heat', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
		heat_blend_map = layers_mod.get_noise2d('heat_blend', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	end
	local humidity_map = layers_mod.get_noise2d('humidity', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	local humidity_blend_map = layers_mod.get_noise2d('humidity_blend', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })
	local filler_depth_map = layers_mod.get_noise2d('filler_depth', nil, nil, nil, { x = csize.x, y = csize.z }, { x = minp.x, y = minp.z })

	local index = 1
	for z = minp.z, maxp.z do
		local heat_base
		if params.geographic_heat then
			heat_base = 15 + math.abs(70 - ((((z + 1000) / 6000) * 140) % 140))
		end
		for x = minp.x, maxp.x do
			local surface = params.share.surface[z][x]
			local height = (surface.top or minp.y - 2) - water_level - offset + 1
			local heat, heat_blend, humidity, humidity_blend

			surface.biome_height = height

			if params.geographic_heat then
				heat = heat_base
			else
				heat = heat_map[index]
			end
			heat_blend = heat_blend_map[index]
			humidity = humidity_map[index]
			humidity_blend = humidity_blend_map[index]

			heat = heat + heat_blend
			humidity = humidity + humidity_blend

			if height > 25 then
				local t = heat
				local h2 = height - 25
				heat = heat - h2 * h2 * 0.005
			end

			surface.heat = heat
			surface.heat_blend = heat_blend
			surface.humidity = humidity
			surface.humidity_blend = humidity_blend

			local grass_p2 = math.floor((humidity - (heat / 2) + 9) / 3)
			grass_p2 = (7 - math.min(7, math.max(0, grass_p2))) * 32
			surface.grass_p2 = grass_p2

			local biome = mod.get_biome(biomes_i, heat, humidity, height)
			assert(biome)

			do
				surface.biome = biome

				local h_factor = 0.03
				if sandy_nodes[biome.node_top] then
					h_factor = h_factor * 3
				end

				local f = biome.filler_depth or 1
				local t = biome.top_depth or 1
				local d = math.floor(math.max(0, filler_depth_map[index] + t) + f - height * h_factor + 0.5)

				if d + f + t < 1 then
					t = 0
				end
				surface.top_depth = t
				surface.filler_depth = math.max(0, d + f - t)
				--d = d + surface.filler_depth + t
				--surface.erosion = math.max(0, - d)

				-- Erosion screws up the ponds. They should probably
				--  be placed here, not in dflats...

				if params.share.biomes_here[biome.name] == true then
					params.share.biomes_here[biome.name] = 1
				end
				params.share.biomes_here[biome.name] = (params.share.biomes_here[biome.name] or 0) + 1

				local depth = surface.bottom

				-- depths
				local depth_top = surface.top_depth or biome.depth_top or 0  -- 1?
				local depth_filler = surface.filler_depth or biome.depth_filler or 0  -- 6?!
				--local erosion = surface.erosion or 0
				local wtd = biome.node_water_top_depth or 0
				local grass_p2 = surface.grass_p2 or 0

				--height = height - erosion
				surface.top = height

				-- biome-determined nodes
				local stone = biome.node_stone or n_stone
				--print(minetest.get_name_from_content_id(biome.node_stone))
				local filler = biome.node_filler or n_air
				local top = biome.node_top or n_air
				local riverbed = biome.node_riverbed
				local ww = biome.node_water or node['default:water_source']
				local wt = biome.node_water_top
				local in_desert = biome.name:find('desert') or humidity < 30

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

				-- Start at the top and fill down.
				local off, underwater
				if height > maxp.y then
					off = height
				end

				local fill_1, fill_2
				--local maxy = math.min(maxp.y, math.max(water_level, height))
				local ivm = area:index(x, maxp.y, z)
				for y = maxp.y, minp.y, -1 do
					if not off then
						if replace[data[ivm]] then
							off = y
							surface.top = off
							if data[ivm] == n_water then
								underwater = true
							end
						elseif (y == minp.y and y == height) then
							off = y
							if data[ivm] == n_water then
								underwater = true
							end
						end

						if off then
							fill_1 = off - depth_top
							fill_2 = fill_1 - depth_filler
						end
					end

					if data[ivm] == n_air and y > height and y <= water_level then
						if y > water_level - wtd then
							data[ivm] = wt
						else
							data[ivm] = ww
						end
						p2data[ivm] = 0
						underwater = true
					elseif data[ivm] == n_water and heat < 30 then
						data[ivm] = n_ice
					elseif data[ivm] == n_water and in_desert then
						data[ivm] = n_air
					elseif y >= height - 1 and data[ivm] == n_clay and in_desert then
						data[ivm] = n_sand
					elseif not off or y > off then
						-- nop
					elseif not replace[data[ivm]] then
						-- nop
					--elseif y > off - surface.erosion then
					--	data[ivm] = n_air
					elseif depth_top < 1 and y >= height then
						-- a minimal, pseudo-erosion
						data[ivm] = n_air
					elseif fill_1 and y > fill_1 then
						-- topping up
						data[ivm] = top
						p2data[ivm] = grass_p2
					elseif filler and fill_2 and y > fill_2 then
						-- filling
						data[ivm] = filler
						p2data[ivm] = 0
					else
						-- Otherwise, it's stoned.
						if stone_layers and stone == n_desert_stone then
							data[ivm] = stone_layers[y % 30 + 1]
							p2data[ivm] = 0
						end
						--p2data[ivm] = 0
					end

					ivm = ivm - ystride
				end
			end

			index = index + 1
		end
	end
end


for name, def in pairs(default_noises) do
	layers_mod.register_noise(name, def)
end


if true then
	dofile(layers_mod.path .. '/default_biomes.lua')
else
	local source = 'default'
	for _, v in pairs(minetest.registered_biomes) do
		local w = table.copy(v)
		w.source = source
		print('mod.register_biome(' .. dump(w) .. ')')
		layers_mod.register_biome(v, source)
	end

	for _, v in pairs(minetest.registered_decorations) do
		local w = table.copy(v)
		w.source = source
		if w.deco_type == 'schematic' then
			w = layers_mod.translate_schematic(w)
		end
		print('mod.register_decoration(' .. dump(w) .. ')')
		layers_mod.register_decoration(v)
	end
end


-----------------------------------------------
-- DFlat environment changes
-----------------------------------------------


if false then
	minetest.register_biome({
		name = 'ether',
		heat_point = -99,
		humidity_point = -99,
		node_stone = layers_mod.mod_name..':etherstone',
		source = 'dflat_ether',
	})
end


do
	local apple_deco
	for _, v in pairs(layers_mod.registered_decorations) do
		if v.name == 'default:apple_tree' then
			apple_deco = v
		end
	end

	if apple_deco and apple_deco.schematic_array and apple_deco.schematic_array.data then
		local def = table.copy(apple_deco)

		def.noise_params.seed = 385
		def.noise_params.offset = def.noise_params.offset - 0.03
		def.schematic = nil
		def.name = layers_mod.mod_name..':cherry_tree'
		def.schematic_array = table.copy(apple_deco.schematic_array)
		for _, v in pairs(def.schematic_array.data) do
			if v.name == 'default:leaves' or v.name == 'default:apple' then
				v.name = layers_mod.mod_name..':leaves_cherry'
			elseif v.name == 'default:tree' then
				v.name = layers_mod.mod_name..':tree_cherry'
			end
		end
		def.source = 'dflat'
		minetest.register_decoration(def)

		def = table.copy(apple_deco)

		def.noise_params.seed = 567
		def.noise_params.offset = def.noise_params.offset - 0.01
		def.schematic = nil
		def.name = layers_mod.mod_name..':oak_tree'
		def.schematic_array = table.copy(apple_deco.schematic_array)
		for _, v in pairs(def.schematic_array.data) do
			if v.name == 'default:leaves' or v.name == 'default:apple' then
				v.name = layers_mod.mod_name..':leaves_oak'
			elseif v.name == 'default:tree' then
				v.name = layers_mod.mod_name..':tree_oak'
			end
		end
		def.source = 'dflat'
		minetest.register_decoration(def)
	end

	--[[
	-- Palm tree
	do
		local d, h, w = 5, 7, 5
		local sch = mod.schematic_array(d, h, w)

		for i = 1, 2 do
			for z = -1, 1 do
				for x = -1, 1 do
					if (x ~= 0) == not (z ~= 0) then
						local n = sch.data[(2 + (z * i)) * h * w + (7 - i) * w + (2 + (x * i)) + 1]
						n.name = layers_mod.mod_name .. ':palm_leaves'
						n.prob = 127
					end
				end
			end
		end

		for i = 0, 3 do
			local n = sch.data[1 * h * w + i * w + 2 + 1]
			n.name = layers_mod.mod_name .. ':palm_tree'
			n.prob = 255
		end

		for i = 4, 5 do
			local n = sch.data[2 * h * w + i * w + 2 + 1]
			n.name = layers_mod.mod_name .. ':palm_tree'
			n.prob = 255
		end

		sch.yslice_prob = {
			{ ypos = 1, prob = 128 },
			{ ypos = 4, prob = 128 },
		}

		minetest.register_decoration({
			deco_type = 'schematic',
			place_on = { 'default:sand' },
			sidelen = 16,
			fill_ratio = 0.02,
			biomes = { 'desert_ocean' },
			y_min = 1,
			y_max = 1,
			schematic = sch,
			flags = 'place_center_x, place_center_z',
			rotation = 'random',
		})
	end

	--rereg = nil
	--]]
end


layers_mod.register_flower('orchid', 'dflat', 'Orchid', { 'rainforest', 'rainforest_swamp' }, 783, { color_pink = 1 })
layers_mod.register_flower('bird_of_paradise', 'dflat', 'Bird of Paradise', { 'rainforest' }, 798, { color_orange = 1 })
layers_mod.register_flower('gerbera', 'Gerbera', 'dflat', { 'savanna', 'rainforest' }, 911, { color_red = 1 })


layers_mod.register_mapfunc('bm_default_biomes', mod.bm_default_biomes)
