-- Duane's mapgen geomoria.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

local Geomorph = geomorph.Geomorph

local math_abs = math.abs
local math_cos = math.cos
local math_floor = math.floor
local math_max = math.max
local math_pi = math.pi
local math_sin = math.sin
local node = layer_mod.node
local VN = vector.new


local carpetable, box_names, sides


do
	local clone_node = layer_mod.clone_node

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
-- Moria_Mapgen class
-----------------------------------------------

local Moria_Mapgen = layer_mod.subclass_mapgen()


function Moria_Mapgen:_init()
	self.biomemap = {}
	self.heatmap = {}
	self.humiditymap = {}

	if not box_names then
		box_names = {}
		for k, v in pairs(geomorph.registered_geomorphs) do
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
	local area = self.area
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
end


-- check
function Moria_Mapgen:generate()
	local nofill

	-- Geomorph requires this.
	self.gpr = PcgRandom(self.seed + 4563)

	local minp, maxp = self.minp, self.maxp
	local water_level = self.water_level
	local height_max = self.share.height_max
	if self.share.disruptive or (height_max and math_max(water_level, height_max) > minp.y) then
		return
	end

	local box_type = box_names[self.gpr:next(1, #box_names)]

	local geo = Geomorph.new()
	local box = geomorph.registered_geomorphs[box_type]
	if box.areas and box.areas:find('geomoria') and not nofill then
		geo:add({
			action = 'cube',
			node = 'default:stone',
			location = VN(0, 0, 0),
			size = VN(80, 80, 80),
		})
	end
	for n, v in pairs(box.shapes) do
		geo:add(v)
	end
	--geo:write_to_map(self, nil, geo_replace[box_type])
	geo:write_to_map(self)

	if not nofill then
		self:dungeon_decor()
	end
end


function Moria_Mapgen:dungeon_decor()
	local minp, maxp = self.minp, self.maxp
	local area = self.area
	local data, p2data = self.data, self.p2data
	--local heightmap = self.heightmap
	local ystride = area.ystride

	local n_web = node[mod_name..':spider_web']
	local n_puddle = node[mod_name..':puddle_ooze']
	local n_broken_door = node[mod_name..':broken_door']
	local n_air = node['air']

	local index = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local ivm = self.area:index(x, minp.y, z)
			for y = minp.y, maxp.y do
				--if data[ivm] == n_air and (not heightmap[index] or y < heightmap[index]) then
				if data[ivm] == n_air then
					for i, s in pairs(sides) do
						if carpetable[data[ivm + s.i]] then
							local sr = self.gpr:next(1, 1000)
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


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------


do
	local max_chunks = layer_mod.max_chunks

	layer_mod.register_map({
		name = 'moria',
		biomes = 'default',
		mapgen = Moria_Mapgen,
		mapgen_name = 'moria',
		map_minp = VN(-max_chunks, -5, -max_chunks),
		map_maxp = VN(max_chunks, -5, max_chunks),
		water_level = 1,
	})
end
