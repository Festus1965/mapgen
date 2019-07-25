-- Duane's mapgen nodes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = mapgen
local mod_name = 'mapgen'
local clone_node = mod.clone_node
local newnode
local light_max = 10
local time_factor = 100 -- 1000


local math_random = math.random
local math_abs = math.abs
local math_max = math.max


-- check
local function register_node_and_alias(n, t)
	minetest.register_node(mod_name..':'..n, t)
	--minetest.register_alias('default:'..n, mod_name..':'..n)
end


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
	minetest.override_item('default:stone', {
		paramtype2 = 'colorfacedir',
		palette = 'mapgen_palette_stone_1.png',
	})

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
	local def = {
        type = 'fixed',
        fixed = {},
	}

	local div = 9
	local hdiv = 5

	for z = 1, div do
		local dz = 1 - math_abs(z - hdiv) / hdiv
		for x = 1, div do
			local dx = 1 - math_abs(x - hdiv) / hdiv
			local c = math_abs(dx * dx + dz * dz)

			--if math_random(1, 3) ~= 1 then
			if c > 0.25 then
				table.insert(def.fixed, {
					(x - 1) / div - 0.5,
					-0.5,
					(z - 1) / div - 0.5,
					x / div - 0.5,
					math_max(dz, dx) * (math_random(1, 10) / 10) - 0.5,
					z / div - 0.5,
				})
			end
		end
	end

	minetest.register_node(mod_name..':pretty_crystal', {
		description = 'Pretty Crystal',
		tiles = { 'mapgen_70_white.png' },
		use_texture_alpha = true,
		--light_source = 8,
		inventory_image = 'mapgen_pretty_crystal_inventory.png',
		drawtype = 'nodebox',
		node_box = def,
		-- Using an 8-pixel palette seems to force the game to use
		--  the highest three bits, rather than five.
		paramtype2 = 'colorwallmounted',
		--paramtype2 = 'colorfacedir',
		palette = 'mapgen_palette_crystals_2.png',
		is_ground_content = true,
		groups = { cracky = 3, natural_stone = 1 },
		sounds = default.node_sound_stone_defaults({
			footstep = { name = 'default_stone_footstep', gain = 0.25 },
		}),
	})
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
	minetest.register_node(mod_name..':basalt', {
		description = 'Basalt',
		tiles = { 'mapgen_basalt.png' },
		is_ground_content = true,
		groups = { cracky = 1, level = 2, natural_stone = 1 },
		sounds = default.node_sound_stone_defaults({
			footstep = { name = 'default_stone_footstep', gain = 0.25 },
		}),
	})

	minetest.register_node(mod_name..':granite', {
		description = 'Granite',
		tiles = { 'mapgen_granite.png' },
		is_ground_content = true,
		groups = { cracky = 1, level = 3, natural_stone = 1 },
		sounds = default.node_sound_stone_defaults({
			footstep = { name = 'default_stone_footstep', gain = 0.25 },
		}),
	})


	newnode = clone_node('default:stone')
	newnode.description = 'Etherstone'
	newnode.tiles = { 'mapgen_black_sand.png' }
	newnode.groups = { cracky = 3 }
	newnode.drop = nil
	minetest.register_node(mod_name..':etherstone', newnode)


	-- stone with lichen
	newnode = clone_node('default:stone')
	newnode.description = 'Cave Stone With Lichen'
	newnode.tiles = { 'default_stone.png^mapgen_lichen.png' }
	newnode.groups = { stone = 1, cracky = 3, crumbly = 3, natural_stone = 1 }
	newnode.sounds = default.node_sound_dirt_defaults({
		footstep = { name = 'default_grass_footstep', gain = 0.25 },
	})
	minetest.register_node(mod_name..':stone_with_lichen', newnode)

	-- stone with algae
	newnode = clone_node('default:stone')
	newnode.description = 'Cave Stone With Algae'
	newnode.tiles = { 'default_stone.png^mapgen_algae.png' }
	newnode.groups = { stone = 1, cracky = 3, crumbly = 3, natural_stone = 1 }
	newnode.sounds = default.node_sound_dirt_defaults({
		footstep = { name = 'default_grass_footstep', gain = 0.25 },
	})
	minetest.register_node(mod_name..':stone_with_algae', newnode)

	-- stone with moss
	newnode = clone_node('default:stone')
	newnode.description = 'Cave Stone With Moss'
	newnode.tiles = { 'default_stone.png^mapgen_moss.png' }
	newnode.groups = { stone = 1, cracky = 3, crumbly = 3, natural_stone = 1 }
	newnode.sounds = default.node_sound_dirt_defaults({
		footstep = { name = 'default_grass_footstep', gain = 0.25 },
	})
	minetest.register_node(mod_name..':stone_with_moss', newnode)

	-- salt
	minetest.register_node(mod_name..':stone_with_salt', {
		description = 'Cave Stone with Salt',
		tiles = { 'mapgen_salt.png' },
		paramtype = 'light',
		use_texture_alpha = true,
		drawtype = 'glasslike',
		sunlight_propagates = false,
		is_ground_content = true,
		groups = { stone = 1, crumbly = 3, cracky = 3 },
		sounds = default.node_sound_glass_defaults(),
	})

	-- salt, radioactive ore
	newnode = clone_node(mod_name..':stone_with_salt')
	newnode.description = 'Salt With Radioactive Ore'
	newnode.tiles = { 'mapgen_radioactive_ore.png' }
	newnode.light_source = 5
	minetest.register_node(mod_name..':radioactive_ore', newnode)

	minetest.register_node(mod_name..':glowing_fungal_stone', {
		description = 'Glowing Fungal Stone',
		tiles = { 'default_stone.png^mapgen_glowing_fungal.png', },
		is_ground_content = true,
		light_source = 5,
		groups = { cracky = 3, stone = 1 },
		drop = { items = { { items = { 'default:cobble' }, }, { items = { mod_name..':glowing_fungus', }, }, }, },
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_node(mod_name..':glowing_gem', {
		description = 'Glowing gems',
		tiles = { 'mapgen_glowing_gem.png', },
		is_ground_content = true,
		paramtype = 'light',
		use_texture_alpha = true,
		drawtype = 'glasslike',
		light_source = 5,
		groups = { cracky = 3, stone = 1 },
		--drop = { items = { { items = { 'default:cobble' }, }, { items = { mod_name..':glowing_fungus', }, }, }, },
		sounds = default.node_sound_stone_defaults(),
	})

	-- black (oily) sand
	newnode = clone_node('default:sand')
	newnode.description = 'Black Sand'
	newnode.tiles = { 'mapgen_black_sand.png' }
	newnode.groups['falling_node'] = 0
	minetest.register_node(mod_name..':black_sand', newnode)

	-- rocks, hot
	minetest.register_node(mod_name..':hot_rock', {
		description = 'Hot Rocks',
		--tiles = { 'mapgen_hot_rock.png' },
		tiles = { 'default_cobble.png^[colorize:#990000:100' },
		--tiles = { 'default_desert_stone.png^[colorize:#FF0000:50' },
		is_ground_content = true,
		groups = { crumbly = 2, surface_hot = 3 },
		--light_source = 5,
		damage_per_second = 1,
		sounds = default.node_sound_stone_defaults({
			footstep = { name = 'default_stone_footstep', gain = 0.25 },
		}),
	})

	-- Glowing fungus grows underground.
	minetest.register_craftitem(mod_name..':glowing_fungus', {
		description = 'Glowing Fungus',
		drawtype = 'plantlike',
		paramtype = 'light',
		tiles = { 'mapgen_glowing_fungus.png' },
		inventory_image = 'mapgen_glowing_fungus.png',
		groups = { dig_immediate = 3 },
	})
end


do
	local giant_mushroom_cap_node_box = {
		type = 'fixed',
		fixed = {
			{ -0.3, -0.25, -0.3, 0.3, 0.5, 0.3 },
			{ -0.3, -0.25, -0.4, 0.3, 0.4, -0.3 },
			{ -0.3, -0.25, 0.3, 0.3, 0.4, 0.4 },
			{ -0.4, -0.25, -0.3, -0.3, 0.4, 0.3 },
			{ 0.3, -0.25, -0.3, 0.4, 0.4, 0.3 },
			{ -0.4, -0.5, -0.4, 0.4, -0.25, 0.4 },
			{ -0.5, -0.5, -0.4, -0.4, -0.25, 0.4 },
			{ 0.4, -0.5, -0.4, 0.5, -0.25, 0.4 },
			{ -0.4, -0.5, -0.5, 0.4, -0.25, -0.4 },
			{ -0.4, -0.5, 0.4, 0.4, -0.25, 0.5 },
		}
	}

	local huge_mushroom_cap_node_box = {
		type = 'fixed',
		fixed = {
			{ -0.5, -0.5, -0.33, 0.5, -0.33, 0.33 },
			{ -0.33, -0.5, 0.33, 0.33, -0.33, 0.5 },
			{ -0.33, -0.5, -0.33, 0.33, -0.33, -0.5 },
			{ -0.33, -0.33, -0.33, 0.33, -0.17, 0.33 },
		}
	}

	local giant_mushroom_stem_node_box = {
		type = 'fixed',
		fixed = {
			{ -0.25, -0.5, -0.25, 0.25, 0.5, 0.25 },
		}
	}

	local grow_into = {
		['air'] = true,
		['default:water_source'] = true,
		['default:water_flowing'] = true,
	}

	local function spread_spores(pos, elapsed, mushroom)
		local posu = {x=pos.x, y=pos.y+1, z=pos.z}
		if (minetest.get_node_light(posu, nil) or 15) == 15 then
			minetest.remove_node(pos)
			return
		end

		local node_down = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
		if not node_down then
			return true
		end

		if node_down.name == 'air' then
			minetest.remove_node(pos)
			return
		end

		--if math.random(5) == 1 then
		--  local name = 'fun_caves:fungal_tree_leaves_'..math.random(4)
		--  if minetest.registered_nodes[name] then
		--    minetest.set_node(pos, {name = name})
		--    return
		--  end
		--end

		local minp = vector.subtract(pos, 8)
		local maxp = vector.add(pos, 8)
		local dirt = minetest.find_nodes_in_area_under_air(minp, maxp, {'group:soil'})
		if dirt and #dirt > 0 then
			local p = dirt[math.random(#dirt)]
			--local crowd = minetest.find_nodes_in_area_under_air(minp, maxp, {'flowers:mushroom_red', 'flowers:mushroom_brown'})
			if mushroom then
				minetest.set_node({x=p.x, y=p.y+1, z=p.z}, {name=mushroom})
			elseif math.random(2) == 1 then
				minetest.set_node({x=p.x, y=p.y+1, z=p.z}, {name='flowers:mushroom_red'})
			else
				minetest.set_node({x=p.x, y=p.y+1, z=p.z}, {name='flowers:mushroom_brown'})
			end
		end

		return true
	end

	minetest.register_node(mod_name..':giant_mushroom_cap', {
		description = 'Giant Mushroom Cap',
		tiles = { 'mapgen_mushroom_giant_cap.png', 'mapgen_mushroom_giant_under.png', 'mapgen_mushroom_giant_cap.png' },
		is_ground_content = false,
		paramtype = 'light',
		drawtype = 'nodebox',
		node_box = giant_mushroom_cap_node_box,
		light_source = 5,
		groups = { fleshy=1, dig_immediate=3, flammable=2, plant=1 },
		on_timer = spread_spores,
		on_construct = function(pos)
			local timer = minetest.get_node_timer(pos)
			local max = 10 * (time_factor or 10)
			if timer then
				timer:set(max, max > 1 and math.random(max - 1) or 0)
			end
		end,
	})


	-- mushroom cap, huge
	minetest.register_node(mod_name..':huge_mushroom_cap', {
		description = 'Huge Mushroom Cap',
		tiles = { 'mapgen_mushroom_giant_cap.png', 'mapgen_mushroom_giant_under.png', 'mapgen_mushroom_giant_cap.png' },
		is_ground_content = false,
		paramtype = 'light',
		drawtype = 'nodebox',
		node_box = huge_mushroom_cap_node_box,
		light_source = 5,
		groups = { fleshy=1, dig_immediate=3, flammable=2, plant=1 },
	})

	-- mushroom stem, giant or huge
	minetest.register_node(mod_name..':giant_mushroom_stem', {
		description = 'Giant Mushroom Stem',
		tiles = { 'mapgen_mushroom_giant_stem.png', 'mapgen_mushroom_giant_stem.png', 'mapgen_mushroom_giant_stem.png' },
		is_ground_content = false,
		groups = { choppy=2, flammable=2,  plant=1, oddly_breakable_by_hand = 1 },
		sounds = default.node_sound_wood_defaults(),
		sunlight_propagates = true,
		paramtype = 'light',
		drawtype = 'nodebox',
		node_box = giant_mushroom_stem_node_box,
		on_timer = function(pos, elapsed)
			local posu = {x=pos.x, y=pos.y+1, z=pos.z}
			local dark = (minetest.get_node_light(posu, nil) or 15) <= (light_max - 4 or 10)
			local node_down = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
			if not (node_down and dark) then
				return true
			end

			if node_down.name == 'air' then
				minetest.remove_node(pos)
				return
			end

			local posu2 = {x=pos.x, y=pos.y+2, z=pos.z}
			local node_up = minetest.get_node_or_nil(posu)
			local node_up2 = minetest.get_node_or_nil(posu2)
			if not (node_up and node_up2) then
				return true
			end

			if math.random(15) == 1
			and minetest.registered_nodes[node_down.name].groups
			and minetest.registered_nodes[node_down.name].groups.soil
			and (
				node_up.name == mod_name..':huge_mushroom_cap'
				or grow_into[node_up.name]
			) and grow_into[node_up2.name] then
				local n = mod_name..':giant_mushroom_stem'
				minetest.set_node(posu, { name = n })
				minetest.set_node(posu2, {name=mod_name..':giant_mushroom_cap'})
				return true
			end

			if not grow_into[node_up.name] then
				return true
			end

			if node_down.name == mod_name..':giant_mushroom_stem' then
				minetest.set_node(posu, {name=mod_name..':giant_mushroom_cap'})
			elseif minetest.registered_nodes[node_down.name].groups
			and minetest.registered_nodes[node_down.name].groups.soil then
				minetest.set_node(posu, {name=mod_name..':huge_mushroom_cap'})
			end

			return true
		end,
		on_construct = function(pos)
			local timer = minetest.get_node_timer(pos)
			local max = 50 * (time_factor or 10)
			if timer then
				timer:set(max, max > 1 and math.random(max - 1) or 0)
			end
		end,
	})


	for _, sh in pairs({'flowers:mushroom_red', 'flowers:mushroom_brown'}) do
		minetest.override_item(sh, {
			on_timer = function(pos, elapsed)
				local posu = {x=pos.x, y=pos.y+1, z=pos.z}
				local daylight = minetest.get_node_light(posu, 0.5) or 0
				local light = minetest.get_node_light(posu, nil) or 0
				local mushroom = minetest.get_node_or_nil(pos)
				if light == 15 then
					minetest.remove_node(pos)
					return
				elseif light > light_max - 4 then
					return true
				elseif daylight > light_max - 4 then
					return spread_spores(pos, elapsed, mushroom.name)
				end

				local node_down = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
				if not node_down then
					return true
				end

				if node_down.name == 'air' then
					minetest.remove_node(pos)
					return
				end

				if math.random(50) ~= 1 then
					return true
				end

				local node_up = minetest.get_node_or_nil(posu)
				if not node_up then
					return true
				end

				if minetest.registered_nodes[node_down.name].groups
				and minetest.registered_nodes[node_down.name].groups.soil
				and grow_into[node_up.name] then
					local n = mod_name..':giant_mushroom_stem'
					minetest.set_node(pos, { name = n })
					minetest.set_node(posu, { name = mod_name..':huge_mushroom_cap' })
				end
			end,
			on_construct = function(pos)
				local timer = minetest.get_node_timer(pos)
				local max = 10 * (time_factor or 10)
				if timer then
					timer:set(max, max > 1 and math.random(max - 1) or 0)
				end
			end,
		})

		minetest.registered_items[sh].groups.timed = 1
	end


	mod.add_construct(mod_name..':giant_mushroom_cap')
	mod.add_construct(mod_name..':giant_mushroom_stem')
	mod.add_construct('flowers:mushroom_red')
	mod.add_construct('flowers:mushroom_brown')

	-- Caps can be cooked and eaten.
	minetest.register_craftitem(mod_name..':mushroom_steak', {
		description = 'Mushroom Steak',
		inventory_image = 'mushroom_steak.png',
		on_use = minetest.item_eat(4),
	})

	minetest.register_craft({
		type = 'cooking',
		output = mod_name..':mushroom_steak',
		recipe = mod_name..':huge_mushroom_cap',
		cooktime = 2,
	})

	minetest.register_craft({
		type = 'cooking',
		output = mod_name..':mushroom_steak 2',
		recipe = mod_name..':giant_mushroom_cap',
		cooktime = 2,
	})
end


do
	-- spikes, hot -- silicon-based life
	local spike_size = { 1.0, 1.2, 1.4, 1.6, 1.7 }
	local nodename
	mod.hot_spikes = { }

	for i in ipairs(spike_size) do
		if i == 1 then
			nodename = mod_name..':hot_spike'
		else
			nodename = mod_name..':hot_spike_'..i
		end

		table.insert(mod.hot_spikes, nodename)

		local vs = spike_size[i]

		minetest.register_node(nodename, {
			description = 'Stone Spike',
			tiles = { 'mapgen_hot_spike.png' },
			is_ground_content = true,
			groups = { cracky = 3, oddly_breakable_by_hand = 1, surface_hot = 3 },
			damage_per_second = 1,
			sounds = default.node_sound_stone_defaults(),
			paramtype = 'light',
			drawtype = 'plantlike',
			walkable = false,
			light_source = i * 2 + 2,
			buildable_to = true,
			visual_scale = vs,
			selection_box = {
				type = 'fixed',
				fixed = { -0.5*vs, -0.5*vs, -0.5*vs, 0.5*vs, -5/16*vs, 0.5*vs },
			}
		})
	end

	mod.hot_spike = { }
	for i = 1, #mod.hot_spikes do
		mod.hot_spike[mod.hot_spikes[i] ] = i
	end


	--[[
	register_node_and_alias('will_o_wisp_glow', {
		description = 'Will-o-wisp',
		drawtype = 'plantlike',
		visual_scale = 0.75,
		tiles = { 'will_o_wisp.png' },
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
			minetest.set_node(pos, { name = mod_name..':will_o_wisp_dark' })
		end,
	})

	register_node_and_alias('will_o_wisp_dark', {
		description = 'Will-o-wisp',
		drawtype = 'plantlike',
		visual_scale = 0.75,
		tiles = { 'will_o_wisp.png' },
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
			minetest.set_node(pos, { name = mod_name..':will_o_wisp_glow' })
		end,
	})

	--mod.add_construct(mod_name..':will_o_wisp_glow')
	--mod.add_construct(mod_name..':will_o_wisp_dark')



	newnode = clone_node('air')
	newnode.drowning = 1
	minetest.register_node(mod_name..':inert_gas', newnode)


	-- kelp-like water plant?
	minetest.register_node(mod_name..':wet_fungus', {
		description = 'Leaves',
		tiles = { 'wet_fungus.png' },
		light_source = 2,
		groups = { snappy = 3 },
		drop = '',
		sounds = default.node_sound_leaves_defaults(),
	})
	--]]
end


do
	-- What's a cave without speleothems?
	local spel = {
		{ stalac = 'stalactite', stalag = 'stalagmite', tile = 'default_stone.png', place_on = { 'default:stone' }, biomes = { 'stone' }, },
		{ stalac = 'stalactite_slimy', stalag = 'stalagmite_slimy', tile = 'default_stone.png^mapgen_algae.png', light = light_max-6, place_on = { mod_name..':stone_with_algae' }, biomes = { 'algae' }, },
		{ stalac = 'stalactite_mossy', stalag = 'stalagmite_mossy', tile = 'default_stone.png^mapgen_moss.png', light = light_max-6, place_on = { mod_name..':stone_with_moss' }, biomes = { 'mossy' }, },
		{ stalac = 'stalactite_lichen', stalag = 'stalagmite_lichen', tile = 'default_stone.png^mapgen_lichen.png', light = light_max-6, place_on = { mod_name..':stone_with_lichen' }, biomes = { 'lichen' }, },
		--{ stalac = 'stalactite_crystal', stalag = 'stalagmite_crystal', tile = 'mapgen_radioactive_ore', light = light_max },
		{ stalac = 'icicle_down', stalag = 'icicle_up', desc = 'Icicle', tile = 'default_ice.png', drop = 'default:ice', place_on = { 'default:ice' }, biomes = { 'ice', }, },
	}

	for _, desc in pairs(spel) do
		minetest.register_node(mod_name..':'..desc.stalac, {
			description = (desc.desc or 'Stalactite'),
			tiles = { desc.tile },
			is_ground_content = true,
			walkable = false,
			light_source = desc.light,
			paramtype = 'light',
			drop = (desc.drop or mod_name..':stalactite'),
			drawtype = 'nodebox',
			node_box = { type = 'fixed',
			fixed = {
				{ -0.07, 0.0, -0.07, 0.07, 0.5, 0.07 },
				{ -0.04, -0.25, -0.04, 0.04, 0.0, 0.04 },
				{ -0.02, -0.5, -0.02, 0.02, 0.25, 0.02 },
			} },
			groups = { rock = 1, cracky = 3 },
			sounds = default.node_sound_stone_defaults(),
		})

		minetest.register_node(mod_name..':'..desc.stalag, {
			description = (desc.desc or 'Stalagmite'),
			tiles = { desc.tile },
			is_ground_content = true,
			walkable = false,
			paramtype = 'light',
			light_source = desc.light,
			drop = mod_name..':stalagmite',
			drawtype = 'nodebox',
			node_box = { type = 'fixed',
			fixed = {
				{ -0.07, -0.5, -0.07, 0.07, 0.0, 0.07 },
				{ -0.04, 0.0, -0.04, 0.04, 0.25, 0.04 },
				{ -0.02, 0.25, -0.02, 0.02, 0.5, 0.02 },
			} },
			groups = { rock = 1, cracky = 3 },
			sounds = default.node_sound_stone_defaults(),
		})

		minetest.register_decoration({
			deco_type = 'simple',
			place_on = desc.place_on,
			sidelen = 16,
			fill_ratio = 0.1,
			biomes = desc.biomes,
			decoration = mod_name..':'..desc.stalac,
			name = desc.stalac,
			flags = 'all_ceilings',
		})

		minetest.register_decoration({
			deco_type = 'simple',
			place_on = desc.place_on,
			sidelen = 16,
			fill_ratio = 0.1,
			biomes = desc.biomes,
			decoration = mod_name..':'..desc.stalag,
			name = desc.stalag,
			flags = 'all_floors',
		})
	end
	--[[


	minetest.register_node(mod_name..':bound_spirit', {
		description = 'Tormented Spirit',
		tiles = { 'spirit.png' },
		use_texture_alpha = true,
		light_source = 1,
		paramtype2 = 'facedir',
		walkable = false,
		pointable = false,
		groups = { poison = 1 },
		drawtype = 'plantlike',
	})
	--]]
end


do
	minetest.register_lbm({
		name = mod_name..':mush_timers',
		nodenames = {
			mod_name..':giant_mushroom_cap',
			mod_name..':giant_mushroom_stem',
			'flowers:mushroom_red',
			'flowers:mushroom_brown',
		},
		action = function(pos, node)
			local n = node.name
			minetest.registered_nodes[n].on_construct(pos)
		end,
	})
end
