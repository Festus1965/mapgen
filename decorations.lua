-- Duane's mapgen nodes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = mapgen
local mod_name = 'mapgen'
local clone_node = mod.clone_node
local node = mod.node


mod.biomes = {}
mod.cave_biomes = {}


--[[
mod.cave_biomes = {
	{
		name = 'stone',
		biome_val = 0,
		stalagmite = {
			node = 'default:torch',
			chance = 50,
			param2 = 1,
		},
	},
	{
		name = 'lichen',
		ceiling_node = mod_name..':stone_with_lichen',
		dirt = 'default:dirt',
		dirt_chance = 10,
		floor_node = mod_name..':stone_with_lichen',
		fungi = true,
		stalactite = {
			node = mod_name..':stalactite_lichen',
			chance = 20,
		},
		stalagmite = {
			node = mod_name..':stalagmite_lichen',
			chance = 20,
		},
		surface_depth = 1,
		underwater = true,
	},
	{
		name = 'algae',
		ceiling_node = mod_name..':stone_with_algae',
		dirt = 'default:dirt',
		dirt_chance = 10,
		floor_node = mod_name..':stone_with_algae',
		fungi = true,
		stalactite = {
			node = mod_name..':stalactite_slimy',
			chance = 20,
		},
		stalagmite = {
			node = mod_name..':stalagmite_slimy',
			chance = 20,
		},
		surface_depth = 1,
		underwater = true,
	},
	{
		name = 'granite_lava',
		deco = 'default:mese',
		deco_chance = 200,
		fluid = 'default:lava_source',
		gas = mod_name..':inert_gas',
		surface_depth = 1,
		stalactite = {
			node = 'default:lava_source',
			chance = 200,
		},
		stone_type = mod_name..':granite',
	},
	{
		name = 'granite',
		stalagmite = {
			node = 'default:torch',
			chance = 50,
			param2 = 1,
		},
		stone_type = mod_name..':granite',
		underwater = true,
	},
	{
		name = 'salt',
		ceiling_node = mod_name..':stone_with_salt',
		deco = mod_name..':radioactive_ore',
		deco_chance = 100,
		floor_node = mod_name..':stone_with_salt',
		surface_depth = 2,
		underwater = false,
	},
	{
		name = 'basalt',
		stalagmite = {
			node = 'default:torch',
			chance = 50,
			param2 = 1,
		},
		stone_type = mod_name..':basalt',
		underwater = true,
	},
	{
		name = 'moss',
		ceiling_node = mod_name..':stone_with_moss',
		deco = mod_name..':glowing_fungal_stone',
		deco_chance = 50,
		floor_node = mod_name..':stone_with_moss',
		fluid = 'default:water_source',
		stalactite = {
			node = mod_name..':stalactite_mossy',
			chance = 20,
		},
		stalagmite = {
			node = mod_name..':stalagmite_mossy',
			chance = 20,
		},
		surface_depth = 1,
		underwater = true,
	},
	{
		name = 'sand',
		ceiling_node = 'default:sandstone',
		floor_node = 'default:sand',
		deco = mod_name..':phosph_sand',
		deco_chance = 30,
		surface_depth = 2,
		underwater = true,
	},
	{
		name = 'coal',
		ceiling_node = mod_name..':black_sand',
		deco = 'default:coalblock',
		deco_chance = 100,
		floor_node = mod_name..':black_sand',
		stalagmite = {
			node = 'fire:permanent_flame',
			chance = 50,
		},
		stone_type = mod_name..':basalt',
		surface_depth = 2,
	},
	{
		name = 'lichen_dead',
		ceiling_node = mod_name..':stone_with_lichen',
		floor_node = mod_name..':stone_with_lichen',
		gas = mod_name..':inert_gas',
		stalactite = {
			node = mod_name..':stalactite',
			chance = 12,
		},
		stalagmite = {
			node = {mod_name..':will_o_wisp_glow', mod_name..':stalagmite'},
			chance = 50,
		},
		surface_depth = 1,
		--underwater = true,
	},
	{
		name = 'hell',
		fluid = 'default:lava_source',
		schematics = { { schematic = mod.schematics['hell_tree'], chance = 150 }, },
		stalagmite = {
			node = mod_name..':bound_spirit',
			chance = 20,
		},
		stone_type = mod_name..':basalt',
	},
	{
		name = 'hot',
		ceiling_node = mod_name..':hot_rock',
		floor_node = mod_name..':hot_rock',
		fluid = 'default:lava_source',
		stalagmite = {
			node = mod.hot_spikes,
			chance = 50,
		},
		stone_type = mod_name..':granite',
		surface_depth = 1,
		underwater = false,
	},
	{
		name = 'ice',
		ceiling_node = 'default:ice',
		deco = mod_name..':will_o_wisp_glow',
		deco_chance = 200,
		floor_node = 'default:ice',
		stalactite = {
			node = mod_name..':icicle_down',
			chance = 12,
		},
		stalagmite = {
			node = mod_name..':icicle_up',
			chance = 12,
		},
		surface_depth = 2,
		underwater = true,
	},
}
--]]


local function register_biome(def)
	if not def.name then
		print('No name biome', dump(def))
		return
	end

	local w = table.copy(def)
	mod.biomes[w.name] = w
	if w.y_max and w.y_max < -19 then
		mod.cave_biomes[w.name] = w
	end
end


do
	for k, v in pairs(minetest.registered_biomes) do
		register_biome(v)
	end
end



local function invert_table(t, use_node)
	local any
	local new_t = {}

	if type(t) == 'string' then
		t = {t}
	end

	for _, d in ipairs(t) do
		if type(d) == 'string' then
			local l = {}
			if use_node and d:find('^group:') then
				local gr = d:gsub('^group:', '')
				for n, v in pairs(minetest.registered_nodes) do
					if v.groups[gr] then
						l[#l+1] = n
					end
				end
			elseif use_node then
				l = {d}
			end

			if use_node then
				for _, v in pairs(l) do
					new_t[node[v]] = node[v]
				end
			else
				new_t[d] = d
			end
			any = true
		end
	end

	if any then
		return new_t
	end
end
mod.invert_table = invert_table


local function register_decoration(def)
	local deco = table.copy(def)
	table.insert(mod.decorations, deco)

	if not deco.name then
		local nname = (deco.decoration or deco.schematic):gsub('^.*[:/]([^%.]+)', '%1')
		deco.name = nname
	end

	if deco.flags and deco.flags ~= '' then
		for flag in deco.flags:gmatch('[^,]+') do
			deco[flag] = deco[flag] or true
		end
	end

	if deco.place_on then
		deco.place_on_i = invert_table(deco.place_on, true)
	end

	if deco.biomes then
		deco.biomes_i = invert_table(deco.biomes)
	end

	for _, a in pairs(mod.aquatic_decorations or {}) do
		if deco.decoration == a or deco.schematic == a then
			deco.aquatic = true
		end
	end

	if deco.deco_type == 'schematic' then
		if deco.schematic and type(deco.schematic) == 'string' then
			local s = deco.schematic
			local f = io.open(s, 'r')
			if f then
				f:close()
				local sch = minetest.serialize_schematic(s, 'lua', {})
				sch = minetest.deserialize('return {'..sch..'}')
				sch = sch.schematic
				deco.schematic_array = sch
			else
				print(mod_name .. ': ** Error opening: '..mts)
			end

			--print(dump(deco.schematic_array))
			if not deco.schematic_array then
				print(mod_name .. ': ** Error opening: '..mts)
			end
		end

		if not deco.schematic_array and deco.schematic and type(deco.schematic) == 'table' then
			deco.schematic_array = deco.schematic
		end

		if deco.schematic_array then
			-- Force air placement to 0 probability.
			-- This is usually correct.
			for _, v in pairs(deco.schematic_array.data) do
				if v.name == 'air' then
					v.prob = 0
					if v.param1 then
						v.param1 = 0
					end
				elseif v.name:find('leaves') or v.name:find('needles') then
					if v.prob > 127 then
						v.prob = v.prob - 128
					end
				end
			end
		else
			print('FAILed to translate schematic: ' .. deco.name)
			deco.bad_schem = true
		end
	end

	return deco
end


do
	mod.decorations = {}
	for n, v in pairs(minetest.registered_decorations) do
		register_decoration(v)
	end
end


-- Catch any registered by other mods.
do
	local old_register_decoration = minetest.register_decoration
	minetest.register_decoration = function (def)
		local d = register_decoration(def)
		old_register_decoration(def)
	end


	local old_clear_registered_decorations = minetest.clear_registered_decorations
	minetest.clear_registered_decorations = function ()
		mod.decorations = {}
		old_clear_registered_decorations()
	end


	local old_register_biome = minetest.register_biome
	minetest.register_biome = function (def)
		local d = register_biome(def)
		old_register_biome(def)
	end


	local old_clear_registered_biomes = minetest.clear_registered_biomes
	minetest.clear_registered_biomes = function ()
		mod.biomes = {}
		mod.cave_biomes = {}
		old_clear_registered_biomes()
	end
end
