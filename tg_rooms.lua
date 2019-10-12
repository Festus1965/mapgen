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
local emergency_caltrop
local ovg = 8


local axes = {'x', 'y', 'z'}
function vector.abs(a)
	local b = table.copy(a)
	for _, axis in pairs(axes) do
		if b[axis] < 0 then
			b[axis] = - b[axis]
		end
	end

	return b
end
--[[
local a = vector.abs(VN(-1, -1.5, 3))
assert(a.x == 1)
assert(a.y == 1.5)
assert(a.z == 3)
--]]


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

	--[[
	print('match_exits:')
	print(dump(e))
	for _, s in pairs(out) do
		print(s.id, s.rotate)
		print(dump(s.exits))
	end
	print('--------------------')
	--]]

	return out
end


function mod.generate_rooms(params)
	if params.share.disruptive then
		return
	end

	local minp, maxp = params.isect_minp, params.isect_maxp

	local tmin = maxp.y
	if params.share.height_min then
		tmin = params.share.height_min - 20
	end
	tmin = math.floor(tmin / 9) * 9
	if tmin < minp.y then
		return
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


local cpoints = {
	VN(4, 0, 9),
	VN(4, 0, 0),
	VN(0, 0, 4),
	VN(9, 0, 4),
	VN(4, 0, 4),
	VN(4, 9, 4),
}
function mod.place_geo(params, loc)
	local rot = 0
	local ps = params.gpr
	local dung_noise = PerlinNoise(layers_mod.registered_noises['rooms_connections'])

	local ex = {
		x = {false, false},
		y = {false, false},
		z = {false, false},
	}

	local tot_exits = 0
	for _, pa in pairs(cpoints) do
		local hn = dung_noise:get_3d(vector.add(loc, pa))
		if hn > 0 then
			if pa.x == 9 then
				ex.x[2] = true
				tot_exits = tot_exits + 1
			elseif pa.x == 0 then
				ex.x[1] = true
				tot_exits = tot_exits + 1
			elseif pa.z == 9 then
				ex.z[2] = true
				tot_exits = tot_exits + 1
			elseif pa.z == 0 then
				ex.z[1] = true
				tot_exits = tot_exits + 1
			elseif hn > 0.75 and pa.y == 0 then
				ex.y[1] = true
				tot_exits = tot_exits + 1
			elseif hn > 0.75 and pa.y == 9 then
				ex.y[2] = true
				tot_exits = tot_exits + 1
			end
		end
	end

	local ss = mod.match_exits(ex)

	if #ss < 1 then
		print('No exit!')
		print(dump(ex))
		print()

		ss = {emergency_caltrop}
	end

	local s = ss[ps:next(1, #ss)]
	rot = s.rotate or 0
	layers_mod.place_schematic(params, s, loc, nil, ps, rot, 0)
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
