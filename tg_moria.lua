-- Duane's mapgen tg_moria.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod, layers_mod = mapgen, mapgen
local mod_name = mod.mod_name
local max_height = 31000
local VN = vector.new


local node = layers_mod.node
local clone_node = layers_mod.clone_node
local carpetable, box_names, sides


dofile(mod.path .. '/dungeon_stuff.lua')


-----------------------------------------------
-- 
-----------------------------------------------


local bts = {}
-- check
function mod.generate_moria(params)
	if params.share.disruptive then
		return
	end

	local minp, maxp = params.isect_minp, params.isect_maxp
	local csize = params.csize
	local chunk = vector.floor(vector.divide(vector.add(minp, 32), 80))

	if params.share.height_min and params.share.height_min < params.realm_maxp.y then
		return
	end

	-- You really don't want cave biomes in geomoria...
	params.share.no_biome = true

	if params.disruptive then
		params.share.disruptive = true
	end

	--print('called at minp ', params.isect_minp.y)
	if not box_names then
		box_names = {}
		for k, v in pairs(layers_mod.registered_geomorphs) do
			if v.areas and v.areas:find('geomoria') then
				table.insert(box_names, v.name)
			end
		end
	end

	if not mod.carpetable then
		mod.setup_dungeon_decor(params)
	end

	local nofill
	local water_level = params.sealevel

	--[[
	local height_max = params.share.height_max
	if params.share.disruptive or (height_max and math.max(water_level, height_max) > minp.y) then
		return
	end
	--]]

	local box_seed = chunk.z * 10000 + chunk.y * 100 + chunk.x + 150
	local bgpr = PcgRandom(box_seed)
	local box_type = box_names[bgpr:next(1, #box_names)]
	local box = layers_mod.registered_geomorphs[box_type]
	--local box = layers_mod.registered_geomorphs['lake_of_fire']

	do
		local geo = Geomorph.new(params)
		geo:add({
			action = 'cube',
			node = 'default:stone',
			location = vector.new(0, 0, 0),
			size = table.copy(csize),
		})
		geo:write_to_map(0)
	end

	local geo = Geomorph.new(params, box)
	geo:write_to_map(0)

	if not nofill then
		mod.dungeon_decor(params)
	end
end


dofile(mod.path .. '/plans.lua')


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------

-- Define the noises.
--layers_mod.register_noise( 'dflat_ground', { offset = 0, scale = 100, seed = 4382, spread = {x = 320, y = 320, z = 320}, octaves = 6, persist = 0.5, lacunarity = 2.0} )

layers_mod.register_mapgen('tg_moria', mod.generate_moria, { full_chunk = true })
if layers_mod.register_spawn then
	--layers_mod.register_spawn('tg_moria', mod.get_spawn_level)
end
