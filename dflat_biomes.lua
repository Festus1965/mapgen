-- Duane's mapgen dflat_biomes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = mapgen
local mod_name = 'mapgen'
local clone_node = mod.clone_node


-----------------------------------------------
-- DFlat environment changes
-----------------------------------------------

do
	minetest.register_biome({
		name = 'ether',
		heat_point = -99,
		humidity_point = -99,
		node_stone = mod_name..':etherstone',
		source = 'dflat_ether',
	})
end


do
	local newnode

	--[[
	newnode = clone_node('default:apple')
	newnode.tiles = { 'mapgen_orange.png' }
	newnode.inventory_image = 'mapgen_orange.png'
	newnode.description = 'Orange'
	newnode.name = mod_name..':orange'
	minetest.register_node(newnode.name, newnode)


	newnode = clone_node('default:apple')
	newnode.tiles = { 'mapgen_pear.png' }
	newnode.inventory_image = 'mapgen_pear.png'
	newnode.description = 'Pear'
	newnode.name = mod_name..':pear'
	minetest.register_node(newnode.name, newnode)
	--]]


	newnode = clone_node('default:leaves')
	newnode.description = 'Cherry Blossoms'
	newnode.tiles = { 'mapgen_leaves_cherry.png' }
	newnode.special_tiles = { 'mapgen_leaves_cherry.png' }
	newnode.groups = { snappy = 3, flammable = 2 }
	minetest.register_node(mod_name..':leaves_cherry', newnode)

	--[[
	newnode = clone_node('default:leaves')
	newnode.description = 'Palm Fronds'
	newnode.tiles = { 'moretrees_palm_leaves.png' }
	newnode.special_tiles = { 'moretrees_palm_leaves.png' }
	minetest.register_node(mod_name..':palm_leaves', newnode)

	newnode = clone_node('default:tree')
	newnode.description = 'Palm Tree'
	newnode.tiles = { 'moretrees_palm_trunk_top.png', 'moretrees_palm_trunk_top.png', 'moretrees_palm_trunk.png', 'moretrees_palm_trunk.png', 'moretrees_palm_trunk.png' }
	newnode.special_tiles = { 'moretrees_palm_trunk.png' }
	minetest.register_node(mod_name..':palm_tree', newnode)

	minetest.register_craft({
		output = 'default:wood 4',
		recipe = {
			{ mod_name..':palm_tree' },
		}
	})

	--newnode = clone_node('default:apple')
	--newnode.description = 'Coconut'
	--newnode.tiles = { 'moretrees_coconut.png' }
	--newnode.inventory_image = 'moretrees_coconut.png'
	--newnode.after_place_node = nil
	--minetest.register_node(mod_name..':coconut', newnode)
	--]]

	default.register_leafdecay({
		trunks = {'default:tree'},
		leaves = {
			'default:apple',
			--mod_name..':orange',
			--mod_name..':pear',
			'default:leaves',
			mod_name..':leaves_cherry',
		},
		radius = 3,
	})

	default.register_leafdecay({
		trunks = {'default:pine_tree'},
		leaves = {
			'default:pine_needles',
		},
		radius = 3,
	})

	default.register_leafdecay({
		trunks = {'default:jungletree'},
		leaves = {
			'default:jungleleaves',
		},
		radius = 3,
	})
end


do
	do
		local apple_deco
		for _, v in pairs(mod.decorations) do
			if v.name == 'default:apple_tree' then
				apple_deco = v
			end
		end

		if apple_deco and apple_deco.schematic_array and apple_deco.schematic_array.data then
			local def = table.copy(apple_deco)

			def.noise_params.seed = 385
			def.noise_params.offset = def.noise_params.offset - 0.03
			def.schematic = nil
			def.name = mod_name..':cherry_tree_'
			def.schematic_array = table.copy(apple_deco.schematic_array)
			for _, v in pairs(def.schematic_array.data) do
				if v.name == 'default:leaves' or v.name == 'default:apple' then
					v.name = mod_name..':leaves_cherry'
				end
			end
			minetest.register_decoration(def)
		end
	end

	--[[
	-- Palm tree
	do
		local d, h, w = 5, 7, 5
		local sch = mod.schematic_array(d, h, w)

		for i = 1, 2 do
			for z = -1, 1 do
				for x = -1, 1 do
					if (x ~= 0) == not (z ~= 0) then
						local n = sch.data[(2 + (z * i)) * h * w + (7 - i) * w + (2 + (x * i)) + 1]
						n.name = mod_name .. ':palm_leaves'
						n.prob = 127
					end
				end
			end
		end

		for i = 0, 3 do
			local n = sch.data[1 * h * w + i * w + 2 + 1]
			n.name = mod_name .. ':palm_tree'
			n.prob = 255
		end

		for i = 4, 5 do
			local n = sch.data[2 * h * w + i * w + 2 + 1]
			n.name = mod_name .. ':palm_tree'
			n.prob = 255
		end

		sch.yslice_prob = {
			{ ypos = 1, prob = 128 },
			{ ypos = 4, prob = 128 },
		}

		minetest.register_decoration({
			deco_type = 'schematic',
			place_on = { 'default:sand' },
			sidelen = 16,
			fill_ratio = 0.02,
			biomes = { 'desert_ocean' },
			y_min = 1,
			y_max = 1,
			schematic = sch,
			flags = 'place_center_x, place_center_z',
			rotation = 'random',
		})
	end

	--rereg = nil
	--]]
end


function mod.register_flower(name, desc, biomes, seed)
	local groups = { }
	groups.snappy = 3
	groups.flammable = 2
	groups.flower = 1
	groups.flora = 1
	groups.attached_node = 1
	local img = mod_name .. '_' .. name .. '.png'

	minetest.register_node(mod_name..':' .. name, {
		description = desc,
		drawtype = 'plantlike',
		waving = 1,
		tiles = { img },
		inventory_image = img,
		wield_image = img,
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		buildable_to = true,
		stack_max = 99,
		groups = groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = 'fixed',
			fixed = { -0.5, -0.5, -0.5, 0.5, -5/16, 0.5 },
		}
	})

	local bi = { }
	if biomes then
		bi = { }
		for _, b in pairs(biomes) do
			bi[b] = true
		end
	end

	if bi['rainforest'] then
		local def = {
			deco_type = 'simple',
			place_on = { 'default:dirt_with_rainforest_litter' },
			sidelen = 16,
			noise_params = {
				offset = 0.015,
				scale = 0.025,
				spread = { x = 200, y = 200, z = 200 },
				seed = seed,
				octaves = 3,
				persist = 0.6
			},
			biomes = { 'rainforest', 'rainforest_swamp' },
			y_min = 1,
			y_max = 31000,
			decoration = mod_name..':'..name,
			name = name,
			flower = true,
		}
		minetest.register_decoration(def)
	end

	local def = {
		deco_type = 'simple',
		place_on = { 'default:dirt_with_grass', 'default:dirt_with_dry_grass', 'default:dirt_with_rainforest_litter' },
		sidelen = 16,
		noise_params = {
			offset = -0.015,
			scale = 0.025,
			spread = { x = 200, y = 200, z = 200 },
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		biomes = biomes,
		y_min = 1,
		y_max = 31000,
		decoration = mod_name..':'..name,
		name = name,
		flower = true,
	}
	minetest.register_decoration(def)
end

mod.register_flower('orchid', 'Orchid', { 'rainforest', 'rainforest_swamp' }, 783)
mod.register_flower('bird_of_paradise', 'Bird of Paradise', { 'rainforest' }, 798)
mod.register_flower('gerbera', 'Gerbera', { 'savanna', 'rainforest' }, 911)
