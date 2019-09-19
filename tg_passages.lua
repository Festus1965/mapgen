-- Duane's mapgen tg_passages.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local altitude_cutoff_high = 30
local altitude_cutoff_low = -10
local altitude_cutoff_low_2 = 63
local water_diff = 8
local VN = vector.new
local chunksize = tonumber(minetest.settings:get('chunksize') or 5)
local chunk_offset = math.floor(chunksize / 2) * 16;

local TREASURE_RARITY = 10


local passages_replace_nodes = {
	'group:soil',
	'group:stone',
	'group:sand',
	'group:ore',
	'default:cobble',
	'default:mossycobble',
	'default:gravel',
	'default:clay',
	'default:cave_ice',
	'default:ice',
	'default:snowblock',
	'default:snow',
	'default:sandstone',
}


function mod.passages(params)
	if params.share.height_min and params.share.height_min < params.sealevel then
		return
	end

	local node = layers_mod.node
	local replace = mod.passages_replace

	local minp, maxp = params.isect_minp, params.isect_maxp
	local data, p2data = params.data, params.p2data
	local area = params.area
	local csize = params.csize
	local seed = params.map_seed
	local ps = params.gpr
	local ystride = area.ystride

	local meet_at = vector.new(24, 0, 49)
	local divs = vector.floor(vector.divide(csize, 4))

	local geo = Geomorph.new(params)
	local surface = params.share.surface
	local x, z, l, pos, size = 6, 12
	local lx, ly, lz, ll
	local alt = 0
	local div_size = 4
	local up

	-- for placing dungeon decor
	if not mod.carpetable then
		mod.carpetable = {
			[node['default:stone']] = true,
			[node['default:sandstone']] = true,
			[node['default:desert_stone']] = true,
			[node['default:cobble']] = true,
			[node['default:mossycobble']] = true,
		}
	end

	-- for placing cobwebs, etc.
	if not mod.sides then
		mod.sides = {
			{ i = -1, p2 = 3 },
			{ i = 1, p2 = 2 },
			{ i = - area.zstride, p2 = 5 },
			{ i = area.zstride, p2 = 4 },
			{ i = - area.ystride, p2 = 1 },
			{ i = area.ystride, p2 = 0 },
		}
	end

	if not params.share.treasure_chests then
		params.share.treasure_chests = {}
	end

	for y = math.floor(csize.y / (div_size * 2)) * div_size * 2, 0, - div_size * 2 do
		local num = ps:next(2, 6)
		local join
		local bct = 0
		for ct = 1, num do
			bct = bct + 1
			if alt % 2 == 0 then
				if lz then
					z = ps:next(lz, lz + ll - 1)
					--z = lz
					if ly ~= y then
						join = vector.new(x * div_size, y, z * div_size)
					end
				else
					z = ps:next(1, divs.z - 2)
				end
				x = ps:next(1, 4)
				l = ps:next(1, divs.x - x - 2)
				if lz and x + l < lx then
					l = lx - x + 1
				end
				pos = vector.new(x * div_size, y, z * div_size)
				size = vector.new(l * div_size, div_size, div_size)
			else
				if lx then
					x = ps:next(lx, lx + ll - 1)
					--x = lx
					if ly ~= y then
						join = vector.new(x * div_size, y, z * div_size)
					end
				else
					x = ps:next(1, divs.x - 2)
				end
				z = ps:next(1, 4)
				l = ps:next(1, divs.z - z - 2)
				if lx and z + l < lz then
					l = lz - z + 1
				end
				pos = vector.new(x * div_size, y, z * div_size)
				size = vector.new(div_size, div_size, l * div_size)
			end

			local good = true
			for z = pos.z, pos.z + size.z do
				if not good then
					break
				end

				if z < 0 or z >= csize.z then
					good = false
					join = nil
					break
				end

				for x = pos.x, pos.x + size.x do
					if x < 0 or x >= csize.x then
						good = false
						join = nil
						break
					end

					local sur = surface[minp.z + z][minp.x + x]
					if not sur or sur.top <= minp.y + pos.y + size.y + 2 then
						good = false
						join = nil
						break
					end
				end
			end

			if good then
				lx, ly, lz, ll = x, y, z, l
				alt = alt + 1

				geo:add({
					action = 'cube',
					node = 'air',
					location = table.copy(pos),
					size = table.copy(size),
					treasure = TREASURE_RARITY,
				})

				if join then
					geo:add({
						action = 'cube',
						node = 'air',
						location = table.copy(join),
						size = vector.new(div_size, div_size * 2 + 1, div_size),
					})
					join = nil
				end
			elseif bct < 1000 then
				ct = ct - 1
			end
		end

		if bct > 999 then
			return
		end

		if params.passages_entrances and math.abs(params.passages_entrances - minp.y - y) <= div_size then
			geo:add({
				action = 'cube',
				node = 'air',
				location = vector.new(0, y, 11 * div_size),
				size = vector.new(csize.x, div_size, div_size),
				intersect = passages_replace_nodes,
				move_earth = true,
			})
			geo:add({
				action = 'cube',
				node = 'air',
				location = vector.new(6 * div_size, y, 0),
				size = vector.new(div_size, div_size, csize.z),
				intersect = passages_replace_nodes,
				move_earth = true,
			})
		end
	end

	if minp.y == params.realm_minp.y then
		geo:add({
			action = 'cube',
			node = 'air',
			location = vector.new(6 * 4, 0, 11 * 4),
			size = vector.new(div_size * 2, div_size * 2, div_size * 2),
		})
		geo:add({
			action = 'cube',
			node = 'air',
			location = vector.new(0, 0, 11 * 4),
			size = vector.new(csize.x, div_size, div_size * 2),
		})
		geo:add({
			action = 'cube',
			node = 'air',
			location = vector.new(6 * 4, 0, 0),
			size = vector.new(div_size * 2, div_size, csize.z),
		})
	end

	geo:write_to_map(0)

	local n_web = node[mod_name..':spider_web']
	local n_puddle = node[mod_name..':puddle_ooze']
	local n_broken_door = node[mod_name..':broken_door']
	local n_air = node['air']

	for _, shape in pairs(geo.shapes) do
		if shape.size.y == div_size then
			local pos = vector.add(shape.location, minp)
			local size = shape.size
			for z = pos.z, pos.z + size.z - 1 do
				for x = pos.x, pos.x + size.x - 1 do
					local ivm = params.area:index(x, pos.y, z)
					for _ = 1, size.y do
						if data[ivm] == n_air then
							for i, s in pairs(mod.sides) do
								if mod.carpetable[data[ivm + s.i]] then
									local sr = params.gpr:next(1, 1000)
									if sr < 3 then
										data[ivm] = n_puddle
										p2data[ivm] = s.p2
									elseif i == 5 and sr < 4 then
										data[ivm] = n_broken_door
										p2data[ivm] = s.p2
									elseif sr < 8 then
										data[ivm] = n_web
										p2data[ivm] = s.p2
									end
								end
							end
						end

						ivm = ivm + ystride
					end
				end
			end
		end
	end
end
