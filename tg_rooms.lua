-- Duane's mapgen tg_rooms.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


-- functions attached


local mod, layers_mod = mapgen, mapgen
local mod_name = mod.mod_name
local max_height = 31000
local VN = vector.new


local RES = 10
local HRES = math.ceil(RES / 2)

local node = layers_mod.node
local clone_node = layers_mod.clone_node
local big_rooms, small_rooms, carpetable
local emergency_caltrop, gpr
local ovg = (80 % RES == 0) and 0 or (RES - 1)
local axes = {'x', 'y', 'z'}

-- These are the points around the current room
--  to check noise, to determine available exits.
-- Only do this horizontally -- noise-based stairs
--  are unreliable and get bizarre sometimes.
local cpoints = {
	{ VN(HRES, 0, 0), 'z', 1, },
	{ VN(HRES, 0, RES), 'z', 2, },
	{ VN(0, 0, HRES), 'x', 1, },
	{ VN(RES, 0, HRES), 'x', 2, },
}
local stair_dist = 7 * RES


dofile(mod.path .. '/dungeon_stuff.lua')


do
	local newnode
	newnode = layers_mod.clone_node('default:lava_source')
	newnode.description = 'Lava'
	newnode.drop = 'default:lava_source'
	newnode.sunlight_propagates = true
	newnode.liquid_range = 0
	newnode.liquid_viscosity = 1
	newnode.liquid_renewable = false
	newnode.liquid_alternative_flowing = mod_name..':weightless_lava'
	newnode.liquid_alternative_source = mod_name..':weightless_lava'
	minetest.register_node(mod_name..':weightless_lava', newnode)

	newnode = layers_mod.clone_node('air')
	newnode.light_source = 14
	minetest.register_node(mod_name..':glow_air', newnode)
end


--[[
do
	local n = layers_mod.clone_node('default:desert_stonebrick')
	n.walkable = false
	minetest.register_node(mod_name .. ':false_brick', n)
end
--]]


function mod.generate_big_rooms()
	local dsb = 'default:stonebrick'
	local ddsb = 'default:desert_stonebrick'
	local dssb = 'default:sandstonebrick'
	local sssb = 'stairs:stair_stonebrick'

	local b
	local center = VN(20, 20, 20)
	local desc = {
		data = {},
		size = vector.new(40, 40, 40),
		rotate = 0,
	}

	do
		-- Big Empty
		b = table.copy(desc)
		table.insert(b.data, {
			action = 'cube',
			node = 'default:stone',
			location = VN(0, 0, 0),
			size = VN(40, 10, 40),
		})
		table.insert(b.data, {
			action = 'cube',
			node = ddsb,
			location = VN(0, 10, 0),
			size = VN(40, 1, 40),
		})
		for y = 20, 30, 10 do
			table.insert(b.data, {
				action = 'cube',
				node = ddsb,
				location = VN(0, y, 0),
				size = VN(40, 1, 40),
			})
			table.insert(b.data, {
				action = 'cube',
				node = 'air',
				location = VN(5, y, 5),
				size = VN(30, 1, 30),
			})
		end
		b.id = 'big_empty'
		table.insert(big_rooms, b)
	end

	do
		-- Open Sky
		b = table.copy(desc)
		table.insert(b.data, {
			action = 'cube',
			node = 'default:dirt',
			location = VN(0, 0, 0),
			size = VN(40, 10, 40),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:steelblock',
			location = VN(0, 39, 0),
			size = VN(40, 1, 40),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:meselamp',
			location = VN(0, 39, 0),
			random = 100,
			size = VN(40, 1, 40),
		})
		for y = 10, 30, 10 do
			table.insert(b.data, {
				action = 'cube',
				node = ddsb,
				location = VN(0, y, 0),
				size = VN(40, 1, 40),
			})
			if y == 10 then
				table.insert(b.data, {
					action = 'cube',
					node = 'default:dirt_with_grass',
					location = VN(5, y, 5),
					size = VN(30, 1, 30),
				})
			else
				table.insert(b.data, {
					action = 'cube',
					node = 'air',
					location = VN(5, y, 5),
					size = VN(30, 1, 30),
				})
			end
		end
		-- big tree
		do
			table.insert(b.data, {
				action = 'sphere',
				node = mod_name .. ':tree_oak',
				intersect = 'air',
				location = VN(12, 8, 12),
				random = 40,
				size = VN(16, 16, 16),
			})
			table.insert(b.data, {
				action = 'sphere',
				node = mod_name .. ':leaves_oak',
				intersect = 'air',
				location = VN(10, 5, 10),
				random = 2,
				size = VN(20, 20, 20),
			})
			table.insert(b.data, {
				action = 'cube',
				node = 'air',
				intersect = mod_name .. ':leaves_oak',
				location = VN(10, 5, 10),
				size = VN(20, 9, 20),
			})
			table.insert(b.data, {
				action = 'cube',
				node = 'air',
				intersect = mod_name .. ':tree_oak',
				location = VN(10, 5, 10),
				size = VN(20, 9, 20),
			})
			table.insert(b.data, {
				action = 'cube',
				node = 'air',
				intersect = mod_name .. ':leaves_oak',
				location = VN(10, 14, 10),
				random = 2,
				size = VN(20, 1, 20),
			})
			table.insert(b.data, {
				action = 'cube',
				node = mod_name .. ':tree_oak',
				location = VN(18, 10, 19),
				size = VN(4, 11, 2),
			})
			table.insert(b.data, {
				action = 'cube',
				node = mod_name .. ':tree_oak',
				location = VN(19, 10, 18),
				size = VN(2, 11, 4),
			})
		end
		for i = 1, 5 do
			table.insert(b.data, {
				action = 'cube',
				node = 'default:grass_' .. i,
				intersect = 'air',
				location = VN(5, 11, 5),
				random = 30 + i * 20,
				size = VN(30, 1, 30),
			})
		end
		table.insert(b.data, {
			action = 'cube',
			node = mod_name .. ':glow_air',
			intersect = 'air',
			location = VN(5, 12, 5),
			random = 25,
			size = VN(30, 26, 30),
		})
		b.id = 'open_sky'
		table.insert(big_rooms, b)
	end

	do
		-- Bridgeworks
		-- add supports?
		b = table.copy(desc)
		table.insert(b.data, {
			action = 'cube',
			node = dsb,
			location = VN(0, 0, 0),
			size = VN(40, 8, 40),
		})
		table.insert(b.data, {
			action = 'cube',
			node = mod_name .. ':sand_gem_glass',
			location = VN(0, 0, 0),
			random = 20,
			size = VN(40, 1, 40),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:water_source',
			location = VN(1, 1, 1),
			size = VN(38, 7, 38),
		})
		for y = 10, 30, 10 do
			local tmp = {}

			table.insert(tmp, {
				action = 'cube',
				node = ddsb,
				location = VN(0, y, 10),
				size = VN(3, 1, 20),
			})
			table.insert(tmp, {
				action = 'cube',
				node = ddsb,
				location = VN(37, y, 10),
				size = VN(3, 1, 20),
			})

			for x = 10, 20, 10 do
				for z = 0, 39, 39 do
					table.insert(tmp, {
						action = 'cube',
						node = dsb,
						location = VN(x, y, z),
						size = VN(10, 10, 1),
					})
				end
				table.insert(tmp, {
					action = 'cube',
					node = dsb,
					location = VN(x + 2, y, 0),
					size = VN(6, 8, 40),
				})
				table.insert(tmp, {
					action = 'cube',
					node = dsb,
					location = VN(x + 2, y + 1, 0),
					size = VN(6, 6, 40),
				})
				table.insert(tmp, {
					action = 'cube',
					node = 'air',
					location = VN(x + 3, y + 1, 0),
					size = VN(4, 7, 40),
				})
				for z = 3, 36, 3 do
					table.insert(tmp, {
						action = 'cube',
						node = 'default:torch_ceiling',
						location = VN(x + 4, y - 1, z),
						random = 3,
						size = VN(1, 1, 1),
					})
					table.insert(tmp, {
						action = 'cube',
						node = 'air',
						location = VN(x + 2, y + 1, z),
						size = VN(6, 6, 2),
					})
					if x == 10 then
						table.insert(tmp, {
							action = 'cube',
							node = 'default:torch_wall',
							location = VN(x + 3, y + 4, z + 2),
							param2 = 3,
							random = 2,
							size = VN(1, 1, 1),
						})
					elseif x == 20 then
						table.insert(tmp, {
							action = 'cube',
							node = 'default:torch_wall',
							location = VN(x + 6, y + 4, z + 2),
							param2 = 2,
							random = 2,
							size = VN(1, 1, 1),
						})
					end
					for x2 = 2, 7, 5 do
						table.insert(tmp, {
							action = 'cube',
							node = sssb,
							location = VN(x + x2, y + 1, z),
							param2 = 2,
							size = VN(1, 1, 1),
						})
						table.insert(tmp, {
							action = 'cube',
							node = sssb,
							location = VN(x + x2, y + 1, z + 1),
							param2 = 0,
							size = VN(1, 1, 1),
						})
						table.insert(tmp, {
							action = 'cube',
							node = sssb,
							location = VN(x + x2, y + 6, z),
							param2 = 22,
							size = VN(1, 1, 1),
						})
						table.insert(tmp, {
							action = 'cube',
							node = sssb,
							location = VN(x + x2, y + 6, z + 1),
							param2 = 20,
							size = VN(1, 1, 1),
						})
					end
				end
			end

			if y == 20 then
				for _, it in pairs(tmp) do
					it.size = {x = it.size.z, y = it.size.y, z = it.size.x}
					it.location = {x = it.location.z, y = it.location.y, z = it.location.x}
					if it.param2 then
						if it.node == 'default:torch_wall' then
							it.param2 = it.param2 + 2
						else
							if it.param2 == 20 then
								it.param2 = 23
							elseif it.param2 == 22 then
								it.param2 = 21
							else
								it.param2 = it.param2 + 1
							end
						end
					end
				end
			end

			for _, it in pairs(tmp) do
				table.insert(b.data, it)
			end
		end
		b.id = 'bridgeworks'
		table.insert(big_rooms, b)
	end

	do
		-- Fire God
		b = table.copy(desc)
		table.insert(b.data, {
			action = 'cube',
			node = 'default:obsidian',
			location = VN(0, 0, 0),
			size = VN(40, 11, 40),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:lava_source',
			location = VN(1, 1, 1),
			size = VN(38, 10, 38),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:obsidian',
			location = VN(RES + HRES - 1, 10, 1),
			random = 2,
			size = VN(2, 1, 38),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:obsidian',
			location = VN(2 * RES + HRES - 1, 10, 1),
			random = 2,
			size = VN(2, 1, 38),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:obsidian',
			location = VN(1, 10, RES + HRES - 1),
			random = 2,
			size = VN(38, 1, 2),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:obsidian',
			location = VN(1, 10, 2 * RES + HRES - 1),
			random = 2,
			size = VN(38, 1, 2),
		})
		table.insert(b.data, {
			action = 'cylinder',
			axis = 'y',
			node = 'default:obsidian',
			location = VN(11, 10, 11),
			size = VN(18, 1, 18),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:obsidian',
			location = VN(17, 24, 21),
			size = VN(6, 6, 6),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:steelblock',
			location = VN(17, 24, 21),
			size = VN(6, 5, 5),
		})
		table.insert(b.data, {
			action = 'cube',
			node = mod_name .. ':weightless_lava',
			location = VN(17, 27, 21),
			size = VN(2, 1, 1),
		})
		table.insert(b.data, {
			action = 'cube',
			node = mod_name .. ':weightless_lava',
			location = VN(21, 27, 21),
			size = VN(2, 1, 1),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:obsidian',
			location = VN(14, 20, 22),
			size = VN(12, 4, 4),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:steelblock',
			location = VN(14, 15, 22),
			size = VN(3, 5, 4),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:steelblock',
			location = VN(23, 15, 22),
			size = VN(3, 5, 4),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:steelblock',
			location = VN(14, 15, 16),
			size = VN(3, 3, 7),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:steelblock',
			location = VN(23, 15, 16),
			size = VN(3, 3, 7),
		})
		table.insert(b.data, {
			action = 'cube',
			node = 'default:obsidian',
			location = VN(17, 10, 22),
			size = VN(6, 14, 4),
		})
		table.insert(b.data, {
			action = 'sphere',
			node = mod_name .. ':weightless_lava',
			location = VN(16, 15, 10),
			size = VN(6, 6, 6),
		})
		b.id = 'fire_god'
		b.rare = true
		table.insert(big_rooms, b)
	end
end


function mod.generate_rooms(params)
	if params.share.disruptive then
		return
	end

	local minp, maxp = params.isect_minp, params.isect_maxp
	local data, p2data, area = params.data, params.p2data, params.area
	local node = layers_mod.node
	local chunk_offset = layers_mod.chunk_offset
	local n_air = node['air']
	local nofill

	params.share.treasure_chest_handler = mod.handle_chest
	gpr = params.gpr  -- handy for treasure function

	if not mod.carpetable then
		mod.setup_dungeon_decor(params)
	end

	local max_y = math.floor((params.realm_maxp.y - ovg) / RES) * RES
	if params.share.height_min then
		max_y = math.min(max_y, math.floor((params.share.height_min - ovg) / RES) * RES)
	end
	max_y = math.min(maxp.y + ovg, max_y)

	for z = minp.z, maxp.z do
		for y = minp.y, max_y + ovg do
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

	if not small_rooms then
		small_rooms = {}
		mod.generate_small_rooms()
		mod.room_small_rooms = small_rooms
	end

	if not big_rooms then
		big_rooms = {}
		mod.room_big_rooms = big_rooms
		mod.generate_big_rooms()
	end

	local big = mod.big_room_here(params)

	for z = minp.z - ovg, maxp.z + ovg do
		if (z + chunk_offset) % RES == 0 then
			for y = minp.y - ovg, max_y + ovg do
				if (y + chunk_offset) % RES == 0 then
					for x = minp.x - ovg, maxp.x + ovg do
						if (x + chunk_offset) % RES == 0 then
							mod.place_small_room(params, VN(x, y, z), big)
						end
					end
				end
			end
		end
	end

	if big then
		mod.place_big_room(params)
	end

	if not nofill then
		mod.dungeon_decor(params, { no_doors = true, no_stains = true })
	end
end


function mod.big_room_here(params)
	local dung_noise = PerlinNoise(layers_mod.registered_noises['rooms_connections'])
	local minp = params.isect_minp
	local t = 0
	for z = 20, 60, 10 do
		for y = 20, 60, 10 do
			for x = 20, 60, 10 do
				local loc = vector.add(minp, VN(x, y, z), 5)
				local hn = dung_noise:get_3d(loc)
				t = t + hn
			end
		end
	end
	if t <= 0 then
		return true
	end
end


function mod.generate_small_rooms()
	local d
	local center = VN(HRES, HRES, HRES)
	local desc = {
		data = {},
		size = vector.new(RES, RES, RES),
		exits = {
			x = {false, false},
			y = {false, false},
			z = {false, false},
		},
		rotate = 0,
	}

	for _, per in pairs({
		{0,0,0,0}, {0,0,0,1}, {0,0,1,0}, {0,0,1,1},
		{0,1,0,0}, {0,1,0,1}, {0,1,1,0}, {0,1,1,1},
		{1,0,0,0}, {1,0,0,1}, {1,0,1,0}, {1,0,1,1},
		{1,1,0,0}, {1,1,0,1}, {1,1,1,0}, {1,1,1,1},
	}) do
		d = table.copy(desc)
		d.exits = {
			x = { per[1] == 1, per[2] == 1, },
			y = { false, false, },
			z = { per[3] == 1, per[4] == 1, },
		}

		table.insert(d.data, {
			action = 'cube',
			node = 'default:desert_stonebrick',
			location = VN(0, 0, 0),
			size = VN(RES, RES, RES),
		})
		table.insert(d.data, {
			action = 'cube',
			node = 'air',
			location = VN(1, 1, 1),
			size = VN(RES - 2, RES - 2, RES - 2),
		})
		if d.exits['x'][1] then
			table.insert(d.data, {
				action = 'cube',
				node = 'air',
				location = VN(0, 1, 1),
				size = VN(1, RES - 2, RES - 2),
			})
		end
		if d.exits['x'][2] then
			table.insert(d.data, {
				action = 'cube',
				node = 'air',
				location = VN(RES - 1, 1, 1),
				size = VN(1, RES - 2, RES - 2),
			})
		end
		if d.exits['z'][1] then
			table.insert(d.data, {
				action = 'cube',
				node = 'air',
				location = VN(1, 1, 0),
				size = VN(RES - 2, RES - 2, 1),
			})
		end
		if d.exits['z'][2] then
			table.insert(d.data, {
				action = 'cube',
				node = 'air',
				location = VN(1, 1, RES - 1),
				size = VN(RES - 2, RES - 2, 1),
			})
		end

		for y = 1, RES - 2, RES - 3 do
			table.insert(d.data, {
				action = 'cube',
				node = 'default:stonebrick',
				intersect = 'air',
				location = VN(0, y, 0),
				size = VN(RES, 1, RES),
			})
			table.insert(d.data, {
				action = 'cube',
				node = 'air',
				location = VN(2, y, 2),
				size = VN(RES - 4, 1, RES - 4),
			})
			if d.exits['x'][1] then
				table.insert(d.data, {
					action = 'cube',
					node = 'air',
					location = VN(0, y, 2),
					size = VN(2, 1, RES - 4),
				})
			end
			if d.exits['x'][2] then
				table.insert(d.data, {
					action = 'cube',
					node = 'air',
					location = VN(RES - 2, y, 2),
					size = VN(2, 1, RES - 4),
				})
			end
			if d.exits['z'][1] then
				table.insert(d.data, {
					action = 'cube',
					node = 'air',
					location = VN(2, y, 0),
					size = VN(RES - 4, 1, 2),
				})
			end
			if d.exits['z'][2] then
				table.insert(d.data, {
					action = 'cube',
					node = 'air',
					location = VN(2, y, RES - 2),
					size = VN(RES - 4, 1, 2),
				})
			end
		end

		table.insert(d.data, {
			action = 'cube',
			node = 'stairs:slab_stonebrick',
			intersect = 'air',
			location = VN(0, RES - 2, 0),
			param2 = 20,
			size = VN(RES, 1, RES),
		})
		table.insert(d.data, {
			action = 'cube',
			node = 'air',
			location = VN(3, RES - 2, 3),
			size = VN(RES - 6, 1, RES - 6),
		})
		if d.exits['x'][1] then
			table.insert(d.data, {
				action = 'cube',
				node = 'air',
				location = VN(0, RES - 2, 3),
				size = VN(3, 1, RES - 6),
			})
		end
		if d.exits['x'][2] then
			table.insert(d.data, {
				action = 'cube',
				node = 'air',
				location = VN(RES - 3, RES - 2, 3),
				size = VN(3, 1, RES - 6),
			})
		end
		if d.exits['z'][1] then
			table.insert(d.data, {
				action = 'cube',
				node = 'air',
				location = VN(3, RES - 2, 0),
				size = VN(RES - 6, 1, 3),
			})
		end
		if d.exits['z'][2] then
			table.insert(d.data, {
				action = 'cube',
				node = 'air',
				location = VN(3, RES - 2, RES - 3),
				size = VN(RES - 6, 1, 3),
			})
		end

		for _, p in pairs({
			{ VN(0, HRES - 1, 1), 5 },
			{ VN(1, HRES - 1, 0), 3 },
			{ VN(RES - 2, HRES - 1, 0), 2 },
			{ VN(RES - 1, HRES - 1, 1), 5 },
			{ VN(0, HRES - 1, RES - 2), 4 },
			{ VN(1, HRES - 1, RES - 1), 3 },
			{ VN(RES - 1, HRES - 1, RES - 2), 4 },
			{ VN(RES - 2, HRES - 1, RES - 1), 2 },
		}) do
			table.insert(d.data, {
				action = 'cube',
				node = 'default:torch_wall',
				intersect = 'air',
				location = p[1],
				param2 = p[2],
				random = 2,
				size = VN(1, 1, 1),
			})
		end

		local te = 0
		for _, e in pairs(per) do
			if e == 1 then
				te = te + 1
			end
		end

		if te < 2 then
			table.insert(d.data, {
				action = 'cube',
				node = 'default:chest',
				intersect = 'air',
				location = VN(HRES, 1, HRES),
				random = 2,
				size = VN(1, 1, 1),
			})

			if d.exits['x'][1] then
				table.insert(d.data, {
					action = 'cube',
					node = 'default:desert_stonebrick',
					location = VN(0, 1, 1),
					size = VN(1, RES - 2, RES - 2),
				})
				table.insert(d.data, {
					action = 'cube',
					node = 'air',
					location = VN(0, 1, HRES - 2),
					size = VN(1, 6, 4),
				})
			end
			if d.exits['x'][2] then
				table.insert(d.data, {
					action = 'cube',
					node = 'default:desert_stonebrick',
					location = VN(RES - 1, 1, 1),
					size = VN(1, RES - 2, RES - 2),
				})
				table.insert(d.data, {
					action = 'cube',
					node = 'air',
					location = VN(RES - 1, 1, HRES - 2),
					size = VN(1, 6, 4),
				})
			end
			if d.exits['z'][1] then
				table.insert(d.data, {
					action = 'cube',
					node = 'default:desert_stonebrick',
					location = VN(1, 1, 0),
					size = VN(RES - 2, RES - 2, 1),
				})
				table.insert(d.data, {
					action = 'cube',
					node = 'air',
					location = VN(HRES - 2, 1, 0),
					size = VN(4, 6, 1),
				})
			end
			if d.exits['z'][2] then
				table.insert(d.data, {
					action = 'cube',
					node = 'default:desert_stonebrick',
					location = VN(1, 1, RES - 1),
					size = VN(RES - 2, RES - 2, 1),
				})
				table.insert(d.data, {
					action = 'cube',
					node = 'air',
					location = VN(HRES - 2, 1, RES - 1),
					size = VN(4, 6, 1),
				})
			end
		end

		d.id = tostring(per)
		table.insert(small_rooms, d)
	end

	local sra = {}
	for _, s in pairs(small_rooms) do
		d = table.copy(s)
		table.insert(d.data, {
			action = 'cube',
			node = 'air',
			location = VN(3, 0, 2),
			size = VN(4, 1, 1),
		})
		table.insert(d.data, {
			action = 'stair',
			node = 'stairs:stair_stone',
			depth = 1,
			location = VN(3, 0, 3),
			param2 = 0,
			size = VN(2, 5, 5),
		})
		table.insert(d.data, {
			action = 'stair',
			node = 'stairs:stair_stonebrick',
			depth = 1,
			location = VN(5, 5, 3),
			param2 = 2,
			size = VN(2, 5, 5),
		})
		table.insert(d.data, {
			action = 'cube',
			node = 'default:stonebrick',
			location = VN(3, 4, 8),
			size = VN(4, 1, 1),
		})
		table.insert(d.data, {
			action = 'cube',
			node = 'air',
			location = VN(5, 0, 3),
			size = VN(2, 1, 4),
		})
		table.insert(d.data, {
			action = 'cube',
			node = 'stairs:stair_desert_stonebrick',
			location = VN(3, 0, 1),
			param2 = 2,
			size = VN(4, 1, 1),
		})
		table.insert(d.data, {
			action = 'cube',
			node = 'stairs:stair_desert_stonebrick',
			location = VN(7, 0, 2),
			param2 = 1,
			size = VN(1, 1, 5),
		})
		table.insert(d.data, {
			action = 'cube',
			node = 'stairs:stair_inner_desert_stonebrick',
			location = VN(7, 0, 1),
			param2 = 2,
			size = VN(1, 1, 1),
		})
		table.insert(d.data, {
			action = 'cube',
			node = 'stairs:stair_inner_desert_stonebrick',
			location = VN(2, 0, 1),
			param2 = 3,
			size = VN(1, 1, 1),
		})
		table.insert(d.data, {
			action = 'cube',
			node = 'stairs:stair_desert_stonebrick',
			location = VN(2, 0, 2),
			param2 = 3,
			size = VN(1, 1, 2),
		})
		d.exits.y = { true, true }
		d.id = 'stair' .. d.id
		table.insert(sra, d)
	end
	for _, s in pairs(sra) do
		table.insert(small_rooms, s)
	end

	--dofile(mod.path .. '/df01.room')
end


function mod.get_big_rooms(rares)
	local out = {}

	for _, s in pairs(big_rooms) do
		if rares or not s.rare then
			table.insert(out, s)
		end
	end

	return out
end


function mod.handle_chest(pos)
	local meta = minetest.get_meta(pos)
	local sr = gpr:next(1, 1000)
	local fill = true

	-- Clear the metadata, if we're overgenerating.
	-- This avoids two traps on a chest (and double-filling).
	if ovg > 0 then
		meta:from_table(nil)
		minetest.registered_nodes['default:chest'].on_construct(pos)
	end

	if sr < 25 then
		meta:set_int('mapgen_pitfall', 6)
		fill = false
	elseif sr < 50 then
		meta:set_string('mapgen_poisoned', 'poison')
	elseif sr < 75 then
		meta:set_string('mapgen_tnt_trap', 'tnt')
		fill = false
	end
	--meta:set_string('mapgen_summon_mob', 'random')

	if fill then
		local inv = meta:get_inventory()
		local invsz = inv:get_size('main')
		if invsz > 0 then
			layers_mod.fill_chest(pos, gpr)
		end
	end

	local tm = minetest.get_node_timer(pos)
	if not tm then
		return
	end
	tm:set(180, math.random(90) + 90)
end


function mod.match_exits(e, rares)
	local out = {}

	for _, s in pairs(small_rooms) do
		local good = true

		for _, axis in pairs(axes) do
			for i = 1, 2 do
				if e[axis][i] ~= s.exits[axis][i] then
					good = false
				end
			end
		end

		if good and (rares or not s.rare) then
			table.insert(out, s)
		end
	end

	return out
end


function mod.place_big_room(params)
	local rot = 0
	local data, p2data, area = params.data, params.p2data, params.area
	local minp, maxp = params.isect_minp, params.isect_maxp
	local chunk_offset = layers_mod.chunk_offset

	-- Try to make the room choice repeatable.
	local hran = minetest.hash_node_position(vector.add(minp, VN(40, 40, 40))) % 16378 + 3706
	math.randomseed(hran)

	local ss = mod.get_big_rooms(math.random(5) == 1)

	if #ss < 1 then
		print('No big rooms!')
		print()
		return
		--ss = {emergency_caltrop}
	end

	local s = ss[math.random(1, #ss)]
	rot = s.rotate or 0

	local geo = Geomorph.new(params, s)
	geo:write_to_map(rot, nil, VN(20, 20, 20))
end


function mod.place_small_room(params, loc, big)
	local rot = 0
	local dung_noise = PerlinNoise(layers_mod.registered_noises['rooms_connections'])
	local data, p2data, area = params.data, params.p2data, params.area
	local minp, maxp = params.isect_minp, params.isect_maxp
	local chunk_offset = layers_mod.chunk_offset

	-- Todo: make this a bit more random.
	local ex_up = (loc.x == params.chunk_minp.x and loc.z == params.chunk_minp.z)
	local ex_down = (loc.x == params.chunk_minp.x and loc.z == params.chunk_minp.z)
	local ex = {
		x = {false, false},
		y = {ex_down, ex_up},
		z = {false, false},
	}


	local center = vector.add(vector.divide(params.chunk_csize, 2), minp)
	local room_center = vector.add(loc, VN(HRES, HRES, HRES))
	local rdv = vector.abs(vector.subtract(center, room_center))
	if big and rdv.x < 20 and rdv.y < 20 and rdv.z < 20 then
		return
	end

	local tot_exits = 0
	for _, cset in pairs(cpoints) do
		local pa, caxis, cdir = cset[1], cset[2], cset[3]
		local hn = dung_noise:get_3d(vector.add(loc, pa))
		local rdv = vector.abs(vector.subtract(center, vector.add(loc, pa)))
		local outer = (rdv.x > 20 or rdv.y > 20 or rdv.z > 20)
		local level = (loc.y + chunk_offset) % 80
		local thirdc = (level >= 30 and level <= 50) and (rdv.x < 10 or rdv.z < 10)

		if (not big and hn > 0)
		or (big and ((outer and hn > 0) or (not outer and thirdc))) then
			ex[caxis][cdir] = true
			tot_exits = tot_exits + 1
		end
	end

	-- Try to make the room choice repeatable.
	local hran = minetest.hash_node_position(loc) % 16378 + 3706
	math.randomseed(hran)

	local ss = mod.match_exits(ex, (math.random(10) == 1))

	if #ss < 1 then
		print('No exit!')
		print(dump(ex))
		print()
		return
		--ss = {emergency_caltrop}
	end

	local s = ss[math.random(1, #ss)]
	rot = s.rotate or 0

	local geo = Geomorph.new(params, s)
	geo:write_to_map(rot, nil, vector.subtract(loc, minp))

	--[[
	for _, cset in pairs(cpoints) do
		local pa, caxis, cdir = cset[1], cset[2], cset[3]
		local hn = dung_noise:get_3d(vector.add(loc, pa))
		if hn > 0 then
			local ivm = area:indexp(vector.add(loc, pa))
			data[ivm] = node['default:diamondblock']
		end
	end
	--]]

	do
		if not params.share.treasure_chests then
			params.share.treasure_chests = {}
		end

		local p = vector.add(loc, VN(HRES, 1, HRES))
		local ivm = area:indexp(p)
		if data[ivm] == layers_mod.node['default:chest'] then
			table.insert(params.share.treasure_chests, p)
		end
	end
end


local status_mod_path = minetest.get_modpath('status')
if status_mod_path and status_mod and status_mod.register_status then
	status_mod.register_status({
		name = 'booty_poisoned',
		during = function(player)
			if not player then
				return
			end
			local player_name = player:get_player_name()
			if not player_name or player_name == '' then
				return
			end

			local damage = 1
			if status_mod.db.status[player_name]['booty_poisoned']['damage'] then
				damage = tonumber(status_mod.db.status[player_name]['booty_poisoned']['damage'])
			end

			local hp = player:get_hp()
			if hp then
				hp = hp - damage
				player:set_hp(hp)
			end
		end,
		terminate = function(player)
			if not player then
				return
			end

			local player_name = player:get_player_name()
			minetest.chat_send_player(player_name, 'Your sickness ebbs away.')
		end,
	})
end


mod.add_construct('default:bookshelf')


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------

-- Define the noises.
layers_mod.register_noise( 'rooms_connections', { offset = 0, scale = 1, seed = 384, spread = {x = RES, y = RES, z = RES}, octaves = 6, persist = 0.5, lacunarity = 2.0} )

layers_mod.register_mapgen('tg_rooms', mod.generate_rooms, { full_chunk = true })
if layers_mod.register_spawn then
	--layers_mod.register_spawn('tg_rooms', mod.get_spawn_level)
end
