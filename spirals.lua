-- Duane's mapgen spirals.lua
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


do
	local newnode = layer_mod.clone_node('default:tree')
	newnode.description = 'Bark'
	newnode.tiles = {'default_tree.png'}
	newnode.is_ground_content = false
	newnode.groups.tree = 0
	newnode.groups.flammable = 0
	newnode.groups.puts_out_fire = 1
	newnode.sunlight_propagates = true
	minetest.register_node(mod_name..':bark', newnode)

	newnode = layer_mod.clone_node('default:leaves')
	newnode.description = 'Leaves'
	newnode.groups = nil
	newnode.sunlight_propagates = true
	minetest.register_node(mod_name..':spiral_leaves', newnode)

	minetest.register_node(mod_name..':cloud_hard', {
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
end


-----------------------------------------------
-- Spirals_Mapgen class
-----------------------------------------------

local function spirals_mapgen(base_class)
	if not base_class then
		return
	end

	local new_class = {}
	local new_mt = { __index = new_class, }

	function new_class:new(mg, params)
		local new_inst = {}
		for k, v in pairs(mg) do
			new_inst[k] = v
		end
		for k, v in pairs(params) do
			new_inst[k] = v
		end

		setmetatable(new_inst, new_mt)
		return new_inst
	end

	setmetatable(new_class, { __index = base_class })

	return new_class
end

local Spirals_Mapgen = spirals_mapgen(layer_mod.Mapgen)


function Spirals_Mapgen:after_decorations()
	-- nop
end


-- check
function Spirals_Mapgen:after_terrain()
	local area = self.area
	local buildable_to = self.buildable_to
	local data = self.data
	local maxp = self.maxp
	local minp = self.minp
	local flets = false

	local n_leaves = node[mod_name..':spiral_leaves']
	local n_bark = node[mod_name .. ':bark']

	local geo = Geomorph.new()
	geo:add({
		action = 'cylinder',
		axis = 'y',
		intersect = {'default:lava_source'},
		node = 'default:stone',
		location = VN(5, 0, 5),
		size = VN(70, 80, 70),
	})
	geo:add({
		action = 'cylinder',
		axis = 'y',
		intersect = {'default:water_source'},
		node = mod_name..':bark',
		location = VN(5, 0, 5),
		size = VN(70, 80, 70),
	})
	geo:add({
		action = 'cylinder',
		axis = 'y',
		node = 'air',
		location = VN(7, 0, 7),
		size = VN(66, 80, 66),
	})
	geo:add({
		action = 'cylinder',
		axis = 'y',
		node = mod_name..':cloud_hard',
		location = VN(12, 25, 12),
		size = VN(56, 1, 56),
	})
	geo:add({
		action = 'cylinder',
		axis = 'y',
		node = mod_name..':cloud_hard',
		location = VN(12, 50, 12),
		size = VN(56, 1, 56),
	})
	geo:write_to_map(self)

	local r1, n1, s1, l1 = 30, 3, 20, 20

	for my = minp.y - 2, maxp.y + 2 do
		for ot = 1, n1 * 2 do
			local t = my / s1 + math_pi * (ot / n1)
			local mx = math_floor(minp.x + 40 + r1 * math_cos(t))
			local mz = math_floor(minp.z + 40 + r1 * math_sin(t))
			local ivm = area:index(mx, my, mz)
			if buildable_to[data[ivm]] then
				data[ivm] = node['default:tree']
			end
			for oz = -2, 2 do
				for oy = -2, 2 do
					ivm = area:index(mx - 2, my + oy, mz + oz)
					for _ = -2, 2 do
						if buildable_to[data[ivm]] then
							data[ivm] = n_leaves
						end
						ivm = ivm + 1
					end
				end
			end
		end
		local r2 = r1 - 3
		local r22 = r2 * r2
		local r32 = 5 * 5
		if flets and my % l1 == 0 then
			for oz = -r2, r2 do
				local ivm = area:index(minp.x + 40 - r2, my, minp.z + 40 + oz)
				for ox = -r2, r2 do
					local r = ox * ox + oz * oz
					if (buildable_to[data[ivm]])
					and r < r22 and r > r32 then
						data[ivm] = n_bark
					end
					ivm = ivm + 1
				end
			end
		end
	end
end


-- This mapgen only adds to already placed terrain.
function Spirals_Mapgen:place_terrain()
	-- nop
end


function Spirals_Mapgen:prepare()
	-- Geomorph requires this.
	self.gpr = PcgRandom(self.seed + 7201)

	self.share.no_dust = true
	self.share.disruptive = true
end


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------


do
	local max_chunks = layer_mod.max_chunks

	layer_mod.register_map({
		name = 'spirals',
		mapgen = Spirals_Mapgen,
		mapgen_name = 'spirals',
		minp = VN(0, -max_chunks, 0),
		maxp = VN(0, max_chunks, 0),
		params = {},
		water_level = 1,
	})
end
