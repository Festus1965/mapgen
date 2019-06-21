-- Duane's mapgen mapgen.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


------------------------------------
-- store inverted schematics
-- remove unused variables
------------------------------------

-- Sometimes the oceans have air in them, causing odd decoration.


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
local altitude_cutoff_low_2 = 63
local base_level = mod.chunk_offset + water_diff
local cave_level = 20
local chunk_offset = mod.chunk_offset
local make_tracks = true
local road_w = 3
local cave_underground = 5
local stone_layer_noise = mod.stone_layer_noise
local use_pcall

local Geomorph = geomorph.Geomorph
local geomorphs = {}
local m_data = {}
local m_p2data = {}


local n_air = node['air']
local n_ignore = node['ignore']
local n_stone = node['default:stone']


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


local buildable_to = {}
for n, v in pairs(minetest.registered_nodes) do
	if v.buildable_to then
		buildable_to[node[n]] = true
	end
end

local grass_nodes = {}
for n in pairs(minetest.registered_nodes) do
	if n:find('grass_') then
		grass_nodes[n] = true
	end
end

local liquids = {}
for _, d in pairs(minetest.registered_nodes) do
	if d.groups and d.drawtype == 'liquid' then
		liquids[node[d.name] ] = true
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
	{ 'default:dirt', 0, },
	{ 'default:sand', 0, },
	{ 'default:stone_with_coal', 0, },
	{ 'default:gravel', 0, },
	{ 'default:stone_with_iron', 1, },
	{ 'default:stone_with_gold', 1, },
	{ 'default:stone_with_diamond', 2, },
	{ 'default:stone_with_mese', 2, },
}
local ore_intersect = {
	'default:stone',
	'default:sandstone',
	'default:desert_stone',
	'environ:basalt',
	'environ:granite',
	'environ:stone_with_lichen',
	'environ:stone_with_algae',
	'environ:stone_with_moss',
	'environ:stone_with_salt',
	'environ:hot_rock',
	'environ:sunny_stone',
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
		biomes_here = {},
		biomemap_cave = {},
		data = m_data,
		heightmap = {}, -- use global?
		meta_data = {},
		minp = minp,
		maxp = maxp,
		node = mod.node,
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


function Mapgen:dungeon(box_type)
		if not box_type then
			return
		end

		local geo = Geomorph.new()
		local box = geomorphs[box_type] or {}
		for _, v in pairs(box.shapes or {}) do
			geo:add(v)
		end
		geo:write_to_map(self, nil, geo_replace[box_type])
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


function Mapgen:generate(timed)
	local minp = self.minp
	local biomes = mod.biomes

	self.gpr = PcgRandom(self.seed + 5107)

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
	local base_heat = 20 + math_abs(70 - ((((minp.z + chunk_offset + 1000) / 6000) * 140) % 140))
	mod.base_heat = base_heat

	if minp.y < -28000 then
		self.ether = true
		self:terrain()
		decorate = false
	elseif sup_chunk.y >= 1 or (sup_chunk.x == 0 and sup_chunk.z == 0) then
		local ground = (sup_chunk.y == 5)
		if ground then
			self:map_roads()
		end

		local t_terrain_f = os_clock()
		self:terrain()
		mod.time_terrain_f = mod.time_terrain_f + os_clock() - t_terrain_f

		local do_ore = true
		if sup_chunk.x == 0 and sup_chunk.z == 0 then
			self:spirals()
			decorate = false
		elseif ground and self.flattened and self.gpr:next(1, 5) == 1 then
			local sr = self.gpr:next(1, 3)
			if sr == 1 then
				self:dungeon('pyramid_temple')
			elseif sr == 2 then
				self:dungeon('pyramid')
			else
				self:simple_ruin()
			end
			do_ore = false
		else
			if math_max(self.height_max, 10) < f_alt then
				self:planets()
			end
			if ground then
				self:houses()
			end
		end

		if sup_chunk.y <= 6
		and not (sup_chunk.x == 0 and sup_chunk.z == 0) and self.height_min > f_alt + cave_underground then
			local t_cave = os_clock()
			self:simple_cave()
			mod.time_caves = mod.time_caves + os_clock() - t_cave
		end

		if do_ore then
			local t_ore = os_clock()
			self:simple_ore()
			mod.time_ore = mod.time_ore + os_clock() - t_ore
		end
	elseif sup_chunk.y == 0 then
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


-- The houses function takes very little cpu time.
-- check
local house_materials = {'sandstonebrick', 'desert_stonebrick', 'stonebrick', 'brick', 'wood', 'junglewood'}
function Mapgen:houses()
	local csize = self.csize
	local plots = self.plots
	local pr = self.gpr
	local heightmap = self.heightmap

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

					for _ = 1, 3 do
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
				local ff_alt = math_max(0, pr:next(1, 3) + pr:next(1, 3) - 4)
				local ore = self:get_ore(ff_alt)
				pos = table.copy(box.pos)
				size = table.copy(box.size)

				geo:add({
					action = 'cube',
					node = ore,
					intersect = {walls1, roof1},
					location = pos,
					size = size,
					random = 100,
				})
			end

			do
				local index = pos.z * csize.x + pos.x
				local height = self.heightmap[index]
				local biome = self.biomemap[index]
				local dirt = biome and biome.node_top or 'default:dirt'

				pos = table.copy(box.pos)
				pos.y = height
				local ivm = self.area:indexp(vector.add(self.minp, pos))
				local p2 = self.p2data[ivm]

				pos = table.copy(box.pos)
				size = table.copy(box.size)
				size.y = 1
				geo:add({
					action = 'cube',
					node = dirt,
					location = pos,
					intersect = 'air',
					param2 = p2,
					size = size,
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

	local stone_layers = {}
	do
		local x, z = math.floor(minp.x / csize.x), math.floor(minp.z / csize.z)
		for y = 0, csize.y - 1 do
			stone_layers[y] = math_floor(math_abs(stone_layer_noise:get_3d({x=x, y=minp.y+y, z=z})) * 7) * 32
		end
	end
	self.stone_layers = stone_layers
end


-- check
function Mapgen:map_roads()
	local csize = self.csize
	local roads = {}
	local tracks = {}
	local has_roads = false

	local index
	local road_ws = road_w * road_w
	for x = -road_w, csize.x + road_w - 1 do
		index = x + road_w + 1
		local l_road = self.noise['road_1'].map[index]
		for z = -road_w, csize.z + road_w - 1 do
			local road_1 = self.noise['road_1'].map[index]
			if (l_road < 0) ~= (road_1 < 0) then
				local index2 = z * csize.x + x + 1
				if make_tracks then
					tracks[index2] = true
				end
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
				if make_tracks then
					tracks[index2] = true
				end
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

	if make_tracks then
		for z = -1, csize.z + 1 do
			for x = -1, csize.x + 1 do
				local index = z * csize.x + x + 1
				if tracks[index] then
					for zo = -1, 1 do
						for xo = -1, 1 do
							local index2 = (z + zo) * csize.x + (x + xo) + 1
							if tracks[index2] then
								if xo == 0 and zo == 0 then
									-- nop
								elseif math_abs(xo) == math_abs(zo) then
									local index3 = (z + 0) * csize.x + (x + xo) + 1
									local index4 = (z + zo) * csize.x + (x + 0) + 1
									if tracks[index3] or tracks[index4] then
										-- nop
									else
										tracks[index3] = true
									end
								end
							end
						end
					end
				end
			end
		end
	end

	local plots = {}

	-- Generate plots for constructions.
	for _ = 1, 15 do
		local scale = self.gpr:next(1, 2) * 4
		local size = VN(self.gpr:next(1, 2), 1, self.gpr:next(1, 2))
		size.x = size.x * scale + 9
		size.y = size.y * 8
		size.z = size.z * scale + 9

		for _ = 1, 10 do
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
					index = z * csize.x + x + 1
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
	self.tracks = tracks
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
			self.biomes_here[biome.name] = true
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

	local biome = self.biomemap_cave[math_floor(csize.z / 2 * csize.x + csize.x / 2)] or {}
	local liquid = biome.node_cave_liquid

	for _ = 1, 40 do
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

		if self.f_alt < 0 or pos.y <= self.heightmap[index] then
			if biome.node_floor or biome.node_ceiling then
				local hpos = vector.add(pos, -(biome.surface_depth or 1))
				local hsize = vector.add(size, (2 * (biome.surface_depth or 1)))
				local hy = math_floor(hsize.y / 2)
				if biome.node_floor then
					geo:add({
						action = 'sphere',
						node = biome.node_floor,
						location = hpos,
						intersect = { biome.node_stone or 'default:stone' },
						underground = cave_underground,
						size = hsize,
					})
					geo:add({
						action = 'cube',
						node = biome.node_stone or 'default:stone',
						location = VN(hpos.x, hpos.y + hy, hpos.z),
						intersect = { biome.node_floor },
						underground = cave_underground,
						size = VN(hsize.x, hy, hsize.z)
					})
				end
				if biome.node_ceiling then
					geo:add({
						action = 'sphere',
						node = biome.node_ceiling,
						location = hpos,
						intersect = { biome.node_stone or 'default:stone' },
						underground = cave_underground,
						size = hsize,
					})
					geo:add({
						action = 'cube',
						node = biome.node_stone or 'default:stone',
						location = VN(hpos.x, hpos.y, hpos.z),
						intersect = { biome.node_ceiling },
						underground = cave_underground,
						size = VN(hsize.x, hy, hsize.z)
					})
				end
			elseif biome.node_lining then
				geo:add({
					action = 'sphere',
					node = biome.node_lining,
					location = vector.add(pos, -(biome.surface_depth or 1)),
					intersect = { biome.node_stone or 'default:stone' },
					underground = cave_underground,
					size = vector.add(size, (2 * (biome.surface_depth or 1))),
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
	end

	if sup_chunk.y < 5 and liquid then
		geo:add({
			action = 'cube',
			node = liquid,
			location = VN(1, 1, 1),
			underground = cave_underground,
			intersect = 'air',
			size = VN(78, pr:next(10, 40), 78),
		})
	end

	geo:write_to_map(self)
end


function Mapgen:get_ore(f_alt)
	local oren = 0
	for _, i in pairs(ores) do
		if f_alt >= (i[2] or 0) then
			oren = oren + 1
		end
	end

	return ores[self.gpr:next(1, oren)][1]
end


function Mapgen:simple_ore()
	local f_alt = math_max(0, - math_floor(self.f_alt / self.csize.y))

	local minp = self.minp
	local pr = self.gpr

	local geo = Geomorph.new()
	for _ = 1, 25 do
		local ore = self:get_ore(f_alt)

		local size = VN(
			pr:next(1, 10) + pr:next(1, 10),
			pr:next(1, 10) + pr:next(1, 10),
			pr:next(1, 10) + pr:next(1, 10)
		)
		if self.placed_lava then
			size = VN(size, 2)
		end

		local p = VN(
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

	-- Change the colors of all default stone.
	-- The time for this is negligible.
	local area = self.area
	local maxp = self.maxp
	local data, p2data = self.data, self.p2data
	local stone_layers = self.stone_layers
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


-- check
function Mapgen:simple_ruin()
	if not self.flattened then
		return
	end

	local csize = self.csize
	local heightmap = self.heightmap
	local boxes = {}

	for _ = 1, 15 do
		local scale = self.gpr:next(2, 3) * 4
		local size = VN(self.gpr:next(1, 3), 1, self.gpr:next(1, 3))
		size.x = size.x * scale + 5
		size.y = size.y * 8
		size.z = size.z * scale + 5

		for _ = 1, 10 do
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
			for _ = pos.x, pos.x + size.x do
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
		location = VN(12, base_level, 12),
		size = VN(56, 1, 56),
	})
	geo:add({
		action = 'cylinder',
		axis = 'y',
		node = mod_name..':cloud_hard',
		location = VN(12, 75, 12),
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
			if buildable_to[data[ivm]] then
				data[ivm] = node['default:tree']
			end
			for oz = -2, 2 do
				for oy = -2, 2 do
					ivm = area:index(mx - 2, my + oy, mz + oz)
					for _ = -2, 2 do
						if buildable_to[data[ivm]] then
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
					if (buildable_to[data[ivm]])
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
-- Since these are tables of references, memory shouldn't be an issue.
local biomes_i, cave_biomes_i
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
	local ground_noise_map = self.noise['ground'].map
	local humidity_1_map = self.noise['humidity_1'].map
	local humidity_2_map = self.noise['humidity_2'].map
	local heat_2_map = self.noise['heat_2'].map
	local cave_heat_map = self.noise['cave_heat'].map
	local sup_chunk = self.sup_chunk

	if self.ether then
		ground_noise_map = self.noise['ground_ether'].map
	end

	local stone_layers = self.stone_layers

	local n_cobble = node['default:cobble']
	local n_mossy = node['default:mossycobble']
	local n_rail_power = node['carts:powerrail']
	local n_rail = node['carts:rail']

	local roads = self.roads or {}
	local tracks = self.tracks or {}

	-- Biome selection is expensive. This helps a bit.

	if not biomes_i then
		biomes_i = {}
		for _, b in pairs(biomes) do
			table.insert(biomes_i, b)
		end
		cave_biomes_i = {}
		for _, b in pairs(cave_biomes) do
			table.insert(cave_biomes_i, b)
		end
	end

	f_alt = f_alt or 0
	base_heat = base_heat or 65

	if self.ether then
		self.biome = biomes['ether']
	else
		self.biome = nil
	end

	local local_water_level = base_level - f_alt - water_diff + 1
	if self.ether then
		local_water_level = local_water_level + water_diff - 1
	end

	local height_min = mod.max_height
	local height_max = -mod.max_height

	local index = 1
	for _ = minp.z, maxp.z do
		for _ = minp.x, maxp.x do
			local ground_1 = ground_noise_map[index]
			height_max = math_max(ground_1, height_max)
			height_min = math_min(ground_1, height_min)
			index = index + 1
		end
	end
	self.height_min = height_min
	self.height_max = height_max

	if (math_max(altitude_cutoff_high, height_max) - altitude_cutoff_high)
	- (math_min(altitude_cutoff_low, height_min) - altitude_cutoff_low) < 3 then
		self.flattened = true
	end

	local humidity, hu2
	local cave_depth_mod = 60 - sup_chunk.y * 20

	index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			-- terrain height calculations
			local ground_1 = ground_noise_map[index]
			local height = base_level
			if ground_1 > altitude_cutoff_high then
				if self.ether then
					height = height + math_floor((ground_1 - altitude_cutoff_high) / 8 + 0.5)
				else
					height = height + ground_1 - altitude_cutoff_high
				end
			elseif ground_1 < altitude_cutoff_low then
				local g = altitude_cutoff_low - ground_1
				if g < altitude_cutoff_low_2 then
					g = g * g * 0.01
				else
					g = (g - altitude_cutoff_low_2) * 0.5 + 40
				end
				if self.ether then
					height = math_floor(height - math_floor(g / 8 + 0.5) + 0.5)
				else
					height = math_floor(height - g + 0.5)
				end
			end

			local biome, biome_cave, heat
			if self.biome then
				biome = self.biome
				biome_cave = cave_biomes['stone']
			else
				hu2 = humidity_2_map[index]
				humidity = humidity_1_map[index] + hu2
				heat = base_heat + heat_2_map[index]
				if height > base_level + 20 then
					local h2 = height - base_level - 20
					heat = heat - h2 * h2 * 0.005
				end

				biome = cave_biomes['stone']
				local biome_diff
				-- Converting to actual height (relative to the layer).
				local biome_height = height - chunk_offset
				for _, b in ipairs(biomes_i) do
					if b and (not b.y_max or b.y_max >= biome_height)
					and (not b.y_min or b.y_min <= biome_height) then
						local diff_he = b.heat_point - heat
						local diff_hu = b.humidity_point - humidity
						local diff = diff_he * diff_he + diff_hu * diff_hu
						if ((not biome_diff) or diff < biome_diff) then
							biome_diff = diff
							biome = b
						end
					end
				end
				biomemap[index] = biome
				self.biomes_here[biome.name] = true

				biome_diff = nil
				local cave_heat = cave_heat_map[index] + cave_depth_mod
				-- Why is this necessary?
				biome_cave = cave_biomes['stone']
				-- This time just look at the middle of the chunk,
				--  since decorations could go all through it.
				for _, b in ipairs(cave_biomes_i) do
					if b and (not b.y_max or b.y_max >= minp.y)
					and (not b.y_min or b.y_min <= maxp.y) then
						local diff_he = b.heat_point - cave_heat
						local diff_hu = b.humidity_point - humidity
						local diff = diff_he * diff_he + diff_hu * diff_hu
						if ((not biome_diff) or diff < biome_diff) then
							biome_diff = diff
							biome_cave = b
						end
					end
				end
				biomemap_cave[index] = biome_cave
				self.biomes_here[biome_cave.name] = true
			end

			local depth_filler = biome.depth_filler or 0
			local depth_top = biome.depth_top or 0
			if depth_top > 0 then
				depth_top = self:erosion(height, index, depth_top, 100)
			end
			if depth_filler > 0 then
				depth_filler = self:erosion(height, index, depth_filler, 20)
			end

			-- From here on, height is relative to the chunk.
			height = math_floor(height - f_alt + 0.5)
			heightmap[index] = height

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
			local grass_p2 = 0
			if biome.node_top == 'default:dirt_with_dry_grass'
			or biome.node_top == 'default:dirt_with_grass' then
				grass_p2 = math_floor((humidity - (heat / 2) + 9) / 3)
				grass_p2 = (7 - math_min(7, math_max(0, grass_p2))) * 32
			end

			local ww = node[biome.water or 'default:water_source']
			local wt = biome.node_water_top
			local wtd = biome.node_water_top_depth or 0
			if wt and wt:find('ice') then
				wt = node['default:ice']
				wtd = math_ceil(math_max(0, (30 - heat) / 3))
			elseif wt then
				wt = node[wt]
			end

			local fill_1 = height - depth_top
			local fill_2 = fill_1 - math_max(0, depth_filler)

			local t_y_loop = os_clock()
			local hu2_check
			if humidity and hu2 then
				hu2_check = (humidity > 70 and (hu2 > 1 or math_floor(hu2 * 1000) % 2 == 0))
			end
			local ivm = area:index(x, minp.y, z)
			for dy = 0, csize_y - 1 do
				if f_alt == 0 and dy == base_level + 1 and tracks[index] then
					if x % 5 == 0 or z % 5 == 0 then
						data[ivm] = n_rail_power
					else
						data[ivm] = n_rail
					end
				elseif f_alt == 0 and dy >= base_level - 1 and dy <= base_level and roads[index] then
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
				elseif dy <= height and dy > fill_1 then
					--print('fill_1 '..dump(fill_1))
					data[ivm] = top
					p2data[ivm] = 0 + grass_p2
				elseif filler and dy <= height and dy > fill_2 then
					--print('fill_2 '..dump(fill_2))
					data[ivm] = filler
					p2data[ivm] = 0
				elseif dy < height - 20 then
					data[ivm] = stone_cave
					p2data[ivm] = 0
				elseif dy <= height then
					--print('stone '..dump(stone))
					data[ivm] = stone
					if stone == n_stone then
						p2data[ivm] = stone_layers[dy]
					else
						p2data[ivm] = 0
					end
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
		local b_check
		if deco.biomes then
			for b in pairs(deco.biomes_i) do
				if self.biomes_here[b] then
					b_check = true
					break
				end
			end
		else
			b_check = true
		end

		if b_check and not (
			deco.bad_schem
			or (deco.max_y and deco.max_y < self.f_alt - chunk_offset)
			or (deco.min_y and deco.min_y > self.f_alt - chunk_offset + self.csize.y)
		) then
			self:place_deco(ps, deco)
		end
	end
end


local y_s = {}
function Mapgen:find_break(x, z, flags)
	local minp, maxp = self.minp, self.maxp
	local data, area = self.data, self.area
	local ystride = self.area.ystride

	for k in pairs(y_s) do
		y_s[k] = nil
	end

	if flags.liquid_surface then
		local ivm = area:index(x, maxp.y, z)
		for y = maxp.y, minp.y + 1, -1 do
			if data[ivm] ~= n_air then
				return
			end
			if liquids[data[ivm - ystride]] then
				return (y - minp.y - 1)
			end
			ivm = ivm - ystride
		end
	end

	if flags.all_ceilings then
		local ivm = area:index(x, minp.y, z)
		for y = minp.y, maxp.y - 1 do
			if buildable_to[data[ivm]] and not buildable_to[data[ivm + ystride]] then
				if data[ivm] == n_air or flags.force_placement then
					table.insert(y_s, -(y - minp.y + 1))
				end
			end
			ivm = ivm + ystride
		end
	end

	if flags.all_floors then
		-- Don't check heightmap. It doesn't work in bubble caves.
		local ivm = area:index(x, maxp.y, z)
		for y = maxp.y, minp.y + 1, -1 do
			if buildable_to[data[ivm]] and not buildable_to[data[ivm - ystride]] then
				if data[ivm] == n_air or flags.force_placement then
					table.insert(y_s, y - minp.y - 1)
				end
			end
			ivm = ivm - ystride
		end
	end

	if #y_s > 0 then
		return y_s[self.gpr:next(1, #y_s)]
	end
end


-- check
function Mapgen:place_deco(ps, deco)
    local data, p2data, vm_area = self.data, self.p2data, self.area
    local minp = self.minp
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
				local y
                local z = ps:next(min.z, max.z)
                local mapindex = csize.x * (z - minp.z) + (x - minp.x) + 1

                if deco.liquid_surface or deco.all_floors or deco.all_ceilings then
					y = self:find_break(x, z, deco)
                elseif heightmap and heightmap[mapindex] then
                    local fy = heightmap[mapindex]
					if fy >= 0 and fy < 80 then
						y = fy
					end
                end

				if y then
					local upside_down
					if y < 0 then
						y = math_abs(y)
						upside_down = true
					end

					if not self.biome then
						if y < heightmap[mapindex] - cave_level then
							biome = biomemap_cave[mapindex]
						else
							biome = biomemap[mapindex]
						end
					end

					if not deco.biomes_i or (biome and deco.biomes_i[biome.name]) then
						local ivm = vm_area:index(x, y + minp.y, z)
						-- Converting to actual height (relative to the layer).
						local deco_height = y + f_alt - chunk_offset
						if ((not deco.place_on_i) or deco.place_on_i[data[ivm]])
						and (not deco.y_max or deco.y_max >= deco_height)
						and (not deco.y_min or deco.y_min <= deco_height) then
							if upside_down then
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

								if (deco.force_placement or buildable_to[data[ivm]]) and not too_close then
									local rot = self.gpr:next(0, 3)
									local sch = deco.schematic_array or deco.schematic
									if upside_down then
										y = y - (deco.place_offset_y or 0) - sch.size.y + 1
										self:place_schematic(sch, VN(x, y + minp.y, z), deco.flags, rot, 2)
									else
										y = y + (deco.place_offset_y or 0)
										self:place_schematic(sch, VN(x, y + minp.y, z), deco.flags, rot)
									end
									schem[#schem+1] = VN(x, y + minp.y, z)
								end
							elseif deco.force_placement or buildable_to[data[ivm]] then
								local ht = self.gpr:next(1, (deco.height_max or 1))
								local inc = 1
								if upside_down then
									ht = -ht
									inc = -1
								end
								if deco.place_offset_y then
									if upside_down then
										ivm = ivm - deco.place_offset_y * ystride
									else
										ivm = ivm + deco.place_offset_y * ystride
									end
								end
								local first_node = data[ivm]
								for _ = y, y + ht - inc, inc do
									local d = deco.decoration
									if type(d) == 'table' then
										d = deco.decoration[math_random(#d)]
									end

									if type(d) == 'string' and (deco.force_placement or buildable_to[data[ivm]]) then
										local grass_p2 = 0
										if grass_nodes[d] then
											grass_p2 = p2data[ivm - ystride]
										end
										data[ivm] = node[d]
										if deco.param2_max then
											p2data[ivm] = self.gpr:next(deco.param2, deco.param2_max)
										else
											p2data[ivm] = deco.param2 or grass_p2 or 0
										end
										if deco.random_color_floor_ceiling then
											if upside_down then
												p2data[ivm] = 0 + self.gpr:next(0, 7) * 32
											else
												p2data[ivm] = 1 + self.gpr:next(0, 7) * 32
											end
										end
									end

									ivm = ivm + ystride * inc
									if not (deco.force_placement or data[ivm] == first_node) then
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
for _ = 1, 21 do
	table.insert(rotated_schematics, {})
end
function Mapgen:place_schematic(schem, pos, flags, rot, rot_z)
	local area = self.area
	local data, p2data = self.data, self.p2data
	local color = self.gpr:next(1, 8)

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
						force or buildable_to[data[ivm]]
					) then
						data[ivm] = node[rotated_schem_2.data[isch].name]

						local param2 = rotated_schem_2.data[isch].param2
						local fdir = (param2 or 0) % 32
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
						if mod.eight_random_colors[data[ivm]] then
							extra = color * 32
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

			if node_dust and buildable_to[data[ivm]] then
				local yc
				for y = maxp.y - 1, minp.y + 1, -1 do
					if y - minp.y + f_alt >= heightmap[index] and not buildable_to[data[ivm]] then
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
	local beds_here = (minetest.get_modpath('beds') and beds and beds.spawn)

	local name = player:get_player_name()
	if beds_here then
		if beds.spawn[name] then
			return
		end
	end

	if minetest.settings:get("static_spawnpoint") then
		return
	end

	-- Very simple, compared to typical mapgen spawn code,

	local pos = VN(
		math_random(range) + math_random(range) - range,
		0,
		math_random(range) + math_random(range) - range
	)
	--pos = VN(1,0,5)
	pos = vector.multiply(pos, 800)
	pos = vector.subtract(vector.add(pos, vector.divide(csize, 2)), chunk_offset)
	pos.y = pos.y + base_level - csize.y / 2 + 2

	--pos = VN(90 + -2 * 3200, 100, 584 + -8 * 3200)
	--pos = VN(1760, 3200, 1090)

	player:setpos(pos)

	if beds_here then
		-- This doesn't work...
		--beds.set_spawns()
		beds.spawn[name] = pos
	end

	return true
end

minetest.register_on_newplayer(mod.spawnplayer)
minetest.register_on_respawnplayer(mod.spawnplayer)
