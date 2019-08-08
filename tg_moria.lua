-- Duane's mapgen dflat.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod, layers_mod
if minetest.get_modpath('realms') then
	layers_mod = realms
	mod = floaters
else
	layers_mod = mapgen
	mod = mapgen
end

local mod_name = mod.mod_name

local max_height = 31000
local VN = vector.new


local node
if layers_mod.mod_name == 'mapgen' then
	node = layers_mod.node
	clone_node = layers_mod.clone_node
else
	dofile(mod.path .. '/functions.lua')
	node = mod.node
	clone_node = mod.clone_node
end


local carpetable, box_names, sides


do
	local clone_node = layers_mod.clone_node

	minetest.register_node(mod_name..':broken_door', {
		description = 'Broken Door',
		tiles = {'broken_door.png'},
		is_ground_content = true,
		walkable = false,
		paramtype = 'light',
		drop = 'default:wood',
		drawtype = 'signlike',
		visual_scale = 2,
		paramtype2 = 'wallmounted',
		selection_box = {
			type = 'wallmounted',
		},
		groups = {choppy=3},
		sounds = default.node_sound_wood_defaults(),
	})

	minetest.register_node(mod_name..':spider_web', {
		description = 'Spider Web',
		tiles = {'spider_web.png'},
		inventory_image = 'spider_web.png',
		is_ground_content = true,
		walkable = false,
		use_texture_alpha = true,
		paramtype = 'light',
		drop = 'farming:cotton',
		drawtype = 'signlike',
		paramtype2 = 'wallmounted',
		selection_box = {
			type = 'wallmounted',
		},
		groups = {oddly_breakable_by_hand=1},
	})

	minetest.register_node(mod_name..':ruined_carpet_1', {
		description = 'Ruined Carpet',
		tiles = {'ruined_carpet_1.png'},
		inventory_image = 'ruined_carpet_1.png',
		is_ground_content = true,
		walkable = false,
		use_texture_alpha = true,
		paramtype = 'light',
		drop = 'farming:string',
		drawtype = 'signlike',
		paramtype2 = 'wallmounted',
		selection_box = {
			type = 'wallmounted',
		},
		groups = {oddly_breakable_by_hand=1},
	})

	minetest.register_node(mod_name..':puddle_ooze', {
		description = 'Disgusting Ooze',
		tiles = {'puddle_ooze.png'},
		inventory_image = 'puddle_ooze.png',
		is_ground_content = true,
		walkable = false,
		light_source = 2,
		use_texture_alpha = true,
		paramtype = 'light',
		drop = 'farming:string',
		drawtype = 'signlike',
		visual_scale = 2,
		paramtype2 = 'wallmounted',
		selection_box = {
			type = 'wallmounted',
		},
		groups = {falling_node=1},
		sounds = default.node_sound_water_defaults(),
	})

	minetest.register_node(mod_name..':broken_statue', {
		description = 'Broken Statue',
		tiles = {'default_sandstone.png'},
		is_ground_content = true,
		paramtype = 'light',
		paramtype2 = 'facedir',
		drop = 'defaut:cobble',
		drawtype = 'nodebox',
		node_box = { type = 'fixed',
		fixed = {
			{-0, 0.2, -0.125, 0.18, 0.5, 0.18}, -- pelvis
			{-0.18, 0.2, -0.125, 0.18, 0.4, 0.18}, -- pelvis
			{0.04, -0.5, -0.08, 0.18, 0.2, 0.1}, -- rightleg
			{-0.18, -0.5, -0.08, -0.04, 0.2, 0.1}, -- leftleg
			{-0.18, -0.5, -0.04, -0.04, -0.45, 0.24}, -- leftfoot
			{0.04, -0.5, -0.04, 0.18, -0.45, 0.24}, -- rightfoot
		} },
		--groups = {oddly_breakable_by_hand=1},
		sounds = default.node_sound_stone_defaults(),
	})

	local nd = clone_node('default:stone')
	nd.walkable = false
	minetest.register_node(mod_name..':false_wall', nd)

	nd = clone_node('default:stone_block')
	nd.walkable = false
	minetest.register_node(mod_name..':false_wall_block', nd)

	-- This just prevents ore spawns in the walls.
	nd = clone_node('default:stone')
	nd.drop = 'default:cobble'
	minetest.register_node(mod_name..':stone1', nd)
	nd = table.copy(nd)
	minetest.register_node(mod_name..':stone2', nd)

	nd = clone_node('default:water_source')
	nd.liquid_range = 2
	nd.liquid_alternative_flowing = mod_name..':water_flowing_tame'
	nd.liquid_alternative_source = mod_name..':water_source_tame'
	minetest.register_node(mod_name..':water_source_tame', nd)

	nd = clone_node('default:water_flowing')
	nd.liquid_range = 2
	nd.liquid_alternative_flowing = mod_name..':water_flowing_tame'
	nd.liquid_alternative_source = mod_name..':water_source_tame'
	minetest.register_node(mod_name..':water_flowing_tame', nd)
end


-----------------------------------------------
-- 
-----------------------------------------------


-- check
function mod.generate_moria(params)
	if not box_names then
		box_names = {}
		for k, v in pairs(layers_mod.registered_geomorphs) do
			if v.areas and v.areas:find('geomoria') then
				table.insert(box_names, v.name)
			end
		end
	end

	-- for placing dungeon decor
	if not carpetable then
		carpetable = {
			[node['default:stone']] = true,
			[node['default:cobble']] = true,
			[node['default:mossycobble']] = true,
		}
	end

	-- for placing cobwebs, etc.
	local area = params.area
	if not sides then
		sides = {
			{ i = -1, p2 = 3 },
			{ i = 1, p2 = 2 },
			{ i = - area.zstride, p2 = 5 },
			{ i = area.zstride, p2 = 4 },
			{ i = - area.ystride, p2 = 1 },
			{ i = area.ystride, p2 = 0 },
		}
	end

	local nofill
	local minp, maxp = params.isect_minp, params.isect_maxp
	local water_level = params.sealevel

	--[[
	local height_max = params.share.height_max
	if params.share.disruptive or (height_max and math.max(water_level, height_max) > minp.y) then
		return
	end
	--]]

	--print(params.realm_maxp.y, params.isect_maxp.y)
	--print(((params.realm_maxp.y - params.isect_maxp.y)))
	--print(((params.realm_maxp.y - params.isect_maxp.y) % 80))
	--print(80 - ((params.realm_maxp.y - params.isect_maxp.y) % 80))

	local box_type = box_names[params.gpr:next(1, #box_names)]

	--local box = layers_mod.registered_geomorphs[box_type]
	local box = layers_mod.registered_geomorphs['reservoir']

	local i = (params.realm_maxp.y - params.isect_maxp.y) % 80
	if i == 0 and params.csize.y < 80 then
		local b = VN(0, 80 - params.csize.y, 0)
		local c = vector.subtract(params.csize, 1)
		c.y = 79
		local bound1 = {
			minp = b,
			maxp = c,
		}
		--print(dump(bound1))
		local geo = Geomorph.new(params, box, bound1)
		if box.areas and box.areas:find('geomoria') and not nofill then
			geo:add({
				action = 'cube',
				node = 'default:stone',
				location = VN(0, 0, 0),
				size = VN(80, 80, 80),
			}, 1)
		end
		geo:write_to_map(0)
	else
		local b = 80 - ((params.realm_maxp.y - params.isect_maxp.y) % 80)
		local c = params.csize.y - b
		local bound2 = {
			minp = VN(0, c, 0),
			maxp = VN(params.csize.x - 1, 79, params.csize.z - 1),
		}

		local geo = Geomorph.new(params, box, bound2)
		if geo.areas and geo.areas:find('geomoria') and not nofill then
			geo:add({
				action = 'cube',
				node = 'default:stone',
				location = VN(0, 0, 0),
				size = VN(80, 80, 80),
			}, 1)
		end

		--geo:write_to_map(self, nil, geo_replace[box_type])
		geo:write_to_map(0)

		--local geo = Geomorph.new(params, box, bound2)
		--geo:write_to_map(0)
	end

	if not nofill then
		--mod.dungeon_decor()
	end
end


function mod.dungeon_decor()
	local minp, maxp = params.isect_minp, params.isect_maxp
	local area = params.area
	local data, p2data = params.data, params.p2data
	local ystride = area.ystride

	local n_web = node[mod_name..':spider_web']
	local n_puddle = node[mod_name..':puddle_ooze']
	local n_broken_door = node[mod_name..':broken_door']
	local n_air = node['air']

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local ivm = params.area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				--if data[ivm] == n_air and (not heightmap[index] or y < heightmap[index]) then
				if data[ivm] == n_air then
					for i, s in pairs(sides) do
						if carpetable[data[ivm + s.i]] then
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

			index = index + 1
		end
	end
end


dofile(mod.path .. '/plans.lua')


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------

-- Define the noises.
--layers_mod.register_noise( 'dflat_ground', { offset = 0, scale = 100, seed = 4382, spread = {x = 320, y = 320, z = 320}, octaves = 6, persist = 0.5, lacunarity = 2.0} )

layers_mod.register_mapgen('tg_moria', mod.generate_moria)
if layers_mod.register_spawn then
	--layers_mod.register_spawn('tg_moria', mod.get_spawn_level)
end
