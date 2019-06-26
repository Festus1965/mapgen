-- Duane's mapgen mapgen.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local DEBUG
local mod = mapgen
local mod_name = 'mapgen'


local math_abs = math.abs
local math_ceil = math.ceil
local math_floor = math.floor
local math_max = math.max
local math_min = math.min
local math_random = math.random
local node = mod.node
local os_clock = os.clock
local VN = vector.new


local chunksize = tonumber(minetest.settings:get("chunksize") or 5)
local chunk_offset = math.floor(chunksize / 2) * 16;

local Geomorph = geomorph.Geomorph
local geomorphs = {}
local m_data = {}
local m_p2data = {}


local n_stone = node['default:stone']


-- If on my system, it's ok to crash.
local use_pcall
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
	mod_name..':basalt',
	mod_name..':granite',
	mod_name..':stone_with_lichen',
	mod_name..':stone_with_algae',
	mod_name..':stone_with_moss',
	mod_name..':stone_with_salt',
	mod_name..':hot_rock',
	mod_name..':sunny_stone',
}


local default_noises = {
	heat = { def = { offset = 50, scale = 50, spread = {x = 1000, y = 1000, z = 1000}, seed = 5349, octaves = 3, persistence = 0.5, lacunarity = 2.0, flags = 'eased' }, },
	heat_blend = { def = { offset = 0, scale = 1.5, spread = {x = 8, y = 8, z = 8}, seed = 13, octaves = 2, persistence = 1.0, lacunarity = 2.0, flags = 'eased' }, },
	humidity = { def = { offset = 50, scale = 50, seed = 842, spread = {x = 1000, y = 1000, z = 1000}, octaves = 3, persist = 0.5, lacunarity = 2, flags = 'eased' }, },
	humidity_blend = { def = { offset = 0, scale = 1.5, seed = 90003, spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1.0, lacunarity = 2, flags = 'eased' }, },
	--flat_cave_1 = { def = { offset = 0, scale = 10, seed = 6386, spread = {x = 23, y = 23, z = 23}, octaves = 3, persist = 0.7, lacunarity = 1.8 }, },
	--cave_heat = { def = { offset = 50, scale = 50, seed = 1578, spread = {x = 200, y = 200, z = 200}, octaves = 3, persist = 0.5, lacunarity = 2 }, },
}



--[[
-- generic subclass
function mod.subclass(...)
	-- "cls" is the new class
	local cls, bases = {}, {...}

	-- copy base class contents into the new class
	for i, base in ipairs(bases) do
		for k, v in pairs(base) do
			cls[k] = v
		end
	end

	-- set the class's __index, and start filling an "is_a" table that contains this class and all of its bases
	-- so you can do an "instance of" check using my_instance.is_a[MyClass]
	cls.__index, cls.is_a = cls, {[cls] = true}
	for i, base in ipairs(bases) do
		for c in pairs(base.is_a or {}) do
			cls.is_a[c] = true
		end
		cls.is_a[base] = true
	end

	cls.super = bases[1]

	-- the class's __call metamethod
	setmetatable(cls, {__call = function (c, ...)
		local instance = setmetatable({}, c)
		-- run the init method if it's there
		local init = instance._init
		if init then init(instance, ...) end
		return instance
	end})

	-- return the new class table, that's ready to fill with methods
	return cls
end
--]]



function mod.subclass_mapgen()
	-- "cls" is the new class
	local cls, bases = {}, { mod.Mapgen }

	-- copy base class contents into the new class
	for i, base in ipairs(bases) do
		for k, v in pairs(base) do
			cls[k] = v
		end
	end

	-- set the class's __index, and start filling an "is_a" table that contains this class and all of its bases
	-- so you can do an "instance of" check using my_instance.is_a[MyClass]
	cls.__index, cls.is_a = cls, {[cls] = true}
	for i, base in ipairs(bases) do
		for c in pairs(base.is_a or {}) do
			cls.is_a[c] = true
		end
		cls.is_a[base] = true
	end

	cls.super = bases[1]

	-- the class's __call metamethod
	setmetatable(cls, {__call = function (c, mg, params, ...)
		local instance = setmetatable({}, c)

		-- These are specific to a Mapgen subclass.
		-- Should they run after _init?
		for k, v in pairs(mg or {}) do
			instance[k] = v
		end
		for k, v in pairs(params or {}) do
			instance[k] = v
		end

		-- run the init method if it's there
		local init = instance._init
		if init then init(instance, ...) end

		return instance
	end})

	-- return the new class table, that's ready to fill with methods
	return cls
end



-----------------------------------------------
-- Mapgen class
-----------------------------------------------

mod.Mapgen = {}
local Mapgen = mod.Mapgen
local Mapgen_mt = { __index = Mapgen, }
function Mapgen:new(minp, maxp, seed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	if not (vm and emin and emax) then
		return
	end

	local inst = {}
	setmetatable(inst, Mapgen_mt)

	inst.area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	inst.csize = { x=chunksize * 16, y=chunksize * 16, z=chunksize * 16 }
	inst.biomemap = {} -- use global?
	inst.biomes_here = {}
	inst.biomemap_cave = {}
	inst.buildable_to = buildable_to
	inst.data = vm:get_data(m_data)
	inst.grassmap = {}
	inst.heatmap = {}
	inst.heightmap = {} -- use global?
	inst.humiditymap = {}
	inst.meta_data = {}
	inst.minp = minp
	inst.maxp = maxp
	inst.node = mod.node
	inst.p2data = vm:get_param2_data(m_p2data)
	inst.noise = {}
	inst.noises = table.copy(default_noises)
	inst.schem = {}
	inst.share = {}
	inst.seed = seed
	inst.vm = vm

	assert(inst.p2data == m_p2data)

	return inst
end


function Mapgen:bedrock()
	local minp, maxp = self.minp, self.maxp
	local data, p2data = self.data, self.p2data

	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			local ivm = self.area:index(minp.x, y, z)
			for x = minp.x, maxp.x do
				-------------------------------------------
				-- Make bedrock.
				-------------------------------------------
				data[ivm] = n_stone
				-------------------------------------------
				p2data[ivm] = 0

				ivm = ivm + 1
			end
		end
	end
end


function Mapgen:dust()
	local area, data, p2data = self.area, self.data, self.p2data
	local minp, maxp = self.minp, self.maxp
	local biomemap = self.biomemap
	local heightmap = self.heightmap
	local water_level = self.water_level

	local n_ignore = node['ignore']
	local n_air = node['air']

	local biome = self.share.biome

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = heightmap[index] or water_level or minp.y - 2
			local ivm = area:index(x, maxp.y - 1, z)
			if biomemap and biomemap[index] then
				biome = biomemap[index]
			end

			local node_dust
			if biome then
				node_dust = biome.node_dust
			end

			if node_dust and data[ivm] == n_air then
				local yc
				for y = maxp.y - 1, minp.y + 1, -1 do
					if y >= height and data[ivm] ~= n_air then
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


-- check
function Mapgen:erosion(height, index, depth, factor)
	if not self.noise['erosion'] then
		return depth
	end

	local e = self.noise['erosion'].map[index]
	if e <= 0 then
		return depth
	end
	e = depth - math_floor(height * height / factor / factor * (e + 1))
	return e
end


-------------------------------------------------
-- Finds a place to put decorations with the all_floors,
--  all_ceilings, or liquid_surface flags.
-------------------------------------------------

local y_s = {}
function Mapgen:find_break(x, z, flags, gpr)
	local minp, maxp = self.minp, self.maxp
	local data, area = self.data, self.area
	local ystride = self.area.ystride

	local n_air = node['air']

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
		return y_s[gpr:next(1, #y_s)]
	end
end


function Mapgen:flat_map_height()
	local minp, maxp = self.minp, self.maxp
	local height = 8

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			self.heightmap[index] = self.water_level + height
			index = index + 1
		end
	end

	self.share.height_max = height
	self.share.height_min = height
end


function Mapgen:generate()
	-- Override this.
	print(mod_name..': You must override the generate method.')
end


function Mapgen:generate_all(timed)
	local minp, maxp = self.minp, self.maxp

	local chunk = vector.divide(vector.add(minp, chunk_offset), 80)
	self:make_stone_layer_noise()  -- This isn't always needed.

	local mapgens = { }
	for _, map in pairs(mod.world_map) do
		if vector.contains(map.minp, map.maxp, chunk) then
			local mapgen = map.mapgen(self, map.params)
			------------------------------------------
			-- Better way to do this?
			------------------------------------------
			mapgen.water_level = map.water_level
			------------------------------------------

			for k, v in pairs(map.noises or {}) do
				self.noises[k] = v
			end

			table.insert(mapgens, mapgen)
		end
	end

	self:make_noises(self.noises)

	local t_terrain = os_clock()
	for _, mapgen in pairs(mapgens) do
		-------------------------------------------
		-- This must include height and biome mapping.
		-------------------------------------------
		mapgen.generate(mapgen)
		-------------------------------------------
	end
	mod.time_terrain = mod.time_terrain + os_clock() - t_terrain

	if #mapgens > 0 then
		local t_deco = os_clock()
		-------------------------------------------
		-- How can we override this?
		-------------------------------------------
		self:place_all_decorations()
		if not self.share.no_dust then
			self:dust()
		end
		-------------------------------------------
		mod.time_deco = mod.time_deco + os_clock() - t_deco
	else
		self:bedrock()
	end

	self:save_map(timed)

	mod.chunks = mod.chunks + 1
end


function Mapgen:geomorph(box_type)
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


function Mapgen:get_noise(n, v)
	local minp, csize = self.minp, self.csize
	local size = v.size or table.copy(csize)

	-------------------------------------------
	-- Move this stuff.
	-------------------------------------------
	if n == 'flat_cave_1' then
		v.def.seed = 6386 + math_floor(minp.y / csize.y)
	end
	-------------------------------------------

	if not v.noise then
		if v.is3d then
			v.noise = minetest.get_perlin_map(v.def, size)
		else
			size.z = nil
			v.noise = minetest.get_perlin_map(v.def, size)
		end

		if not v.noise then
			print(mod_name..': could not get noise '..n)
			return
		end
	end

	if not self.noise[n] then
		-- Keep pointers to global noise info
		self.noise[n] = {
			def = v.def,
			map = nil,
			noise = v.noise,
		}
	end

	-------------------------------------------
	-- Fix this.
	-------------------------------------------
	-- This stays with the mapgen object. ????????
	if v.is3d then
		v.map = v.noise:get3dMap_flat(minp, v.map)
		self.noise[n] = v
	else
		v.map = v.noise:get2dMap_flat({x=minp.x, y=minp.z}, v.map)
		self.noise[n] = v
	end
	-------------------------------------------

	return v
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


function Mapgen:make_noises(noises)
	for n, v in pairs(noises or {}) do
		self:get_noise(n, v)
	end
end


local stone_layer_noise = mod.stone_layer_noise
function Mapgen:make_stone_layer_noise()
	local minp, csize = self.minp, self.csize

	local stone_layers = {}
	do
		local x, z = math.floor(minp.x / csize.x), math.floor(minp.z / csize.z)
		for y = 0, csize.y - 1 do
			stone_layers[y] = math_floor(math_abs(stone_layer_noise:get_3d({x=x, y=minp.y+y, z=z})) * 7) * 32
		end
	end
	self.stone_layers = stone_layers
end


-- Since these are tables of references, memory shouldn't be an issue.
local biomes_i, cave_biomes_i
function Mapgen:map_biomes(offset)
	local heightmap = self.heightmap
	local heatmap = self.heatmap
	local humiditymap = self.humiditymap
	local biomemap = self.biomemap
	local biomemap_cave = self.biomemap_cave
	local biomes = mod.biomes
	local water_level = self.water_level
	-----------------------------------------
	-- Move this.
	-----------------------------------------
	local cave_heat_map
	if not self.div and self.noise['cave_heat'] then
		cave_heat_map = self.noise['cave_heat'].map
	end
	-----------------------------------------
	local cave_biomes = mod.cave_biomes
	local minp, maxp = self.minp, self.maxp

	if offset then
		offset = offset - 1
	else
		offset = 0
	end

	local cave_depth_mod = -10 - math_floor((minp.y - offset + self.chunk_offset) / 80) * 5

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

	local index = 1
	for _ = minp.z, maxp.z do
		for _ = minp.x, maxp.x do
			local height = heightmap[index]
			local heat = heatmap[index]
			local humidity = humiditymap[index]

			local biome = cave_biomes['stone']
			local biome_diff
			-- Converting to actual height (relative to the layer).
			local biome_height = height and (height - offset) or water_level
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

			-----------------------------------------
			-- Move this.
			-----------------------------------------
			if not self.div and cave_heat_map then
				biome_diff = nil
				local cave_heat = cave_heat_map[index] + cave_depth_mod
				-- Why is this necessary?
				local biome_cave = cave_biomes['stone']
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
			-----------------------------------------

			index = index + 1
		end
	end
end


function Mapgen:map_heat_humidity()
	local minp, maxp = self.minp, self.maxp
	local heightmap = self.heightmap
	local heatmap = self.heatmap
	local humiditymap = self.humiditymap
	local grassmap = self.grassmap
	local water_level = self.water_level

	local heat_noise = map.heat or 'heat'
	local heat_noise_map = self.noise[heat_noise] or self[heat_noise] or heat_noise
	local heat_blend_noise = map.heat_blend or 'heat_blend'
	local heat_blend_noise_map = self.noise[heat_blend_noise] or self[heat_blend_noise] or heat_blend_noise
	local humidity_noise = map.humidity or 'humidity'
	local humidity_noise_map = self.noise[humidity_noise] or self[humidity_noise] or humidity_noise
	local humidity_blend_noise = map.humidity_blend or 'humidity_blend'
	local humidity_blend_noise_map = self.noise[humidity_blend_noise] or self[humidity_blend_noise] or humidity_blend_noise

	if type(heat_noise_map) == 'table' and heat_noise_map.map then
		heat_noise_map = heat_noise_map.map
	end
	if type(heat_blend_noise_map) == 'table' and heat_blend_noise_map.map then
		heat_blend_noise_map = heat_blend_noise_map.map
	end
	if type(humidity_noise_map) == 'table' and humidity_noise_map.map then
		humidity_noise_map = humidity_noise_map.map
	end
	if type(humidity_blend_noise_map) == 'table' and humidity_blend_noise_map.map then
		humidity_blend_noise_map = humidity_blend_noise_map.map
	end

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = heightmap[index] or minp.y - 2
			local heat, heat_blend, humidity, humidity_blend

			if type(heat_noise_map) == 'table' then
				heat = heat_noise_map[index]
			elseif type(heat_noise_map) == 'function' then
				heat = heat_noise_map(index)
			elseif type(heat_noise_map) == 'number' then
				heat = heat_noise_map
			else
				return
			end
			if type(heat_blend_noise_map) == 'table' then
				heat_blend = heat_blend_noise_map[index]
			elseif type(heat_blend_noise_map) == 'function' then
				heat_blend = heat_blend_noise_map(index)
			elseif type(heat_blend_noise_map) == 'number' then
				heat_blend = heat_blend_noise_map
			else
				return
			end
			heat = heat + heat_blend

			if height > water_level + 25 then
				local h2 = height - water_level - 25
				heat = heat - h2 * h2 * 0.005
			end

			if type(humidity_noise_map) == 'table' then
				humidity = humidity_noise_map[index]
			elseif type(humidity_noise_map) == 'function' then
				humidity = humidity_noise_map(index)
			elseif type(humidity_noise_map) == 'number' then
				humidity = humidity_noise_map
			else
				return
			end
			if type(humidity_blend_noise_map) == 'table' then
				humidity_blend = humidity_blend_noise_map[index]
			elseif type(humidity_blend_noise_map) == 'function' then
				humidity_blend = humidity_blend_noise_map(index)
			elseif type(humidity_blend_noise_map) == 'number' then
				humidity_blend = humidity_blend_noise_map
			else
				return
			end
			humidity = humidity + humidity_blend

			heatmap[index] = heat
			humiditymap[index] = humidity

			local grass_p2 = math_floor((humidity - (heat / 2) + 9) / 3)
			grass_p2 = (7 - math_min(7, math_max(0, grass_p2))) * 32
			grassmap[index] = grass_p2

			index = index + 1
		end
	end
end


function Mapgen:place_all_decorations()
	local minp, maxp = self.minp, self.maxp
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
			or (deco.max_y and deco.max_y < minp.y)
			or (deco.min_y and deco.min_y > maxp.y)
		) then
			self:place_deco(ps, deco)
		end
	end
end


-- check
local cave_level = 20
function Mapgen:place_deco(ps, deco)
    local data, p2data, vm_area = self.data, self.p2data, self.area
    local minp, maxp = self.minp, self.maxp
    local heightmap, schem = self.heightmap, self.schem
	local biomemap = self.biomemap
	local biomemap_cave = self.biomemap_cave
	local ystride = vm_area.ystride
	local biome = self.share.biome

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
				local upside_down

                if deco.liquid_surface or deco.all_floors or deco.all_ceilings then
					y = self:find_break(x, z, deco, ps)
					if y then
						if y < 0 then
							y = math_abs(y)
							upside_down = true
						end
						y = y + minp.y
					end
                elseif heightmap and heightmap[mapindex] then
                    local fy = heightmap[mapindex]
					if fy >= minp.y and fy < maxp.y then
						y = fy
					end
                end

				if y then
					if not self.share.biome then
						if y < heightmap[mapindex] - cave_level then
							biome = biomemap_cave[mapindex]
						else
							biome = biomemap[mapindex]
						end
					end

					if not deco.biomes_i or (biome and deco.biomes_i[biome.name]) then
						local ivm = vm_area:index(x, y, z)
						if ((not deco.place_on_i) or deco.place_on_i[data[ivm]])
						and (not deco.y_max or deco.y_max >= y)
						and (not deco.y_min or deco.y_min <= y) then
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
									local rot = ps:next(0, 3)
									local sch = deco.schematic_array or deco.schematic
									if upside_down then
										y = y - (deco.place_offset_y or 0) - sch.size.y + 1
										self:place_schematic(sch, VN(x, y, z), deco.flags, ps, rot, 2)
									else
										y = y + (deco.place_offset_y or 0)
										self:place_schematic(sch, VN(x, y, z), deco.flags, ps, rot)
									end
									schem[#schem+1] = VN(x, y, z)
								end
							elseif deco.force_placement or buildable_to[data[ivm]] then
								local ht = ps:next(1, (deco.height_max or 1))
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
											p2data[ivm] = ps:next(deco.param2, deco.param2_max)
										else
											p2data[ivm] = deco.param2 or grass_p2 or 0
										end
										if deco.random_color_floor_ceiling then
											if upside_down then
												p2data[ivm] = 0 + ps:next(0, 7) * 32
											else
												p2data[ivm] = 1 + ps:next(0, 7) * 32
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
function Mapgen:place_schematic(schem, pos, flags, ps, rot, rot_z)
	local area = self.area
	local data, p2data = self.data, self.p2data
	local color = ps:next(1, 8)

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
			yslice[ys.ypos] = ((ys.prob or 255) <= ps:next(1, 255))

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

					if prob >= ps:next(1, 126)
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


-- check
function Mapgen:place_terrain()
	local area = self.area
	local cave_biomes = mod.cave_biomes
	local data = self.data
	local heightmap = self.heightmap
	local grassmap = self.grassmap
	local biomemap = self.biomemap
	local biomemap_cave = self.biomemap_cave
	local maxp = self.maxp
	local minp = self.minp
	local ystride = area.ystride
	local p2data = self.p2data
	local div = self.div
	local water_level = self.water_level

	local ground = (maxp.y >= water_level and minp.y <= water_level)

	local stone_layers = self.stone_layers

	local n_cobble = node['default:cobble']
	local n_mossy = node['default:mossycobble']

	self:map_height()
	self:map_heat_humidity()
	if not self.share.biome then
		self:map_biomes(self.share.height_offset)
	end

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = heightmap[index] or minp.y - 2
			local biome, biome_cave

			if self.share.biome then
				biome = self.share.biome
				biome_cave = cave_biomes['stone']
			else
				biome = biomemap[index] or {}
				biome_cave = biomemap_cave[index] or {}
			end

			local depth_filler = biome.depth_filler or 0
			local depth_top = biome.depth_top or 0
			if depth_top > 0 then
				depth_top = self:erosion(height, index, depth_top, 100)
			end
			if depth_filler > 0 then
				depth_filler = self:erosion(height, index, depth_filler, 20)
			end

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
				grass_p2 = grassmap[index] or 0
			end

			local ww = biome.water or 'default:water_source'
			local wt = biome.node_water_top
			local wtd = biome.node_water_top_depth or 0
			do
				local heat = self.heatmap[index]
				if heat < 28 and ((not wt and ww:find('water')) or wt:find('ice')) then
					wt = node['default:ice']
					wtd = math_ceil(math_max(0, (30 - heat) / 3))
				elseif wt then
					wt = node[wt]
				end
			end
			ww = node[ww]

			local fill_1 = height - depth_top
			local fill_2 = fill_1 - math_max(0, depth_filler)

			local t_y_loop = os_clock()

			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				if y > height and y <= water_level then
					if y > water_level - wtd then
						data[ivm] = wt
					else
						data[ivm] = ww
					end
					p2data[ivm] = 0
				elseif y <= height and y > fill_1 then
					data[ivm] = top
					p2data[ivm] = 0 + grass_p2
				elseif filler and y <= height and y > fill_2 then
					data[ivm] = filler
					p2data[ivm] = 0
				elseif y < height - 20 then
					data[ivm] = stone_cave
					p2data[ivm] = 0
				elseif y <= height then
					data[ivm] = stone
					if stone == n_stone then
						p2data[ivm] = stone_layers[y - minp.y]
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
local cave_underground = 5
function Mapgen:simple_caves()
	local minp, maxp = self.minp, self.maxp
	local pr = self.gpr
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

		if maxp.y < self.water_level or pos.y <= self.heightmap[index] then
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

	if minp.y < self.water_level and liquid then
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


function Mapgen:simple_ore()
	local minp, maxp = self.minp, self.maxp
	local f_alt = math_max(0, - math_floor((minp.y + self.chunk_offset) / self.csize.y))

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




local function generate(minp, maxp, seed)
	if not (minp and maxp and seed) then
		print(mod_name..': generate did not receive minp, maxp, and seed. Aborting.')
		return
	end

	local mg = Mapgen:new(minp, maxp, seed)
	if not mg then
		return
	end

	mg.chunk_offset = chunk_offset

	mg:generate_all(true)
	local mem = math_floor(collectgarbage('count')/1024)
	if mem > 200 then
		print('Lua Memory: ' .. mem .. 'M')
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


function mod.spawnplayer(player)
	local csize = { x=chunksize * 16, y=chunksize * 16, z=chunksize * 16 }
	local range = 1000

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

	local pos

	for ct = 1, 1000 do
		pos = VN(
			math_random(range) + math_random(range) - range,
			0,
			math_random(range) + math_random(range) - range
		)
		local chunk = vector.floor(vector.divide(vector.add(pos, chunk_offset), csize))

		local mg_map
		for _, map in pairs(mod.world_map) do
			if vector.contains(map.minp, map.maxp, chunk) then
				mg_map = map
				break
			end
		end

		if not (mg_map.mapgen and mg_map.mapgen.get_spawn_level) then
			return
		end

		pos.y = mg_map.mapgen:get_spawn_level(mg_map, pos.x, pos.z)

		if pos.y then
			--print(ct..' spawns attempted')
			break
		end
	end

	if not pos.y then
		return
	end

	pos.y = pos.y + 2
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
