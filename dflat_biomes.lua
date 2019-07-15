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
			def.name = mod_name..':cherry_tree'
			def.schematic_array = table.copy(apple_deco.schematic_array)
			for _, v in pairs(def.schematic_array.data) do
				if v.name == 'default:leaves' or v.name == 'default:apple' then
					v.name = mod_name..':leaves_cherry'
				elseif v.name == 'default:tree' then
					v.name = mod_name..':tree_cherry'
				end
			end
			minetest.register_decoration(def)

			def = table.copy(apple_deco)

			def.noise_params.seed = 567
			def.noise_params.offset = def.noise_params.offset - 0.01
			def.schematic = nil
			def.name = mod_name..':oak_tree'
			def.schematic_array = table.copy(apple_deco.schematic_array)
			for _, v in pairs(def.schematic_array.data) do
				if v.name == 'default:leaves' or v.name == 'default:apple' then
					v.name = mod_name..':leaves_oak'
				elseif v.name == 'default:tree' then
					v.name = mod_name..':tree_oak'
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


mod.register_flower('orchid', 'Orchid', { 'rainforest', 'rainforest_swamp' }, 783)
mod.register_flower('bird_of_paradise', 'Bird of Paradise', { 'rainforest' }, 798)
mod.register_flower('gerbera', 'Gerbera', { 'savanna', 'rainforest' }, 911)
