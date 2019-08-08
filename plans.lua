-- Boxes mapgen plans.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017, 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


-- Rotation:
-- 0 Z+   1 X+   2 Z-   3 X-
-- ladders:  2 X+   3 X-   4 Z+   5 Z-


local mod = mapgen
local mod_name = 'mapgen'
local clone_node = mod.clone_node
local light_max = default.light_max or 10


local vn = vector.new
local register_geomorph = mod.register_geomorph
local building_stone = 'default:stone'
local ground = 20
local vault_width = 7
local vault_offset = math.floor(vault_width / 2)
local p
mod.geo_parts = {}


local n_ex = 'air'
local default_exits = {
	{act = 'cube', node = n_ex, loc = vn(0, 21, 19), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(0, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(0, 21, 59), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(79, 21, 19), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(79, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(79, 21, 59), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(19, 21, 0), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(39, 21, 0), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(59, 21, 0), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(19, 21, 79), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(39, 21, 79), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(59, 21, 79), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(0, 51, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(79, 51, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = n_ex, loc = vn(39, 51, 0), size = vn(2, 3, 1)},
	{act = 'cube', node = n_ex, loc = vn(39, 51, 79), size = vn(2, 3, 1)},
}
mod.geo_parts['default_exits'] = default_exits


local upper_cross = {
	{act = 'cube', node = 'air', loc = vn(0, 51, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 0), size = vn(2, 3, 80)},
}
local placeholder_y51 = upper_cross
mod.geo_parts['upper_cross'] = upper_cross


local lower_cross = {
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 80)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(80, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(80, 3, 2)},
}
mod.geo_parts['lower_cross'] = lower_cross

p = {}


-----------------------------------------------------


for _, item in pairs(lower_cross) do
	table.insert(p, table.copy(item))
end

for _, item in pairs(upper_cross) do
	table.insert(p, table.copy(item))
end

for _, item in pairs(default_exits) do
	table.insert(p, table.copy(item))
end

for _, z in pairs({19, 39, 59}) do
	for _, x in pairs({19, 39, 59}) do
		table.insert(p, {
			act = 'puzzle',
			chance = 10,
			loc = vn(x - vault_offset, 21, z - vault_offset),
			size = vn(vault_width, vault_width, vault_width)
		})
	end
end

register_geomorph({
	name = 'crossroads',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


--[[
p = {
	{act = 'cube', node = 'mapgen:sky_scrith', loc = vn(0, 0, 0), size = vn(80, 80, 80)},
	{act = 'cube', node = 'air', loc = vn(1, 1, 1), size = vn(78, 78, 78)},
	{act = 'cube', node = 'default:stone', loc = vn(1, 1, 1), size = vn(78, ground - 3, 78)},
	{act = 'cube', node = 'default:dirt', loc = vn(1, ground - 2, 1), size = vn(78, 2, 78)},
	{act = 'cube', node = 'default:dirt_with_grass', loc = vn(1, ground, 1), size = vn(78, 1, 78)},
}

for _, item in pairs(default_exits) do
	table.insert(p, table.copy(item))
end

register_geomorph({
	name = 'green_lawn',
	areas = 'walking',
	data = p,
})
--]]


-----------------------------------------------------


p = {
	{act = 'cube', node = 'mapgen:sky_scrith', loc = vn(0, 0, 0), size = vn(80, 80, 80)},
	{act = 'cube', node = 'air', loc = vn(1, 1, 1), size = vn(78, 78, 78)},
	{act = 'cube', node = 'default:water_source', loc = vn(1, 1, 1), size = vn(78, 70, 78)},
	{act = 'cube', node = 'default:dirt', loc = vn(1, 1, 1), size = vn(78, 3, 78)},
}

for _, item in pairs(lower_cross) do
	local copy = table.copy(item)
	copy.node = 'default:glass'
	copy.loc = vector.add(copy.loc, -1)
	copy.size = vector.add(copy.size, 2)
	table.insert(p, copy)

	if not mod.let_there_be_light then
		copy = table.copy(copy)
		copy.size.y = 1
		copy.node = 'default:lamp'
		if copy.size.z > 10 then
			copy.size.x = 1
		else
			copy.size.z = 1
		end

		table.insert(p, copy)
		copy = table.copy(copy)
		if copy.size.z > 10 then
			copy.loc.x = copy.loc.x + 3
		else
			copy.loc.z = copy.loc.z + 3
		end
		table.insert(p, copy)
	end

	copy = table.copy(item)
	copy.node = 'air'
	table.insert(p, copy)
end

for _, item in pairs(lower_cross) do
	table.insert(p, table.copy(item))
end

for _, item in pairs(default_exits) do
	table.insert(p, table.copy(item))
end

register_geomorph({
	name = 'wet_crossroads',
	areas = 'walking',
	data = p,
})


-----------------------------------------------------


p = {
	{act = 'cube', node = 'air', line = 'default:stone_block', treasure = 1, loc = vn(1, 21, 1), size = vn(78, 38, 78)},
	{act = 'cube', node = 'default:stone_block', loc = vn(1, 50, 1), size = vn(78, 1, 78)},
	{act = 'cube', node = 'air', loc = vn(5, 50, 5), size = vn(70, 1, 70)},
	{act = 'stair', node = 'stairs:stair_stone', depth = 3, height = 4, param2 = 2, loc = vn(1, 21, 25), size = vn(2, 30, 30)},
	{act = 'stair', node = 'stairs:stair_stone', depth = 3, height = 4, param2 = 0, loc = vn(77, 21, 25), size = vn(2, 30, 30)},
}

for _, item in pairs(default_exits) do
	table.insert(p, 2, table.copy(item))
end

for z = 7, 78, 9 do
	for x = 7, 78, 9 do
		local i = {act = 'cube', node = 'default:stone_block', loc = vn(z, 21, x), size = vn(2, 38, 2)}
		table.insert(p, i)
		if not mod.let_there_be_light then
			for y = 25, 57, 9 do
				i = {act = 'cube', node = 'default:meselamp', loc = vn(z, y, x), size = vn(2, 1, 2), cheap_lighting = true}
				table.insert(p, i)
			end
		end
	end
end

register_geomorph({
	name = 'pillared_room',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


p = {
	--{param = 'wet'},
	{act = 'cube', node = 'air', loc = vn(20, 12, 11), size = vn(51, 36, 50)},
	{act = 'cube', node = 'default:water_source', treasure = 5, loc = vn(20, 11, 11), size = vn(51, 10, 50)},
	{act = 'cube', node = building_stone, loc = vn(38, 11, 30), size = vn(17, 10, 16)},
	{act = 'cube', node = building_stone, loc = vn(39, 11, 11), size = vn(2, 10, 19)},
	{act = 'cube', node = 'default:water_source', treasure = 3, loc = vn(49, 11, 62), size = vn(30, 5, 17)},
	{act = 'cube', node = 'default:water_source', loc = vn(17, 11, 69), size = vn(32, 2, 2)},
	{act = 'cube', node = 'default:water_source', loc = vn(43, 11, 61), size = vn(2, 2, 10)},
	{act = 'cube', node = 'default:water_source', loc = vn(17, 11, 23), size = vn(2, 2, 46)},
	{act = 'cube', node = 'default:water_source', treasure = 1, loc = vn(1, 11, 1), size = vn(18, 5, 22)},
	{act = 'cube', node = 'air', loc = vn(56, 21, 1), size = vn(8, 5, 5)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 1), size = vn(8, 5, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 11)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 42), size = vn(15, 6, 16)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 22), size = vn(7, 6, 19)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 31), size = vn(4, 4, 7)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 22), size = vn(4, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 10), size = vn(10, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 10), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(72, 21, 47), size = vn(7, 4, 11)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 34), size = vn(8, 6, 12)},
	{act = 'cube', node = 'air', loc = vn(72, 21, 1), size = vn(7, 5, 32)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 19), size = vn(9, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(49, 21, 62), size = vn(30, 6, 17)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 62), size = vn(30, 6, 17)},
	{act = 'cube', node = 'air', loc = vn(37, 21, 75), size = vn(6, 4, 4)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 59), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 10), size = vn(2, 3, 32)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 34), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 26), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 1), size = vn(14, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 10), size = vn(4, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 7), size = vn(7, 3, 11)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 7), size = vn(44, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 5), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(58, 21, 5), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(21, 21, 73), size = vn(28, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 56), size = vn(2, 3, 6)},
	{act = 'ladder', node = 'default:ladder_steel', param2 = 5, loc = vn(78, 11, 62), size = vn(1, 10, 1)},
	{act = 'ladder', node = 'default:ladder_steel', param2 = 4, loc = vn(20, 21, 60), size = vn(1, 20, 1)},

	{act = 'cube', node = 'air', loc = vn(20, 41, 61), size = vn(51, 5, 9)},
	{act = 'cube', node = 'air', loc = vn(11, 41, 11), size = vn(9, 5, 59)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, param2 = 2, loc = vn(16, 21, 36), size = vn(2, 20, 20)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(1, 41, 39), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 0, loc = vn(39, 41, 69), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(71, 51, 39), size = vn(8, 3, 2)},
	{act = 'stair', node = 'stairs:stair_stone', depth = 2, param2 = 2, loc = vn(69, 41, 51), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', loc = vn(69, 51, 13), size = vn(2, 3, 38)},
	{act = 'cube', node = 'air', loc = vn(61, 51, 13), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(61, 31, 13), size = vn(2, 20, 2)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(61, 50, 13), size = vn(2, 1, 2)},
	{act = 'cube', node = 'air', loc = vn(60, 51, 41), size = vn(8, 4, 10)},
	{act = 'cube', node = 'air', loc = vn(60, 51, 29), size = vn(8, 4, 10)},
	{act = 'cube', node = 'air', loc = vn(28, 51, 30), size = vn(24, 6, 25)},
	{act = 'cube', node = 'air', loc = vn(52, 51, 41), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(44, 51, 27), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(28, 51, 27), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(44, 51, 55), size = vn(8, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(28, 51, 55), size = vn(8, 3, 3)},
	{act = 'cube', node = building_stone, loc = vn(37, 51, 40), size = vn(5, 6, 5)},
	{act = 'cube', node = 'air', loc = vn(68, 51, 34), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(68, 51, 44), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 1), size = vn(2, 3, 29)},
}

for _, item in pairs(default_exits) do
	table.insert(p, 2, table.copy(item))
end

register_geomorph({
	name = 'reservoir',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


p = {
	{act = 'cube', node = 'air', loc = vn(1, 21, 21), size = vn(2, 3, 40)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(7, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 17), size = vn(70, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 19), size = vn(7, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 1), size = vn(42, 6, 14)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 46), size = vn(5, 3, 11)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 23), size = vn(5, 3, 11)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 59), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(69, 21, 23), size = vn(2, 3, 38)},
	{act = 'cube', node = 'air', loc = vn(21, 21, 21), size = vn(50, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 21), size = vn(2, 3, 59)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 77), size = vn(22, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(44, 21, 75), size = vn(2, 3, 2)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(30, 25, 25), size = vn(10, 10, 50)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(40, 25, 25), size = vn(10, 10, 50)},
	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(50, 25, 25), size = vn(10, 10, 50)},
	{act = 'cube', node = 'air', loc = vn(30, 21, 25), size = vn(30, 8, 50)},

	{act = 'cube', node = 'air', treasure = 8, loc = vn(24, 21, 64), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(24, 21, 51), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(24, 21, 38), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(24, 21, 25), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(61, 21, 64), size = vn(14, 3, 11)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(61, 21, 51), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(61, 21, 38), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(61, 21, 25), size = vn(5, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(29, 21, 68), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(29, 21, 56), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(29, 21, 43), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(29, 21, 30), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(60, 21, 68), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(60, 21, 56), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(60, 21, 43), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(60, 21, 30), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 34), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 59), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 31, 13), size = vn(25, 4, 11)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(33, 21, 14), size = vn(10, 10, 1)},
	{act = 'cube', node = 'air', loc = vn(61, 31, 56), size = vn(14, 4, 19)},
	{act = 'ladder', node = 'default:ladder_steel', param2 = 4, loc = vn(63, 21, 74), size = vn(1, 10, 1)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 0, loc = vn(73, 21, 49), size = vn(2, 10, 10)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(6, 21, 57), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(16, 31, 24), size = vn(2, 4, 35)},
	{act = 'cube', node = 'air', treasure = 1, loc = vn(61, 31, 22), size = vn(2, 4, 34)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(36, 31, 22), size = vn(25, 4, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 57), size = vn(3, 3, 2)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(61, 31, 55), size = vn(2, 4, 1)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(36, 31, 22), size = vn(1, 4, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(67, 31, 46), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(55, 41, 37), size = vn(10, 4, 10)},
	{act = 'cube', node = 'air', loc = vn(13, 41, 16), size = vn(53, 6, 15)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(12, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(23, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(34, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(45, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(56, 41, 31), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(12, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(23, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(34, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(45, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', treasure = 8, loc = vn(56, 41, 11), size = vn(9, 4, 5)},
	{act = 'cube', node = 'air', loc = vn(67, 41, 25), size = vn(2, 3, 21)},
	{act = 'cube', node = 'air', loc = vn(65, 41, 22), size = vn(4, 3, 3)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(67, 41, 11), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(65, 41, 41), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(65, 41, 11), size = vn(2, 3, 2)},

	{act = 'cube', node = 'air', loc = vn(77, 51, 3), size = vn(2, 3, 38)},
	{act = 'cube', node = 'air', loc = vn(1, 51, 39), size = vn(76, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 51, 1), size = vn(78, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 51, 3), size = vn(2, 3, 36)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 75), size = vn(2, 3, 4)},
}

for x = 9, 69, 15 do
	table.insert(p, {act = 'cube', node = 'air', loc = vn(x, 51, 41), size = vn(2, 3, 34)})
	for z = 44, 74, 6 do
		table.insert(p, {act = 'cube', node = 'air', treasure = 20, loc = vn(x - 6, 51, z - 2), size = vn(5, 3, 5)})
		table.insert(p, {act = 'cube', node = 'air', treasure = 20, loc = vn(x + 3, 51, z - 2), size = vn(5, 3, 5)})
		table.insert(p, {act = 'cube', node = 'air', loc = vn(x - 1, 51, z), size = vn(1, 2, 1)})
		table.insert(p, {act = 'cube', node = 'doors:door_wood_b', param2 = 3, loc = vn(x - 1, 51, z), size = vn(1, 1, 1)})
		table.insert(p, {act = 'cube', node = 'air', loc = vn(x + 2, 51, z), size = vn(1, 2, 1)})
		table.insert(p, {act = 'cube', node = 'doors:door_wood_a', param2 = 1, loc = vn(x + 2, 51, z), size = vn(1, 1, 1)})
	end
end

for _, item in pairs(default_exits) do
	table.insert(p, 2, table.copy(item))
end

register_geomorph({
	name = 'market',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


p = {
	{act = 'cube', node = 'air', loc = vn(19, 21, 76), size = vn(2, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 74), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 70), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 70), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(23, 21, 72), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(25, 21, 76), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(28, 21, 60), size = vn(2, 3, 16)},
	{act = 'cube', node = 'air', loc = vn(28, 21, 58), size = vn(27, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(53, 21, 41), size = vn(2, 3, 17)},
	{act = 'cube', node = 'air', loc = vn(50, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 73), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(32, 21, 71), size = vn(20, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(52, 21, 63), size = vn(16, 15, 16)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 59), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 52), size = vn(2, 3, 15)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 52), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 54), size = vn(2, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(11, 21, 61), size = vn(14, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(23, 21, 59), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 21, 57), size = vn(12, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 21, 55), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 21, 53), size = vn(37, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(48, 21, 50), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 21, 41), size = vn(2, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(5, 21, 48), size = vn(25, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 25), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(8, 21, 25), size = vn(2, 3, 19)},
	{act = 'cube', node = 'air', loc = vn(8, 21, 44), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 23), size = vn(2, 3, 21)},
	{act = 'cube', node = 'air', loc = vn(21, 21, 39), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', floor = 'default:stone_block', loc = vn(1, 21, 17), size = vn(78, 15, 6)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(2, 21, 3), size = vn(17, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(2, 21, 5), size = vn(2, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 13), size = vn(33, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 9), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 11), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(35, 21, 11), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(35, 21, 9), size = vn(15, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 17)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 23), size = vn(2, 3, 13)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 17)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(59, 21, 36), size = vn(20, 3, 8)},
	{act = 'cube', node = 'air', treasure = 3, floor = 'default:stone_block', loc = vn(30, 21, 30), size = vn(20, 15, 20)},

	{act = 'cube', node = 'air', loc = vn(13, 31, 55), size = vn(2, 3, 22)},
	{act = 'cube', node = 'air', loc = vn(15, 31, 75), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(17, 31, 45), size = vn(2, 3, 32)},
	{act = 'cube', node = 'air', loc = vn(4, 31, 53), size = vn(11, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 31, 25), size = vn(2, 3, 28)},
	{act = 'cube', node = 'air', treasure = 1, loc = vn(8, 31, 35), size = vn(11, 3, 10)},
	{act = 'cube', node = 'air', treasure = 1, loc = vn(8, 31, 24), size = vn(11, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(20, 31, 11), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(20, 31, 23), size = vn(2, 3, 18)},
	{act = 'cube', node = 'air', loc = vn(22, 31, 39), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(32, 31, 52), size = vn(2, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(34, 31, 52), size = vn(7, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 31, 50), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 31, 23), size = vn(2, 3, 7)},
	{act = 'cube', node = 'air', loc = vn(39, 31, 5), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(41, 31, 5), size = vn(24, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(58, 31, 11), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(58, 31, 23), size = vn(2, 3, 40)},
	{act = 'cube', node = 'air', loc = vn(50, 31, 39), size = vn(8, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(63, 31, 58), size = vn(2, 3, 3)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(3, 21, 65), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(12, 21, 9), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(50, 21, 9), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(65, 21, 59), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(32, 21, 61), size = vn(2, 10, 10)},
	{act = 'ladder', node = 'default:ladder_steel', param2 = 3, loc = vn(4, 21, 25), size = vn(1, 10, 1)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 9), size = vn(1, 3, 2)},

	{act = 'cube', node = 'air', loc = vn(63, 41, 17), size = vn(2, 3, 31)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(63, 31, 48), size = vn(2, 10, 10)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 0, loc = vn(63, 31, 7), size = vn(2, 10, 10)},

	{act = 'cube', node = building_stone, loc = vn(20, 30, 17), size = vn(2, 1, 6)},
	{act = 'cube', node = building_stone, loc = vn(39, 30, 17), size = vn(2, 1, 6)},
	{act = 'cube', node = building_stone, loc = vn(58, 30, 17), size = vn(2, 1, 6)},
	{act = 'cube', node = building_stone, loc = vn(56, 30, 63), size = vn(6, 1, 3)},
	{act = 'cube', node = building_stone, loc = vn(39, 30, 30), size = vn(2, 1, 20)},
	{act = 'cube', node = building_stone, loc = vn(30, 30, 39), size = vn(20, 1, 2)},

	{act = 'cube', node = mod_name..':false_wall', loc = vn(1, 21, 58), size = vn(2, 3, 1)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(21, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(6, 21, 12), size = vn(2, 3, 1)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(38, 21, 9), size = vn(1, 3, 2)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(41, 21, 9), size = vn(1, 3, 2)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(59, 21, 23), size = vn(2, 3, 1)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(13, 31, 67), size = vn(2, 3, 1)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(13, 31, 34), size = vn(2, 3, 1)},
}

for _, item in pairs(default_exits) do
	table.insert(p, 2, table.copy(item))
end

for _, item in pairs(placeholder_y51) do
	table.insert(p, 2, table.copy(item))
end

register_geomorph({
	name = 'silly_straw',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


p = {
	--{param = 'dry'},
	{act = 'cube', node = 'air', floor = 'default:stone_block', loc = vn(1, 21, 1), size = vn(78, 5, 78)},
	{act = 'cube', node = building_stone, loc = vn(9, 21, 9), size = vn(62, 1, 62)},
	{act = 'cube', node = building_stone, loc = vn(9, 23, 9), size = vn(62, 5, 62)},
	{act = 'cube', node = 'air', loc = vn(10, 11, 10), size = vn(60, 25, 60)},
	{act = 'cube', node = 'default:lava_source', loc = vn(10, 11, 10), size = vn(60, 5, 60)},
	{act = 'cube', node = building_stone, loc = vn(25, 11, 25), size = vn(30, 9, 30)},
	{act = 'cube', node = 'default:stone_block', loc = vn(25, 20, 25), size = vn(30, 1, 30)},
	{act = 'cube', node = building_stone, loc = vn(39, 20, 55), size = vn(2, 1, 15)},
	{act = 'cube', node = building_stone, loc = vn(39, 20, 10), size = vn(2, 1, 15)},
	{act = 'cube', node = building_stone, loc = vn(10, 20, 39), size = vn(15, 1, 2)},
	{act = 'cube', node = building_stone, loc = vn(55, 20, 39), size = vn(15, 1, 2)},
	{act = 'cube', node = 'air', loc = vn(70, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(9, 21, 39), size = vn(1, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 70), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 9), size = vn(2, 3, 1)},
	{act = 'cube', node = building_stone, loc = vn(37, 20, 37), size = vn(6, 2, 6)},
	{act = 'cube', node = 'default:lava_source', loc = vn(38, 20, 38), size = vn(4, 2, 4)},
}

for _, item in pairs(default_exits) do
	table.insert(p, 2, table.copy(item))
end

for _, item in pairs(placeholder_y51) do
	table.insert(p, 2, table.copy(item))
end

register_geomorph({
	name = 'lake_of_fire',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


p = {
	--{param = 'wet'},
	{act = 'cube', node = 'air', loc = vn(29, 11, 55), size = vn(2, 3, 16)},
	{act = 'cube', node = 'air', loc = vn(25, 11, 69), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(25, 11, 9), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(9, 11, 9), size = vn(2, 3, 62)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 9), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 24), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 39), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 54), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(11, 11, 69), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(49, 11, 59), size = vn(12, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(49, 11, 55), size = vn(2, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(26, 11, 25), size = vn(30, 6, 30)},
	{act = 'cube', node = 'air', loc = vn(49, 11, 19), size = vn(2, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(29, 11, 9), size = vn(2, 3, 16)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(15, 11, 5), size = vn(10, 6, 10)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(15, 11, 20), size = vn(10, 6, 10)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(15, 11, 35), size = vn(10, 6, 10)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(15, 11, 50), size = vn(10, 6, 10)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(15, 11, 65), size = vn(10, 6, 10)},
	{act = 'cube', node = building_stone, loc = vn(18, 11, 8), size = vn(4, 6, 4)},
	{act = 'cube', node = building_stone, loc = vn(18, 11, 23), size = vn(4, 6, 4)},
	{act = 'cube', node = building_stone, loc = vn(18, 11, 38), size = vn(4, 6, 4)},
	{act = 'cube', node = building_stone, loc = vn(18, 11, 53), size = vn(4, 6, 4)},
	{act = 'cube', node = building_stone, loc = vn(18, 11, 68), size = vn(4, 6, 4)},
	{act = 'cube', node = 'default:water_source', loc = vn(19, 11, 9), size = vn(2, 10, 2)},
	{act = 'cube', node = 'default:water_source', loc = vn(19, 11, 24), size = vn(2, 10, 2)},
	{act = 'cube', node = 'default:water_source', loc = vn(19, 11, 39), size = vn(2, 10, 2)},
	{act = 'cube', node = 'default:water_source', loc = vn(19, 11, 54), size = vn(2, 10, 2)},
	{act = 'cube', node = 'default:water_source', loc = vn(19, 11, 69), size = vn(2, 10, 2)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(61, 11, 59), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(39, 11, 1), size = vn(2, 10, 10)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(39, 11, 19), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 11, 11), size = vn(2, 3, 14)},
	{act = 'cube', node = building_stone, loc = vn(61, 21, 59), size = vn(1, 6, 2)},

	{act = 'cylinder', node = 'air', axis = 'z', loc = vn(10, 15, 1), size = vn(20, 20, 79)},
	{act = 'cube', node = building_stone, loc = vn(10, 15, 1), size = vn(20, 6, 79)},
	{act = 'cube', node = 'air', floor = 'default:stone_block', loc = vn(10, 21, 1), size = vn(20, 4, 79)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 56), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 36), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 16), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 64), size = vn(2, 3, 7)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 69), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 44), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 49), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 24), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 29), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(4, 21, 9), size = vn(2, 3, 7)},
	{act = 'cube', node = 'air', loc = vn(6, 21, 9), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(31, 21, 56), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(31, 21, 36), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(31, 21, 16), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(34, 21, 64), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(30, 21, 69), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(34, 21, 44), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(30, 21, 49), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(34, 21, 24), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(30, 21, 29), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(34, 21, 9), size = vn(2, 3, 7)},
	{act = 'cube', node = 'air', loc = vn(30, 21, 9), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 59), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 39), size = vn(41, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 19), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 1), size = vn(2, 3, 79)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 69), size = vn(2, 3, 11)},

	{act = 'cube', node = building_stone, loc = vn(15, 21, 5), size = vn(10, 1, 10)},
	{act = 'cube', node = 'default:water_source', loc = vn(16, 21, 6), size = vn(8, 1, 8)},
	{act = 'cube', node = building_stone, loc = vn(19, 21, 9), size = vn(2, 2, 2)},
	{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 9), size = vn(2, 1, 2)},
	{act = 'cube', node = building_stone, loc = vn(15, 21, 20), size = vn(10, 1, 10)},
	{act = 'cube', node = 'default:water_source', loc = vn(16, 21, 21), size = vn(8, 1, 8)},
	{act = 'cube', node = building_stone, loc = vn(19, 21, 24), size = vn(2, 2, 2)},
	{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 24), size = vn(2, 1, 2)},
	{act = 'cube', node = building_stone, loc = vn(15, 21, 35), size = vn(10, 1, 10)},
	{act = 'cube', node = 'default:water_source', loc = vn(16, 21, 36), size = vn(8, 1, 8)},
	{act = 'cube', node = building_stone, loc = vn(19, 21, 39), size = vn(2, 2, 2)},
	{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 39), size = vn(2, 1, 2)},
	{act = 'cube', node = building_stone, loc = vn(15, 21, 50), size = vn(10, 1, 10)},
	{act = 'cube', node = 'default:water_source', loc = vn(16, 21, 51), size = vn(8, 1, 8)},
	{act = 'cube', node = building_stone, loc = vn(19, 21, 54), size = vn(2, 2, 2)},
	{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 54), size = vn(2, 1, 2)},
	{act = 'cube', node = building_stone, loc = vn(15, 21, 65), size = vn(10, 1, 10)},
	{act = 'cube', node = 'default:water_source', loc = vn(16, 21, 66), size = vn(8, 1, 8)},
	{act = 'cube', node = building_stone, loc = vn(19, 21, 69), size = vn(2, 2, 2)},
	{act = 'cube', node = mod_name..':water_source_tame', loc = vn(19, 23, 69), size = vn(2, 1, 2)},

	{act = 'cube', node = 'air', loc = vn(51, 31, 65), size = vn(20, 5, 10)},
	{act = 'cube', node = 'air', loc = vn(51, 31, 15), size = vn(10, 5, 10)},
	{act = 'cube', node = 'air', loc = vn(55, 31, 25), size = vn(2, 3, 27)},
	{act = 'cube', node = 'air', loc = vn(60, 31, 41), size = vn(2, 3, 24)},
	{act = 'cube', node = 'air', loc = vn(57, 31, 39), size = vn(8, 3, 2)},
	{act = 'cube', node = building_stone, loc = vn(54, 11, 49), size = vn(4, 6, 4)},
	{act = 'cube', node = 'air', loc = vn(55, 6, 50), size = vn(2, 25, 2)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(55, 30, 50), size = vn(2, 1, 2)},
	{act = 'cube', node = 'air', treasure = 1, loc = vn(65, 31, 35), size = vn(10, 5, 10)},
	{act = 'cube', node = 'air', loc = vn(69, 31, 45), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', treasure = 1, loc = vn(65, 31, 50), size = vn(10, 5, 10)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(57, 31, 39), size = vn(1, 3, 2)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(61, 21, 19), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(41, 21, 69), size = vn(10, 10, 2)},
}

for _, item in pairs(default_exits) do
	table.insert(p, 2, table.copy(item))
end

for _, item in pairs(placeholder_y51) do
	table.insert(p, 2, table.copy(item))
end

register_geomorph({
	name = 'fountain_court',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


p = {
	{act = 'cube', node = 'default:dirt', loc = vn(5, 19, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = 'default:dirt', loc = vn(5, 19, 5), size = vn(70, 1, 70), treasure = 1},
	{act = 'cube', node = 'air', loc = vn(5, 21, 5), size = vn(70, 7, 70)},
	{act = 'cube', node = 'flowers:mushroom_brown', random = 30, loc = vn(5, 21, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 75), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 19), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 39), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(75, 21, 59), size = vn(5, 3, 2)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(61, 21, 75), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(9, 21, 3), size = vn(10, 10, 2)},
	{act = 'cube', node = 'default:dirt', loc = vn(5, 29, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = 'default:dirt', loc = vn(5, 29, 5), size = vn(70, 1, 70), treasure = 1},
	{act = 'cube', node = 'air', loc = vn(5, 31, 5), size = vn(70, 7, 70)},
	{act = 'cube', node = 'flowers:mushroom_brown', random = 30, loc = vn(5, 31, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(71, 31, 75), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(3, 31, 3), size = vn(6, 3, 2)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(75, 31, 65), size = vn(2, 10, 10)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 0, loc = vn(3, 31, 5), size = vn(2, 10, 10)},

	{act = 'cube', node = 'default:dirt', loc = vn(5, 39, 5), size = vn(70, 2, 70)},
	{act = 'cube', node = 'default:dirt', loc = vn(5, 39, 5), size = vn(70, 1, 70), treasure = 1},
	{act = 'cube', node = 'air', loc = vn(5, 41, 5), size = vn(70, 7, 70)},
	{act = 'cube', node = 'flowers:mushroom_brown', random = 30, loc = vn(5, 41, 5), size = vn(70, 1, 70)},
	{act = 'cube', node = 'air', loc = vn(75, 41, 60), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(3, 41, 15), size = vn(2, 3, 5)},
}

for _, item in pairs(default_exits) do
	table.insert(p, 2, table.copy(item))
end

for _, item in pairs(placeholder_y51) do
	table.insert(p, 2, table.copy(item))
end

register_geomorph({
	name = 'mushroom_garden',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


p = {
	{act = 'cube', node = 'air', loc = vn(15, 39, 15), size = vn(50, 6, 50)},
	{act = 'cube', node = 'air', loc = vn(16, 38, 16), size = vn(48, 7, 48)},
	{act = 'cube', node = 'air', loc = vn(17, 37, 17), size = vn(46, 8, 46)},
	{act = 'cube', node = 'air', loc = vn(18, 36, 18), size = vn(44, 9, 44)},
	{act = 'cube', node = 'air', loc = vn(19, 35, 19), size = vn(42, 10, 42)},
	{act = 'cube', node = 'air', loc = vn(20, 34, 20), size = vn(40, 11, 40)},
	{act = 'cube', node = 'air', loc = vn(21, 33, 21), size = vn(38, 12, 38)},
	{act = 'cube', node = 'air', loc = vn(22, 32, 22), size = vn(36, 13, 36)},
	{act = 'cube', node = 'air', treasure = 1, loc = vn(24, 21, 24), size = vn(32, 24, 32)},

	{act = 'cube', node = 'air', treasure = 4, loc = vn(30, 21, 65), size = vn(20, 5, 10)},
	{act = 'cube', node = 'air', treasure = 4, loc = vn(30, 21, 5), size = vn(20, 5, 10)},
	{act = 'cube', node = 'air', treasure = 4, loc = vn(65, 21, 30), size = vn(10, 5, 20)},
	{act = 'cube', node = 'air', treasure = 4, loc = vn(5, 21, 30), size = vn(10, 5, 20)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 56), size = vn(2, 3, 24)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 3, 24)},
	{act = 'cube', node = 'air', loc = vn(77, 21, 19), size = vn(3, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(77, 21, 59), size = vn(3, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(3, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(3, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 77), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 77), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(24, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(56, 21, 39), size = vn(24, 3, 2)},

	{act = 'cube', node = 'air', loc = vn(19, 31, 65), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(59, 31, 65), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(59, 31, 13), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 31, 13), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(65, 31, 19), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(65, 31, 59), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 31, 59), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 31, 19), size = vn(2, 3, 2)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(59, 21, 67), size = vn(2, 10, 10)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 0, loc = vn(59, 21, 3), size = vn(2, 10, 10)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 0, loc = vn(19, 21, 3), size = vn(2, 10, 10)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(67, 21, 19), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(67, 21, 59), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(3, 21, 59), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(3, 21, 19), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(19, 21, 67), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(65, 39, 29), size = vn(2, 3, 22)},
	{act = 'cube', node = 'air', loc = vn(13, 39, 29), size = vn(2, 3, 22)},
	{act = 'cube', node = 'air', loc = vn(29, 39, 65), size = vn(22, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(29, 39, 13), size = vn(22, 3, 2)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(65, 31, 51), size = vn(2, 8, 8)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 0, loc = vn(65, 31, 21), size = vn(2, 8, 8)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(13, 31, 51), size = vn(2, 8, 8)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 0, loc = vn(13, 31, 21), size = vn(2, 8, 8)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(51, 31, 65), size = vn(8, 8, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(21, 31, 65), size = vn(8, 8, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(51, 31, 13), size = vn(8, 8, 2)},
	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(21, 31, 13), size = vn(8, 8, 2)},
}

for _, item in pairs(default_exits) do
	table.insert(p, 2, table.copy(item))
end

for _, item in pairs(placeholder_y51) do
	table.insert(p, 2, table.copy(item))
end

register_geomorph({
	name = 'arena',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


p = {
	{act = 'cube', node = 'air', loc = vn(0, 21, 19), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 39), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(0, 21, 59), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(79, 21, 19), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(79, 21, 39), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(79, 21, 59), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 0), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 0), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 0), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 79), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 79), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(59, 21, 79), size = vn(2, 2, 1)},

	{act = 'cube', node = 'air', loc = vn(38, 21, 1), size = vn(4, 3, 78)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 58), size = vn(78, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 18), size = vn(78, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 37), size = vn(8, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(10, 21, 30), size = vn(25, 5, 20)},
	{act = 'cube', node = 'air', loc = vn(35, 21, 38), size = vn(3, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(42, 21, 38), size = vn(37, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(51, 21, 42), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(51, 21, 37), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(69, 21, 42), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(69, 21, 37), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(44, 21, 43), size = vn(16, 6, 9)},
	{act = 'cube', node = 'air', loc = vn(44, 21, 28), size = vn(16, 6, 9)},
	{act = 'cube', node = 'air', loc = vn(62, 21, 43), size = vn(16, 6, 9)},
	{act = 'cube', node = 'air', loc = vn(62, 21, 28), size = vn(16, 6, 9)},

	{act = 'cube', node = 'air', loc = vn(24, 21, 71), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(43, 21, 71), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(24, 21, 7), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(43, 21, 7), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 71), size = vn(8, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(56, 21, 71), size = vn(8, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(16, 21, 1), size = vn(8, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(56, 21, 1), size = vn(8, 3, 8)},

	{act = 'cube', node = 'doors:door_wood_a', param2 = 3, loc = vn(0, 21, 59), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 3, loc = vn(0, 21, 60), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 1, loc = vn(79, 21, 59), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_a', param2 = 1, loc = vn(79, 21, 60), size = vn(1, 1, 1)},

	{act = 'cube', node = 'doors:door_wood_a', param2 = 3, loc = vn(0, 21, 19), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 3, loc = vn(0, 21, 20), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 1, loc = vn(79, 21, 19), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_a', param2 = 1, loc = vn(79, 21, 20), size = vn(1, 1, 1)},

	{act = 'cube', node = 'doors:door_wood_a', param2 = 0, loc = vn(39, 21, 79), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 0, loc = vn(40, 21, 79), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 2, loc = vn(39, 21, 0), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_a', param2 = 2, loc = vn(40, 21, 0), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(37, 21, 71), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(42, 21, 71), size = vn(1, 2, 2)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 1, loc = vn(37, 21, 71), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_a', param2 = 1, loc = vn(37, 21, 72), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_a', param2 = 3, loc = vn(42, 21, 71), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 3, loc = vn(42, 21, 72), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(37, 21, 7), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(42, 21, 7), size = vn(1, 2, 2)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 1, loc = vn(37, 21, 7), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_a', param2 = 1, loc = vn(37, 21, 8), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_a', param2 = 3, loc = vn(42, 21, 7), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 3, loc = vn(42, 21, 8), size = vn(1, 1, 1)},

	{act = 'cube', node = 'doors:door_wood_b', param2 = 1, loc = vn(79, 21, 39), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_a', param2 = 1, loc = vn(79, 21, 40), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(9, 21, 39), size = vn(1, 2, 2)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 1, loc = vn(9, 21, 39), size = vn(1, 1, 1)},
	{act = 'cube', node = 'doors:door_wood_a', param2 = 1, loc = vn(9, 21, 40), size = vn(1, 1, 1)},

	{act = 'cube', node = mod_name..':false_wall', loc = vn(28, 21, 26), size = vn(1, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(27, 31, 26), size = vn(3, 3, 3)},
	{act = 'cube', node = 'air', loc = vn(28, 31, 29), size = vn(1, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(3, 31, 39), size = vn(74, 3, 2)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(3, 31, 42), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(47, 31, 42), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(32, 31, 32), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(64, 31, 32), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', treasure = 3, loc = vn(11, 31, 32), size = vn(9, 4, 6)},
	{act = 'cube', node = 'air', loc = vn(6, 31, 41), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(51, 31, 41), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(14, 31, 38), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(36, 31, 38), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(66, 31, 38), size = vn(2, 3, 1)},
	{act = 'ladder', node = 'default:ladder_steel', param2 = 2, loc = vn(28, 21, 27), size = vn(1, 10, 1)},
}

for _, o in pairs({0, 43}) do
	for x = 4 + o, 32 + o, 4 do
		for _, y in pairs({57, 17}) do
			local i = {act = 'cube', node = 'air', loc = vn(x, 21, y + 5), size = vn(1, 2, 1)}
			table.insert(p, i)
			i = {act = 'cube', node = 'doors:door_wood_a', param2 = 0, loc = vn(x, 21, y + 5), size = vn(1, 1, 1)}
			table.insert(p, i)
			i = {act = 'cube', node = 'air', loc = vn(x - 1, 21, y + 6), size = vn(3, 3, 3)}
			table.insert(p, i)

			i = {act = 'cube', node = 'air', loc = vn(x, 21, y), size = vn(1, 2, 1)}
			table.insert(p, i)
			i = {act = 'cube', node = 'doors:door_wood_a', param2 = 2, loc = vn(x, 21, y), size = vn(1, 1, 1)}
			table.insert(p, i)
			i = {act = 'cube', node = 'air', loc = vn(x - 1, 21, y - 3), size = vn(3, 3, 3)}
			table.insert(p, i)
		end
	end
end

for _, item in pairs(placeholder_y51) do
	table.insert(p, 2, table.copy(item))
end

register_geomorph({
	name = 'prison',
	areas = 'geomoria',
	data = p,
})


-----------------------------------------------------


--[[
p = {
	{act = 'sphere', node = 'air', loc = vn(1, -18, 1), size = vn(78, 78, 78)},
	{act = 'cube', node = building_stone, loc = vn(1, 0, 1), size = vn(78, 21, 78)},
	{act = 'cube', node = 'default:stone_block', loc = vn(1, 20, 1), size = vn(78, 1, 78)},
}
--]]


-- used in stair base as well as height

p = {
	{act = 'cube', node = building_stone, loc = vn(26, 0, 23), size = vn(5, 5, 31)},
	{act = 'cube', node = building_stone, loc = vn(26, 0, 49), size = vn(28, 26, 5)},
	{act = 'cube', node = building_stone, loc = vn(49, 19, 29), size = vn(5, 27, 28)},
	{act = 'cube', node = building_stone, loc = vn(29, 39, 26), size = vn(25, 27, 5)},
	{act = 'cube', node = building_stone, loc = vn(26, 59, 26), size = vn(5, 21, 28)},
	{act = 'cube', node = 'air', loc = vn(27, 0, 47), size = vn(3, 4, 6)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, depth = 3, param2 = 1, loc = vn(30, 0, 50), size = vn(20, 20, 3)},
	{act = 'cube', node = 'air', loc = vn(47, 20, 50), size = vn(6, 4, 3)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, depth = 3, param2 = 2, loc = vn(50, 20, 30), size = vn(3, 20, 20)},
	{act = 'cube', node = 'air', loc = vn(50, 40, 27), size = vn(3, 4, 6)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, depth = 3, param2 = 3, loc = vn(30, 40, 27), size = vn(20, 20, 3)},
	{act = 'cube', node = 'air', loc = vn(27, 60, 27), size = vn(6, 4, 3)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, depth = 3, param2 = 0, loc = vn(27, 60, 30), size = vn(3, 21, 20)},
}

--[[
register_geomorph({
	name = 'stair_height',
	areas = 'geomoria',
	data = p,
})
--]]


-----------------------------------------------------


local q = table.copy(p)
p = {
	{act = 'sphere', node = 'air', loc = vn(35, 31, 35), size = vn(40, 40, 40)},
	{act = 'cube', node = building_stone, loc = vn(35, 31, 35), size = vn(40, 20, 40)},
	{act = 'cube', node = 'default:stone_block', loc = vn(35, 50, 35), size = vn(40, 1, 40)},

	{act = 'stair', node = 'stairs:stair_stone', height = 4, param2 = 3, loc = vn(50, 41, 10), size = vn(10, 10, 2)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, param2 = 0, loc = vn(10, 41, 25), size = vn(2, 10, 10)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, param2 = 3, loc = vn(20, 41, 55), size = vn(10, 10, 2)},
	{act = 'cube', node = 'air', loc = vn(55, 41, 20), size = vn(15, 5, 50)},
	{act = 'cube', node = 'air', loc = vn(60, 46, 25), size = vn(5, 1, 40)},
	{act = 'cube', node = 'air', loc = vn(60, 41, 15), size = vn(2, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(30, 41, 55), size = vn(2, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(60, 41, 10), size = vn(10, 3, 5)},
	{act = 'cube', node = 'air', loc = vn(33, 41, 20), size = vn(22, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(23, 41, 9), size = vn(12, 4, 11)},
	{act = 'cube', node = 'air', loc = vn(12, 41, 9), size = vn(11, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(10, 41, 9), size = vn(2, 3, 16)},


	{act = 'cube', node = 'air', loc = vn(66, 51, 39), size = vn(13, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 66), size = vn(2, 3, 13)},
	{act = 'cube', node = 'air', loc = vn(1, 51, 39), size = vn(4, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 51, 10), size = vn(2, 3, 55)},
	{act = 'cube', node = 'air', loc = vn(7, 51, 10), size = vn(43, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(25, 51, 14), size = vn(11, 4, 11)},
	{act = 'cube', node = 'air', loc = vn(38, 51, 14), size = vn(11, 4, 11)},
	{act = 'cube', node = 'air', loc = vn(51, 51, 14), size = vn(11, 4, 11)},
	{act = 'cube', node = 'air', loc = vn(64, 51, 14), size = vn(11, 4, 11)},
	{act = 'cube', node = 'air', loc = vn(36, 51, 1), size = vn(8, 4, 8)},
	{act = 'cube', node = 'air', loc = vn(39, 51, 9), size = vn(2, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(29, 51, 12), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(36, 51, 14), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(49, 51, 23), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(62, 51, 14), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 51, 65), size = vn(15, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(10, 51, 35), size = vn(2, 3, 30)},
	{act = 'cube', node = 'air', loc = vn(18, 51, 55), size = vn(2, 3, 10)},
	{act = 'cube', node = 'air', loc = vn(14, 51, 55), size = vn(2, 3, 10)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, param2 = 2, loc = vn(14, 51, 45), size = vn(2, 10, 10)},

	{act = 'cube', node = 'air', loc = vn(14, 61, 22), size = vn(2, 3, 23)},
	{act = 'cube', node = 'air', loc = vn(14, 61, 4), size = vn(61, 5, 18)},
	{act = 'cube', node = 'air', loc = vn(16, 66, 6), size = vn(14, 1, 14)},
	{act = 'cube', node = 'air', loc = vn(36, 66, 6), size = vn(14, 1, 14)},
	{act = 'cube', node = 'air', loc = vn(56, 66, 6), size = vn(14, 1, 14)},
	{act = 'cube', node = 'air', loc = vn(50, 61, 22), size = vn(10, 5, 21)},
	{act = 'cube', node = building_stone, loc = vn(48, 60, 34), size = vn(14, 1, 42)},
	{act = 'cube', node = building_stone, loc = vn(34, 60, 54), size = vn(14, 1, 2)},
	{act = 'cube', node = 'air', loc = vn(23, 61, 54), size = vn(17, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(13, 61, 56), size = vn(12, 4, 16)},
	{act = 'cube', node = 'air', loc = vn(25, 61, 70), size = vn(9, 4, 9)},

	{act = 'cube', node = 'air', loc = vn(65, 31, 70), size = vn(7, 3, 9)},
	{act = 'cube', node = 'air', loc = vn(57, 31, 39), size = vn(12, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(57, 31, 11), size = vn(2, 3, 28)},
	{act = 'cube', node = 'air', loc = vn(35, 31, 70), size = vn(10, 3, 9)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, param2 = 2, loc = vn(30, 31, 65), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', loc = vn(30, 31, 75), size = vn(5, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(45, 31, 75), size = vn(8, 3, 2)},

	{act = 'cube', node = 'air', loc = vn(57, 21, 1), size = vn(6, 6, 78)},
	{act = 'cube', node = 'air', loc = vn(63, 21, 58), size = vn(9, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(72, 21, 56), size = vn(7, 3, 8)},
	{act = 'stair', node = 'stairs:stair_stone', depth = 2, height = 4, param2 = 3, loc = vn(69, 21, 39), size = vn(10, 10, 2)},
	{act = 'sphere', node = 'air', loc = vn(10, 11, 2), size = vn(20, 20, 20)},
	{act = 'cube', node = building_stone, loc = vn(10, 11, 2), size = vn(20, 10, 20)},
	{act = 'cube', node = 'default:stone_block', loc = vn(10, 20, 2), size = vn(20, 1, 20)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 1), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(35, 21, 21), size = vn(13, 5, 27)},
	{act = 'cube', node = 'air', loc = vn(37, 21, 55), size = vn(16, 5, 10)},
	{act = 'cube', node = 'air', loc = vn(51, 21, 53), size = vn(2, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(35, 21, 48), size = vn(2, 3, 9)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, param2 = 0, loc = vn(51, 21, 65), size = vn(2, 10, 10)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 65), size = vn(2, 3, 14)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, param2 = 0, loc = vn(65, 21, 60), size = vn(2, 10, 10)},

	{act = 'cube', node = 'stairs:stair_stone', param2 = 0, loc = vn(51, 20, 53), size = vn(2, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(5, 26, 5), size = vn(4, 3, 6)},
	{act = 'cube', node = 'air', loc = vn(45, 31, 11), size = vn(12, 3, 2)},
	{act = 'stair', node = 'stairs:stair_stone', height = 5, param2 = 1, loc = vn(40, 26, 11), size = vn(5, 5, 2)},
	{act = 'cube', node = 'air', loc = vn(5, 26, 11), size = vn(35, 3, 2)},
	{act = 'cube', node = building_stone, loc = vn(9, 25, 11), size = vn(22, 1, 2)},

	{act = 'cube', node = 'air', loc = vn(64, 21, 20), size = vn(7, 3, 1)},
	{act = 'cube', node = mod_name..':false_wall', loc = vn(64, 21, 20), size = vn(1, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(41, 21, 11), size = vn(16, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(71, 21, 3), size = vn(2, 3, 52)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 19), size = vn(6, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(74, 21, 42), size = vn(5, 4, 13)},
	{act = 'cube', node = 'air', loc = vn(73, 21, 48), size = vn(1, 2, 1)},
	{act = 'cube', node = 'doors:door_wood_b', param2 = 1, loc = vn(73, 21, 48), size = vn(1, 1, 1)},

	{act = 'cube', node = 'air', loc = vn(29, 21, 11), size = vn(10, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(39, 21, 1), size = vn(2, 3, 12)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 11), size = vn(10, 3, 2)},
	{act = 'cube', node = 'air', loc = vn(1, 21, 13), size = vn(2, 3, 8)},
	{act = 'cube', node = 'air', loc = vn(19, 21, 21), size = vn(2, 3, 58)},
	{act = 'cube', node = 'air', loc = vn(21, 21, 55), size = vn(14, 3, 2)},
	{act = 'cube', node = 'air', floor = 'default:stone_block', loc = vn(1, 21, 25), size = vn(14, 4, 50)},
	{act = 'cube', node = 'air', loc = vn(2, 25, 26), size = vn(12, 1, 48)},
	{act = 'cube', node = 'air', loc = vn(3, 26, 27), size = vn(10, 1, 46)},
	{act = 'cube', node = 'air', loc = vn(4, 27, 28), size = vn(8, 1, 44)},
	{act = 'cube', node = 'air', loc = vn(15, 21, 49), size = vn(4, 3, 2)},
	{act = 'cube', node = 'default:stone_block', loc = vn(5, 21, 30), size = vn(5, 1, 40)},
	{act = 'cube', node = 'default:water_source', loc = vn(6, 21, 31), size = vn(3, 1, 38)},
	{act = 'stair', node = 'stairs:stair_stone', height = 4, param2 = 2, loc = vn(70, 31, 60), size = vn(2, 10, 10)},
}

for y = 2, 78, 3 do
	for x = 56, 63, 7 do
		table.insert(p, {act = 'cube', node = 'air', loc = vn(x, 21, y), size = vn(1, 3, 1)})
	end
end

for _, y in pairs({1, 7, 13, 22, 28, 34, 40, 46, 52}) do
	table.insert(p, {act = 'cube', node = 'air', loc = vn(65, 21, y), size = vn(5, 3, 5)})
	table.insert(p, {act = 'cube', node = 'air', loc = vn(70, 21, y + 2), size = vn(1, 2, 1)})
	table.insert(p, {act = 'cube', node = 'doors:door_wood_a', param2 = 3, loc = vn(70, 21, y + 2), size = vn(1, 1, 1)})
end

for _, y in pairs({1, 7, 13, 22, 28}) do
	table.insert(p, {act = 'cube', node = 'air', loc = vn(74, 21, y), size = vn(5, 3, 5)})
	table.insert(p, {act = 'cube', node = 'air', loc = vn(73, 21, y + 2), size = vn(1, 2, 1)})
	table.insert(p, {act = 'cube', node = 'doors:door_wood_b', param2 = 1, loc = vn(73, 21, y + 2), size = vn(1, 1, 1)})
end

for _, y in pairs({24, 30, 36, 42, 48, 59, 65, 71}) do
	table.insert(p, {act = 'cube', node = 'air', loc = vn(22, 21, y), size = vn(5, 3, 5)})
	table.insert(p, {act = 'cube', node = 'air', loc = vn(21, 21, y + 2), size = vn(1, 2, 1)})
	table.insert(p, {act = 'cube', node = 'doors:door_wood_b', param2 = 1, loc = vn(21, 21, y + 2), size = vn(1, 1, 1)})
end

for _, item in pairs(default_exits) do
	table.insert(p, 2, table.copy(item))
end

for i = #p, 1, -1 do
	table.insert(q, 6, p[i])
end

register_geomorph({
	name = 'stair_base',
	areas = 'geomoria',
	data = q,
})


-----------------------------------------------------


p = {}
	--[[
	{act = 'cube', node = 'mapgen:sky_scrith', loc = vn(0, 0, 0), size = vn(80, 80, 80)},
	{act = 'cube', node = 'air', loc = vn(1, 1, 1), size = vn(78, 78, 78)},
	{act = 'cube', node = 'default:desert_sand', loc = vn(1, 1, 1), size = vn(78, ground, 78)}
}

for _, i in pairs(upper_cross) do
	local j = table.copy(i)
	j.loc = table.copy(j.loc)
	j.loc.y = j.loc.y - 1
	j.size = table.copy(j.size)
	j.size.y = 1
	j.node = mod_name..':cloud_hard'
	table.insert(p, j)
end
--]]

for i = 1, 35 do
	table.insert(p, {act = 'cube', node = 'default:stone_block', loc = vn(40 - i, ground + 35 - i, 40 - i), size = vn(i * 2 - 1, 1, i * 2 - 1)})

	if i < 34 and i > 3 then
		if i % 5 == 4 and i > 20 then
			table.insert(p, {act = 'cube', node = 'default:stone_block', loc = vn(50 - i, ground + 35 - i, 50 - i), size = vn(i * 2 - 21, 1, i * 2 - 21)})
		elseif i % 5 == 3 and i > 20 then
			table.insert(p, {act = 'cube', node = 'air', loc = vn(50 - i, ground + 35 - i, 50 - i), size = vn(i * 2 - 21, 1, i * 2 - 21)})

			table.insert(p, {act = 'cube', node = 'air', loc = vn(51 - i, ground + 35 - i, 51 - i), size = vn(7 + i - 23, 1, i - 23), treasure = 2})
			table.insert(p, {act = 'cube', node = 'air', loc = vn(51 - i, ground + 35 - i, 31), size = vn(7 + i - 23, 1, 7), treasure = 2})
			table.insert(p, {act = 'cube', node = 'air', loc = vn(51 - i, ground + 35 - i, 41), size = vn(7 + i - 23, 1, 7), treasure = 2})
			table.insert(p, {act = 'cube', node = 'air', loc = vn(51 - i, ground + 35 - i, 51), size = vn(7 + i - 23, 1, i - 23), treasure = 2})

			table.insert(p, {act = 'cube', node = 'air', loc = vn(44, ground + 35 - i, 51 - i), size = vn(7 + i - 23, 1, i - 23), treasure = 2})
			table.insert(p, {act = 'cube', node = 'air', loc = vn(44, ground + 35 - i, 31), size = vn(7 + i - 23, 1, 7), treasure = 2})
			table.insert(p, {act = 'cube', node = 'air', loc = vn(44, ground + 35 - i, 41), size = vn(7 + i - 23, 1, 7), treasure = 2})
			table.insert(p, {act = 'cube', node = 'air', loc = vn(44, ground + 35 - i, 51), size = vn(7 + i - 23, 1, i - 23), treasure = 2})
		else
			table.insert(p, {act = 'cube', node = 'air', loc = vn(50 - i, ground + 35 - i, 50 - i), size = vn(i * 2 - 21, 1, i * 2 - 21)})
		end

		if i > 25 then
			table.insert(p, {act = 'cube', node = 'default:stone_block', loc = vn(42 - i, ground + 35 - i, 29), size = vn(i * 2 - 5, 1, 1)})
			table.insert(p, {act = 'cube', node = 'default:stone_block', loc = vn(42 - i, ground + 35 - i, 49), size = vn(i * 2 - 5, 1, 1)})
		end
		table.insert(p, {act = 'cube', node = 'default:stone_block', loc = vn(42 - i, ground + 35 - i, 39), size = vn(i * 2 - 5, 1, 1)})
		table.insert(p, {act = 'cube', node = 'default:stone_block', loc = vn(36, ground + 35 - i, 42 - i), size = vn(7, 1, i * 2 - 5)})
		table.insert(p, {act = 'cube', node = 'air', loc = vn(37, ground + 35 - i, 42 - i), size = vn(5, 1, i * 2 - 5)})
	end
end

--[[
for _, item in pairs(default_exits) do
	table.insert(p, table.copy(item))
end
--]]

register_geomorph({
	name = 'pyramid',
	areas = 'ruins',
	ruin = 0,
	rarity = 10,
	data = p,
})


-----------------------------------------------------


p = {
	{act = 'cube', node = 'mapgen:sky_scrith', loc = vn(0, 0, 0), size = vn(80, 80, 80)},
	{act = 'cube', node = 'default:water_source', loc = vn(1, 1, 1), size = vn(78, 70, 78)},
	{act = 'cube', node = 'air', loc = vn(1, 70, 1), size = vn(78, 8, 78)},
	{act = 'cube', node = 'default:dirt', loc = vn(1, 1, 1), size = vn(78, ground, 78)},
}

for _, item in pairs(lower_cross) do
	local copy = table.copy(item)
	copy.node = 'default:glass'
	copy.loc = vector.add(copy.loc, -1)
	copy.size = vector.add(copy.size, 2)
	table.insert(p, copy)
end

for i = 1, 35 do
	if i > 2 then
		local n = 'default:glass'
		if not mod.let_there_be_light then
			if (i + 3) % 10 == 0 then
				n = 'default:lamp'
			end
		end
		table.insert(p, {act = 'cube', node = n, loc = vn(40 - i, ground + 35 - i, 40 - i), size = vn(i * 2 - 1, 1, i * 2 - 1)})
	end
	if i > 2 then
		local n = 'air'
		if i == 35 then
			n = 'default:sandstone_block'
		end
		table.insert(p, {act = 'cube', node = n, loc = vn(41 - i, ground + 35 - i, 41 - i), size = vn(i * 2 - 3, 1, i * 2 - 3)})
	end
end

for _, item in pairs(lower_cross) do
	local copy = table.copy(item)
	copy.node = 'air'
	table.insert(p, copy)
end

if not mod.let_there_be_light then
	--table.insert(p, {act = 'cube', node = 'default:lamp', loc = vn(20, ground, 20), size = vn(39, 1, 39)})
	--table.insert(p, {act = 'cube', node = 'default:sandstone_block', loc = vn(21, ground, 21), size = vn(37, 1, 37)})
	table.insert(p, {act = 'cube', node = 'default:lamp', loc = vn(30, ground, 30), size = vn(19, 1, 19)})
end
table.insert(p, {act = 'cube', node = 'default:sandstone_block', loc = vn(31, ground, 31), size = vn(17, 1, 17)})
if not mod.let_there_be_light then
	table.insert(p, {act = 'cube', node = 'default:lamp', loc = vn(38, ground, 38), size = vn(3, 1, 3)})
end
table.insert(p, {act = 'cube', node = 'default:desert_stone', loc = vn(36, ground + 1, 36), size = vn(7, 1, 7)})
table.insert(p, {act = 'cube', node = 'air', loc = vn(37, ground + 1, 37), size = vn(5, 1, 5)})

for _, item in pairs(default_exits) do
	table.insert(p, table.copy(item))
end

register_geomorph({
	name = 'pyramid_glass',
	areas = 'walking',
	ruin = 0,
	rarity = 10,
	data = p,
})


-----------------------------------------------------


do
	local plaster = mod_name..':plaster'
	local floor_ceiling = mod_name..':floor_ceiling'
	local roof = mod_name..':roof'
	local sidewalk = 'default:stone_block'

	p = {
		{act = 'cube', node = mod_name..':sky_scrith', loc = vn(0, 0, 0), size = vn(80, 80, 80), },
		{act = 'cube', node = mod_name..':black_scrith', loc = vn(0, 1, 0), size = vn(80, 76, 80), },
		{act = 'cube', node = 'default:stone', loc = vn(1, 1, 1), size = vn(78, 18, 78), },
		{act = 'cube', node = 'default:brick', loc = vn(1, 19, 1), size = vn(78, 58, 78), },
		{act = 'cube', node = 'air', loc = vn(2, 19, 2), size = vn(76, 60, 76), },
		{act = 'cube', node = sidewalk, loc = vn(2, 19, 2), size = vn(76, 2, 76), },
		{act = 'cube', node = 'air', loc = vn(4, 19, 4), size = vn(72, 2, 72), },
		{act = 'cube', node = sidewalk, loc = vn(2, 50, 2), size = vn(76, 1, 76), },
		{act = 'cube', node = 'air', loc = vn(4, 50, 4), size = vn(72, 1, 72), },
		{act = 'cube', node = mod_name..':road', loc = vn(4, 19, 4), size = vn(72, 1, 72), },
		{act = 'cube', node = sidewalk, loc = vn(13, 19, 13), size = vn(54, 2, 54), },
		{act = 'cube', node = sidewalk, loc = vn(13, 50, 13), size = vn(54, 1, 54), },
		{act = 'cube', node = 'default:brick', loc = vn(15, 21, 15), size = vn(50, 49, 50), },
		{act = 'cube', node = 'air', loc = vn(16, 21, 16), size = vn(48, 58, 48), },
		{act = 'cube', node = roof, loc = vn(16, 68, 16), size = vn(48, 1, 48), },
	}
	local skip = { [4] = true, [8] = true, [12] = true }
	for f = 1, 9 do
		if f < 9 then
			table.insert(p, { action = 'cube', node = floor_ceiling, location = vn(16, 14 + f * 6, 16), size = vn(48, 1, 48), })
		end

		for o = 1, 15 do
			if f < 9 and o > 3 and o < 13
			and (not skip[o] or f ~= 1)
			and (o ~= 8 or f ~= 6) then
				table.insert(p, { action = 'cube', node = 'default:obsidian_glass', location = vn(-2 + o * 5, 16 + f * 6, 15), size = vn(4, 3, 50), intersect = true, })
				table.insert(p, { action = 'cube', node =  'default:obsidian_glass', location = vn(15, 16 + f * 6, -2 + o * 5), size = vn(50, 3, 4), intersect = true, })
			end
			if (o ~= 8 or f ~= 6) and (not skip[o] or f ~= 1) then
				table.insert(p, { action = 'cube', node = 'default:obsidian_glass', location = vn(-2 + o * 5, 16 + f * 6, 1), size = vn(4, 3, 1), intersect = true, })
				table.insert(p, { action = 'cube', node =  'default:obsidian_glass', location = vn(1, 16 + f * 6, -2 + o * 5), size = vn(1, 3, 4), intersect = true, })
				table.insert(p, { action = 'cube', node = 'default:obsidian_glass', location = vn(-2 + o * 5, 16 + f * 6, 78), size = vn(4, 3, 1), intersect = true, })
				table.insert(p, { action = 'cube', node =  'default:obsidian_glass', location = vn(78, 16 + f * 6, -2 + o * 5), size = vn(1, 3, 4), intersect = true, })
			end
		end

		if f < 9 then
			table.insert(p, { action = 'cube', node = plaster, location = vn(16, 15 + f * 6, 37), size = vn(48, 5, 1), })
			table.insert(p, { action = 'cube', node = plaster, location = vn(16, 15 + f * 6, 42), size = vn(48, 5, 1), })

			table.insert(p, { action = 'cube', node = plaster, location = vn(37, 15 + f * 6, 16), size = vn(1, 5, 48), })
			table.insert(p, { action = 'cube', node = plaster, location = vn(42, 15 + f * 6, 16), size = vn(1, 5, 48), })

			table.insert(p, { action = 'cube', node =  'air', location = vn(37, 15 + f * 6, 39), size = vn(8, 3, 2), })
			table.insert(p, { action = 'cube', node =  'air', location = vn(39, 15 + f * 6, 37), size = vn(2, 3, 8), })

			table.insert(p, { action = 'cube', node =  'air', location = vn(37, 15 + f * 6, 19), size = vn(8, 3, 2), })
			table.insert(p, { action = 'cube', node =  'air', location = vn(19, 15 + f * 6, 37), size = vn(2, 3, 8), })
			table.insert(p, { action = 'cube', node =  'air', location = vn(37, 15 + f * 6, 59), size = vn(8, 3, 2), })
			table.insert(p, { action = 'cube', node =  'air', location = vn(59, 15 + f * 6, 37), size = vn(2, 3, 8), })
		end
	end

	for _, i in pairs(mod.geo_parts['lower_cross']) do
		local j = table.copy(i)
		table.insert(p, j)
	end
	for _, i in pairs(mod.geo_parts['upper_cross']) do
		local j = table.copy(i)
		table.insert(p, j)
	end
	table.insert(p, { action = 'cube', node =  'air', location = vn(38, 21, 38), size = vn(4, 54, 4), })
	for _, i in pairs(mod.geo_parts['default_exits']) do
		table.insert(p, i)
	end

	register_geomorph({
		name = 'city_block',
		areas = 'walking',
		ruin = 0,
		rarity = 10,
		data = p,
	})
end


-----------------------------------------------------


p = {
	--{act = 'cube', node = 'mapgen:sky_scrith', loc = vn(0, 0, 0), size = vn(80, 80, 80)},
	--{act = 'cube', node = 'air', loc = vn(1, 1, 1), size = vn(78, 78, 78)},
	--{act = 'cube', node = 'default:dirt', loc = vn(1, 1, 1), size = vn(78, ground, 78)},
	--{act = 'cube', node = 'default:dirt_with_grass', loc = vn(1, ground, 1), size = vn(78, 1, 78)},
	{act = 'cube', node = 'default:stone_block', loc = vn(30, ground + 1, 30), size = vn(20, 24, 20)},
	{act = 'cube', node = 'default:stone_block', loc = vn(31, ground + 28, 31), size = vn(18, 1, 18)},
	{act = 'cube', node = 'default:stone_block', loc = vn(31, ground + 30, 31), size = vn(18, 1, 18)},
	{act = 'cube', node = 'default:stone_block', loc = vn(32, ground + 25, 32), size = vn(16, 6, 16)},
	{act = 'cube', node = 'air', loc = vn(33, ground + 25, 33), size = vn(14, 5, 14)},
	{act = 'cube', node = 'air', loc = vn(32, ground + 25, 38), size = vn(16, 3, 4)},
	{act = 'cube', node = 'air', loc = vn(32, ground + 25, 36), size = vn(16, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(32, ground + 25, 43), size = vn(16, 3, 1)},
	{act = 'cube', node = 'air', loc = vn(38, ground + 25, 32), size = vn(4, 3, 16)},
	{act = 'cube', node = 'air', loc = vn(36, ground + 25, 32), size = vn(1, 3, 16)},
	{act = 'cube', node = 'air', loc = vn(43, ground + 25, 32), size = vn(1, 3, 16)},
	{act = 'cube', node = 'default:stone', loc = vn(38, ground + 25, 38), size = vn(4, 1, 4)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 2, loc = vn(34, ground + 1, 50), size = vn(12, 24, 24)},
	{act = 'stair', node = 'default:stone_block', param2 = 2, loc = vn(33, ground + 1, 50), size = vn(1, 24, 24)},
	{act = 'stair', node = 'default:stone_block', param2 = 2, loc = vn(38, ground + 1, 50), size = vn(1, 24, 24)},
	{act = 'stair', node = 'air', param2 = 2, loc = vn(39, ground, 50), size = vn(2, 25, 25)},
	{act = 'cube', node = 'default:water_source', loc = vn(39, ground + 24, 50), size = vn(2, 1, 1)},
	{act = 'stair', node = 'default:stone_block', param2 = 2, loc = vn(41, ground + 1, 50), size = vn(1, 24, 24)},
	{act = 'stair', node = 'default:stone_block', param2 = 2, loc = vn(46, ground + 1, 50), size = vn(1, 24, 24)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 0, loc = vn(34, ground + 1, 6), size = vn(12, 24, 24)},
	{act = 'stair', node = 'default:stone_block', param2 = 0, loc = vn(33, ground + 1, 6), size = vn(1, 24, 24)},
	{act = 'stair', node = 'default:stone_block', param2 = 0, loc = vn(38, ground + 1, 6), size = vn(1, 24, 24)},
	{act = 'stair', node = 'air', param2 = 0, loc = vn(39, ground, 5), size = vn(2, 25, 25)},
	{act = 'cube', node = 'default:water_source', loc = vn(39, ground + 24, 29), size = vn(2, 1, 1)},
	{act = 'stair', node = 'default:stone_block', param2 = 0, loc = vn(41, ground + 1, 6), size = vn(1, 24, 24)},
	{act = 'stair', node = 'default:stone_block', param2 = 0, loc = vn(46, ground + 1, 6), size = vn(1, 24, 24)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 3, loc = vn(50, ground + 1, 34), size = vn(24, 24, 12)},
	{act = 'stair', node = 'default:stone_block', param2 = 3, loc = vn(50, ground + 1, 33), size = vn(24, 24, 1)},
	{act = 'stair', node = 'default:stone_block', param2 = 3, loc = vn(50, ground + 1, 38), size = vn(24, 24, 1)},
	{act = 'stair', node = 'air', param2 = 3, loc = vn(50, ground, 39), size = vn(25, 25, 2)},
	{act = 'cube', node = 'default:lava_source', loc = vn(50, ground + 24, 39), size = vn(1, 1, 2)},
	{act = 'stair', node = 'default:stone_block', param2 = 3, loc = vn(50, ground + 1, 41), size = vn(24, 24, 1)},
	{act = 'stair', node = 'default:stone_block', param2 = 3, loc = vn(50, ground + 1, 46), size = vn(24, 24, 1)},

	{act = 'stair', node = 'stairs:stair_stone', param2 = 1, loc = vn(6, ground + 1, 34), size = vn(24, 24, 12)},
	{act = 'stair', node = 'default:stone_block', param2 = 1, loc = vn(6, ground + 1, 33), size = vn(24, 24, 1)},
	{act = 'stair', node = 'default:stone_block', param2 = 1, loc = vn(6, ground + 1, 38), size = vn(24, 24, 1)},
	{act = 'stair', node = 'air', param2 = 1, loc = vn(5, ground, 39), size = vn(25, 25, 2)},
	{act = 'cube', node = 'default:lava_source', loc = vn(29, ground + 24, 39), size = vn(1, 1, 2)},
	{act = 'stair', node = 'default:stone_block', param2 = 1, loc = vn(6, ground + 1, 41), size = vn(24, 24, 1)},
	{act = 'stair', node = 'default:stone_block', param2 = 1, loc = vn(6, ground + 1, 46), size = vn(24, 24, 1)},

	-- fireproofing
	{act = 'cube', node = 'air', loc = vn(13, ground + 6, 39), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(66, ground + 6, 39), size = vn(1, 2, 2)},
	{act = 'cube', node = 'air', loc = vn(39, ground + 6, 13), size = vn(2, 2, 1)},
	{act = 'cube', node = 'air', loc = vn(39, ground + 6, 66), size = vn(2, 2, 1)},
	{ act = 'cube', node = 'default:stone', loc = vn(16, ground - 2, 16), size = vn(48, 3, 48), },
	{act = 'cube', node = 'default:stone', loc = vn(5, ground - 2, 33), size = vn(70, 3, 14)},
	{act = 'cube', node = 'default:stone', loc = vn(33, ground - 2, 5), size = vn(14, 3, 70)},
}

for i = 1, 7 do
	table.insert(p, { action = 'cube', node =  'default:stone_block', location = vn(30 - (8 - i) * 2, ground + 1, 30 - (8 - i) * 2), size = vn(20 + (8 - i) * 4, i * 3, 20 + (8 - i) * 4), })
end

--[[
for _, i in pairs(upper_cross) do
	local j = table.copy(i)
	j.loc = table.copy(j.loc)
	j.loc.y = j.loc.y - 1
	j.size = table.copy(j.size)
	j.size.y = 1
	j.intersect = {'air'}
	j.node = mod_name..':cloud_hard'
	table.insert(p, j)
end

for _, item in pairs(default_exits) do
	table.insert(p, table.copy(item))
end
--]]

register_geomorph({
	name = 'pyramid_temple',
	areas = 'ruins',
	ruin = 0,
	rarity = 10,
	data = p,
})


-----------------------------------------------------
