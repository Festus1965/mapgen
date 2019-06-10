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



do
	-- Used in spirals.
	register_node_and_alias('cloud_hard', {
		description = 'Cloud',
		drawtype = 'glasslike',
		paramtype = 'light',
		tiles = {'mapgen_white_t.png'},
		floodable = false,
		diggable = false,
		buildable_to = false,
		use_texture_alpha = true,
		sunlight_propagates = true,
		post_effect_color = {a = 50, r = 255, g = 255, b = 255},
	})

	newnode = clone_node('default:tree')
	newnode.description = 'Bark'
	newnode.tiles = {'default_tree.png'}
	newnode.is_ground_content = false
	newnode.groups.tree = 0
	newnode.groups.flammable = 0
	newnode.groups.puts_out_fire = 1
	newnode.sunlight_propagates = true
	minetest.register_node(mod_name..':bark', newnode)


	-- Used in planets.
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

	-- Used in planets.
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
