-- Duane's mapgen mapgen.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local DEBUG
local mod = mapgen
local mod_name = 'mapgen'


if minetest.get_modpath('realms') then
	return
end


mod.buildable_to = {}
mod.grass_nodes = {}
mod.liquids = {}
mod.registered_realms = {}

--local buildable_to = mod.buildable_to
--local grass_nodes = mod.grass_nodes
--local liquids = mod.liquids
local m_data = {}
local m_p2data = {}




function mod.parse_configuration_file_line(line, lineno)
	local fields = {}
	for f in line:gmatch('([^|]+)%|?') do
		local s = f:gsub('%s+', '')
		table.insert(fields, s)
	end
	local error_line = mod_name .. ': * bad realms.conf, line #' .. lineno .. ': ' .. line

	if #fields <= 1 then
		return
	elseif #fields < 8 then
		minetest.log(error_line)
		minetest.log(mod_name .. ':   missing items (There should be 8+, separated by |)')
		return
	end

	if not mod.registered_mapgens[fields[1] ] then
		fields[1] = fields[1]:gsub('[^%a%d%_]+', '')
		local file_name = mod.path .. '/' .. fields[1] .. '.lua'
		local f = io.open(file_name, 'r')
		if f then
			f:close()
			dofile(file_name)
		end
	end

	if not mod.registered_mapgens[fields[1] ] then
		--minetest.log(error_line)
		--minetest.log(mod_name .. ':   ' .. fields[1] .. ' is not a registered mapgen')
		return
	end

	for i = 2, 8 do
		local s = fields[i]
		fields[i] = tonumber(fields[i])
		if not fields[i] then
			minetest.log(error_line)
			minetest.log(mod_name .. ':   ' .. s .. ' is not a number')
			return
		end
	end
	if fields[1] == 'tg_floaters' then
		print(dump(fields))
	end

	return fields
end


function mod.read_configuration_file()
	local file_name = mod.path .. '/realms.conf'

	local file = io.open(file_name, 'r')
	if not file then
		return
	end

	local good
	local lineno = 0
	for line in file:lines() do
		lineno = lineno + 1
		local fields = mod.parse_configuration_file_line(line, lineno)
		if fields then
			table.insert(mod.registered_realms, {
				mapgen = fields[1],
				realm_minp = { x = fields[2], y = fields[3], z = fields[4] },
				realm_maxp = { x = fields[5], y = fields[6], z = fields[7] },
				sea_level = fields[8],
				biomes_name = fields[9],
			})
			good = true
		end
	end

	file:close()

	return good
end


--[[
function mod.get_vm(minp, maxp, seed)
	if not (minp and maxp) then
		return
	end

	if not mod.mapseed then
		mod.mapseed = minetest.get_mapgen_setting('seed')

		-- This is not the correct mapseed if a text value is used
		--  as the world's seed. Mintest gives the wrong seed to lua
		--  for some reason. It's not a big deal, just annoying.
		mod.mapseed = limit32(tonumber(mod.mapseed))

		--print(mod_name..': starting with mapseed = ' .. string.format('%x', mod.mapseed))
	end
	local mapseed = mod.mapseed

	-- This is not the same blockseed minetest provides. It uses
	--  some extremely suspicious arithmetic that deliberately
	--  overflows an integer repeatedly, for a mathematically
	--  incorrect result. Lua doesn't want to give incorrect
	--  results, so it's very hard to duplicate.
	-- Instead, I just make my own seed.
	local blockseed = mod.get_block_seed2(minp, mapseed)

	local vm, emin, emax
	if seed then
		self.ongen = true
		vm, emin, emax = minetest.get_mapgen_object('voxelmanip')
	else
		self.ongen = false
		vm = minetest.get_voxel_manip()
		if not vm then
			return
		end
		emin, emax = vm:read_from_map(minp, maxp)
	end
end
--]]


function mod.generate_all(params)
	--mod.make_stone_layer_noise()  -- This isn't always needed.

	local realms = {}
	for _, realm in pairs(mod.registered_realms) do
		local minp, maxp = realm.realm_minp, realm.realm_maxp

		-- This won't necessarily find realms smaller than a chunk.
		if vector.contains(minp, maxp, params.chunk_minp)
		or vector.contains(minp, maxp, params.chunk_maxp) then
			print('running mapgen ' .. realm.mapgen)
			table.insert(realms, realm)
		end
	end

	if #realms < 1 then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object('voxelmanip')

	if not (vm and emin and emax) then
		return
	end

	--[[
	local csize = self.csize
	local max_height = mod.max_height
	local heightmap = {}
	for i = 1, csize.z * csize.x do
		heightmap[i]= -max_height
	end
	self.heightmap = heightmap
	--]]

	params.area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	params.data = vm:get_data(m_data)
	params.p2data = vm:get_param2_data(m_p2data)
	params.vmparam2 = params.p2data
	--params.seed = blockseed
	params.vm = vm
	params.metadata = {}
	params.share = {}
	params.share.propagate_shadow = false

	-- This has to be done after the game starts.
	mod.populate_node_arrays()

	--params.biomemaps = {}
	for _, realm in pairs(realms) do
		-------------------------------------------
		-- This must include height and biome mapping.
		-------------------------------------------
		local t_terrain = os.clock()
		params.isect_minp = vector.intersect_max(params.chunk_minp, realm.realm_minp)
		params.isect_maxp = vector.intersect_min(params.chunk_maxp, realm.realm_maxp)
		params.sealevel = realm.sea_level
		--assert(vector.equals(params.isect_minp, params.chunk_minp))
		--assert(vector.equals(params.isect_maxp, params.chunk_maxp))
		mod.registered_mapgens[realm.mapgen](params)
		mod.time_terrain = mod.time_terrain + os.clock() - t_terrain
		-------------------------------------------

		--[[
		local biome = mapgen.biome or mapgen.share.biome
		if biome then
			table.insert(params.biomemaps, { ['only'] = biome })
		elseif mapgen.biomemap then
			table.insert(params.biomemaps, mapgen.biomemap)
		end
		--]]
	end

	--[[
	mod.place_all_decorations()
	if not params.share.no_dust then
		mod.dust()
	end
	--]]

	mod.save_map(params)

	mod.chunks = mod.chunks + 1
end


function mod.populate_node_arrays()
	local node = mod.node

	if #mod.buildable_to < 1 then
		for n, v in pairs(minetest.registered_nodes) do
			if v.buildable_to then
				mod.buildable_to[node[n] ] = true
			end
		end
	end

	if #mod.grass_nodes < 1 then
		for n in pairs(minetest.registered_nodes) do
			if n:find('grass_') then
				mod.grass_nodes[n] = true
			end
		end
	end

	if #mod.liquids < 1 then
		for _, d in pairs(minetest.registered_nodes) do
			if d.groups and d.drawtype == 'liquid' then
				mod.liquids[node[d.name] ] = true
			end
		end
	end
end


function mod.save_map(params)
	local t_over = os.clock()

	params.vm:set_data(params.data)
	params.vm:set_param2_data(params.p2data)

	if DEBUG then
		params.vm:set_lighting({day = 10, night = 10})
	else
		params.vm:set_lighting({day = 0, night = 0}, params.minp, params.maxp)
		params.vm:calc_lighting(nil, nil, params.share.propagate_shadow)
	end

	--params.vm:update_liquids()
	params.vm:write_to_map()

	-- Save all meta data for chests, cabinets, etc.
	for _, t in ipairs(params.metadata) do
		local meta = minetest.get_meta({x=t.x, y=t.y, z=t.z})
		meta:from_table()
		meta:from_table(t.meta)
	end

	-- Call on_construct methods for nodes that request it.
	-- This is mainly useful for starting timers.
	for i, n in ipairs(params.data) do
		if mod.construct_nodes[n] then
			local pos = params.area:position(i)
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

	mod.time_overhead = mod.time_overhead + os.clock() - t_over
end


function mod.generate(minp, maxp, seed)
	if not (minp and maxp and seed) then
		print(mod_name..': generate did not receive minp, maxp, and seed. Aborting.')
		return
	end

	local params = {
		chunk_minp = minp,
		chunk_maxp = maxp,
		chunk_seed = seed,
	}
	mod.generate_all(params)

	local mem = math.floor(collectgarbage('count')/1024)
	if true or mem > 200 then
		print('Lua Memory: ' .. mem .. 'M')
	end
end


function mod.pgenerate(...)
	local status, err

	local t_all = os.clock()
	if mod.use_pcall then
		status, err = pcall(mod.generate, ...)
	else
		status = true
		mod.generate(...)
	end
	mod.time_all = mod.time_all + os.clock() - t_all

	if not status then
		print(mod_name .. ': Could not generate terrain:')
		print(dump(err))
		collectgarbage('collect')
	end
end


function mod.main()
	-- If on my system, it's ok to crash.
	local f = io.open(mod.path..'/duane', 'r')
	if f then
		print(mod_name .. ': Running without safety measures...')
	else
		mod.use_pcall = true
	end


	if mod.read_configuration_file() then
		if minetest.registered_on_generateds then
			-- This is unsupported. I haven't been able to think of an alternative.
			table.insert(minetest.registered_on_generateds, 1, mod.pgenerate)
		else
			minetest.register_on_generated(mod.pgenerate)
		end
	end
end


mod.main()
