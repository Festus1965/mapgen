-- Duane's mapgen functions.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

-- Some of this code was inspired by, and hopefully is compatible
--  with, Donald Hines' Realms mod.


local mod = mapgen
local mod_name = 'mapgen'


mod.mapgen_forced_params = {}
mod.registered_biomes = {}
mod.registered_cave_biomes = {}
mod.registered_decorations = {}
mod.registered_loot = {}
mod.registered_mapfuncs = {}
mod.registered_mapgens = {}
mod.registered_noises = {}
mod.registered_spawns = {}
mod.rmf = mod.registered_mapfuncs
mod.pit_depth = 12
mod.chunksize = tonumber(minetest.settings:get('chunksize') or 5)
mod.chunk_offset = math.floor(mod.chunksize / 2) * 16;


local axes = { 'x', 'y', 'z' }

mod.summoned_mob_names = {
	'nmobs:cave_bear',
	'nmobs:boulder',
	'nmobs:cockatrice',
	'nmobs:giant_lizard',
	'nmobs:rat',
	'nmobs:scorpion',
	'nmobs:skeleton',
	'nmobs:green_slime',
	'nmobs:deep_spider',
	'nmobs:goblin',
	'nmobs:goblin_basher',
}
local summoned_mob_names = mod.summoned_mob_names


-- This table looks up nodes that aren't already stored.
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


-- This table looks up wallmounted nodes that aren't already stored.
mod.wallmounted = setmetatable({}, {
	__index = function(t, k)
		if not (t and k and type(t) == 'table') then
			return
		end

		t[k] = minetest.registered_nodes[k].paramtype2 == 'wallmounted'
		return t[k]
	end
})


local fnv_offset = 2166136261
local fnv_prime = 16777619
function math.fnv1a(data)
	local hash = fnv_offset
	for _, b in pairs(data) do
		hash = math.xor(hash, b)
		hash = hash * fnv_prime
	end
	return hash
end


function math.xor(a, b)
	local r = 0
	for i = 0, 31 do
		local x = a / 2 + b / 2
		if x ~= math.floor(x) then
			r = r + 2^i
		end
		a = math.floor(a / 2)
		b = math.floor(b / 2)
	end
	return r
end
assert(math.xor(60, 13) == 49)


function vector.abs(a)
	local b = table.copy(a)
	for _, axis in pairs(axes) do
		if b[axis] < 0 then
			b[axis] = - b[axis]
		end
	end

	return b
end


function vector.contains(minp, maxp, x, y, z)
	-- Don't create a vector here. It would be slower.
	if y and z then
		if minp.x > x or maxp.x < x
		or minp.y > y or maxp.y < y
		or minp.z > z or maxp.z < z then
			return
		end
	else
		for _, a in pairs(axes) do
			if minp[a] > x[a] or maxp[a] < x[a] then
				return
			end
		end
	end

	return true
end


function vector.intersect_min(a, b)
	local out = {}
	for _, axis in pairs(axes) do
		if a[axis] < b[axis] then
			out[axis] = a[axis]
		else
			out[axis] = b[axis]
		end
	end
	return out
end


function vector.intersect_max(a, b)
	local out = {}
	for _, axis in pairs(axes) do
		if a[axis] > b[axis] then
			out[axis] = a[axis]
		else
			out[axis] = b[axis]
		end
	end
	return out
end


function vector.mod(v, m)
	local w = table.copy(v)
	for _, d in ipairs(axes) do
		if w[d] then
			w[d] = w[d] % m
		end
	end
	return w
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
		if value == 0 then
			def_groups[group] = nil
		else
			def_groups[group] = value
		end
	end

	minetest.override_item(node_name, {groups = def_groups})
	return true
end


function mod.chest_rightclick(pos, node, clicker, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)

	if meta:contains('mapgen_summon_mob') then
	elseif meta:contains('mapgen_poisoned')
	and minetest.global_exists('status_mod')
	and status_mod.set_status then
		local player_name = clicker:get_player_name()
		if not player_name or player_name == '' then
			return
		end
		minetest.chat_send_player(player_name, minetest.colorize('#FF0000', 'You\'ve been poisoned!'))
		status_mod.set_status(player_name, 'booty_poisoned', 2 ^ math.random(8), {damage = 1})

		meta:set_string('mapgen_poisoned', '')
		return
	elseif meta:contains('mapgen_tnt_trap')
	and minetest.registered_items['tnt:tnt_burning'] then
		meta:from_table(nil)
		minetest.set_node(pos, {name = 'tnt:tnt_burning'})
		local timer = minetest.get_node_timer(pos)
		if timer then
			timer:start(3)
		end
		minetest.sound_play('default_dig_crumbly', {pos = pos, gain = 0.5, max_hear_distance = 10})
		return
	elseif meta:contains('mapgen_pitfall') then
		local depth = meta:get_int('mapgen_pitfall') or 21
		meta:from_table(nil)
		minetest.remove_node(pos)

		pos = clicker:getpos()
		if not pos then
			return
		end

		mod.disintigrate({x = pos.x - 1, y = pos.y - depth, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 2, z = pos.z + 1})

		return
	end

	return true
end


local MAX_MOBS = 30
function mod.chest_timer(pos, elapsed)
	local mt = minetest.get_meta(pos)
	if not mt then
		return true
	end

	if elapsed < 150 then
		--print('elapsed error:', elapsed)
		return true
	end

	local close
	for _, player in pairs(minetest.get_connected_players()) do
		local p = player:get_pos()
		local rd = vector.abs(vector.subtract(p, pos))
		if rd.x * rd.x + rd.z * rd.z + 2 * rd.y * rd.y < 2700 then
			close = true
			break
		end
	end

	if not close then
		return true
	end

	local ct = 0
	for _, o in pairs(minetest.luaentities) do
		if vector.distance(o.object:get_pos(), pos) < 300 then
			ct = ct + 1
			if ct > MAX_MOBS then
				return true
			end
		end
	end

	local p = table.copy(pos)
	p.y = p.y + 2
	local name = summoned_mob_names[math.random(#summoned_mob_names)]
	minetest.add_entity(p, name)

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


function mod.cube_intersect(r1, r2)
	local minp, maxp = {}, {}
	for _, axis in pairs(axes) do
		minp[axis] = math.max(r1.minp[axis], r2.minp[axis])
		maxp[axis] = math.min(r1.maxp[axis], r2.maxp[axis])

		if minp[axis] > maxp[axis] then
			return
		end
	end
	return minp, maxp
end


function mod.disintigrate(minp, maxp)
	if not (minp and maxp) then
		return
	end
	minp = vector.round(minp)
	maxp = vector.round(maxp)

	local air = minetest.get_content_id('air')
	local vm = minetest.get_voxel_manip()
	if not vm then
		return
	end

	local emin, emax = vm:read_from_map(minp, maxp)
	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local data = vm:get_data()
	local p = {}
	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			local ivm = area:index(minp.x, y, z)
			for x = minp.x, maxp.x do
				data[ivm] = air
				ivm = ivm + 1
			end
		end
	end
	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end


function mod.fill_chest(pos)
	local value = math.random(20)
	if pos.y < -100 then
		local depth = math.log(pos.y / -100)
		depth = depth * depth * depth * 10
		value = value + math.floor(depth)
	end
	local loot = mod.get_loot(value)

	local inv = minetest.get_inventory({ type = 'node', pos = pos })
	if inv then
		for _, it in pairs(loot) do
			if inv:room_for_item('main', it) then
				inv:add_item('main', it)
			end
		end
	end
end


function mod.get_loot(avg_value)
	local value = avg_value or 10
	local loot = {}
	local jump = 3

	if avg_value > 100 then
		jump = 4
	end

	while value > 0 do
		local r = 1
		local its = {}

		for i = 1, 12 do
			if math.random(5) < jump then
				r = r + 1
			else
				break
			end
		end

		while #its < 1 do
			for _, tr in pairs(mod.registered_loot) do
				if tr.rarity == r then
					table.insert(its, tr)
				end
			end
			r = r - 1
		end

		if #its > 0 then
			local it = its[math.random(#its)]
			local it_str = it.name
			local num = it.number.min
			local tool = minetest.registered_tools[it.name] ~= nil
			if tool or it.number.max > num then
				num = math.random(num, it.number.max)
				it_str = it_str .. ' ' .. num
				if tool then
					it_str = it_str .. ' ' .. math.floor(65000 * (math.random(10) + 5) / 20)
				end
			end
			table.insert(loot, it_str)
			value = value - 3 ^ r
		end
	end

	return loot
end


function mod.get_noise2d(params)
	local name = params.name
	--local default = params.default
	local seed = params.seed
	--local default_seed = params.default_seed
	local size = params.size
	local pos = params.pos

	if not (name and pos and size and type(name) == 'string'
	and type(pos) == 'table' and type(size) == 'table'
	and mod.registered_noises[name]) then
		return
	end

	if size.z then
		size.y = size.z
	end

	if pos.z then
		pos.y = pos.z
	end

	local def = table.copy(mod.registered_noises[name])
	if seed then
		def.seed = def.seed + seed
	end
	local noise = minetest.get_perlin_map(def, size)
	if not noise then
		return
	end

	return noise:get_2d_map_flat(pos)
end


function mod.get_noise3d(params)
	local name = params.name
	--local default = params.default
	local seed = params.seed
	--local default_seed = params.default_seed
	local size = params.size
	local pos = params.pos

	if not (name and pos and size and type(name) == 'string'
	and type(pos) == 'table' and type(size) == 'table'
	and mod.registered_noises[name]) then
		return
	end

	local def = table.copy(mod.registered_noises[name])
	if seed then
		def.seed = def.seed + seed
	end
	local noise = minetest.get_perlin_map(def, size)
	if not noise then
		return
	end

	return noise:get_3d_map_flat(pos)
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


function mod.register_biome(def, source)
	if not def.name then
		minetest.log(mod_name .. ': No-name biome: ' .. dump(def))
		return
	end

	local w = table.copy(def)

	--w.node_cave_liquid = node[w.node_cave_liquid]
	--w.node_ceiling = node[w.node_ceiling]
	--w.node_dust = node[w.node_dust]
	--w.node_filler = node[w.node_filler]
	--w.node_floor = node[w.node_floor]
	--w.node_gas = node[w.node_gas]
	--w.node_lining = node[w.node_lining]
	--w.node_riverbed = node[w.node_riverbed]
	--w.node_stone = node[w.node_stone]
	--w.node_top = node[w.node_top]
	--w.node_water = node[w.node_water]
	--w.node_water_top = node[w.node_water_top]

	w.source = source or w.source
	mod.registered_biomes[w.name] = w

	return w
end


local unknown_count = 0
function mod.register_decoration(def)
	local deco = table.copy(def)
	table.insert(mod.registered_decorations, deco)

	if not deco.name then
		local nname
		local dec = deco.decoration or deco.schematic
		if dec and type(dec) == 'string' then
			nname = dec:gsub('^.*[:/]([^%.]+)', '%1')
		else
			unknown_count = unknown_count + 1
			nname = 'unknown' .. unknown_count
		end
		deco.name = nname
	end

	if deco.place_on and type(deco.place_on) == 'table'
	and deco.place_on[1]:find('ethereal') then
		deco.source = 'ethereal'
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
		deco = mod.translate_schematic(deco)
	end

	return deco
end


function mod.register_flower(name, source, desc, biomes, seed, groups)
	groups = groups or { }
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
			source = source,
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
		source = source,
	})
end


function mod.register_loot(def, force)
	if not def.name or not def.rarity
	or not minetest.registered_items[def.name]
	or (not force and mod.registered_loot[def.name]) then
		print(mod_name .. ': not (re)registering ' .. (def.name or 'nil'))
		--print(dump(def))
		return
	end

	if not def.level then
		def.level = 1
	end

	if not def.number then
		def.number = {}
	end
	if not def.number.min then
		def.number.min = 1
	end
	if not def.number.max then
		def.number.max = def.number.min
	end

	mod.registered_loot[def.name] = def
end


function mod.register_mapfunc(name, func)
	if not (name and func and type(name) == 'string' and type(func) == 'function') then
		return
	end

	if mod.registered_mapfuncs[name] then
		minetest.log(mod_name .. ': * Overriding existing map function: ' .. name)
	end

	mod.registered_mapfuncs[name] = func
end


function mod.register_mapgen(name, func, forced_params)
	if not (name and func and type(name) == 'string' and type(func) == 'function') then
		return
	end

	if mod.registered_mapgens[name] then
		minetest.log(mod_name .. ': * Overriding existing mapgen: ' .. name)
	end

	mod.registered_mapgens[name] = func

	mod.mapgen_forced_params[name] = forced_params
end


function mod.register_noise(name, def)
	if not (name and def and type(name) == 'string' and type(def) == 'table') then
		return
	end

	if mod.registered_noises[name] then
		minetest.log(mod_name .. ': * Overriding existing noise: ' .. name)
	end

	mod.registered_noises[name] = def
end


function mod.register_spawn(name, func)
	if not (name and func and type(name) == 'string' and type(func) == 'function') then
		return
	end

	if mod.registered_spawns[name] then
		minetest.log(mod_name .. ': * Overriding existing spawn: ' .. name)
	end

	mod.registered_spawns[name] = func
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
				s.data[i].name = 'air'
				s.data[i].param1 = 000
			end
		end
	end

	s.yslice_prob = {}

	return s
end


function mod.translate_schematic(deco)
	if deco.deco_type ~= 'schematic' then
		return
	end

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
				if v.prob and v.prob > 127 then
					v.prob = v.prob - 128
				end
			end
		end
	else
		print('FAILed to translate schematic: ' .. deco.name)
		deco.bad_schem = true
	end

	return deco
end


do
	local found_it
	for k, v in pairs(minetest.registered_abms) do
		if v.label == 'Grass spread' then
			found_it = k
		end
	end

	if not found_it then
		minetest.log(mod_name .. ': Cannot locate (or correct) grass spread abm.')
	else
		table.remove(minetest.registered_abms, found_it)

		minetest.register_abm({
			label = 'Grass spread',
			nodenames = {'default:dirt'},
			neighbors = {
				'air',
				'group:grass',
				'group:dry_grass',
				'default:snow',
			},
			interval = 6,
			chance = 50,
			catch_up = false,
			action = function(pos, node_)
				-- Check for darkness: night, shadow or under a light-blocking node
				-- Returns if ignore above
				local above = {x = pos.x, y = pos.y + 1, z = pos.z}
				if (minetest.get_node_light(above) or 0) < 13 then
					return
				end

				-- Look for spreading dirt-type neighbours
				local p2 = minetest.find_node_near(pos, 1, 'group:spreading_dirt_type')
				if p2 then
					local n3 = minetest.get_node(p2)
					minetest.set_node(pos, {name = n3.name, param2 = n3.param2})
					return
				end

				-- Else, any seeding nodes on top?
				local name = minetest.get_node(above).name
				-- Snow check is cheapest, so comes first
				if name == 'default:snow' then
					minetest.set_node(pos, {name = 'default:dirt_with_snow'})
				-- Most likely case first
				elseif minetest.get_item_group(name, 'grass') ~= 0 then
					minetest.set_node(pos, {name = 'default:dirt_with_grass'})
				elseif minetest.get_item_group(name, 'dry_grass') ~= 0 then
					minetest.set_node(pos, {name = 'default:dirt_with_dry_grass'})
				end
			end
		})
	end
end



minetest.register_privilege('mapgen', {
	description = 'allowed to alter the landscape',
	give_to_singleplayer = true,
	give_to_admin = true,
})


--[[
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
			npos.x = math.floor(npos.x * 8 + 0.5)
			--npos.y = npos.y + 28800
			npos.y = math.floor((npos.y + 28400) * 8 + 0.5)
			npos.z = math.floor(npos.z * 8 + 0.5)
			player:set_pos(npos)
		else
			npos.x = math.floor(npos.x / 8 + 0.5)
			--npos.y = npos.y - 28800
			npos.y = math.floor((npos.y) / 8 + 0.5) - 28400 + 2
			npos.z = math.floor(npos.z / 8 + 0.5)
			player:set_pos(npos)
		end
	end,
})
--]]


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

		local chunksize = mod.chunksize
		local chunk_offset = mod.chunk_offset
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
				for _ = minp.x, maxp.x do
					data[ivm] = n_air
					p2data[ivm] = 0
					ivm = ivm + 1
				end
			end
		end

		vm:set_data(data)
		vm:set_param2_data(p2data)
		vm:write_to_map()

		local map_seed = mod.generate_map_seed()
		local blockseed = mod.generate_block_seed(minp)

		local params = {
			chunk_minp = minp,
			chunk_maxp = maxp,
			chunk_csize = vector.add(vector.subtract(maxp, minp), 1),
			chunk_seed = blockseed,
			genesis_redo = true,
			--real_chunk_seed = seed,
			map_seed = map_seed,
		}
		mod.generate_all(params)
	end,
})


do
	-- Catch any registered by other mods.
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


minetest.after(0, function()
	local options = {}
	-- 1 wood / stone
	-- 2 coal
	-- 3 iron
	-- 4 gold
	-- 5 diamond
	-- 6 mese
	--options['booty:flaming_sword']       =  {  1,  10,   nil   }
	--options['booty:philosophers_stone']  =  {  1,  10,  nil   }
	--options['booty:unobtainium']         =  {  1,  10,  nil   }
	options['bucket:bucket_empty']       =  {  1,  3,    2     }
	options['bucket:bucket_lava']      =  {  1,  5,   nil     }
	options['bucket:bucket_water']      =  {  1,  4,   nil     }
	options['carts:rail']      =  {  1,  4,   nil     }
	options['default:acacia_wood']       =  {  1,  1,    10    }
	options['default:apple']             =  {  1,  1,    10    }
	options['default:axe_diamond']      =  {  1,  6,   nil     }
	options['default:book']              =  {  1,  3,    10    }
	options['default:cactus']      =  {  1,  1,   5     }
	options['default:coal_lump']         =  {  1,  2,    10    }
	options['default:desert_cobble']      =  {  1,  1,   20     }
	options['default:desert_sand']      =  {  1,  1,   20     }
	options['default:diamond']           =  {  1,  5,   5     }
	options['default:dirt']      =  {  1,  1,   20     }
	options['default:flint']      =  {  1,  2,   5     }
	options['default:glass']             =  {  1,  3,    5     }
	options['default:gold_ingot']        =  {  1,  4,   5     }
	options['default:junglewood']        =  {  1,  1,    10    }
	options['default:mese']      =  {  1,  7,   5     }
	options['default:mese_crystal']      =  {  1,  6,   nil   }
	options['default:meselamp']          =  {  1,  7,   nil   }
	options['default:obsidian']          =  {  1,  6,   nil   }
	options['default:obsidian_glass']    =  {  1,  6,   5     }
	options['default:obsidian_shard']    =  {  1,  5,    nil   }
	options['default:paper']             =  {  1,  2,    10    }
	options['default:pick_diamond']      =  {  1,  6,   nil   }
	options['default:pick_mese']         =  {  1,  7,   nil   }
	options['default:pick_steel']      =  {  1,  4,   nil   }
	options['default:pick_stone']      =  {  1,  2,   nil   }
	options['default:pick_wood']      =  {  1,  1,   nil   }
	options['default:sand']      =  {  1,  1,   20     }
	options['default:steel_ingot']       =  {  1,  3,    5     }
	options['default:stick']      =  {  1,  1,   20     }
	options['default:sword_diamond']     =  {  1,  6,   nil   }
	options['default:sword_mese']        =  {  1,  7,   nil   }
	options['default:sword_steel']      =  {  1,  4,   nil   }
	options['default:sword_stone']      =  {  1,  2,   nil   }
	options['default:sword_wood']      =  {  1,  1,   nil   }
	options['default:wood']              =  {  1,  1,    10    }
	options['dinv:bag_large']             =  { 1, 5, nil }
	options['dinv:bag_medium']            =  { 1, 4, nil }
	options['dinv:bag_small']             =  { 1, 3, nil }
	options['dinv:boots']                 =  { 1, 3, nil }
	options['dinv:chain_armor']           =  { 1, 6, nil }
	options['dinv:fur_cloak']             =  { 1, 3, nil }
	options['dinv:leather_armor']         =  { 1, 4, nil }
	options['dinv:leather_cap']           =  { 1, 4, nil }
	options['dinv:plate_armor']           =  { 1, 8, nil }
	options['dinv:ring_breath']           =  { 1, 6, nil }
	options['dinv:ring_leap']             =  { 1, 5, nil }
	options['dinv:ring_protection_9']     =  { 1, 5, nil }
	options['dinv:steel_shield']          =  { 1, 5, nil }
	options['dinv:wood_shield']           =  { 1, 3, nil }
	options['dpies:apple_pie']           =  {  1,  3,   10    }
	options['dpies:blueberry_pie']        =  {  1,   3,   nil   }
	options['dpies:meat_pie']            =  {  1,  3,   10    }
	options['dpies:onion']               =  {  1,  1,    10    }
	options['farming:cotton']            =  {  1,  1,    10    }
	options['farming:flour']             =  {  1,  1,    10    }
	options['farming:seed_cotton']       =  {  1,  1,    10    }
	options['farming:seed_wheat']        =  {  1,  1,    10    }
	options['farming:string']      =  {  1,  2,   5     }
	options['farming:wheat']      =  {  1,  1,   20     }
	options['fire:permanent_flame']      =  {  1,  4,   nil   }
	options['fun_tools:flare_gun']        =  { 1, 4, nil }
	options['fun_tools:molotov_cocktail'] =  { 1, 4, 5 }
	options['fun_tools:naptha']           =  { 1, 3, 5 }
	options['mapgen:moon_glass']      =  {  1,  4,   5     }
	--options['mapgen:moon_juice']      =  {  1,  4,   5     }
	--options['mapgen:moonstone']       =  {  1,  5,   nil   }
	options['map:mapping_kit']            =  { 1, 4, nil }
	options['tnt:gunpowder']              =  { 1, 3, 10 }
	options['vessels:glass_fragments']      =  {  1,  2,   5     }
	options['wooden_bucket:bucket_wood_empty']       =  {  1,  3,    nil     }
	options['wool:white']                =  {  1,  1,    nil     }

	for name, d in pairs(options) do
		if minetest.registered_items[name] then
			local def = {
				level = d[1],
				rarity = d[2],
				name = name,
				number = {
					min = 1,
					max = d[3] or 1,
				},
			}
			mod.register_loot(def, true)
		end
	end

	for name, desc in pairs(minetest.registered_items) do
		if name:find('^wool:') then
			local def = {
				level = 1,
				rarity = 100,
				name = name,
				number = {
					min = 1,
					max = 10,
				},
			}
		end
	end
end)

do
	local orig_loot_reg = dungeon_loot.register
	dungeon_loot.register = function(def)
		if not def or def.chance <= 0 then
			return
		end

		mod.register_loot({
			name = def.name,
			rarity = math.ceil(1 / 2 / def.chance),
			level = def.level or 1,
			number = {
				min = def.count[1] or 1,
				max = def.count[2] or 1,
			},
		})

		orig_loot_reg(def)
	end
end
