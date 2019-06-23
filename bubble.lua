-- Duane's mapgen bubble.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

local Geomorph = geomorph.Geomorph

local math_abs = math.abs
local math_floor = math.floor
local math_max = math.max
local math_sqrt = math.sqrt
local node = layer_mod.node
local VN = vector.new


local cave_biome_names = {}
-- check
function Mapgen:bubble_cave()
	local data, p2data = self.data, self.p2data
	local minp, maxp, area = self.minp, self.maxp, self.area
	local center = vector.round(vector.divide(vector.add(minp, maxp), 2))
	local ystride = area.ystride
	local cave_biomes = mod.cave_biomes or {}

	if #cave_biome_names < 1 then
		for n in pairs(cave_biomes) do
			table.insert(cave_biome_names, n)
		end
	end

	local biome = cave_biomes[cave_biome_names[self.gpr:next(1, math_max(1, #cave_biome_names))]] or {}
	self.biome = biome

	local n_b_stone = node[biome.node_stone] or n_stone
	local n_ceiling = node[biome.node_ceiling]
	local n_lining = node[biome.node_lining]
	local n_floor = node[biome.node_floor]
	local n_fluid = node[biome.node_cave_liquid]
	local n_gas = node[biome.node_gas] or n_air
	local surface_depth = biome.surface_depth or 1

	if biome.node_cave_liquid == 'default:lava_source'
	or biome.gas == 'default:lava_source' then
		self.placed_lava = true
	end

	local geo = Geomorph.new()
	local pos = VN(0,0,0)
	local size = VN(80,80,80)
	geo:add({
		action = 'cube',
		node = biome.node_stone or 'default:stone',
		location = table.copy(pos),
		size = table.copy(size),
	})
	if biome.node_lining then
		geo:add({
			action = 'sphere',
			node = biome.node_lining,
			location = vector.add(pos, 1),
			intersect = { biome.node_stone or 'default:stone' },
			size = vector.add(size, -2),
		})
	end
	geo:add({
		action = 'sphere',
		node = 'air',
		location = vector.add(pos, surface_depth + 1),
		size = vector.add(size, -(2 * (surface_depth + 1))),
	})
	geo:write_to_map(self)

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local ground = self.noise['flat_cave_1'].map[index]

			if ground < -10 then
				ground = ground + 10
				ground = - (ground * ground) - 10
			elseif ground > 0 then
				---------------------------
				-- cpu drain
				---------------------------
				ground = math_sqrt(ground)
				---------------------------
			end
			ground = math_floor(ground)

			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y - 1 do
				local diff = math_abs(center.y - y)
				if diff >= cave_level + ground
				and diff < cave_level + ground + surface_depth
				and data[ivm] == n_air then
					if y < center.y then
						data[ivm] = n_lining or n_floor or n_b_stone
						p2data[ivm] = 0
					else
						data[ivm] = n_lining or n_ceiling or n_b_stone
						p2data[ivm] = 0
					end
				elseif diff < cave_level + ground and data[ivm] == n_air then
					if n_fluid and y <= center.y - cave_level then
						data[ivm] = n_fluid
						p2data[ivm] = 0
					else
						data[ivm] = n_gas
						p2data[ivm] = 0
					end
				elseif data[ivm] == n_air then
					if diff < 10 then
						data[ivm] = n_floor or n_b_stone
					else
						data[ivm] = n_b_stone
					end
					p2data[ivm] = 0
				end

				ivm = ivm + ystride
			end

			index = index + 1
		end
	end
end
