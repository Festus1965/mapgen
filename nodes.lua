-- Duane's mapgen nodes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = mapgen
local mod_name = 'mapgen'
local clone_node = mod.clone_node
local newnode
local light_max = 10


-- check
local function register_node_and_alias(n, t)
	minetest.register_node(mod_name..':'..n, t)
	--minetest.register_alias('default:'..n, mod_name..':'..n)
end


register_node_and_alias('cloud_hard', {
	description = 'Cloud',
	drawtype = 'glasslike',
	paramtype = 'light',
	tiles = {'white_t.png'},
	floodable = false,
	diggable = false,
	buildable_to = false,
	use_texture_alpha = true,
	sunlight_propagates = true,
	post_effect_color = {a = 50, r = 255, g = 255, b = 255},
})


do
	newnode = clone_node('default:tree')
	newnode.description = 'Bark'
	newnode.tiles = {'default_tree.png'}
	newnode.is_ground_content = false
	newnode.groups.tree = 0
	newnode.groups.flammable = 0
	newnode.groups.puts_out_fire = 1
	newnode.sunlight_propagates = true
	minetest.register_node(mod_name..':bark', newnode)

	newnode = mod.clone_node('default:water_source')
	newnode.description = 'Water'
	newnode.drop = 'default:water_source'
	newnode.liquid_range = 0
	newnode.liquid_viscosity = 1
	newnode.liquid_renewable = false
	newnode.liquid_alternative_flowing = mod_name..':weightless_water'
	newnode.liquid_alternative_source = mod_name..':weightless_water'
	minetest.register_node(mod_name..':weightless_water', newnode)

	if bucket and bucket.liquids then
		bucket.liquids[mod_name..':weightless_water'] = {
			source = mod_name..':weightless_water',
			flowing = mod_name..':weightless_water',
			itemname = 'bucket:bucket_water',
		}
	end

	newnode = mod.clone_node('default:lava_source')
	newnode.description = 'Lava'
	newnode.drop = 'default:lava_source'
	newnode.sunlight_propagates = true
	newnode.liquid_range = 0
	newnode.liquid_viscosity = 1
	newnode.liquid_renewable = false
	newnode.liquid_alternative_flowing = mod_name..':weightless_lava'
	newnode.liquid_alternative_source = mod_name..':weightless_lava'
	minetest.register_node(mod_name..':weightless_lava', newnode)

	if bucket and bucket.liquids then
		bucket.liquids[mod_name..':weightless_lava'] = {
			source = mod_name..':weightless_lava',
			flowing = mod_name..':weightless_lava',
			itemname = 'bucket:bucket_lava',
		}
	end
end

do
	minetest.register_node(mod_name..':basalt', {
		description = 'Basalt',
		tiles = {'basalt.png'},
		is_ground_content = true,
		groups = {cracky=1, level=2},
		sounds = default.node_sound_stone_defaults({
			footstep = {name='default_stone_footstep', gain=0.25},
		}),
	})


	minetest.register_node(mod_name..':granite', {
		description = 'Granite',
		tiles = {'granite.png'},
		is_ground_content = true,
		groups = {cracky=1, level=3},
		sounds = default.node_sound_stone_defaults({
			footstep = {name='default_stone_footstep', gain=0.25},
		}),
	})

	-- black (oily) sand
	newnode = clone_node('default:sand')
	newnode.description = 'Black Sand'
	newnode.tiles = {'fun_caves_black_sand.png'}
	newnode.groups['falling_node'] = 0
	minetest.register_node(mod_name..':black_sand', newnode)

	newnode = clone_node('default:sand')
	newnode.description = 'Phosphorescent Sand'
	newnode.groups['falling_node'] = 0
	newnode.drop = 'default:sand'
	newnode.light_source = 1
	minetest.register_node(mod_name..':phosph_sand', newnode)

	register_node_and_alias('will_o_wisp_glow', {
		description = 'Will-o-wisp',
		drawtype = 'plantlike',
		visual_scale = 0.75,
		tiles = {'will_o_wisp.png'},
		paramtype = 'light',
		sunlight_propagates = true,
		light_source = 8,
		walkable = false,
		diggable = false,
		pointable = false,
		is_ground_content = false,
		on_construct = function(pos)
			local timer = minetest.get_node_timer(pos)
			local max = 30
			if timer then
				timer:set(max, math.random(max - 1))
			end
		end,
		on_timer = function(pos, elapsed)
			--local nod = minetest.get_node_or_nil(pos)
			minetest.set_node(pos, {name=mod_name..':will_o_wisp_dark'})
		end,
	})

	register_node_and_alias('will_o_wisp_dark', {
		description = 'Will-o-wisp',
		drawtype = 'plantlike',
		visual_scale = 0.75,
		tiles = {'will_o_wisp.png'},
		paramtype = 'light',
		sunlight_propagates = true,
		walkable = false,
		diggable = false,
		pointable = false,
		is_ground_content = false,
		on_construct = function(pos)
			local timer = minetest.get_node_timer(pos)
			local max = 30
			if timer then
				timer:set(max, math.random(max - 1))
			end
		end,
		on_timer = function(pos, elapsed)
			--local nod = minetest.get_node_or_nil(pos)
			minetest.set_node(pos, {name=mod_name..':will_o_wisp_glow'})
		end,
	})

	mod.add_construct(mod_name..':will_o_wisp_glow')
	mod.add_construct(mod_name..':will_o_wisp_dark')

	minetest.register_node(mod_name..':hot_rock', {
		description = 'Hot Rocks',
		tiles = {'hot_rock.png'},
		is_ground_content = true,
		groups = {crumbly=2, surface_hot=3},
		light_source = 2,
		damage_per_second = 1,
		sounds = default.node_sound_stone_defaults({
			footstep = {name='default_stone_footstep', gain=0.25},
		}),
	})

	-- stone with lichen
	newnode = clone_node('default:stone')
	newnode.description = 'Cave Stone With Lichen'
	newnode.tiles = {'default_stone.png^fun_caves_lichen.png'}
	newnode.groups = {stone=1, cracky=3, crumbly=3}
	newnode.sounds = default.node_sound_dirt_defaults({
		footstep = {name='default_grass_footstep', gain=0.25},
	})
	minetest.register_node(mod_name..':stone_with_lichen', newnode)


	-- salt
	minetest.register_node(mod_name..':stone_with_salt', {
		description = 'Cave Stone with Salt',
		tiles = {'salt.png'},
		paramtype = 'light',
		use_texture_alpha = true,
		drawtype = 'glasslike',
		sunlight_propagates = false,
		is_ground_content = true,
		groups = {stone=1, crumbly=3, cracky=3},
		sounds = default.node_sound_glass_defaults(),
	})

	-- salt, radioactive ore
	newnode = clone_node(mod_name..':stone_with_salt')
	newnode.description = 'Salt With Radioactive Ore'
	newnode.tiles = {'radioactive_ore.png'}
	newnode.light_source = 5
	minetest.register_node(mod_name..':radioactive_ore', newnode)

	---- ice, thin -- transparent
	--minetest.register_node(mod_name..':thin_ice', {
	--	description = 'Thin Ice',
	--	tiles = {'caverealms_thin_ice.png'},
	--	is_ground_content = true,
	--	groups = {cracky=3},
	--	sounds = default.node_sound_glass_defaults(),
	--	use_texture_alpha = true,
	--	light_source = 1,
	--	drawtype = 'glasslike',
	--	sunlight_propagates = true,
	--	freezemelt = 'default:water_source',
	--	paramtype = 'light',
	--})

	-- stone with algae
	newnode = clone_node('default:stone')
	newnode.description = 'Cave Stone With Algae'
	newnode.tiles = {'default_stone.png^fun_caves_algae.png'}
	newnode.groups = {stone=1, cracky=3, crumbly=3}
	newnode.sounds = default.node_sound_dirt_defaults({
		footstep = {name='default_grass_footstep', gain=0.25},
	})
	minetest.register_node(mod_name..':stone_with_algae', newnode)

	-- stone, hot
	minetest.register_node(mod_name..':hot_stone', {
		description = 'Hot Stone',
		tiles = {'default_desert_stone.png^[colorize:#FF0000:150'},
		is_ground_content = true,
		groups = {crumbly=2, surface_hot=3},
		light_source = light_max - 5,
		damage_per_second = 1,
		sounds = default.node_sound_stone_defaults({
			footstep = {name='default_stone_footstep', gain=0.25},
		}),
	})

	-- stone with moss
	newnode = clone_node('default:stone')
	newnode.description = 'Cave Stone With Moss'
	newnode.tiles = {'default_stone.png^fun_caves_moss.png'}
	newnode.groups = {stone=1, cracky=3, crumbly=3}
	newnode.sounds = default.node_sound_dirt_defaults({
		footstep = {name='default_grass_footstep', gain=0.25},
	})
	minetest.register_node(mod_name..':stone_with_moss', newnode)


	newnode = clone_node('air')
	newnode.drowning = 1
	minetest.register_node(mod_name..':inert_gas', newnode)


	-- spikes, hot -- silicon-based life
	local spike_size = { 1.0, 1.2, 1.4, 1.6, 1.7 }
	mod.hot_spikes = {}

	for i in ipairs(spike_size) do
		if i == 1 then
			nodename = mod_name..':hot_spike'
		else
			nodename = mod_name..':hot_spike_'..i
		end

		table.insert(mod.hot_spikes, nodename)

		vs = spike_size[i]

		minetest.register_node(nodename, {
			description = 'Stone Spike',
			tiles = {'hot_spike.png'},
			inventory_image = 'hot_spike.png',
			wield_image = 'hot_spike.png',
			is_ground_content = true,
			groups = {cracky=3, oddly_breakable_by_hand=1, surface_hot=3},
			damage_per_second = 1,
			sounds = default.node_sound_stone_defaults(),
			paramtype = 'light',
			drawtype = 'plantlike',
			walkable = false,
			light_source = i * 2,
			buildable_to = true,
			visual_scale = vs,
			selection_box = {
				type = 'fixed',
				fixed = {-0.5*vs, -0.5*vs, -0.5*vs, 0.5*vs, -5/16*vs, 0.5*vs},
			}
		})
	end

	mod.hot_spike = {}
	for i = 1, #mod.hot_spikes do
		mod.hot_spike[mod.hot_spikes[i]] = i
	end


	-- kelp-like water plant?
	minetest.register_node(mod_name..':wet_fungus', {
		description = 'Leaves',
		tiles = {'wet_fungus.png'},
		light_source = 2,
		groups = {snappy = 3},
		drop = '',
		sounds = default.node_sound_leaves_defaults(),
	})
end


do
	-- What's a cave without speleothems?
	local spel = {
		{type1='stalactite', type2='stalagmite', tile='default_stone.png'},
		{type1='stalactite_slimy', type2='stalagmite_slimy', tile='default_stone.png^fun_caves_algae.png', light=light_max-6},
		{type1='stalactite_mossy', type2='stalagmite_mossy', tile='default_stone.png^fun_caves_moss.png', light=light_max-6},
		{type1='stalactite_lichen', type2='stalagmite_lichen', tile='default_stone.png^fun_caves_lichen.png', light=light_max-6},
		--{type1='stalactite_crystal', type2='stalagmite_crystal', tile='fun_caves_radioactive_ore', light=light_max},
		{type1='icicle_down', type2='icicle_up', desc='Icicle', tile='default_ice.png', drop='default:ice'},
	}

	for _, desc in pairs(spel) do
		minetest.register_node(mod_name..':'..desc.type1, {
			description = (desc.desc or 'Stalactite'),
			tiles = {desc.tile},
			is_ground_content = true,
			walkable = false,
			light_source = desc.light,
			paramtype = 'light',
			drop = (desc.drop or mod_name..':stalactite'),
			drawtype = 'nodebox',
			node_box = { type = 'fixed',
			fixed = {
				{-0.07, 0.0, -0.07, 0.07, 0.5, 0.07},
				{-0.04, -0.25, -0.04, 0.04, 0.0, 0.04},
				{-0.02, -0.5, -0.02, 0.02, 0.25, 0.02},
			} },
			groups = {rock=1, cracky=3},
			sounds = default.node_sound_stone_defaults(),
		})

		minetest.register_node(mod_name..':'..desc.type2, {
			description = (desc.desc or 'Stalagmite'),
			tiles = {desc.tile},
			is_ground_content = true,
			walkable = false,
			paramtype = 'light',
			light_source = desc.light,
			drop = mod_name..':stalagmite',
			drawtype = 'nodebox',
			node_box = { type = 'fixed',
			fixed = {
				{-0.07, -0.5, -0.07, 0.07, 0.0, 0.07},
				{-0.04, 0.0, -0.04, 0.04, 0.25, 0.04},
				{-0.02, 0.25, -0.02, 0.02, 0.5, 0.02},
			} },
			groups = {rock=1, cracky=3},
			sounds = default.node_sound_stone_defaults(),
		})
	end

	register_node_and_alias('glowing_fungal_stone', {
		description = 'Glowing Fungal Stone',
		tiles = {'default_stone.png^glowing_fungal.png',},
		is_ground_content = true,
		light_source = 5,
		groups = {cracky=3, stone=1},
		drop = {items={ {items={'default:cobble'},}, {items={mod_name..':glowing_fungus',},},},},
		sounds = default.node_sound_stone_defaults(),
	})

	-- Glowing fungus grows underground.
	minetest.register_craftitem(mod_name..':glowing_fungus', {
		description = 'Glowing Fungus',
		drawtype = 'plantlike',
		paramtype = 'light',
		tiles = {'glowing_fungus.png'},
		inventory_image = 'glowing_fungus.png',
		groups = {dig_immediate = 3},
	})


	minetest.register_node(mod_name..':bound_spirit', {
		description = 'Tormented Spirit',
		tiles = {'spirit.png'},
		use_texture_alpha = true,
		light_source = 1,
		paramtype2 = 'facedir',
		walkable = false,
		pointable = false,
		groups = {poison = 1},
		drawtype = 'plantlike',
	})
end
