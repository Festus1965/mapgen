-- Duane's mapgen tg_roads_ruins.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local NUM_DEPOSITS = 50


local mod, layers_mod = mapgen, mapgen
local mod_name = mod.mod_name
local chunksize = tonumber(minetest.settings:get('chunksize') or 5)
local chunk_offset = math.floor(chunksize / 2) * 16;
local VN = vector.new


function mod.generate_simple_ores(params)
	---------------------------------
	local force_alt, num_deposits
	---------------------------------

	local t_ore = os.clock()

	local minp = params.chunk_minp
	local f_alt = force_alt
	local pr = params.gpr

	if not f_alt then
		f_alt = minp.y
		-- Correct for higher planes.
		if params.sealevel > 0 then
			f_alt = f_alt - params.sealevel
		end

		f_alt = math.max(0, - math.floor((f_alt + chunk_offset) / (chunksize * 16)) - 1)
		f_alt = f_alt + math.max(0, pr:next(-6, 3) + pr:next(-6, 3))
		--f_alt = math.max(f_alt, math.floor(math.max(math.abs(minp.x), math.abs(minp.z)) / 3000))
	end

	local volume = params.csize.x * params.csize.y * params.csize.z
	if not num_deposits then
		num_deposits = math.floor(NUM_DEPOSITS * volume / (80 * 80 * 80))
	end

	if not params.ore_intersect then
		params.ore_intersect = table.copy(mod.default_ore_intersect)
	end

	local geo = Geomorph.new(params)
	for _ = 1, num_deposits do
		local ore = mod.get_ore(params.gpr, f_alt)

		local size = VN(
			pr:next(1, 4) + pr:next(1, 4),
			pr:next(1, 4) + pr:next(1, 4),
			pr:next(1, 4) + pr:next(1, 4)
		)
		if params.placed_lava then
			size = VN(size, 2)
		end

		local max_range = VN(
			params.csize.x - size.x,
			params.csize.y - size.y - 3,
			params.csize.z - size.z
		)

		if max_range.y > 3 then
			local p = VN(
				pr:next(0, max_range.x),
				pr:next(3, max_range.y),
				pr:next(0, max_range.z)
			)

			geo:add({
				action = 'cube',
				node = ore,
				random = 4,
				location = p,
				size = size,
				intersect = params.ore_intersect,
			})
		end
	end
	geo:write_to_map()

	--[[
	-- Change the colors of all default stone.
	-- The time for this is negligible.
	if params.stone_layers then
		local area = params.area
		local data, p2data = params.data, params.p2data
		local stone_layers = params.stone_layers
		local ystride = area.ystride
		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				local ivm = area:index(x, minp.y, z)
				for y = minp.y, maxp.y do
					local dy = y - minp.y

					if data[ivm] == n_stone then
						p2data[ivm] = stone_layers[dy]
					end

					ivm = ivm + ystride
				end
			end
		end
	end
	--]]

	mod.time_ore = mod.time_ore + os.clock() - t_ore
end


layers_mod.register_mapgen('tg_simple_ores', mod.generate_simple_ores)
