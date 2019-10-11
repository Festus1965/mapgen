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
local ovg = 9


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
				table.insert(s.data, {
					param2 = 0,
					name = 'air',
					prob = 255,
				})
			end
		end
	end
	s.exits = {
		x = {true, true},
		y = {true, true},
		z = {true, true},
	}
	s.id = 'air'
	table.insert(schematics, s)

	s = table.copy(schematic_array)
	for z = 1, 9 do
		for y = 1, 9 do
			for x = 1, 9 do
				table.insert(s.data, {
					param2 = 0,
					name = 'default:stone',
					prob = 255,
				})
			end
		end
	end
	s.id = 'stone'
	table.insert(schematics, s)

	s = table.copy(schematic_array)
	for z = 1, 9 do
		for y = 1, 9 do
			for x = 1, 9 do
				local sub= 'default:stone'
				local p = VN(x, y, z)
				local d = vector.abs(vector.subtract(center, p))
				if (d.x < 2 and d.z < 2) or (d.y < 2 and d.z < 2) or (d.x < 2 and d.y < 2) then
					sub = 'air'
				end

				table.insert(s.data, {
					param2 = 0,
					name = sub,
					prob = 255,
				})
			end
		end
	end
	s.exits = {
		x = {true, true},
		y = {true, true},
		z = {true, true},
	}
	s.id = 'caltrop'
	table.insert(schematics, s)

	s = table.copy(schematic_array)
	for z = 1, 9 do
		for y = 1, 9 do
			for x = 1, 9 do
				local sub= 'default:stone'
				local p = VN(x, y, z)
				local d = vector.abs(vector.subtract(center, p))
				if (d.y < 2 and d.z < 2) or (d.x < 2 and d.y < 2) then
					sub = 'air'
				end

				table.insert(s.data, {
					param2 = 0,
					name = sub,
					prob = 255,
				})
			end
		end
	end
	s.exits = {
		x = {true, true},
		y = {false, false},
		z = {true, true},
	}
	s.id = 'cross'
	table.insert(schematics, s)

	s = table.copy(schematic_array)
	for z = 1, 9 do
		for y = 1, 9 do
			for x = 1, 9 do
				local sub= 'default:stone'
				local p = VN(x, y, z)
				local dp = vector.subtract(center, p)
				local d = vector.abs(dp)
				if (d.y < 2 and d.z < 2 and dp.x < 2) or (d.x < 2 and d.y < 2 and dp.z < 2) then
					sub = 'air'
				end

				table.insert(s.data, {
					param2 = 0,
					name = sub,
					prob = 255,
				})
			end
		end
	end
	s.exits = {
		x = {false, true},
		y = {false, false},
		z = {false, true},
	}
	s.id = 'L'
	table.insert(schematics, s)

	s = table.copy(schematic_array)
	for z = 1, 9 do
		for y = 1, 9 do
			for x = 1, 9 do
				local sub= 'default:stone'
				local p = VN(x, y, z)
				local dp = vector.subtract(center, p)
				local d = vector.abs(dp)
				if (d.y < 2 and d.z < 2) then
					sub = 'air'
				end

				table.insert(s.data, {
					param2 = 0,
					name = sub,
					prob = 255,
				})
			end
		end
	end
	s.exits = {
		x = {true, true},
		y = {false, false},
		z = {false, false},
	}
	s.id = 'straight'
	table.insert(schematics, s)

	s = table.copy(schematic_array)
	for z = 1, 9 do
		for y = 1, 9 do
			for x = 1, 9 do
				local sub= 'default:stone'
				local p = VN(x, y, z)
				local dp = vector.subtract(center, p)
				local d = vector.abs(dp)
				if (d.y < 2 and d.z < 2) or (d.x < 2 and d.y < 2 and dp.z < 2) then
					sub = 'air'
				end

				table.insert(s.data, {
					param2 = 0,
					name = sub,
					prob = 255,
				})
			end
		end
	end
	s.exits = {
		x = {true, true},
		y = {false, false},
		z = {false, true},
	}
	s.id = 'T'
	table.insert(schematics, s)

	s = table.copy(schematic_array)
	for z = 1, 9 do
		for y = 1, 9 do
			for x = 1, 9 do
				local sub= 'default:stone'
				local p = VN(x, y, z)
				local dp = vector.subtract(center, p)
				local d = vector.abs(dp)
				if (d.y < 2 and d.z < 3 and d.x < 3) or (d.y < 2 and d.x < 2 and dp.z < 2) then
					sub = 'air'
				end

				table.insert(s.data, {
					param2 = 0,
					name = sub,
					prob = 255,
				})
			end
		end
	end
	s.exits = {
		x = {false, false},
		y = {false, false},
		z = {false, true},
	}
	s.id = 'vault'
	table.insert(schematics, s)

	mod.rotate_schematics()
end


function mod.rotate_schematics()
	local news = {}
	for _, sch in pairs(schematics) do
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
				elseif drot == 2 then
					cop.exits.x = {
						sch.exits.x[2],
						sch.exits.x[1],
					}
					cop.exits.y = sch.exits.y
					cop.exits.z = {
						sch.exits.z[2],
						sch.exits.z[1],
					}
				elseif drot == 3 then
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
	local csize = params.csize
	local chunk = vector.floor(vector.divide(vector.add(minp, 32), 80))

	local tmin = maxp.y
	if params.share.height_min then
		tmin = params.share.height_min - 20
	end
	if tmin < minp.y then
		return
	end

	-- You really don't want cave biomes in geomoria...
	params.share.no_biome = true

	if params.disruptive then
		params.share.disruptive = true
	end

	if not schematics then
		schematics = {}
		mod.generate_schematics()
	end

	local nofill
	local water_level = params.sealevel

	--local box_seed = chunk.z * 10000 + chunk.y * 100 + chunk.x + 150
	--local bgpr = PcgRandom(box_seed)
	--local box_type = box_names[bgpr:next(1, #box_names)]
	--local box = layers_mod.registered_geomorphs[box_type]
	--local box = layers_mod.registered_geomorphs['lake_of_fire']

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
			end
		end
	end

	--[[
	if (loc.x + loc.z) % 11 == 0 then
		opt = 1
		ex = {
			x = {true, true},
			y = {false, false},
			z = {true, true},
		}
	else
		ex = {
			x = {false, false},
			y = {false, false},
			z = {true, true},
		}
	end
	--]]

	local ss = mod.match_exits(ex)

	if #ss < 1 then
		print('No exit!')
		print(dump(ex))
		print()
		return
	end

	local s = ss[math.random(#ss)]
	rot = s.rotate or 0
	--print(tot_exits, s.id, s.rotate)
	if loc.y > -100 and loc.y < -90 then
		layers_mod.place_schematic(params, s, loc, nil, ps, rot, 0)
	end

	--[[
	--print(dump(loc))
	for _, pa in pairs(cpoints) do
		local ivm = params.area:indexp(vector.add(vector.add(pa, loc), VN(0,4,0)))
		--print(dump(vector.add(pa, loc)))
		local hn = dung_noise:get_3d(vector.add(loc, pa))
		if hn > 0 then
			params.data[ivm] = layers_mod.node['default:meselamp']
		end
	end
	--print('++++++++++++++++++')
	--]]
end


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------

-- Define the noises.
layers_mod.register_noise( 'rooms_connections', { offset = 0, scale = 1, seed = 384, spread = {x = 9, y = 9, z = 9}, octaves = 6, persist = 0.5, lacunarity = 2.0} )

layers_mod.register_mapgen('tg_rooms', mod.generate_rooms, { full_chunk = true })
if layers_mod.register_spawn then
	--layers_mod.register_spawn('tg_rooms', mod.get_spawn_level)
end
