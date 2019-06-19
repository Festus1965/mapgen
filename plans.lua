-- Boxes mapgen plans.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017, 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


-- Rotation:
-- 0 Z+   1 X+   2 Z-   3 X-
-- ladders:  2 X+   3 X-   4 Z+   5 Z-


local mod = mapgen
local mod_name = 'mapgen'


local vn = vector.new
local register_geomorph = geomorph.register_geomorph
local ground = 40
local p
mod.geo_parts = {}


-----------------------------------------------------


p = {}

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

register_geomorph({
	name = 'pyramid',
	areas = 'ruins',
	ruin = 0,
	rarity = 10,
	data = p,
})


-----------------------------------------------------


p = {
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

register_geomorph({
	name = 'pyramid_temple',
	areas = 'ruins',
	ruin = 0,
	rarity = 10,
	data = p,
})


-----------------------------------------------------


p = nil
