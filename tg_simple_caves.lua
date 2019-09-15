-- Duane's mapgen tg_simple_caves.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local VN = vector.new
local chunksize = tonumber(minetest.settings:get('chunksize') or 5)
local chunk_offset = math.floor(chunksize / 2) * 16;


local mod, layers_mod
if minetest.get_modpath('realms') then
	layers_mod = realms
	mod = floaters
else
	layers_mod = mapgen
	mod = mapgen
end

local mod_name = mod.mod_name
local ground_c, move_down


local under_stones = {
	{'default:stone', 'default:water_source', nil},
	{'default:sandstone', 'default:water_source', nil},
	{'default:desert_stone', 'default:water_source', nil},
	{'default:silver_sandstone', 'default:water_source', nil},
	{mod_name..':basalt', 'default:lava_source', nil},
	{mod_name..':granite', 'default:lava_source', nil},
	{mod_name..':stone_with_lichen', 'default:water_source', nil},
	{mod_name..':stone_with_algae', 'default:water_source', mod_name..':glowing_fungal_stone'},
	{mod_name..':stone_with_moss', 'default:water_source', mod_name..':glowing_fungal_stone'},
	{mod_name..':stone_with_salt', 'default:water_source', mod_name..':radioactive_ore'},
	{mod_name..':hot_rock', 'default:lava_source', nil},
}


local cave_underground = 5
function mod.generate_simple_caves(params)
	local t_caves = os.clock()

	local minp, maxp = params.isect_minp, params.isect_maxp
	local area, data, p2data = params.area, params.data, params.vmparam2
	local csize = vector.add(vector.subtract(maxp, minp), 1)

	local node = layers_mod.node
	local n_air = node['air']
	local n_ignore = node['ignore']
	local n_water = node['default:water_source']
	local n_stone = node['default:stone']
	local n_lava = node['default:lava_source']

	local pr = params.gpr
	--local chunk_yeg_y = math.floor((minp.y + chunk_offset + 80) / 80) % 10

	local geo = Geomorph.new(params)
	--local stone_type, liquid, deco = unpack(under_stones[pr:next(1, #under_stones)])
	--[[
	local center = vector.add(VN(40, 0, 40), minp)
	local ivm = params.area:indexp(center)
	local curr_stone = minetest.get_name_from_content_id(params.data[ivm])
	local found
	for _, t in pairs(ore_intersect) do
		if t == curr_stone then
			found = true
			break
		end
	end
	if not found then
		curr_stone = stone_type
	end

	if pr:next(1, 2) == 1 then
		stone_type = curr_stone
	end
	--]]

	for i = 1, pr:next(1, 50) do
		local size = VN(
			pr:next(9, 25),
			pr:next(9, 25),
			pr:next(9, 25)
		)
		local big = pr:next(1, 10)
		if big == 1 then
			size.x = pr:next(9, 78)
		elseif big == 2 then
			size.y = pr:next(9, 78)
		elseif big == 3 then
			size.z = pr:next(9, 78)
		end

		local pos = VN(
			pr:next(1, 79 - size.x),
			pr:next(1, 79 - size.y),
			pr:next(1, 79 - size.z)
		)

		geo:add({
			action = 'sphere',
			intersect = 'default:stone',
			node = layers_mod.mod_name .. ':placeholder_lining',
			location = vector.add(pos, -2),
			underground = cave_underground,
			size = vector.add(size, 4),
		})

		geo:add({
			action = 'sphere',
			node = 'air',
			location = vector.add(pos, 1),
			underground = cave_underground,
			size = vector.add(size, -2),
		})
		geo:add({
			action = 'sphere',
			node = 'air',
			random = 6,
			location = pos,
			underground = cave_underground,
			size = size,
		})

		--[[
		if stone_type ~= curr_stone and deco then
			geo:add({
				action = 'sphere',
				node = deco,
				random = 20,
				location = pos,
				underground = cave_underground,
				intersect = stone_type,
				size = size,
			})
		end

		if (chunk_yeg_y < 1 or chunk_yeg_y > 4) and liquid then
			if pr:next(1, 3) == 1 then
				geo:add({
					action = 'sphere',
					node = liquid,
					random = 50,
					location = pos,
					underground = cave_underground,
					intersect = stone_type,
					size = size,
				})
			end
		end
		--]]
	end

	geo:write_to_map(0)
end


layers_mod.register_mapgen('tg_simple_caves', mod.generate_simple_caves)
