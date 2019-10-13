-- Duane's mapgen tg_rooms.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod, layers_mod = mapgen, mapgen
local mod_name = mod.mod_name
local max_height = 31000
local VN = vector.new


local node = layers_mod.node
local clone_node = layers_mod.clone_node
local schematics, carpetable, box_names, sides
local emergency_caltrop, gpr
local ovg = 8
local axes = {'x', 'y', 'z'}

local mob_names = {
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


--[[
do
	-- This special node handles traps and mob generation.
	-- The mob generation should be more efficient, since
	--  they only appear near players.
	-- About 75% of these blocks will be inert and untimed.
	-- This still means over 200 active timers per chunk...

	local n = layers_mod.clone_node('default:desert_stonebrick')

	n.on_construct = function(pos)
		local sr = math.random(50)
		local tm = minetest.get_node_timer(pos)
		local mt = minetest.get_meta(pos)
		local fun
		if not (tm and mt) then
			return
		end

		if sr < 5 then
		elseif sr < 10 then
		elseif sr < 50 then
			fun = 'summon'
			tm:set(180, math.random(90) + 90)
		end

		mt:set_string('fun', fun)
	end

	n.on_timer = function(pos, elapsed)
		local mt = minetest.get_meta(pos)
		if not mt then
			return true
		end
		local fun = mt:get_string('fun')

		if fun == 'pitfall' then
			-- nop
		elseif fun == 'summon' then
			if elapsed < 150 then
				--print('elapsed error:', elapsed)
				return true
			end

			local close
			for _, player in pairs(minetest.get_connected_players()) do
				local p = player:get_pos()
				local rd = vector.abs(vector.subtract(p, pos))
				if rd.x * rd.x + rd.z * rd.z + 5 * rd.y * rd.y < 2500 then
					close = true
				end
			end

			if not close then
				return true
			end

			local ct = 0
			local mob_count = 0
			for _, o in pairs(minetest.luaentities) do
				if vector.distance(o.object:get_pos(), pos) < 300 then
					ct = ct + 1
				end
				mob_count = mob_count + 1
			end

			if ct > 30 then
				return true
			end

			local p = table.copy(pos)
			p.y = p.y + 2
			local name = mob_names[math.random(#mob_names)]
			minetest.add_entity(p, name)

			return true
		end
	end
	n.drop = 'default:desert_stonebrick'

	minetest.register_node(mod_name .. ':fun_brick', n)
	layers_mod.add_construct(mod_name .. ':fun_brick')
end

do
	local n = layers_mod.clone_node('default:desert_stonebrick')
	n.walkable = false
	minetest.register_node(mod_name .. ':false_brick', n)
end
--]]


function mod.generate_rooms(params)
	if params.share.disruptive then
		return
	end

	local minp, maxp = params.isect_minp, params.isect_maxp
	local data, p2data, area = params.data, params.p2data, params.area
	local node = layers_mod.node
	local n_air = node['air']

	params.share.treasure_chest_handler = mod.handle_chest
	gpr = params.gpr  -- handy for treasure function

	local tmin = maxp.y
	if params.share.height_min then
		tmin = params.share.height_min - 20
	end
	tmin = math.floor(tmin / 9) * 9
	if tmin < minp.y then
		return
	end

	for z = minp.z, maxp.z do
		for y = minp.y, math.min(maxp.y, tmin) do
			local ivm = area:index(minp.x, y, z)
			for x = minp.x, maxp.x do
				data[ivm] = n_air
				p2data[ivm] = 0
				ivm = ivm + 1
			end
		end
	end

	-- You really don't want cave biomes here...
	params.share.no_biome = true
	params.share.propagate_shadow = true

	if params.disruptive then
		params.share.disruptive = true
	end

	if not schematics then
		schematics = {}
		mod.room_schematics = schematics
		mod.generate_schematics()
	end

	for z = minp.z - ovg, maxp.z + ovg do
		if z % 9 == 0 then
			for y = minp.y - ovg, maxp.y + ovg do
				if y % 9 == 0 and y + 9 < tmin then
					for x = minp.x - ovg, maxp.x + ovg do
						if x % 9 == 0 then
							mod.place_geo(params, VN(x, y, z))
						end
					end
				end
			end
		end
	end
end


function mod.generate_schematics()
	local s
	local center = VN(5, 5, 5)
	local schematic_array = {
		yslice_prob = nil,
		data = {},
		size = vector.new(9, 9, 9),
		exits = {
			x = {false, false},
			y = {false, false},
			z = {false, false},
		},
		rotate = 0,
	}

	s = table.copy(schematic_array)
	for z = 1, 9 do
		for y = 1, 9 do
			for x = 1, 9 do
				if x == 1 or x == 9 or y == 1 or y == 9 or z == 1 or z == 9 then
					table.insert(s.data, {
						param2 = 0,
						name = 'default:desert_stonebrick',
						prob = 255,
					})
				else
					table.insert(s.data, {
						param2 = 0,
						name = 'default:stone',
						prob = 255,
					})
				end
			end
		end
	end
	s.id = 'stone'
	table.insert(schematics, s)

	dofile(mod.path .. '/df01.room')
	dofile(mod.path .. '/df02.room')
	dofile(mod.path .. '/df03.room')
	dofile(mod.path .. '/df04.room')
	dofile(mod.path .. '/df05.room')
	dofile(mod.path .. '/df06.room')
	emergency_caltrop = schematics[#schematics]
	dofile(mod.path .. '/df07.room')
	dofile(mod.path .. '/df08.room')

	mod.rotate_schematics()
end


function mod.handle_chest(pos)
	local meta = minetest.get_meta(pos)
	local sr = gpr:next(1, 1000)

	if sr < 25 then
		meta:set_int('mapgen_pitfall', 6)
	else
		local inv = meta:get_inventory()
		local invsz = inv:get_size("main")
		if invsz > 0 then
			layers_mod.populate_chest(pos, gpr)
		end
	end
end


function mod.match_exits(e)
	local out = {}

	for _, s in pairs(schematics) do
		local good = true

		for _, axis in pairs(axes) do
			for i = 1, 2 do
				if e[axis][i] ~= s.exits[axis][i] then
					good = false
				end
			end
		end

		if good then
			table.insert(out, s)
		end
	end

	return out
end


-- These are the points around the current room
--  to check noise, to determine available exits.
-- Only do this horizontally -- noise-based stairs
--  are unreliable and get bizarre sometimes.
local cpoints = {
	{ VN(4, 0, 0), 'z', 1, },
	{ VN(4, 0, 9), 'z', 2, },
	{ VN(0, 0, 4), 'x', 1, },
	{ VN(9, 0, 4), 'x', 2, },
}
local stair_dist = 7 * 9
function mod.place_geo(params, loc)
	local rot = 0
	local ps = params.gpr
	local dung_noise = PerlinNoise(layers_mod.registered_noises['rooms_connections'])
	local data, p2data, area = params.data, params.p2data, params.area

	-- Todo: make this a bit more random.
	local ex_up = (loc.x % stair_dist == 0 and loc.z % stair_dist == 0)
	local ex_down = (loc.x % stair_dist == 0 and loc.z % stair_dist == 0)
	local ex = {
		x = {false, false},
		y = {ex_down, ex_up},
		z = {false, false},
	}

	local tot_exits = 0
	for _, cset in pairs(cpoints) do
		local pa, caxis, cdir = cset[1], cset[2], cset[3]
		local hn = dung_noise:get_3d(vector.add(loc, pa))
		if hn > 0 then
			ex[caxis][cdir] = true
			tot_exits = tot_exits + 1
		end
	end

	local ss = mod.match_exits(ex)

	if #ss < 1 then
		--print('No exit!')
		--print(dump(ex))
		--print()
		ss = {emergency_caltrop}
	end

	-- Try to make the room choice repeatable.
	local hran = minetest.hash_node_position(loc) + 3706
	math.randomseed(hran)
	local s = ss[math.random(1, #ss)]
	rot = s.rotate or 0

	----------------------------------------
	-- This is extremely slow, but the game function
	--  ignores param2...
	layers_mod.place_schematic(params, s, loc, nil, ps, rot, 0)
	----------------------------------------

	if not (ex.y[1] or ex.y[2]) then
		if s.id == 'vault' then
			if not params.share.treasure_chests then
				params.share.treasure_chests = {}
			end

			if math.random(math.max(2, 5 - #ss)) == 1 then
				local p = vector.add(loc, VN(4, 1, 4))
				local ivm = area:indexp(p)
				data[ivm] = layers_mod.node['default:chest']
				table.insert(params.share.treasure_chests, p)
			end
		end
	end
end


function mod.rotate_schematics()
	local news = {}
	for _, sch in pairs(schematics) do
		local sym
		if sch.exits.x[1] and sch.exits.x[2] and sch.exits.z[1] and sch.exits.z[2] then
			sym = 'r'
		end
		if (sch.exits.x[1] and sch.exits.x[2]) and not (sch.exits.z[1] or sch.exits.z[2])
		or not (sch.exits.x[1] or sch.exits.x[2]) and (sch.exits.z[1] and sch.exits.z[2]) then
			sym = 'b'
		end

		if sym ~= 'r' then
			for rot = 0, 3 do
				if sch.rotate ~= rot then
					local cop = {}
					for k in pairs(sch) do
						cop[k] = sch[k]
					end
					cop.rotate = rot
					cop.exits = {}

					local drot = (rot - sch.rotate) % 4
					if drot == 1 then
						cop.exits.x = {
							sch.exits.z[2],
							sch.exits.z[1],
						}
						cop.exits.y = sch.exits.y
						cop.exits.z = sch.exits.x
					elseif drot == 2 and sym ~= 'b' then
						cop.exits.x = {
							sch.exits.x[2],
							sch.exits.x[1],
						}
						cop.exits.y = sch.exits.y
						cop.exits.z = {
							sch.exits.z[2],
							sch.exits.z[1],
						}
					elseif drot == 3 and sym ~= 'b' then
						cop.exits.x = sch.exits.z
						cop.exits.y = sch.exits.y
						cop.exits.z = {
							sch.exits.x[2],
							sch.exits.x[1],
						}
					end

					table.insert(news, cop)
				end
			end
		end
	end

	for _, sch in pairs(news) do
		table.insert(schematics, sch)
	end
end


minetest.register_chatcommand('clearroom', {
	description = 'save the room you\'re in as a schematic file',
	--privs = {privs=true}, -- Require the 'privs' privilege to run
	func = function(name, param)
		local pos = minetest.get_player_by_name(name):getpos()
		local loc = vector.multiply(vector.floor(vector.divide(pos, 9)), 9)
		local p2 = vector.add(loc, 8)
		local vm = minetest.get_voxel_manip()
		local emin, emax = vm:read_from_map(loc, p2)
		local data = vm:get_data()
		local p2data = vm:get_param2_data()
		local a = VoxelArea:new({MinEdge = emin, MaxEdge = emax})

		for z = loc.z, p2.z do
			for y = loc.y, p2.y do
				local ivm = a:index(loc.x, y, z)
				for x = loc.x, p2.x do
					data[ivm] = layers_mod.node['air']
					p2data[ivm] = 0

					ivm = ivm + 1
				end
			end
		end

		vm:set_data(data)
		vm:set_param2_data(p2data)
		vm:write_to_map()
	end,
})


minetest.register_chatcommand('saveroom', {
	params = '[filename]',
	description = 'save the room you\'re in as a schematic file',
	--privs = {privs=true}, -- Require the 'privs' privilege to run
	func = function(name, param)
		local in_filename = param
		if not in_filename or in_filename == '' or string.find(in_filename, '[^%a%d_]') then
			print(mod_name .. ': Specify a simple filename containing digits and letters. The suffix will be added automatically. Paths are not allowed.')
			return
		end

		local filename = mod.world .. '/' .. in_filename .. '.room'
		local pos = minetest.get_player_by_name(name):getpos()
		local loc = vector.multiply(vector.floor(vector.divide(pos, 9)), 9)
		local p2 = vector.add(loc, 8)
		local vm = minetest.get_voxel_manip()
		local emin, emax = vm:read_from_map(loc, p2)
		local data = vm:get_data()
		local p2data = vm:get_param2_data()
		local a = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
		local schem = {
			size = vector.add(vector.subtract(p2, loc), 1),
			exits = {
				x = {false, false},
				y = {false, false},
				z = {false, false},
			},
			rotate = 0,
			id = in_filename,
		}
		schem.data = {}
		for z = loc.z, p2.z do
			for y = loc.y, p2.y do
				local ivm = a:index(loc.x, y, z)
				for x = loc.x, p2.x do
					local node = {}
					node.name = minetest.get_name_from_content_id(data[ivm])
					--if node.name == 'air' then
					--	node.prob = 0
					--end
					if p2data[ivm] ~= 0 then
						node.param2 = p2data[ivm]
					end
					schem.data[#schem.data+1] = node

					ivm = ivm + 1
				end
			end
		end

		local file = io.open(filename, 'wb')
		if file then
			local data = minetest.serialize(schem)
			data = data:gsub('%}, ', '},\n')
			data = data:gsub('return', 'local s = ')
			data = 'local mod = mapgen\n' .. data .. '\ntable.insert(mod.room_schematics, s)'
			--data = minetest.compress(data)
			file:write(data)
			file:close()
		end
		print(mod_name .. ' saved a schematic to \''..filename..'\'')
	end,
})


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------

-- Define the noises.
layers_mod.register_noise( 'rooms_connections', { offset = 0, scale = 1, seed = 384, spread = {x = 9, y = 9, z = 9}, octaves = 6, persist = 0.5, lacunarity = 2.0} )

layers_mod.register_mapgen('tg_rooms', mod.generate_rooms, { full_chunk = true })
if layers_mod.register_spawn then
	--layers_mod.register_spawn('tg_rooms', mod.get_spawn_level)
end
