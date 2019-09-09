-- Duane's mapgen nodes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = mapgen
local mod_name = 'mapgen'
local clone_node = mod.clone_node
local newnode


do
	local tree_sch = {}

	local function get_tree_schematic(tree_name)
		for k, v in pairs(mod.decorations) do
			if v.name:find(tree_name) then
				-- For some reason, the game doesn't use the
				--  schematic probabilities the way the documentation
				--  says it should.
				local sch = table.copy(v.schematic_array)
				for k, v in pairs(sch.data or {}) do
					local p = v.param1 or v.prob
					if p and type(p) == 'number' then
						v.prob = math.min(255, p * 2)
						v.param1 = nil
					end
				end
				tree_sch[tree_name] = sch
				return sch
			end
		end
	end

	function mod.grow_sapling(pos)
		if not default.can_grow(pos) then
			-- try again 5 min later
			minetest.get_node_timer(pos):start(300)
			return
		end

		local n = minetest.get_node(pos)
		pos.y = pos.y - 1
		if n.name == mod_name..':oak_sapling' then
			local sch = tree_sch['oak_tree']
			if not sch then
				sch = get_tree_schematic('oak_tree')
			end
			minetest.log('action', 'An oak sapling grows into a tree at '..  minetest.pos_to_string(pos))
			minetest.place_schematic(pos, sch, math.random(1, 4), nil, nil, 'place_center_x,place_center_z')
		elseif n.name == mod_name..':cherry_sapling' then
			local sch = tree_sch['cherry_tree']
			if not sch then
				sch = get_tree_schematic('cherry_tree')
			end
			minetest.log('action', 'An cherry sapling grows into a tree at '..  minetest.pos_to_string(pos))
			minetest.place_schematic(pos, sch, math.random(1, 4), nil, nil, 'place_center_x,place_center_z')
		end
	end

	local newnode = clone_node('default:sapling')
	newnode.description =  'Oak Tree Sapling'
	newnode.on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end
	newnode.on_timer = mod.grow_sapling
	newnode.on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			mod_name..':oak_sapling',
			{x = -3, y = 1, z = -3},
			{x = 3, y = 6, z = 3},
			4)
		return itemstack
	end
	minetest.register_node(mod_name..':oak_sapling', newnode)

	local newnode = clone_node('default:sapling')
	newnode.description =  'Cherry Tree Sapling'
	newnode.on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end
	newnode.on_timer = mod.grow_sapling
	newnode.on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			mod_name..':cherry_sapling',
			{x = -3, y = 1, z = -3},
			{x = 3, y = 6, z = 3},
			4)
		return itemstack
	end
	minetest.register_node(mod_name..':cherry_sapling', newnode)
end


do
	local newnode

	newnode = clone_node('default:leaves')
	newnode.description = 'Cherry Blossoms'
	newnode.tiles = { 'mapgen_leaves_cherry.png' }
	newnode.special_tiles = { 'mapgen_leaves_cherry.png' }
	newnode.drop = {
		max_items = 1,
		items = {
			{ items = {mod_name..':cherry_sapling'}, rarity = 20, },
			{ items = { mod_name..':leaves_cherry' }, }
		}
	}
	newnode.groups = { snappy = 3, flammable = 2 }
	minetest.register_node(mod_name..':leaves_cherry', newnode)

	newnode = clone_node('default:leaves')
	newnode.description = 'Oak Leaves'
	newnode.tiles = { 'mapgen_leaves_oak.png' }
	newnode.special_tiles = { 'mapgen_leaves_oak.png' }
	--newnode.groups = { snappy = 3, flammable = 2 }
	newnode.drop = {
		max_items = 1,
		items = {
			{ items = {mod_name..':acorns'}, rarity = 5 },
			{ items = {mod_name..':oak_sapling'}, rarity = 20, },
			{ items = { mod_name..':leaves_oak' }, }
		}
	}
	minetest.register_node(mod_name..':leaves_oak', newnode)

	newnode = clone_node('default:tree')
	newnode.description = 'Oak Tree'
	newnode.tiles = { 'mapgen_tree_oak_top.png', 'mapgen_tree_oak_top.png', 'mapgen_tree_oak.png' }
	minetest.register_node(mod_name..':tree_oak', newnode)

	minetest.register_craft({
		output = 'default:wood 4',
		recipe = {
			{ mod_name..':tree_oak' },
		}
	})

	newnode = clone_node('default:tree')
	newnode.description = 'Cherry Tree'
	newnode.tiles = { 'mapgen_tree_cherry_top.png', 'mapgen_tree_cherry_top.png', 'mapgen_tree_cherry.png' }
	minetest.register_node(mod_name..':tree_cherry', newnode)

	minetest.register_craft({
		output = 'default:wood 4',
		recipe = {
			{ mod_name..':tree_cherry' },
		}
	})

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

	newnode = clone_node('default:apple')
	newnode.description = 'Coconut'
	newnode.tiles = { 'moretrees_coconut.png' }
	newnode.inventory_image = 'moretrees_coconut.png'
	newnode.after_place_node = nil
	minetest.register_node(mod_name..':coconut', newnode)
	--]]

	default.register_leafdecay({
		trunks = {'default:tree'},
		leaves = {
			'default:apple',
			'default:leaves',
		},
		radius = 3,
	})

	default.register_leafdecay({
		trunks = {mod_name..':tree_cherry'},
		leaves = {
			mod_name..':leaves_cherry',
		},
		radius = 3,
	})

	default.register_leafdecay({
		trunks = {mod_name..':tree_oak'},
		leaves = {
			mod_name..':leaves_oak',
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
	minetest.register_craftitem(mod_name..':acorns', {
		description = 'Acorns',
		inventory_image = 'mapgen_acorns.png',
	})

	minetest.register_craft({
		type = 'shapeless',
		output = 'farming:flour',
		recipe = {
			mod_name..':acorns',
			mod_name..':acorns',
			mod_name..':acorns',
			mod_name..':acorns',
		},
	})

	minetest.register_craftitem(mod_name..':pine_nuts', {
		description = 'Pine Nuts',
		inventory_image = 'mapgen_pine_nuts.png',
		on_use = minetest.item_eat(1),
	})

	minetest.override_item('default:pine_needles', {
		drop = {
			max_items = 1,
			items = {
				{items = {mod_name..':pine_nuts'}, rarity = 15},
				{items = {'default:pine_bush_sapling'}, rarity = 5},
				{items = {'default:pine_bush_needles'}}
			}
		},
	})
end


mod.eight_random_colors = {}
do
	for _, par in pairs({
		{'default:leaves', 0},
		{'default:aspen_leaves', 0},
		{'default:pine_needles', 8},
		{'default:jungleleaves', 8},
	}) do
		local i, j = par[1], par[2]
		minetest.override_item(i, {
			paramtype2 = 'colorfacedir',
			palette = 'mapgen_palette_leaves_3.png',
			-- This may wash out the textures too much...
			tiles = {i:gsub(':', '_')..'.png^[colorize:#FFFFFF:'..j},
		})
		mod.eight_random_colors[mod.node[i]] = true
	end
	--[[
	minetest.override_item('default:stone', {
		paramtype2 = 'colorfacedir',
		palette = 'mapgen_palette_stone_1.png',
	})
	--]]

	minetest.override_item('default:dirt_with_grass', {
		paramtype2 = 'colorfacedir',
		palette = 'mapgen_palette_grass_2.png',
		tiles = { 'mapgen_gray_grass.png' }
	})
	minetest.override_item('default:dirt_with_dry_grass', {
		paramtype2 = 'colorfacedir',
		palette = 'mapgen_palette_grass_2.png',
		tiles = { 'mapgen_gray_grass.png' }
	})

	for i = 1, 5 do
		minetest.override_item('default:grass_'..i, {
			paramtype2 = 'colorfacedir',
			palette = 'mapgen_palette_grass_2.png',
			tiles = { 'mapgen_gray_grass_'..i..'.png' }
		})
		minetest.override_item('default:dry_grass_'..i, {
			paramtype2 = 'colorfacedir',
			palette = 'mapgen_palette_grass_2.png',
			tiles = { 'mapgen_gray_dry_grass_'..i..'.png' }
		})
	end
end


do
	for _, v in pairs(minetest.registered_nodes) do
		local g = v.groups

		if v.name:find('default:stone_with') then
			g.ore = 1
			minetest.override_item(v.name, { groups = g })
		end

		if (g.stone or v.name:find('default:.*sandstone') or g.ore)
		and not (
			v.name:find('brick')
			or v.name:find('block')
			or v.name:find('stair')
			or v.name:find('slab')
			or v.name:find('default:.*cobble')
			or v.name:find('walls:.*cobble')
		) then
			g.natural_stone = 1
			minetest.override_item(v.name, { groups = g })
		end
	end
end


do
	for _, n in pairs({'match_three:top', 'default:chest'}) do
		if minetest.registered_nodes[n] then
			mod.add_construct(n)
		end
	end

	minetest.override_item('default:chest', { light_source = 2 })
end
