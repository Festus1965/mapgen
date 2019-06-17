-- Duane's mapgen nodes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = mapgen
local mod_name = 'mapgen'
local node = mod.node


mod.biomes = {}
mod.cave_biomes = {}


local function register_biome(def)
	if not def.name then
		print('No-name biome', dump(def))
		return
	end

	local w = table.copy(def)
	mod.biomes[w.name] = w
end


do
	for _, v in pairs(minetest.registered_biomes) do
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
		for flag in deco.flags:gmatch('[^, ]+') do
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
				print(mod_name .. ': ** Error opening: '..deco.schematic)
			end

			--print(dump(deco.schematic_array))
			if not deco.schematic_array then
				print(mod_name .. ': ** Error opening: '..deco.name)
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
	for _, v in pairs(minetest.registered_decorations) do
		register_decoration(v)
	end
end


-- Catch any registered by other mods.
do
	local old_register_decoration = minetest.register_decoration
	minetest.register_decoration = function (def)
		register_decoration(def)
		old_register_decoration(def)
	end


	local old_clear_registered_decorations = minetest.clear_registered_decorations
	minetest.clear_registered_decorations = function ()
		mod.decorations = {}
		old_clear_registered_decorations()
	end


	local old_register_biome = minetest.register_biome
	minetest.register_biome = function (def)
		register_biome(def)
		old_register_biome(def)
	end


	local old_clear_registered_biomes = minetest.clear_registered_biomes
	minetest.clear_registered_biomes = function ()
		mod.biomes = {}
		mod.cave_biomes = {}
		old_clear_registered_biomes()
	end
end


dofile(mod.path..'/environ.lua')
