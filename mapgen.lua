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


local chunksize = tonumber(minetest.settings:get('chunksize') or 5)
local chunk_offset = math.floor(chunksize / 2) * 16;
local spawn_height = tonumber(minetest.settings:get('mapgen_spawn_height') or 1)

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


for _, n in pairs({'match_three:top', 'default:chest'}) do
	if minetest.registered_nodes[n] then
		mod.add_construct(n)
	end
end


mod.buildable_to = {}
mod.grass_nodes = {}
mod.liquids = {}
local buildable_to = mod.buildable_to
local grass_nodes = mod.grass_nodes
local liquids = mod.liquids


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



-- generic subclass
function mod.subclass(...)
	-- 'cls' is the new class
	local cls, bases = {}, {...}

	-- copy base class contents into the new class
	for i, base in ipairs(bases) do
		for k, v in pairs(base) do
			cls[k] = v
		end
	end

	-- set the class's __index, and start filling an 'is_a' table that contains this class and all of its bases
	-- so you can do an 'instance of' check using my_instance.is_a[MyClass]
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


-- specialized for mapgens
function mod.subclass_mapgen()
	local cls, bases = {}, { mod.Mapgen }

	for i, base in ipairs(bases) do
		for k, v in pairs(base) do
			-- In this case, we don't want to inherit _init.
			if k ~= '_init' then
				cls[k] = v
			end
		end
	end

	cls.__index, cls.is_a = cls, {[cls] = true}
	for i, base in ipairs(bases) do
		for c in pairs(base.is_a or {}) do
			cls.is_a[c] = true
		end
		cls.is_a[base] = true
	end

	cls.super = bases[1]

	setmetatable(cls, {__call = function (c, mg, params, ...)
		local instance = setmetatable({}, c)

		for k, v in pairs(mg or {}) do
			instance[k] = v
		end
		for k, v in pairs(params or {}) do
			instance[k] = v
		end

		local init = instance._init
		if init then init(instance, ...) end

		return instance
	end})

	return cls
end



-----------------------------------------------
-- Mapgen class
-----------------------------------------------

mod.Mapgen = mod.subclass({
	csize = { x=chunksize * 16, y=chunksize * 16, z=chunksize * 16 },
	biomemap = {}, -- use global?
	biomes_here = {},
	biomemap_cave = {},
	buildable_to = buildable_to,
	chunksize = chunksize,
	chunk_offset = chunk_offset,
	default_noises = default_noises,
	grassmap = {},
	heatmap = {},
	heightmap = {}, -- use global?
	humiditymap = {},
	meta_data = {},
	noises = table.copy(default_noises),  -- This copy isn't necessary...
	node = mod.node,
	ore_intersect = ore_intersect,
	ores = ores,
	noise = {},
	schem = {},
	share = {},
})
local Mapgen = mod.Mapgen

function Mapgen:_init(minp, maxp, seed)
	if not (minp and maxp and seed) then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object('voxelmanip')
	if not (vm and emin and emax) then
		return
	end

	local csize = self.csize
	local max_height = mod.max_height
	local heightmap = {}
	for i = 1, csize.z * csize.x do
		heightmap[i]= -max_height
	end
	self.heightmap = heightmap

	self.area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	self.data = vm:get_data(m_data)
	self.minp = minp
	self.maxp = maxp
	self.p2data = vm:get_param2_data(m_p2data)
	self.seed = seed
	self.vm = vm
	self.share = {}  -- Don't carry this between chunks.
	self.share.propagate_shadow = false

	if #buildable_to < 1 then
		for n, v in pairs(minetest.registered_nodes) do
			if v.buildable_to then
				buildable_to[node[n] ] = true
			end
		end
	end

	if #grass_nodes < 1 then
		for n in pairs(minetest.registered_nodes) do
			if n:find('grass_') then
				grass_nodes[n] = true
			end
		end
	end

	if #liquids < 1 then
		for _, d in pairs(minetest.registered_nodes) do
			if d.groups and d.drawtype == 'liquid' then
				liquids[node[d.name] ] = true
			end
		end
	end
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

			local biome = self.biome or self.share.biome
			if not biome then
				for _, bm in pairs(self.biomemaps) do
					if bm['only'] then
						biome = bm['only']
					else
						biome = bm[index]
					end

					if biome and biome.node_dust then
						break
					end
					biome = nil
				end
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
	if not self.noises['erosion'] then
		return depth
	end

	local e = self.noises['erosion'].map[index]
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
		if vector.contains(map.map_minp, map.map_maxp, chunk) then
			local mapgen = map.mapgen(self, map)
			--print(mapgen.name)
			table.insert(mapgens, mapgen)
			mapgen:make_noises(mapgen.noises)
		end
	end

	self.biomemaps = {}
	for _, mapgen in pairs(mapgens) do
		-------------------------------------------
		-- This must include height and biome mapping.
		-------------------------------------------
		local t_terrain = os_clock()
		mapgen.generate(mapgen)
		mod.time_terrain = mod.time_terrain + os_clock() - t_terrain
		-------------------------------------------

		local biome = mapgen.biome or mapgen.share.biome
		if biome then
			table.insert(self.biomemaps, { ['only'] = biome })
		elseif mapgen.biomemap then
			table.insert(self.biomemaps, mapgen.biomemap)
		end
	end

	self:place_all_decorations()
	if not self.share.no_dust then
		self:dust()
	end

	if #mapgens == 0 and minp.y < 0 then
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


function Mapgen:get_noise(v)
	if not v then
		print(mod_name..': get_noise was called without an argument')
		return
	end

	local minp, csize = self.minp, self.csize
	local size = v.size or table.copy(csize)

	--[[
	-------------------------------------------
	-- Move this stuff.
	-------------------------------------------
	if n == 'flat_cave_1' then
		v.def.seed = 6386 + math_floor(minp.y / csize.y)
	end
	-------------------------------------------
	--]]

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

	if not (v.map and v.minp == minp) then
		if v.is3d then
			v.map = v.noise:get3dMap_flat(minp, v.map)
		else
			v.map = v.noise:get2dMap_flat({x=minp.x, y=minp.z}, v.map)
		end
		-- Store minp so I know when this is a new chunk.
		v.minp = minp
	end

	return v
end


function Mapgen:get_ore(f_alt)
	local oren = 0
	for _, i in pairs(self.ores) do
		if f_alt >= (i[2] or 0) then
			oren = oren + 1
		end
	end

	return self.ores[self.gpr:next(1, oren)][1]
end


function Mapgen:make_noises(noises)
	for _, v in pairs(noises or {}) do
		self:get_noise(v)
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


function Mapgen:get_biome(biomes_i, heat, humidity, biome_height)
	local biome, biome_diff
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
	return biome
end


function Mapgen:map_biomes(force_height)
	if self.biome or not self.biomes then
		return
	end

	local heightmap = self.heightmap
	local heatmap = self.heatmap
	local humiditymap = self.humiditymap
	local biomemap = self.biomemap
	local biomes = self.biomes
	local water_level = self.water_level
	local biomes_i = {}
	local minp, maxp = self.minp, self.maxp
	local offset = (self.height_offset or 1) - 1

	-- Biome selection is expensive. This helps a bit.
	for _, b in pairs(biomes) do
		table.insert(biomes_i, b)
	end

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = force_height or heightmap[index] or ((minp.y + maxp.y) / 2)
			local heat = heatmap[index]
			local humidity = humiditymap[index]

			-- Converting to actual height (relative to the layer).
			local biome_height = height - offset
			local biome = self:get_biome(biomes_i, heat, humidity, biome_height)

			if biome then
				biomemap[index] = biome
				self.biomes_here[biome.name] = true
			end

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
	local offset = (self.height_offset or 1) - 1

	local heat_noise_map = self.noises[self.heat] or self[self.heat] or (type(self.heat) == 'number' and self.heat) or self:get_noise(default_noises['heat'])
	local heat_blend_noise_map = self.noises[self.heat_blend] or self[self.heat_blend] or (type(self.heat_blend) == 'number' and self.heat_blend) or self:get_noise(default_noises['heat_blend'])
	local humidity_noise_map = self.noises[self.humidity] or self[self.humidity] or (type(self.humidity) == 'number' and self.humidity) or self:get_noise(default_noises['humidity'])
	local humidity_blend_noise_map = self.noises[self.humidity_blend] or self[self.humidity_blend] or (type(self.humidity_blend) == 'number' and self.humidity_blend) or self:get_noise(default_noises['humidity_blend'])

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

			height = height - offset

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


function Mapgen:map_height()
	-- Override this.
	print(mod_name..': You must override the map_height method.')
end


function Mapgen:place_all_decorations()
	local minp, maxp = self.minp, self.maxp
	local ps = PcgRandom(self.seed + 53)
	local biome = self.biome or self.share.biome

	for _, deco in pairs(mod.decorations) do
		local b_check
		if deco.biomes then
			for b in pairs(deco.biomes_i) do
				if (biome and b == biome.name) or self.biomes_here[b] then
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
function Mapgen:place_deco(ps, deco)
    local data, p2data, vm_area = self.data, self.p2data, self.area
    local minp, maxp = self.minp, self.maxp
    local heightmap, schem = self.heightmap, self.schem
	--local biomemap = self.biomemap
	local ystride = vm_area.ystride

    local csize = self.csize
    local sidelen = deco.sidelen or csize.x

    if csize.x % sidelen ~= 0 then
        sidelen = csize.x
    end

    local divlen = csize.x / sidelen
    local area = sidelen * sidelen

	local cave_level = self.share.cave_level or 20

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
					local biome = self.biome or self.share.biome or (not deco.biomes_i)
					if not biome then
						for _, bm in pairs(self.biomemaps) do
							if bm['only'] then
								biome = bm['only']
							else
								biome = bm[mapindex]
							end

							if biome and not (biome.underground and y > heightmap[mapindex] - cave_level)
							and deco.biomes_i[biome.name] then
								break
							end
							biome = nil
						end
					end

					if biome then
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
										d = deco.decoration[ps:next(1, #d)]
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
					and (force or buildable_to[data[ivm]]) then
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
	local maxp = self.maxp
	local minp = self.minp
	local ystride = area.ystride
	local p2data = self.p2data
	local water_level = self.water_level

	local stone_layers = self.stone_layers

	self:map_height()
	if not (self.biome or self.share.biome) then
		self:map_heat_humidity()
		self:map_biomes()
	end

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local height = heightmap[index] or minp.y - 2
			local biome = self.biome or self.share.biome or biomemap[index] or {}

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
				local heat = self.heatmap[index] or 50
				if heat < 28 and ((not wt and ww:find('water')) or wt:find('ice')) then
					wt = node['default:ice']
					wtd = math_ceil(math_max(0, (30 - heat) / 3))
				elseif wt then
					wt = node[wt]
				end
			end
			ww = node[ww]
			local wtb = water_level - wtd

			local fill_1 = height - depth_top
			local fill_2 = fill_1 - math_max(0, depth_filler)

			local t_y_loop = os_clock()
			local ivm = area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				if y > height and y <= water_level then
					if y > wtb then
						data[ivm] = wt
					else
						data[ivm] = ww
					end
					p2data[ivm] = 0
				elseif y <= height and y > fill_1 then
					data[ivm] = top
					p2data[ivm] = grass_p2 --  + 0
				elseif filler and y <= height and y > fill_2 then
					data[ivm] = filler
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
		self.vm:calc_lighting(nil, nil, self.share.propagate_shadow)
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


function Mapgen:simple_ore(num_deposits)
	local minp, maxp = self.minp, self.maxp
	local f_alt = math_max(0, - math_floor((minp.y + self.chunk_offset) / self.csize.y))

	local pr = self.gpr
	if not num_deposits then
		num_deposits = 100
	end

	local geo = Geomorph.new()
	for _ = 1, num_deposits do
		local ore = self:get_ore(f_alt)

		local size = VN(
			pr:next(1, 4) + pr:next(1, 4),
			pr:next(1, 4) + pr:next(1, 4),
			pr:next(1, 4) + pr:next(1, 4)
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
			intersect = self.ore_intersect,
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

	local mg = Mapgen(minp, maxp, seed)
	if not mg then
		return
	end
	mg.name = 'Mapgen'

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
		collectgarbage('collect')
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
	local range = 2000

	local beds_here = (minetest.get_modpath('beds') and beds and beds.spawn)

	local name = player:get_player_name()
	if beds_here then
		if beds.spawn[name] then
			return
		end
	end

	if minetest.settings:get('static_spawnpoint') then
		return
	end

	local pos

	for ct = 1, 10000 do
		pos = VN(
			math_random(range) + math_random(range) - range,
			spawn_height,
			math_random(range) + math_random(range) - range
		)
		local chunk = vector.floor(vector.divide(vector.add(pos, chunk_offset), csize))

		local mg_map
		for _, map in pairs(mod.world_map) do
			if vector.contains(map.map_minp, map.map_maxp, chunk) then
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
