-- Duane's mapgen tg_simple_caves.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


tg_simple_caves = {}
local mod, layers_mod = tg_simple_caves, mapgen
local mod_name = 'tg_simple_caves'
local VN = vector.new


local cave_underground = 5
function mod.generate_simple_caves(params)
	if params.share.disruptive then
		return
	end

	local t_caves = os.clock()

	local pr = params.gpr
	local geo = Geomorph.new(params)

	for _ = 1, pr:next(1, 50) do
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

		if not params.share.no_biome then
			geo:add({
				action = 'sphere',
				intersect = 'default:stone',
				node = layers_mod.mod_name .. ':placeholder_lining',
				location = vector.add(pos, -2),
				underground = cave_underground,
				size = vector.add(size, 4),
			})
		end

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

	layers_mod.time_caves = (layers_mod.time_caves or 0) + os.clock() - t_caves
end


layers_mod.register_mapgen('tg_simple_caves', mod.generate_simple_caves)
