-- Duane's mapgen functions.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = mapgen
local mod_name = 'mapgen'

local math_floor = math.floor
local math_min = math.min
local math_max = math.max


-- This tables looks up nodes that aren't already stored.
mod.node = setmetatable({}, {
	__index = function(t, k)
		if not (t and k and type(t) == 'table') then
			return
		end

		t[k] = minetest.get_content_id(k)
		return t[k]
	end
})
local node = mod.node


function vector.mod(v, m)
	local w = table.copy(v)
	for _, d in ipairs({'x', 'y', 'z'}) do
		if w[d] then
			w[d] = w[d] % m
		end
	end
	return w
end


local axes = { 'x', 'y', 'z' }
function vector.contains(minp, maxp, q)
	for _, a in pairs(axes) do
		if minp[a] > q[a] or maxp[a] < q[a] then
			return
		end
	end

	return true
end


-- These nodes will have their on_construct method called
--  when placed by the mapgen (to start timers).
mod.construct_nodes = {}
function mod.add_construct(node_name)
	mod.construct_nodes[node[node_name]] = true
end


-- Modify a node to add a group
function mod.add_group(node_name, groups)
	local def = minetest.registered_items[node_name]
	if not (node_name and def and groups and type(groups) == 'table') then
		return false
	end
	local def_groups = def.groups or {}
	for group, value in pairs(groups) do
		if value ~= 0 then
			def_groups[group] = value
		else
			def_groups[group] = nil
		end
	end
	minetest.override_item(node_name, {groups = def_groups})
	return true
end


function mod.clone_node(name)
	if not (name and type(name) == 'string') then
		return
	end
	if not minetest.registered_nodes[name] then
		return
	end

	local nod = minetest.registered_nodes[name]
	local node2 = table.copy(nod)
	return node2
end


-- memory issues?
function mod.node_string_or_table(n)
    if not n then
        return {}
    end

    local o
    if type(n) == 'string' then
        o = { n }
    elseif type(n) == 'table' then
        o = table.copy(n)
    else
        return {}
    end

    for i, v in pairs(o) do
        o[i] = node[v]
    end

    return o
end


-- Create and initialize a table for a schematic.
function mod.schematic_array(width, height, depth)
	if not (
		width and height and depth
		and type(width) == 'number'
		and type(height) == 'number'
		and type(depth) == 'number'
	) then
		return
	end

	-- Dimensions of data array.
	local s = {size={x=width, y=height, z=depth}}
	s.data = {}

	for z = 0,depth-1 do
		for y = 0,height-1 do
			for x = 0,width-1 do
				local i = z*width*height + y*width + x + 1
				s.data[i] = {}
				s.data[i].name = "air"
				s.data[i].param1 = 000
			end
		end
	end

	s.yslice_prob = {}

	return s
end


mod.max_chunks = 387
mod.world_map = {}
function mod.register_map(def)
	-------------------------------------------
	-- Check parameters.
	-------------------------------------------

	local biomes = def.biomes
	if biomes and biomes == 'default' then
		biomes = {}
		for n, v in pairs(mod.biomes) do
			if v.source == 'default' then
				local w = table.copy(v)
				if v.y_max then
					w.y_max = v.y_max + def.water_level - 1
					w.y_max = math_min(w.y_max, mod.max_height)
				end
				if v.y_min then
					w.y_min = v.y_min + def.water_level - 1
					w.y_min = math_max(w.y_min, -mod.max_height)
				end

				biomes[n] = w
			end
		end
		def.biomes = biomes
		--print('registering mapgen: '..def.mapgen_name)
	end

	table.insert(mod.world_map, def)
end


mod.biomes = {}
mod.cave_biomes = {}


function mod.register_biome(def, source)
	if not def.name then
		print('No-name biome', dump(def))
		return
	end

	local w = table.copy(def)
	w.source = source
	mod.biomes[w.name] = w
end


do
	-- This tries to determine which biomes are default.
	local default_biome_names = {
		['cold_desert_ocean'] = true,
		['cold_desert_ocean'] = true,
		['cold_desert'] = true,
		['cold_desert'] = true,
		['coniferous_forest_dunes'] = true,
		['coniferous_forest_dunes'] = true,
		['coniferous_forest_ocean'] = true,
		['coniferous_forest_ocean'] = true,
		['coniferous_forest'] = true,
		['coniferous_forest'] = true,
		['deciduous_forest_ocean'] = true,
		['deciduous_forest_ocean'] = true,
		['deciduous_forest_shore'] = true,
		['deciduous_forest_shore'] = true,
		['deciduous_forest'] = true,
		['deciduous_forest'] = true,
		['desert_ocean'] = true,
		['desert_ocean'] = true,
		['desert'] = true,
		['desert'] = true,
		['grassland_dunes'] = true,
		['grassland_dunes'] = true,
		['grassland_ocean'] = true,
		['grassland_ocean'] = true,
		['grassland'] = true,
		['grassland'] = true,
		['icesheet_ocean'] = true,
		['icesheet_ocean'] = true,
		['icesheet'] = true,
		['icesheet'] = true,
		['rainforest_ocean'] = true,
		['rainforest_ocean'] = true,
		['rainforest_swamp'] = true,
		['rainforest_swamp'] = true,
		['rainforest'] = true,
		['rainforest'] = true,
		['sandstone_desert_ocean'] = true,
		['sandstone_desert_ocean'] = true,
		['sandstone_desert'] = true,
		['sandstone_desert'] = true,
		['savanna_ocean'] = true,
		['savanna_ocean'] = true,
		['savanna_shore'] = true,
		['savanna_shore'] = true,
		['savanna'] = true,
		['savanna'] = true,
		['snowy_grassland_ocean'] = true,
		['snowy_grassland_ocean'] = true,
		['snowy_grassland'] = true,
		['snowy_grassland'] = true,
		['taiga_ocean'] = true,
		['taiga_ocean'] = true,
		['taiga'] = true,
		['taiga'] = true,
		['tundra_beach'] = true,
		['tundra_beach'] = true,
		['tundra_highland'] = true,
		['tundra_highland'] = true,
		['tundra_ocean'] = true,
		['tundra_ocean'] = true,
		['tundra'] = true,
		['tundra'] = true,
		['underground'] = true,
	}

	for _, v in pairs(minetest.registered_biomes) do
		if default_biome_names[v.name] then
			mod.register_biome(v, 'default')
		else
			mod.register_biome(v, v.source)
		end
	end
end



function mod.invert_table(t, use_node)
	local any
	local new_t = {}

	if type(t) == 'string' then
		t = {t}
	end

	for _, d in ipairs(t) do
		if type(d) == 'string' then
			local l = {}
			if use_node and d:find('^group:') then
				local gr = d:gsub('^group:', '')
				for n, v in pairs(minetest.registered_nodes) do
					if v.groups[gr] then
						l[#l+1] = n
					end
				end
			elseif use_node then
				l = {d}
			end

			if use_node then
				for _, v in pairs(l) do
					new_t[node[v]] = node[v]
				end
			else
				new_t[d] = d
			end
			any = true
		end
	end

	if any then
		return new_t
	end
end


function mod.register_decoration(def)
	local deco = table.copy(def)
	table.insert(mod.decorations, deco)

	if not deco.name then
		local nname = (deco.decoration or deco.schematic):gsub('^.*[:/]([^%.]+)', '%1')
		deco.name = nname
	end

	if deco.flags and deco.flags ~= '' then
		for flag in deco.flags:gmatch('[^, ]+') do
			deco[flag] = deco[flag] or true
		end
	end

	if deco.place_on then
		deco.place_on_i = mod.invert_table(deco.place_on, true)
	end

	if deco.biomes then
		deco.biomes_i = mod.invert_table(deco.biomes)
	end

	for _, a in pairs(mod.aquatic_decorations or {}) do
		if deco.decoration == a or deco.schematic == a then
			deco.aquatic = true
		end
	end

	if deco.deco_type == 'schematic' then
		if deco.schematic and type(deco.schematic) == 'string' then
			local s = deco.schematic
			local f = io.open(s, 'r')
			if f then
				f:close()
				local sch = minetest.serialize_schematic(s, 'lua', {})
				sch = minetest.deserialize('return {'..sch..'}')
				sch = sch.schematic
				deco.schematic_array = sch
			else
				print(mod_name .. ': ** Error opening: '..deco.schematic)
			end

			--print(dump(deco.schematic_array))
			if not deco.schematic_array then
				print(mod_name .. ': ** Error opening: '..deco.name)
			end
		end

		if not deco.schematic_array and deco.schematic and type(deco.schematic) == 'table' then
			deco.schematic_array = deco.schematic
		end

		if deco.schematic_array then
			-- Force air placement to 0 probability.
			-- This is usually correct.
			for _, v in pairs(deco.schematic_array.data) do
				if v.name == 'air' then
					v.prob = 0
					if v.param1 then
						v.param1 = 0
					end
				elseif v.name:find('leaves') or v.name:find('needles') then
					if v.prob > 127 then
						v.prob = v.prob - 128
					end
				end
			end
		else
			print('FAILed to translate schematic: ' .. deco.name)
			deco.bad_schem = true
		end
	end

	return deco
end


do
	mod.decorations = {}
	for _, v in pairs(minetest.registered_decorations) do
		mod.register_decoration(v)
	end
end


-- Catch any registered by other mods.
do
	local old_register_decoration = minetest.register_decoration
	minetest.register_decoration = function (def)
		mod.register_decoration(def)
		old_register_decoration(def)
	end


	local old_clear_registered_decorations = minetest.clear_registered_decorations
	minetest.clear_registered_decorations = function ()
		mod.decorations = {}
		old_clear_registered_decorations()
	end


	local old_register_biome = minetest.register_biome
	minetest.register_biome = function (def)
		mod.register_biome(def)
		old_register_biome(def)
	end


	local old_clear_registered_biomes = minetest.clear_registered_biomes
	minetest.clear_registered_biomes = function ()
		mod.biomes = {}
		old_clear_registered_biomes()
	end
end


function mod.register_flower(name, desc, biomes, seed)
	local groups = { }
	groups.snappy = 3
	groups.flammable = 2
	groups.flower = 1
	groups.flora = 1
	groups.attached_node = 1
	local img = mod_name .. '_' .. name .. '.png'

	minetest.register_node(mod_name..':' .. name, {
		description = desc,
		drawtype = 'plantlike',
		waving = 1,
		tiles = { img },
		inventory_image = img,
		wield_image = img,
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		buildable_to = true,
		stack_max = 99,
		groups = groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = 'fixed',
			fixed = { -0.5, -0.5, -0.5, 0.5, -5/16, 0.5 },
		}
	})

	local bi = { }
	if biomes then
		bi = { }
		for _, b in pairs(biomes) do
			bi[b] = true
		end
	end

	if bi['rainforest'] then
		minetest.register_decoration({
			deco_type = 'simple',
			place_on = { 'default:dirt_with_rainforest_litter' },
			sidelen = 16,
			noise_params = {
				offset = 0.015,
				scale = 0.025,
				spread = { x = 200, y = 200, z = 200 },
				seed = seed,
				octaves = 3,
				persist = 0.6
			},
			biomes = { 'rainforest', 'rainforest_swamp' },
			y_min = 1,
			y_max = 31000,
			decoration = mod_name..':'..name,
			name = name,
			flower = true,
		})
	end

	minetest.register_decoration({
		deco_type = 'simple',
		place_on = { 'default:dirt_with_grass', 'default:dirt_with_dry_grass', 'default:dirt_with_rainforest_litter' },
		sidelen = 16,
		noise_params = {
			offset = -0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		biomes = biomes,
		y_min = 1,
		y_max = 31000,
		decoration = mod_name..':'..name,
		name = name,
		flower = true,
	})
end


minetest.register_on_shutdown(function()
  print('time caves: '..math.floor(1000 * mod.time_caves / mod.chunks))
  print('time decorations: '..math.floor(1000 * mod.time_deco / mod.chunks))
  print('time ore: '..math.floor(1000 * mod.time_ore / mod.chunks))
  print('time overhead: '..math.floor(1000 * mod.time_overhead / mod.chunks))
  print('time terrain: '..math.floor(1000 * mod.time_terrain / mod.chunks))
  print('time terrain_f: '..math.floor(1000 * mod.time_terrain_f / mod.chunks))
  print('time y loop: '..math.floor(1000 * mod.time_y_loop / mod.chunks))

  print('Total Time: '..math.floor(1000 * mod.time_all / mod.chunks))
  print('chunks: '..mod.chunks)
end)


minetest.register_privilege('mapgen', {
	description = 'allowed to alter the landscape',
	give_to_singleplayer = true,
	give_to_admin = true,
})

minetest.register_chatcommand('ether', {
	params = '',
	description = 'Teleport to ether',
	privs = { mapgen = true },
	func = function(player_name, param)
		if type(player_name) ~= 'string' or player_name == '' then
			return
		end

		local player = minetest.get_player_by_name(player_name)
		if not player then
			return
		end

		local pos = player:get_pos()
		local npos = table.copy(pos)

		if pos.y < -27000 then
			npos.x = math_floor(npos.x * 8 + 0.5)
			--npos.y = npos.y + 28800
			npos.y = math_floor((npos.y + 28400) * 8 + 0.5)
			npos.z = math_floor(npos.z * 8 + 0.5)
			player:set_pos(npos)
		else
			npos.x = math_floor(npos.x / 8 + 0.5)
			--npos.y = npos.y - 28800
			npos.y = math_floor((npos.y) / 8 + 0.5) - 28400 + 2
			npos.z = math_floor(npos.z / 8 + 0.5)
			player:set_pos(npos)
		end
	end,
})


minetest.register_chatcommand('chunk', {
	params = '',
	description = 'What chunk is this?',
	privs = { },
	func = function(player_name, param)
		if not player_name then
			return
		end

		local player = minetest.get_player_by_name(player_name)
		if not player then
			return
		end

		local pos = player:get_pos()
		if not pos then
			return
		end

		local chunksize = tonumber(minetest.settings:get('chunksize') or 5)
		local chunk_offset = math.floor(chunksize / 2) * 16;
		local csize = { x=chunksize * 16, y=chunksize * 16, z=chunksize * 16 }

		local chunk = vector.floor(vector.divide(vector.add(pos, chunk_offset), csize.z))
		minetest.chat_send_player(player_name, 'Chunk: ' .. chunk.x .. ',' .. chunk.y .. ',' .. chunk.z)
	end,
})


minetest.register_chatcommand('genesis', {
	params = '',
	description = 'Regenerate a chunk, destroying all existing nodes.',
	privs = { mapgen = true },
	func = function(player_name, param)
		if not player_name then
			return
		end

		local player = minetest.get_player_by_name(player_name)
		if not player then
			return
		end

		local pos = player:get_pos()
		if not pos then
			return
		end

		local chunksize = tonumber(minetest.settings:get('chunksize') or 5)
		local chunk_offset = math.floor(chunksize / 2) * 16;
		local csize = { x=chunksize * 16, y=chunksize * 16, z=chunksize * 16 }

		local chunk = vector.floor(vector.divide(vector.add(pos, chunk_offset), csize.z))
		local minp = vector.add(vector.multiply(chunk, csize.z), -chunk_offset)
		local maxp = vector.add(vector.add(minp, -1), csize.z)
		local vm = minetest.get_voxel_manip()
		if not vm then
			return
		end
		local emin, emax = vm:read_from_map(minp, maxp)

		if not (emin and emax) then
			return
		end

		local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
		local data = vm:get_data()
		local p2data = vm:get_param2_data()
		local n_air = minetest.get_content_id('air')

		for z = minp.z, maxp.z do
			for y = minp.y, maxp.y do
				local ivm = area:index(minp.x, y, z)
				for x = minp.x, maxp.x do
					data[ivm] = n_air
					p2data[ivm] = 0
					ivm = ivm + 1
				end
			end
		end

		vm:set_data(data)
		vm:set_param2_data(p2data)
		vm:write_to_map()
		vm = nil

		local mg = mod.Mapgen(minp, maxp, nil)
		if not mg then
			return
		end
		mg.name = 'Mapgen'

		mg:generate_all(true)
	end,
})
