-- Duane's mapgen mapgen.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


------------------------------------
-- store inverted schematics
-- remove unused variables
------------------------------------


local DEBUG
local mod = mapgen
local mod_name = 'mapgen'


local math_abs = math.abs
local math_cos = math.cos
local math_ceil = math.ceil
local math_floor = math.floor
local math_max = math.max
local math_min = math.min
local math_pi = math.pi
local math_random = math.random
local math_sin = math.sin
local math_sqrt = math.sqrt
local node = mod.node
local os_clock = os.clock
local VN = vector.new


local water_diff = 8
local altitude_cutoff_high = 30
local altitude_cutoff_low = -10
local base_level = mod.chunk_offset + water_diff
local cave_level = 20
local chunk_offset = mod.chunk_offset
local road_w = 3
local cave_underground = 5
local use_pcall

local Geomorph = geomorph.Geomorph
local geomorphs = {}
local m_data = {}
local m_p2data = {}


local n_air = node['air']
local n_ice = node['default:ice']
local n_ignore = node['ignore']
local n_stone = node['default:stone']
local n_water = node['default:water_source']


-- If on my system, it's ok to crash.
do
	local f = io.open(mod.path..'/duane', 'r')

	if f then
		print(mod_name .. ': Running without safety measures...')
	else
		use_pcall = true
	end
end


local box_names = {}
do
	local allowed = {
		geomoria = true,
		--ruins = true,
		walking = true,
	}
	if geomorph then
		geomorphs = geomorph.registered_geomorphs
	end

	for n, v in pairs(geomorphs) do
		if not v.areas or allowed[v.areas] then
			table.insert(box_names, n)
		end
	end
end


mod.construct_nodes = {}
for _, n in pairs({'match_three:top', 'default:chest'}) do
	if minetest.registered_nodes[n] then
		mod.construct_nodes[node[n]] = true
	end
end


-- tables of rotation values for rotating schematics
local drotn = {[0]=3, 0, 1, 2, 19, 16, 17, 18, 15, 12, 13, 14, 7, 4, 5, 6, 11, 8, 9, 10, 21, 22, 23, 20}


-- table of node types to be dusted
local dusty_types = {
	normal = true,
	allfaces_optional = true,
	glasslike_framed_optional = true,
	glasslike = true,
	glasslike_framed = true,
	allfaces = true,
}


local geo_replace = {
	pyramid = {['default:stone_block'] = 'default:sandstone_block'},
	pyramid_temple = {['default:stone_block'] = 'default:desert_stone_block'},
}


local ores = {
	'default:stone_with_coal',
	'default:stone_with_iron',
	'default:stone_with_copper',
	'default:stone_with_tin',
	'default:stone_with_gold',
	'default:stone_with_diamond',
	'default:stone_with_mese',
}
local ore_odds, total_ore_odds
local ore_intersect = {
	'default:stone',
	'default:sandstone',
	'default:desert_stone',
	mod_name..':basalt',
	mod_name..':granite',
	mod_name..':stone_with_lichen',
	mod_name..':stone_with_algae',
	mod_name..':stone_with_moss',
	mod_name..':stone_with_salt',
	mod_name..':hot_rock',
	mod_name..':sunny_stone',
}


local random_biomes = {
	'taiga',
	'icesheet',
	'desert',
	'rainforest',
	'snowy_grassland',
	'savanna',
	'coniferous_forest',
	'cold_desert',
	'deciduous_forest',
	'sandstone_desert',
	'grassland',
}


local stone_types = {
	{'default:cobble', 'default:stonebrick', 'default:stone', 'default:stoneblock'},
	{'default:desert_cobble', 'default:desert_stonebrick', 'default:desert_stone', 'default:desert_stone_block'},
	{'default:sandstonebrick', 'default:sandstonebrick', 'default:sandstone', 'default:sandstone_block'},
	{'default:desert_sandstone_brick', 'default:desert_sandstone_brick', 'default:desert_sandstone', 'default:desert_sandstone_block'},
	{'default:silver_sandstone_brick', 'default:silver_sandstone_brick', 'default:silver_sandstone', 'default:silver_sandstone_block'},
}


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


---------------
-- Mapgen class
---------------
local Mapgen = {}
Mapgen.__index = Mapgen

function Mapgen.new(minp, maxp, seed)
	local self = setmetatable({
		area = nil,
		csize = nil,
		biomemap = {}, -- use global?
		biomemap_cave = {},
		data = m_data,
		--heatmap = {},
		heightmap = {}, -- use global?
		--humiditymap = {},
		meta_data = {},
		minp = minp,
		maxp = maxp,
		node = mod.node,
		--occupied = nil,
		p2data = m_p2data,
		placed_lava = nil,
		plots = {},
		puzzle_boxes = {},
		noise = {},
		schem = {},
		seed = seed,
		shadow = {},
		vm = nil,
	}, Mapgen)

	self.csize = mod.csize

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	if not (vm and emin and emax) then
		return
	end
	self.vm = vm

	self.data = vm:get_data(self.data)
	self.p2data = vm:get_param2_data(self.p2data)
	self.area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})

	return self
end


local cave_biome_names = {}
-- check
function Mapgen:bubble_cave()
	local data, p2data = self.data, self.p2data
	local minp, maxp, area = self.minp, self.maxp, self.area
	local heightmap = self.heightmap
	local f_alt = self.f_alt
	local center = vector.round(vector.divide(vector.add(minp, maxp), 2))
	local pr = self.gpr
	local ystride = area.ystride
	local cave_biomes = mod.cave_biomes or {}

	if #cave_biomes < 1 then
		for n, v in pairs(cave_biomes) do
			cave_biome_names[#cave_biome_names+1] = n
		end
	end

	local biome = cave_biomes[cave_biome_names[self.gpr:next(1, math_max(1, #cave_biome_names))]] or {}
	self.biome = biome

	local n_b_stone = node[biome.node_stone] or n_stone
	local n_ceiling = node[biome.ceiling_node]
	local n_lining = node[biome.node_lining] or n_stone
	local n_floor = node[biome.floor_node]
	local n_fluid = node[biome.node_cave_liquid]
	local n_gas = node[biome.gas] or n_air
	local n_stalac, n_stalag, stalac_p2, stalag_p2
	local schematics = biome.schematics or {}
	local stalactite_chance, stalagmite_chance
	local surface_depth = biome.surface_depth or 1
	local c_deco = biome.deco
	local c_deco_chance = biome.deco_chance or 100

	if c_deco then
		c_deco = node[c_deco]
	end

	if biome.underwater and pr:next(1, 4) == 1 then
		n_gas = n_water
		n_stalac = {node[mod_name..':wet_fungus']}
		stalactite_chance = 50
		stalac_p2 = 0
		n_stalag = {node[mod_name..':wet_fungus']}
		stalagmite_chance = 50
		stalag_p2 = 0
	else
		if biome.stalactite
		and type(biome.stalactite) == 'table'
		and biome.stalactite.node then
			n_stalac = mod.node_string_or_table(biome.stalactite.node)
			stalactite_chance = biome.stalactite.chance or 100
			stalac_p2 = biome.stalactite.param2 or 0
		end

		if biome.stalagmite
		and type(biome.stalagmite) == 'table'
		and biome.stalagmite.node then
			n_stalag = mod.node_string_or_table(biome.stalagmite.node)
			stalagmite_chance = biome.stalagmite.chance or 100
			stalag_p2 = biome.stalagmite.param2 or 0
		end
	end

	if biome.node_cave_liquid == 'default:lava_source'
	or biome.gas == 'default:lava_source' then
		self.placed_lava = true
	end

	local geo = Geomorph.new()
	local pos = VN(0,0,0)
	local size = VN(80,80,80)
	geo:add({
		action = 'cube',
		node = biome.stone_type or 'default:stone',
		location = table.copy(pos),
		size = table.copy(size),
	})
	if biome.node_lining then
		geo:add({
			action = 'sphere',
			node = biome.node_lining,
			location = vector.add(pos, 1),
			size = vector.add(size, -2),
		})
	end
	geo:add({
		action = 'sphere',
		node = 'air',
		location = vector.add(pos, 2),
		size = vector.add(size, -4),
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
						if c_deco and pr:next(1, c_deco_chance) == 1 then
							data[ivm] = c_deco
						else
							data[ivm] = n_lining or n_floor or n_b_stone
						end
						p2data[ivm] = 0
					else
						if c_deco and pr:next(1, c_deco_chance) == 1 then
							data[ivm] = c_deco
						else
							data[ivm] = n_lining or n_ceiling or n_b_stone
						end
						p2data[ivm] = 0
					end
				elseif n_stalac and #n_stalac > 0 and y > center.y
				and diff == 19 + ground and data[ivm] == n_air
				and pr:next(1, stalactite_chance) == 1 then
					data[ivm] = n_stalac[pr:next(1, #n_stalac)]
					p2data[ivm] = stalac_p2
				elseif n_stalag and #n_stalag > 0 and y < center.y
				and diff == 19 + ground and data[ivm] == n_air
				and y > center.y - cave_level
				and pr:next(1, stalagmite_chance) == 1 then
					data[ivm] = n_stalag[pr:next(1, #n_stalag)]
					p2data[ivm] = stalag_p2
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


function Mapgen:dungeon(box_type)
		local t_moria = os_clock()

		if not box_type then
			return
		end

		local geo = Geomorph.new()
		local box = geomorphs[box_type] or {}
		for n, v in pairs(box.shapes or {}) do
			geo:add(v)
		end
		geo:write_to_map(self, nil, geo_replace[box_type])

		mod.moria_chunks = mod.moria_chunks + 1
		mod.time_moria = mod.time_moria + os_clock() - t_moria
end


-- check
function Mapgen:erosion(height, index, depth, factor)
	local e = self.noise['erosion'].map[index]
	if e <= 0 then
		return depth
	end
	e = depth - math_floor(height * height / factor / factor * (e + 1))
	return e
end


local first_biome_check = true
function Mapgen:generate(timed)
	local minp = self.minp
	local biomes = mod.biomes

	self.gpr = PcgRandom(self.seed + 5107)
	local contents = self.gpr:next(1, 6)

	if not biomes then
		biomes = {}
		mod.biomes = biomes

		for n, v in pairs(minetest.registered_biomes) do
			local c = table.copy(v)
			biomes[n] = c
		end
	end

	self:make_noise()

	local t_terrain = os_clock()
	local sup_chunk = vector.floor(vector.divide(vector.add(minp, chunk_offset), 80))
	sup_chunk.y = sup_chunk.y + 5
	sup_chunk = vector.mod(sup_chunk, 10)
	local f_alt = (sup_chunk.y - 5) * 80
	self.f_alt = f_alt
	self.sup_chunk = sup_chunk

	local decorate = true
	local base_heat = math_abs(90 - ((((minp.z + chunk_offset + 1000) / 6000) * 180) % 180))
	mod.base_heat = base_heat

	if sup_chunk.y >= 4 or (sup_chunk.x == 0 and sup_chunk.z == 0) then
		local ground = (sup_chunk.y == 5)
		if ground then
			self:map_roads()
		end

		self:terrain()

		local do_ore = true
		if sup_chunk.x == 0 and sup_chunk.z == 0 then
			self:spirals()
			decorate = false
		elseif ground and self.flattened and self.gpr:next(1, 1) == 1 then
			local sr = self.gpr:next(1, 3)
			if sr == 1 then
				self:dungeon('pyramid_temple')
			elseif sr == 2 then
				self:dungeon('pyramid')
			else
				self:simple_ruin()
				do_ore = false
			end
		else
			if math_max(self.height_max, 10) < f_alt then
				self:planets()
			end
			if ground then
				self:houses()
			end
		end

		if do_ore then
			local t_ore = os_clock()
			self:simple_ore()
			mod.time_ore = mod.time_ore + os_clock() - t_ore
		end

		if sup_chunk.y <= 6
		and not (sup_chunk.x == 0 and sup_chunk.z == 0) and self.height_min > f_alt + cave_underground then
			local t_cave = os_clock()
			self:simple_cave()
			mod.time_caves = mod.time_caves + os_clock() - t_cave
		end
	elseif sup_chunk.y < 4 then
		local t_cave = os_clock()
		self:bubble_cave()
		mod.time_caves = mod.time_caves + os_clock() - t_cave

		local t_ore = os_clock()
		self:simple_ore()
		mod.time_ore = mod.time_ore + os_clock() - t_ore
		-- ????
		decorate = true
	end
	mod.time_terrain = mod.time_terrain + os_clock() - t_terrain

	if decorate then
		local t_deco = os_clock()
		self:place_all_decorations()
		self:dust()
		mod.time_deco = mod.time_deco + os_clock() - t_deco
	end

	if #self.puzzle_boxes > 0 then
		self:place_puzzles()
	end

	self:save_map(timed)

	mod.chunks = mod.chunks + 1
end


local function generate(minp, maxp, seed)
	if not (minp and maxp and seed) then
		return
	end

	if not mod.csize then
		mod.csize = vector.add(vector.subtract(maxp, minp), 1)

		if not mod.csize then
			return
		end
	end

	local mg = Mapgen.new(minp, maxp, seed)
	if not mg then
		return
	end

	mg:generate(true)
	local mem = math_floor(collectgarbage('count')/1024)
	if mem > 200 then
		print('Lua Memory: ' .. mem .. 'M')
	end
end


-- check
local house_materials = {'sandstonebrick', 'desert_stonebrick', 'stonebrick', 'brick', 'wood', 'junglewood'}
function Mapgen:houses()
	local csize, area = self.csize, self.area
	local plots = self.plots
	local pr = self.gpr
	local heightmap = self.heightmap
	local stone = 'default:sandstone'
	for _, box in pairs(plots) do
		local pos = vector.add(box.pos, -2)
		local size = vector.add(box.size, 4)
		local good = true

		for z = pos.z, pos.z + size.z do
			for x = pos.x, pos.x + size.x do
				local index = z * csize.x + x + 1
				if not heightmap[index] or heightmap[index] < base_level - 1 or heightmap[index] > base_level + 1 then
					good = false
					break
				end
			end
			if not good then
				break
			end
		end

		if good then
			local walls, roof
			while walls == roof do
				walls = (house_materials)[pr:next(1, #house_materials)]
				roof = (house_materials)[pr:next(1, #house_materials)]
			end
			local walls1 = 'default:'..walls
			local roof1 = 'default:'..roof
			local geo = Geomorph.new()
			local lev = pr:next(1, 4) - 2
			if #self.puzzle_boxes == 0 and lev == 0 and box.size.x >= 7 and box.size.z >= 7 then
				local width = 7
				table.insert(self.puzzle_boxes, {
					pos = table.copy(pos),
					size = VN(width, width, width),
				})
			else
				lev = math_max(1, lev)

				-- foundation
				pos = table.copy(box.pos)
				pos.y = pos.y - 1
				size = table.copy(box.size)
				size.y = 1
				geo:add({
					action = 'cube',
					node = 'default:cobble',
					location = pos,
					size = size,
				})

				pos = table.copy(box.pos)
				pos.y = pos.y + lev * 5
				size = table.copy(box.size)
				if pr:next(1, 3) == 1 then
					size.y = 1
					geo:add({
						action = 'cube',
						node = roof1,
						location = pos,
						size = size,
					})
				elseif box.size.x <= box.size.z then
					size.x = math_floor(size.x / 2)

					local pos2 = table.copy(pos)
					pos2.x = pos2.x + size.x
					pos2.y = pos2.y + size.x - 1

					pos = table.copy(pos)
					pos.x = pos.x + box.size.x - size.x
				else
					size.z = math_floor(size.z / 2)

					local pos2 = table.copy(pos)
					pos2.z = pos2.z + size.z
					pos2.y = pos2.y + size.z - 1

					pos = table.copy(pos)
					pos.z = pos.z + box.size.z - size.z
				end
				pos = table.copy(box.pos)
				pos.y = box.pos.y
				size = table.copy(box.size)
				size.y = lev * 5
				geo:add({
					action = 'cube',
					node = walls1,
					location = pos,
					size = size,
				})
				for y = 0, lev - 1 do
					local pos2 = vector.add(pos, 1)
					local sz2 = vector.add(size, -2)
					pos2.y = box.pos.y + y * 5 + 1
					sz2.y = 4
					geo:add({
						action = 'cube',
						node = 'air',
						location = pos2,
						size = sz2,
					})
				end

				pos = table.copy(box.pos)
				size = table.copy(box.size)
				for y = 0, lev - 1 do
					for z = box.pos.z + 2, box.pos.z + box.size.z, 4 do
						geo:add({
							action = 'cube',
							node = 'air',
							location = VN(box.pos.x, box.pos.y + y * 5 + 2, z),
							size = VN(box.size.x, 2, 2),
						})
					end
					for x = box.pos.x + 2, box.pos.x + box.size.x, 4 do
						geo:add({
							action = 'cube',
							node = 'air',
							location = VN(x, box.pos.y + y * 5 + 2, box.pos.z),
							size = VN(2, 2, box.size.z),
						})
					end
				end

				do
					local l = math_max(box.size.x, box.size.z)
					local f = pr:next(0, 2)
					pos = vector.round(vector.add(box.pos, vector.divide(box.size, 2)))
					pos = vector.subtract(pos, math_floor(l / 2 + 0.5) - f)
					pos.y = pos.y + lev * 5
					geo:add({
						action = 'sphere',
						node = 'air',
						intersect = {walls1, roof1},
						location = pos,
						size = VN(l - 2 * f, 20, l - 2 * f),
					})

					for i = 1, 3 do
						local pos2 = table.copy(pos)
						pos2.x = pos2.x + pr:next(0, box.size.x) - math_floor(box.size.x / 2)
						pos2.z = pos2.z + pr:next(0, box.size.z) - math_floor(box.size.z / 2)

						geo:add({
							action = 'sphere',
							node = 'air',
							intersect = {walls1, roof1},
							location = pos2,
							size = VN(l, 20, l),
						})
					end
				end
			end

			do
				local ore
				pos = table.copy(box.pos)
				local size = table.copy(box.size)
				if ore_odds then
					local orn = pr:next(1, total_ore_odds)
					local i = 0
					for _, od in pairs(ore_odds) do
						i = i + 1
						if orn <= od then
							orn = i
							break
						end
						orn = orn - od
					end
					ore = ores[orn]
				else
					ore = ores[1]
				end
				geo:add({
					action = 'cube',
					node = ore,
					intersect = {walls1, roof1},
					location = pos,
					size = size,
					random = 50,
				})
			end

			geo:write_to_map(self, 0)
		end
	end
end


function Mapgen:make_noise()
	local minp, csize = self.minp, self.csize

	-- Generate all noises.
	for n, _ in pairs(mod.noise) do
		local size = table.copy(csize)
		if n == 'flat_cave_1' then
			mod.noise[n].def.seed = 6386 + math_floor(minp.y / csize.y)
		elseif n == 'road_1' then
			size = vector.add(size, road_w * 2)
		end

		if not mod.noise[n].noise then
			if mod.noise[n].is3d then
				mod.noise[n].noise = minetest.get_perlin_map(mod.noise[n].def, size)
			else
				size.z = nil
				mod.noise[n].noise = minetest.get_perlin_map(mod.noise[n].def, size)
			end

			if not mod.noise[n].noise then
				return
			end
		end

		if not self.noise[n] then
			-- Keep pointers to global noise info
			self.noise[n] = {
				def = mod.noise[n].def,
				map = nil,
				noise = mod.noise[n].noise,
			}
		end

		-- This stays with the mapgen object.
		if mod.noise[n].is3d then
			self.noise[n].map = mod.noise[n].noise:get3dMap_flat(self.minp, self.noise[n].map)
		else
			self.noise[n].map = mod.noise[n].noise:get2dMap_flat({x=self.minp.x, y=self.minp.z}, self.noise[n].map)
		end
	end
end


-- check
function Mapgen:map_roads()
	local csize, area = self.csize, self.area
	local roads = {}
	local has_roads = false

	local index = 1
	local road_ws = road_w * road_w
	for x = -road_w, csize.x + road_w - 1 do
		index = x + road_w + 1
		local l_road = self.noise['road_1'].map[index]
		for z = -road_w, csize.z + road_w - 1 do
			local road_1 = self.noise['road_1'].map[index]
			if (l_road < 0) ~= (road_1 < 0) then
				local index2 = z * csize.x + x + 1
				for zo = -road_w, road_w do
					local zos = zo * zo
					for xo = -road_w, road_w do
						if x + xo >= 0 and x + xo < csize.x
						and z + zo >= 0 and z + zo < csize.z then
							if xo * xo + zos < road_ws then
								roads[index2 + zo * csize.x + xo] = true
								has_roads = true
							end
						end
					end
				end
			end
			l_road = road_1
			index = index + csize.x + road_w * 2
		end
	end

	-- Mark the road locations.
	index = 1
	for z = -road_w, csize.z + road_w - 1 do
		local l_road = self.noise['road_1'].map[index]
		for x = -road_w, csize.x + road_w - 1 do
			local road_1 = self.noise['road_1'].map[index]
			if (l_road < 0) ~= (road_1 < 0) then
				local index2 = z * csize.x + x + 1
				for zo = -road_w, road_w do
					local zos = zo * zo
					for xo = -road_w, road_w do
						if x + xo >= 0 and x + xo < csize.x and z + zo >= 0 and z + zo < csize.z then
							if xo * xo + zos < road_ws then
								roads[index2 + zo * csize.x + xo] = true
								has_roads = true
							end
						end
					end
				end
			end
			l_road = road_1
			index = index + 1
		end
	end

	local plots = {}

	-- Generate plots for constructions.
	for ct = 1, 15 do
		local scale = self.gpr:next(1, 2) * 4
		local size = VN(self.gpr:next(1, 2), 1, self.gpr:next(1, 2))
		size.x = size.x * scale + 9
		size.y = size.y * 8
		size.z = size.z * scale + 9

		for ct2 = 1, 10 do
			local pos = VN(self.gpr:next(2, csize.x - size.x - 3), base_level, self.gpr:next(2, csize.z - size.z - 3))
			local good = true
			for _, box in pairs(plots) do
				if box.pos.x + box.size.x < pos.x
				or pos.x + size.x < box.pos.x
				or box.pos.z + box.size.z < pos.z
				or pos.z + size.z < box.pos.z then
					-- nop
				else
					good = false
					break
				end
			end
			for z = pos.z, pos.z + size.z do
				for x = pos.x, pos.x + size.x do
					local index = z * csize.x + x + 1
					if roads[index] then
						good = false
						break
					end
				end
				if not good then
					break
				end
			end
			if good then
				pos.y = pos.y - 2
				table.insert(plots, {
					pos = vector.add(pos, 2),
					size = vector.add(size, -4)
				})
				break
			end
		end
	end

	self.plots = plots
	self.has_roads = has_roads
	self.roads = roads
end


function Mapgen:place_puzzles()
	local width = 7
	local geo = Geomorph.new()

	for _, puz in pairs(self.puzzle_boxes) do
		local pos = vector.add(puz.pos, -1)
		pos.y = pos.y + 4
		local size = vector.add(puz.size, 2)
		geo:add({
			action = 'cube',
			node = 'air',
			clear_up = 13,
			location = pos,
			size = size,
		})

		pos = table.copy(puz.pos)
		pos.y = pos.y + 4
		geo:add({
			action = 'puzzle',
			chance = 1,
			clear_up = 13,
			location = pos,
			size = VN(width, width, width),
		})

		-- Only the first.
		--break
	end
	geo:write_to_map(self, 0)
end


-- check
function Mapgen:planets()
	local ring_jump = 3

	local minp, maxp = self.minp, self.maxp
	local csize, area = self.csize, self.area
	local data, p2data = self.data, self.p2data
	local heightmap = self.heightmap
	local biomemap = self.biomemap
	local ystride = area.ystride
	local biomes = mod.biomes
	local pr = self.gpr
	local sphere_count = pr:next(0, 1) + pr:next(0, 1)
	if sphere_count < 1 then
		return
	end
	local geo = Geomorph.new()
	local a, b, c, st

	local biome_name = random_biomes[self.gpr:next(1, #random_biomes)]
	local biome = biomes[biome_name] or {}
	self.biome = biome
	local b_stone = biome.node_stone or 'default:stone'

	for _ = 1, sphere_count do
		local sphere_size = pr:next(3, 10) + pr:next(3, 10)
		a = pr:next(0, csize.x-sphere_size-1)
		b = pr:next(0, csize.y-sphere_size-1)
		c = pr:next(0, csize.z-sphere_size-1)
		st = pr:next(0, 5)

		if st == 0 or st == 4 then
			a = pr:next(9, csize.x-sphere_size-10)
			b = pr:next(9, csize.y-sphere_size-10)
			c = pr:next(9, csize.z-sphere_size-10)
			local ring_size = math_floor(16 / 5)

			for i = ring_size, 0, -1 do
				local stone = stone_types[pr:next(1, 5)][3]
				geo:add({
					action = 'cylinder',
					node = stone,
					location = VN(a - ring_jump - i,
						b + math_floor(sphere_size / 2),
						c - ring_jump - i),
					size = VN(sphere_size + ring_jump * 2 + 2 * i,
						1, sphere_size + ring_jump * 2 + 2 * i),
					axis = 'y',
				})
			end

			geo:add({
				action = 'cylinder',
				node = 'air',
				location = VN(a - ring_jump + 1,
					b + math_floor(sphere_size / 2),
					c - ring_jump + 1),
				size = VN(sphere_size + 2 * (ring_jump - 1),
					1, sphere_size + 2 * (ring_jump - 1)),
				axis = 'y',
			})
		end

		if st < 4 then
			if biome.node_filler then
				geo:add({
					action = 'sphere',
					node = biome.node_filler,
					location = VN(a, b, c),
					size = VN(sphere_size, sphere_size, sphere_size),
				})
			end
			geo:add({
				action = 'sphere',
				node = b_stone,
				location = VN(a+2, b, c+2),
				size = VN(sphere_size-4, sphere_size-4, sphere_size-4)
			})
		elseif st == 4 then
			geo:add({
				action = 'sphere',
				node = mod_name..':weightless_water',
				location = VN(a, b, c),
				size = VN(sphere_size, sphere_size, sphere_size)
			})
		elseif st == 5 then
			sphere_size = math_floor((sphere_size + 4) / 2)
			geo:add({
				action = 'sphere',
				node = mod_name..':weightless_lava',
				location = VN(a, b, c),
				size = VN(sphere_size, sphere_size, sphere_size)
			})
		end
	end

	geo:write_to_map(self)

	local n_top = node[biome.node_top or 'default:dirt_with_grass']
	local n_filler = node[biome.node_filler or 'default:dirt']

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			biomemap[index] = biome
			local ivm = area:index(x, maxp.y, z)
			local found_top

			for y = maxp.y, minp.y, -1 do
				if not found_top and data[ivm] == n_filler then
					if y - minp.y < 60 then
						heightmap[index] = y - minp.y
					end
					data[ivm] = n_top
					p2data[ivm] = 0
					found_top = true
				end

				ivm = ivm - ystride
			end

			index = index + 1
		end
	end
end


function Mapgen:save_map(timed)
	local t_over
	if timed then
		t_over = os_clock()
	end

	self.vm:set_data(self.data)
	self.vm:set_param2_data(self.p2data)

	if DEBUG then
		self.vm:set_lighting({day = 10, night = 10})
	else
		self.vm:set_lighting({day = 0, night = 0}, self.minp, self.maxp)
		self.vm:calc_lighting(nil, nil, false)
	end

	self.vm:update_liquids()
	self.vm:write_to_map()

	-- Save all meta data for chests, cabinets, etc.
	for _, t in ipairs(self.meta_data) do
		local meta = minetest.get_meta({x=t.x, y=t.y, z=t.z})
		meta:from_table()
		meta:from_table(t.meta)
	end

	-- Call on_construct methods for nodes that request it.
	-- This is mainly useful for starting timers.
	for i, n in ipairs(self.data) do
		if mod.construct_nodes[n] then
			local pos = self.area:position(i)
			local node_name = minetest.get_name_from_content_id(n)
			if minetest.registered_nodes[node_name] and minetest.registered_nodes[node_name].on_construct then
				minetest.registered_nodes[node_name].on_construct(pos)
			else
				local timer = minetest.get_node_timer(pos)
				if timer then
					timer:start(math_random(100))
				end
			end
		end
	end

	if timed then
		mod.time_overhead = mod.time_overhead + os_clock() - t_over
	end
end


-- check
function Mapgen:simple_cave()
	local pr = self.gpr
	local sup_chunk = self.sup_chunk
	local csize = self.csize

	local geo = Geomorph.new()
	local center = vector.add(VN(40, 0, 40), self.minp)
	local ivm = self.area:indexp(center)
	local curr_stone = minetest.get_name_from_content_id(self.data[ivm])

	local biome = self.biomemap[math_floor(csize.z / 2 * csize.x + csize.x / 2)]
	local liquid = biome.node_cave_liquid

	for i = 1, 40 do
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

		local index = pos.z * csize.x + pos.x + 1
		biome = self.biomemap_cave[index] or {}

		if biome.node_lining then
			geo:add({
				action = 'sphere',
				node = biome.node_lining,
				location = vector.add(pos, -1),
				underground = cave_underground,
				size = vector.add(size, 2),
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
	end

	if sup_chunk.y < 5 and liquid then
		geo:add({
			action = 'cube',
			node = liquid,
			location = VN(1, 1, 1),
			underground = cave_underground,
			intersect = 'air',
			size = VN(78, pr:next(10, 80), 78),
		})
	end

	geo:write_to_map(self)
end


-- check
function Mapgen:simple_ore()
	if not ore_odds then
		ore_odds = {}
		total_ore_odds = 0
		for i = 1, #ores do
			ore_odds[#ores - i + 1] = i
			total_ore_odds = total_ore_odds + i
		end
	end

	local minp = self.minp
	local pr = self.gpr
	local size = VN(
		pr:next(1, 6) + pr:next(1, 6),
		pr:next(1, 6) + pr:next(1, 6),
		pr:next(1, 6) + pr:next(1, 6)
	)
	if self.placed_lava then
		size = vector.add(size, 2)
	end
	size = vector.multiply(size, 2)

	local geo = Geomorph.new()
	for ct = 1, 25 do
		local orn = pr:next(1, total_ore_odds)
		local i = 0
		for _, od in pairs(ore_odds) do
			i = i + 1
			if orn <= od then
				orn = i
				break
			end
			orn = orn - od
		end
		local ore = ores[orn]
		local p = vector.new(
			pr:next(0, 80 - size.x),
			pr:next(0, 80 - size.y),
			pr:next(0, 80 - size.z)
		)
		geo:add({
			action = 'cube',
			node = ore,
			random = 4,
			location = p,
			size = size,
			intersect = ore_intersect,
		})
	end
	geo:write_to_map(self)
end


-- check
function Mapgen:simple_ruin()
	if not self.flattened then
		return
	end

	local csize = self.csize
	local heightmap = self.heightmap
	local boxes = {}

	for ct = 1, 15 do
		local scale = self.gpr:next(2, 3) * 4
		local size = VN(self.gpr:next(1, 3), 1, self.gpr:next(1, 3))
		size.x = size.x * scale + 5
		size.y = size.y * 8
		size.z = size.z * scale + 5

		for ct2 = 1, 10 do
			local pos = VN(self.gpr:next(1, csize.x - size.x - 2), base_level, self.gpr:next(1, csize.z - size.z - 2))
			local good = true
			for _, box in pairs(boxes) do
				if box.pos.x + box.size.x < pos.x or pos.x + size.x < box.pos.x
				or box.pos.z + box.size.z < pos.z or pos.z + size.z < box.pos.z then
					-- nop
				else
					good = false
					break
				end
			end
			if good then
				table.insert(boxes, { pos = pos, size = size })
				break
			end
		end
	end
	local geo = Geomorph.new()
	local stone = 'default:sandstone'
	for _, box in pairs(boxes) do
		local pos = table.copy(box.pos)
		local size = table.copy(box.size)

		for z = pos.z, pos.z + size.z do
			local index = z * csize.x + pos.x + 1
			for x = pos.x, pos.x + size.x do
				heightmap[index] = base_level
				index = index + 1
			end
		end

		-- foundation
		pos.y = pos.y - 2
		size.y = 3
		geo:add({
			action = 'cube',
			node = stone,
			location = pos,
			size = size,
		})

		pos = table.copy(pos)
		pos.y = pos.y + 3
		size = table.copy(size)
		size.y = 1
		geo:add({
			action = 'cube',
			node = 'air',
			location = pos,
			size = size,
		})

		box.pos.x = box.pos.x + 2
		box.pos.z = box.pos.z + 2
		box.size.x = box.size.x - 4
		box.size.z = box.size.z - 4

		pos = table.copy(box.pos)
		pos.y = pos.y + 8
		size = table.copy(box.size)
		size.y = 1
		geo:add({
			action = 'cube',
			node = stone,
			location = pos,
			size = size,
		})
		pos = vector.add(box.pos, 1)
		pos.y = pos.y + 8
		size = vector.add(box.size, -2)
		size.y = 1
		geo:add({
			action = 'cube',
			node = stone,
			location = pos,
			size = size,
		})
		pos = table.copy(pos)
		pos.y = pos.y - 1
		geo:add({
			action = 'cube',
			node = 'air',
			location = pos,
			size = size,
		})
		local pool = 14
		if box.size.x > pool and box.size.z > pool then
			pos = vector.add(box.pos, (pool / 2) - 1)
			pos.y = box.pos.y + 1
			size = vector.add(box.size, -(pool - 2))
			size.y = 1
			geo:add({
				action = 'cube',
				node = stone,
				location = pos,
				size = size,
			})
			pos = vector.add(box.pos, pool / 2)
			pos.y = box.pos.y + 1
			size = vector.add(box.size, -pool)
			size.y = 1
			geo:add({
				action = 'cube',
				node = 'default:water_source',
				location = pos,
				size = size,
			})
		end

		for z = box.pos.z, box.pos.z + box.size.z, 4 do
			for x = box.pos.x, box.pos.x + box.size.x, 4 do
				if x == box.pos.x or x == box.pos.x + box.size.x - 1
				or z == box.pos.z or z == box.pos.z + box.size.z - 1 then
					geo:add({
						action = 'cube',
						node = stone,
						location = VN(x, box.pos.y, z),
						size = VN(1, box.size.y, 1),
					})
				end
			end
		end
	end
	geo:write_to_map(self)

	return true
end


-- check
function Mapgen:spirals()
	local area = self.area
	local data = self.data
	local maxp = self.maxp
	local minp = self.minp
	local flets = false
	local n_cloud_hard = node[mod_name..':cloud_hard']
	local n_leaves = node['default:leaves']
	local n_bark = node[mod_name .. ':bark']
	local sup_chunk = self.sup_chunk

	local geo = Geomorph.new()
	if sup_chunk.y < 4 then
		geo:add({
			action = 'cube',
			intersect = 'air',
			node = mod_name..':cloud_hard',
			location = VN(0, base_level, 0),
			size = VN(80, 1, 80),
		})
		geo:add({
			action = 'cube',
			intersect = 'air',
			node = mod_name..':cloud_hard',
			location = VN(0, 50, 0),
			size = VN(80, 1, 80),
		})
	end
	if sup_chunk.y <= 4 then
		geo:add({
			action = 'cube',
			intersect = {'default:water_source', 'default:lava_source'},
			node = 'default:stone',
			location = VN(0, 0, 0),
			size = VN(80, 1, 80),
		})
	end
	if sup_chunk.y >= 4 and sup_chunk.y < 6 then
		geo:add({
			action = 'cylinder',
			axis = 'y',
			intersect = {'default:water_source'},
			node = mod_name..':bark',
			location = VN(5, 0, 5),
			size = VN(70, 80, 70),
		})
	else
		geo:add({
			action = 'cylinder',
			axis = 'y',
			intersect = {'default:water_source', 'default:lava_source'},
			node = 'default:stone',
			location = VN(5, 0, 5),
			size = VN(70, 80, 70),
		})
	end
	geo:add({
		action = 'cylinder',
		axis = 'y',
		node = 'air',
		location = VN(7, 0, 7),
		size = VN(66, 80, 66),
	})
	geo:add({
		action = 'cylinder',
		axis = 'y',
		node = mod_name..':cloud_hard',
		location = VN(12, 20, 12),
		size = VN(56, 1, 56),
	})
	geo:add({
		action = 'cylinder',
		axis = 'y',
		node = mod_name..':cloud_hard',
		location = VN(12, 50, 12),
		size = VN(56, 1, 56),
	})
	geo:write_to_map(self)

	local r1, n1, s1, l1 = 30, 3, 20, 20

	for my = minp.y - 2, maxp.y + 2 do
		for ot = 1, n1 * 2 do
			local t = my / s1 + math_pi * (ot / n1)
			local mx = math_floor(minp.x + 40 + r1 * math_cos(t))
			local mz = math_floor(minp.z + 40 + r1 * math_sin(t))
			local ivm = area:index(mx, my, mz)
			if data[ivm] == n_air or data[ivm] == n_ignore or data[ivm] == n_cloud_hard or data[ivm] == n_leaves then
				data[ivm] = node['default:tree']
			end
			for oz = -2, 2 do
				for oy = -2, 2 do
					ivm = area:index(mx - 2, my + oy, mz + oz)
					for ox = -2, 2 do
						if data[ivm] == n_air or data[ivm] == n_ignore or data[ivm] == n_cloud_hard then
							data[ivm] = n_leaves
						end
						ivm = ivm + 1
					end
				end
			end
		end
		local r2 = r1 - 3
		local r22 = r2 * r2
		local r32 = 5 * 5
		if flets and my % l1 == 0 then
			for oz = -r2, r2 do
				local ivm = area:index(minp.x + 40 - r2, my, minp.z + 40 + oz)
				for ox = -r2, r2 do
					local r = ox * ox + oz * oz
					if (data[ivm] == n_air or data[ivm] == n_ignore)
					and r < r22 and r > r32 then
						data[ivm] = n_bark
					end
					ivm = ivm + 1
				end
			end
		end
	end
end


-- check
function Mapgen:terrain()
	local csize, area = self.csize, self.area
	local csize_y = csize.y
	local base_heat = mod.base_heat
	local biomes = mod.biomes
	local cave_biomes = mod.cave_biomes
	local data = self.data
	local f_alt = self.f_alt
	local heightmap = self.heightmap
	local biomemap = self.biomemap
	local biomemap_cave = self.biomemap_cave
	local maxp = self.maxp
	local minp = self.minp
	local ystride = area.ystride
	local p2data = self.p2data
	local hx, hz = csize.x / 2, csize.z / 2
	local ground_noise_map = self.noise['ground_2'].map
	local humidity_1_map = self.noise['humidity_1'].map
	local humidity_2_map = self.noise['humidity_2'].map
	local heat_2_map = self.noise['heat_2'].map

	local n_cobble = node['default:cobble']
	local n_mossy = node['default:mossycobble']

	local roads = self.roads

	f_alt = f_alt or 0
	base_heat = base_heat or 65

	local biome
	local local_water_level = base_level - f_alt - water_diff
	self.biome = biome

	local height_min = mod.max_height
	local height_max = -mod.max_height

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local ground_1 = ground_noise_map[index]
			height_max = math_max(ground_1, height_max)
			height_min = math_min(ground_1, height_min)
			index = index + 1
		end
	end
	self.height_min = height_min
	self.height_max = height_max

	if (math_max(altitude_cutoff_high, height_max) - altitude_cutoff_high) - (math_min(altitude_cutoff_low, height_min) - altitude_cutoff_low) < 3 then
		self.flattened = true
	end

	local humidity, hu2 = 50, 0

	index = 1
	for z = minp.z, maxp.z do
		local dz = z - minp.z
		for x = minp.x, maxp.x do
			local dx = x - minp.x

			-- terrain height calculations
			local ground_1 = ground_noise_map[index]
			local height = base_level
			if ground_1 > altitude_cutoff_high then
				height = height + ground_1 - altitude_cutoff_high
			elseif ground_1 < altitude_cutoff_low then
				local g = altitude_cutoff_low - ground_1
				g = g * g * 0.01
				height = math_floor(height - g + 0.5)
			end

			hu2 = humidity_2_map[index]
			humidity = humidity_1_map[index] + hu2
			local heat = base_heat + heat_2_map[index]
			if height > base_level + 20 then
				local h2 = height - base_level - 20
				heat = heat - h2 * h2 * 0.005
			end

			local biome_diff
			for _, b in pairs(biomes) do
				if b then
					local diff_he = b.heat_point - heat
					local diff_hu = b.humidity_point - humidity
					local diff = diff_he * diff_he + diff_hu * diff_hu
					if (not b.y_max or b.y_max >= height)
					and (not b.y_min or b.y_min <= height)
					and ((not biome_diff) or diff < biome_diff) then
						biome_diff = diff
						biome = b
						biomemap[index] = b
					end
				end
			end

			biome_diff = nil
			local biome_cave = biome
			for _, b in pairs(cave_biomes) do
				if b then
					local diff_he = b.heat_point - heat
					local diff_hu = b.humidity_point - humidity
					local diff = diff_he * diff_he + diff_hu * diff_hu
					if (not b.y_max or b.y_max >= minp.y)
					and (not b.y_min or b.y_min <= maxp.y)
					and ((not biome_diff) or diff < biome_diff) then
						biome_diff = diff
						biome_cave = b
						biomemap_cave[index] = b
					end
				end
			end

			local depth_filler = biome.depth_filler or 0
			local depth_top = biome.depth_top or 0
			depth_top = self:erosion(height, index, depth_top, 100)
			depth_filler = self:erosion(height, index, depth_filler, 20)

			-- From here on, height is relative to the chunk.
			height = math_floor(height - f_alt + 0.5)
			--print('rel height ' .. height .. ',' .. f_alt)
			heightmap[index] = height
			local m_height = csize_y - height - 1

			local stone = node['default:stone']
			if biome.node_stone then
				stone = node[biome.node_stone] or stone
			end
			local stone_cave = node['default:stone']
			if biome_cave.node_stone then
				stone_cave = node[biome_cave.node_stone] or stone
			end

			local filler = biome.node_filler or 'air'
			filler = node[filler]
			local top = biome.node_top or 'air'
			top = node[top]

			local ww = node[biome.water or 'default:water_source']
			local wt = biome.node_water_top
			local wtd = biome.node_water_top_depth or 0
			if not wt or wt:find('ice') then
				wt = node['default:ice']
				wtd = math_ceil(math_max(0, (30 - heat) / 3))
			else
				wt = node[wt]
			end

			local fill_1 = height - depth_top
			local fill_2 = fill_1 - math_max(0, depth_filler)
			local m_fill_1 = csize_y - fill_1 - 1
			local m_fill_2 = csize_y - fill_2 - 1

			local t_y_loop = os_clock()
			local hu2_check = (humidity > 70 and (hu2 > 1 or math_floor(hu2 * 1000) % 2 == 0))
			local ivm = area:index(x, minp.y, z)
			for dy = 0, csize_y - 1 do
				if f_alt == 0 and dy >= base_level - 1 and dy <= base_level and roads[index] then
					--print('road '..dump(f_alt))
					if hu2_check then
						data[ivm] = n_mossy
					else
						data[ivm] = n_cobble
					end
				elseif dy > height and dy <= local_water_level then
					--print('water '..dump(local_water_level))
					if dy > local_water_level - wtd then
						data[ivm] = wt
					else
						data[ivm] = ww
					end
					p2data[ivm] = 0
				elseif dy <= height and dy > fill_1 and dy >= local_water_level then
					--print('fill_1 '..dump(fill_1))
					data[ivm] = top
					p2data[ivm] = 0
				elseif filler and dy <= height and dy > fill_2 then
					--print('fill_2 '..dump(fill_2))
					data[ivm] = filler
					p2data[ivm] = 0
				elseif dy < height - 20 then
					data[ivm] = stone_cave
					p2data[ivm] = 0
				elseif dy < height then
					--print('stone '..dump(stone))
					data[ivm] = stone
					p2data[ivm] = 0
				end

				ivm = ivm + ystride
			end
			mod.time_y_loop = mod.time_y_loop + os_clock() - t_y_loop

			index = index + 1
		end
	end
end


local function pgenerate(...)
	local status, err

	local t_all = os_clock()
	if use_pcall then
		status, err = pcall(generate, ...)
	else
		status = true
		generate(...)
	end
	mod.time_all = mod.time_all + os_clock() - t_all

	if not status then
		print(mod_name .. ': Could not generate terrain:')
		print(dump(err))
		collectgarbage("collect")
	end
end


if minetest.registered_on_generateds then
	-- This is unsupported. I haven't been able to think of an alternative.
	table.insert(minetest.registered_on_generateds, 1, pgenerate)
else
	minetest.register_on_generated(pgenerate)
end


function Mapgen:place_all_decorations()
	local ps = PcgRandom(self.seed + 53)

	for _, deco in pairs(mod.decorations) do
		if not deco.bad_schem then
			self:place_deco(ps, deco)
		end
	end
end


local liquids = {}
for _, d in pairs(minetest.registered_nodes) do
	if d.groups and d.drawtype == 'liquid' then
		liquids[node[d.name]] = true
	end
end
function Mapgen:find_break(y_s, x, z, dir, typ)
	local minp, maxp = self.minp, self.maxp
	local csize = self.csize
	local data, area = self.data, self.area
	local ystride = self.area.ystride
	local heightmap = self.heightmap

	if dir == 'up' then
		local ivm = area:index(x, minp.y, z)
		for y = minp.y, maxp.y - 1 do
			if data[ivm] == n_air and data[ivm + ystride] ~= n_air then
				table.insert(y_s, y - minp.y + 1)
			end
			ivm = ivm + ystride
		end
	else
		-- Don't check heightmap. It doesn't work in bubble caves.
		local ivm = area:index(x, maxp.y, z)
		for y = maxp.y, minp.y + 1, -1 do
			if (
				data[ivm] == n_air and typ == 'liquid'
				and liquids[data[ivm - ystride]]
			) or (
				data[ivm] == n_air and typ ~= 'liquid'
				and data[ivm - ystride] ~= n_air
				and not liquids[data[ivm - ystride]]
			) then
				table.insert(y_s, y - minp.y - 1)
			end
			ivm = ivm - ystride
		end
	end
end


-- check
function Mapgen:place_deco(ps, deco)
    local data, p2data, vm_area = self.data, self.p2data, self.area
    local minp, maxp = self.minp, self.maxp
    local heightmap, schem = self.heightmap, self.schem
	local biomemap = self.biomemap
	local biomemap_cave = self.biomemap_cave
	local ystride, f_alt = vm_area.ystride, self.f_alt
	local biome = self.biome

    local csize = self.csize
    local sidelen = deco.sidelen or csize.x

    if csize.x % sidelen ~= 0 then
        sidelen = csize.x
    end

    local divlen = csize.x / sidelen
    local area = sidelen * sidelen

    for z0 = 0, divlen-1 do
        for x0 = 0, divlen-1 do
            local center = {
                x=math_floor(minp.x + sidelen / 2 + sidelen * x0),
                z=math_floor(minp.z + sidelen / 2 + sidelen * z0),
            }
            local min = {
                x=minp.x + sidelen * x0,
                z=minp.z + sidelen * z0,
            }
            local max = {
                x=minp.x + sidelen + sidelen * x0 - 1,
                z=minp.z + sidelen + sidelen * z0 - 1,
            }

            local nval = (
				deco.noise_params
				and minetest.get_perlin(deco.noise_params):get2d({x=center.x, y=center.z})
				or deco.fill_ratio
			)

            local deco_count = area * nval
            if deco_count > 1 then
                deco_count = math_floor(deco_count)
            elseif deco_count > 0 then
                if ps:next(1, 1000) <= deco_count * 1000 then
                    deco_count = 1
                else
                    deco_count = 0
                end
            end

            for _ = 1, deco_count do
                local x = ps:next(min.x, max.x)
                local z = ps:next(min.z, max.z)
                local mapindex = csize.x * (z - minp.z) + (x - minp.x) + 1
                local y, up
				local y_s = {}

                if deco.liquid_surface then
					self:find_break(y_s, x, z, 'down', 'liquid')
                elseif deco.all_ceilings then
					self:find_break(y_s, x, z, 'up')
					up = true
                elseif deco.all_floors then
					self:find_break(y_s, x, z, 'down')
                elseif heightmap and heightmap[mapindex] then
                    y = heightmap[mapindex]
					if y >= 0 and y < 80 then
						table.insert(y_s, y)
					end
                end

				for _, y in pairs(y_s) do
					if not self.biome then
						if y < heightmap[mapindex] - cave_level then
							biome = biomemap_cave[mapindex]
						else
							biome = biomemap[mapindex]
						end
					end

					if not deco.biomes_i or (biome and deco.biomes_i[biome.name]) then
						local ivm = vm_area:index(x, y + minp.y, z)
						if ((not deco.place_on_i) or deco.place_on_i[data[ivm]])
						and (not deco.y_max or deco.y_max >= y + f_alt)
						and (not deco.y_min or deco.y_min <= y + f_alt) then
							if up then
								ivm = ivm - ystride
							else
								ivm = ivm + ystride
							end
							if deco.deco_type == 'schematic' then
								local too_close
								local size_s = deco.size_offset and ((deco.size_offset.x + 1) * (deco.size_offset.z + 1)) or 9

								for _, s in ipairs(schem) do
									local dx, dz = s.x - x, s.z - z
									if dx * dx + dz * dz <= size_s then
										too_close = true
										break
									end
								end

								------------------------------
								-- Check for spawnby nodes.
								------------------------------

								if (deco.aquatic or data[ivm] == n_air) and not too_close then
									local rot = self.gpr:next(0, 3)
									y = y + (deco.place_offset_y or 0)
									local sch = deco.schematic_array or deco.schematic
									self:place_schematic(sch, VN(x, y + minp.y, z), deco.flags, rot)
									if up then
										local my = y + (deco.place_offset_y or 0) - sch.size.y + 1
										self:place_schematic(sch, VN(x, my, z), deco.flags, rot, 2)
									end
									schem[#schem+1] = VN(x, y + minp.y, z)
								end
							elseif deco.aquatic or data[ivm] == n_air then
								local ht = self.gpr:next(1, (deco.height_max or 1))
								local inc = 1
								if up then
									ht = -ht
									inc = -1
								end
								if deco.place_offset_y then
									ivm = ivm + deco.place_offset_y * ystride
								end
								for y2 = y, y + ht - inc, inc do
									local d = deco.decoration
									if type(d) == 'table' then
										d = deco.decoration[math_random(#d)]
									end

									if type(d) == 'string' then
										data[ivm] = node[d]
										if deco.param2_max then
											p2data[ivm] = self.gpr:next(deco.param2, deco.param2_max)
										else
											p2data[ivm] = deco.param2 or 0
										end
									end

									ivm = ivm + ystride * inc
									if not (deco.aquatic or data[ivm] == n_air) then
										break
									end
								end
							end
						end
					end
				end
            end
        end
    end
end


-- check
local rotated_schematics = {}
for i = 1, 21 do
	table.insert(rotated_schematics, {})
end
function Mapgen:place_schematic(schem, pos, flags, rot, rot_z)
	local area = self.area
	local data, p2data = self.data, self.p2data

	if not rot_z then
		rot_z = 0
	end

	if not rot then
		rot = 0
	end

	if not (pos and schem and type(schem) == 'table') then
		return
	end

	local yslice_offset = 0
	local yslice = {}  -- true if the slice should be removed
	if schem.yslice_prob then
		for _, ys in pairs(schem.yslice_prob) do
			yslice[ys.ypos] = ((ys.prob or 255) <= self.gpr:next(1, 255))

			if rot_z == 2 and yslice[ys.ypos] then
				yslice_offset = yslice_offset + 1
			end
		end
	end

	local rotated_schem_1
	local rotated_schem_2
	if rotated_schematics[rot+1 + rot_z * 4][schem] then
		rotated_schem_1 = rotated_schematics[rot+1][schem]
	else
		if rot == 0 or rot == 2 then
			rotated_schem_1 = mod.schematic_array(schem.size.x, schem.size.y, schem.size.z)
		elseif rot == 1 or rot == 3 then
			rotated_schem_1 = mod.schematic_array(schem.size.z, schem.size.y, schem.size.x)
		end

		if rot_z == 2 then
			rotated_schem_2 = mod.schematic_array(rotated_schem_1.size.x, rotated_schem_1.size.y, rotated_schem_1.size.z)
		elseif rot_z == 1 or rot_z == 3 then
			rotated_schem_2 = mod.schematic_array(rotated_schem_1.size.y, rotated_schem_1.size.x, rotated_schem_1.size.z)
		end

		if rot == 0 then
			rotated_schem_1 = schem
		else
			local ystride = schem.size.x
			local zstride = schem.size.y * schem.size.x
			local ystride_1 = rotated_schem_1.size.x
			local zstride_1 = rotated_schem_1.size.y * rotated_schem_1.size.x

			for z = 0, schem.size.z - 1 do
				for x = 0, schem.size.x - 1 do
					local x1, z1
					if rot == 1 then
						x1, z1 = schem.size.z - z - 1, x
					elseif rot == 2 then
						x1, z1 = schem.size.x - x - 1, schem.size.z - z - 1
					elseif rot == 3 then
						x1, z1 = z, schem.size.x - x - 1
					end

					for y = 0, schem.size.y-1 do
						local isch1 = z1 * zstride_1 + y * ystride_1 + x1 + 1
						local isch = z * zstride + y * ystride + x + 1
						rotated_schem_1.data[isch1] = schem.data[isch]
					end
				end
			end
		end

		rotated_schematics[rot+1][schem] = rotated_schem_1
	end

	if rot_z == 0 then
		rotated_schem_2 = rotated_schem_1
	else
		local ystride_1 = rotated_schem_1.size.x
		local zstride_1 = rotated_schem_1.size.y * rotated_schem_1.size.x
		local ystride_2 = rotated_schem_2.size.x
		local zstride_2 = rotated_schem_2.size.y * rotated_schem_2.size.x

		for y1 = 0, rotated_schem_1.size.y - 1 do
			for x1 = 0, rotated_schem_1.size.x - 1 do
				local x2, y2
				if rot_z == 1 then
					x2, y2 = rotated_schem_1.size.y - y1 - 1, x1
				elseif rot_z == 2 then
					x2, y2 = rotated_schem_1.size.x - x1 - 1, rotated_schem_1.size.y - y1 - 1
				elseif rot_z == 3 then
					x2, y2 = y1, rotated_schem_1.size.x - x1 - 1
				end

				for z = 0, rotated_schem_1.size.z-1 do
					local isch2 = z * zstride_2 + y2 * ystride_2 + x2 + 1
					local isch1 = z * zstride_1 + y1 * ystride_1 + x1 + 1
					rotated_schem_2.data[isch2] = rotated_schem_1.data[isch1]
				end
			end
		end
	end

	local place_center_x = flags and flags:find('place_center_x')
	local place_center_z = flags and flags:find('place_center_z')
	if rot_z == 0 then
		if flags and (
			((rot == 0 or rot == 2) and place_center_x)
			or ((rot == 1 or rot == 3) and place_center_z)
		) then
			pos.x = pos.x - math_floor(rotated_schem_2.size.x / 2)
		end

		if flags and (
			((rot == 0 or rot == 2) and place_center_z)
			or ((rot == 1 or rot == 3) and place_center_x)
		) then
			pos.z = pos.z - math_floor(rotated_schem_2.size.z / 2)
		end
	elseif rot_z == 2 then
		if flags and (((rot == 0 or rot == 2) and place_center_x) or ((rot == 1 or rot == 3) and place_center_z)) then
			pos.x = pos.x - math_floor(rotated_schem_2.size.x / 2)
		end

		if flags and (
			((rot == 0 or rot == 2) and place_center_z)
			or ((rot == 1 or rot == 3) and place_center_x)
		) then
			pos.z = pos.z - math_floor(rotated_schem_2.size.z / 2)
		end
	elseif rot_z == 1 or rot_z == 3 then
		if flags and place_center_z then
			pos.y = pos.y - math_floor(rotated_schem_2.size.y / 2)
		end

		if flags and place_center_x then
			pos.z = pos.z - math_floor(rotated_schem_2.size.z / 2)
		end
	end

	-- ?????
	if rot_z == 2 and flags and place_center_z then
		pos.y = pos.y - rotated_schem_2.size.y
	elseif rot_z == 1 and flags and place_center_z then
		pos.x = pos.x - rotated_schem_2.size.x
	end

	for z = 0, rotated_schem_2.size.z-1 do
		for x = 0, rotated_schem_2.size.x-1 do
			local ycount = 1
			for y = 0, rotated_schem_2.size.y-1 do
				local ivm = area:index(pos.x + x, pos.y + yslice_offset + ycount - 1, pos.z + z)
				local isch = z * rotated_schem_2.size.y * rotated_schem_2.size.x + y * rotated_schem_2.size.x + x + 1

				if not yslice[y] then
					local prob = rotated_schem_2.data[isch].prob or rotated_schem_2.data[isch].param1 or 255
					local force

					if prob > 127 then
						prob = prob - 128
						force = true
					end

					if prob >= self.gpr:next(1, 126)
					and (
						force or (
							data[ivm] == n_air
							or data[ivm] == n_water
							or data[ivm] == n_ignore
						)
					) then
						data[ivm] = node[rotated_schem_2.data[isch].name]

						local param2 = rotated_schem_2.data[isch].param2
						local fdir = (param2 or 0) % 24
						local extra = (param2 or 0) - fdir
						for _ = 1, rot do
							fdir = drotn[fdir]
						end
						if rot_z > 0 then
							--Values range 0 - 23
							--facedir / 4 = axis direction:
							--0 = y+	1 = z+	2 = z-	3 = x+	4 = x-	5 = y-
							--facedir modulo 4 = rotation around that axis
							local za = {
								{[0] = 12, [7] = 4, [9] = 8, [12] = 0, [18] = 20 },
								{[0] = 20, [7] = 4, [9] = 8, [12] = 16, [18] = 12, },
								{[0] = 16, [7] = 4, [9] = 8, [12] = 0, [18] = 20 },
							}
							fdir = za[rot_z][fdir] or za[rot_z][0]
						end
						param2 = fdir + extra
						p2data[ivm] = param2
					end

					ycount = ycount + 1
				end
			end
		end
	end
end


function Mapgen:dust()
	local area, data, p2data = self.area, self.data, self.p2data
	local minp, maxp = self.minp, self.maxp
	local biomemap = self.biomemap
	local heightmap = self.heightmap
	local f_alt = self.f_alt
	--local treetop

	local biome = self.biome
	local n_cloud = node[mod_name..':cloud_hard']

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local ivm = area:index(x, maxp.y - 1, z)
			if biomemap and biomemap[index] then
				biome = biomemap[index]
			end

			local node_dust
			if biome then
				node_dust = biome.node_dust
			end

			if node_dust and (data[ivm] == n_air or data[ivm] == n_ignore) then
				local yc
				for y = maxp.y - 1, minp.y + 1, -1 do
					if y - minp.y + f_alt >= heightmap[index] and data[ivm] and data[ivm] ~= n_air and data[ivm] ~= n_ignore and data[ivm] ~= n_cloud then
						yc = y
						break
					end

					ivm = ivm - area.ystride
				end

				if yc then
					local name = minetest.get_name_from_content_id(data[ivm])
					local n = minetest.registered_nodes[name]
					if data[ivm] == n_ignore
					or (
						n and (not n.drawtype or dusty_types[n.drawtype])
						and n.walkable ~= false
					) then
						ivm = ivm + area.ystride
						data[ivm] = node[node_dust]
						p2data[ivm] = 0
					end
				end
			end

			index = index + 1
		end
	end
end


function mod.spawnplayer(player)
	local csize = mod.csize
	local range = 6

	local name = player:get_player_name()
	if minetest.get_modpath('beds') and beds and beds.spawn then
		if beds.spawn[name] then
			return
		end
	end

	if minetest.settings:get("static_spawnpoint") then
		return
	end

	-- Very simple, compared to typical mapgen spawn code,

	local pos = vector.new(
		math_random(range) + math_random(range) - range,
		0,
		math_random(range) + math_random(range) - range
	)
	--pos = vector.new(3,0,-3)
	pos = vector.multiply(pos, 800)
	pos = vector.subtract(vector.add(pos, vector.divide(csize, 2)), chunk_offset)
	pos.y = pos.y + base_level - csize.y / 2 + 2

	--pos = vector.new(90 + -2 * 3200, 100, 584 + -8 * 3200)
	--pos = vector.new(1760, 3200, 1090)

	player:setpos(pos)
	return true
end

minetest.register_on_newplayer(mod.spawnplayer)
minetest.register_on_respawnplayer(mod.spawnplayer)
