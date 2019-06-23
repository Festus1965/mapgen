-- Duane's mapgen roads.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local layer_mod = mapgen
local mod = mapgen
local mod_name = 'mapgen'

local Geomorph = geomorph.Geomorph

local math_abs = math.abs
local math_floor = math.floor
local math_max = math.max
local node = layer_mod.node
local VN = vector.new

local make_roads = true
local make_tracks = false


-----------------------------------------------
-- Roads_Mapgen class
-----------------------------------------------

local function roads_mapgen(base_class)
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

		new_inst.puzzle_boxes = {}

		setmetatable(new_inst, new_mt)
		return new_inst
	end

	setmetatable(new_class, { __index = base_class })

	return new_class
end

local Roads_Mapgen = roads_mapgen(layer_mod.Mapgen)


function Roads_Mapgen:after_decorations()
	-- nop
end


function Roads_Mapgen:after_terrain()
	if self.disruptive then
		return
	end

	self:houses()

	if #self.puzzle_boxes > 0 then
		self:place_puzzles()
	end
end


-- The houses function takes very little cpu time.
-- check
local house_materials = {'sandstonebrick', 'desert_stonebrick', 'stonebrick', 'brick', 'wood', 'junglewood'}
function Roads_Mapgen:houses()
	local csize = self.csize
	local plots = self.plots
	local pr = self.gpr
	local heightmap = self.heightmap
	local base_level = self.base_level

	for _, box in pairs(plots) do
		local pos = vector.add(box.pos, -2)
		local size = vector.add(box.size, 4)
		local good = true

		for z = pos.z, pos.z + size.z do
			for x = pos.x, pos.x + size.x do
				local index = z * csize.x + x + 1
				if not heightmap[index] or heightmap[index] < base_level - 1 or heightmap[index] > base_level + 1 then
					good = false
					break
				end
			end
			if not good then
				break
			end
		end

		if good then
			local walls, roof
			while walls == roof do
				walls = (house_materials)[pr:next(1, #house_materials)]
				roof = (house_materials)[pr:next(1, #house_materials)]
			end
			local walls1 = 'default:'..walls
			local roof1 = 'default:'..roof
			local geo = Geomorph.new()
			local lev = pr:next(1, 4) - 2
			if #self.puzzle_boxes == 0 and lev == 0 and box.size.x >= 7 and box.size.z >= 7 then
				local width = 7
				table.insert(self.puzzle_boxes, {
					pos = table.copy(pos),
					size = VN(width, width, width),
				})
			else
				lev = math_max(1, lev)

				-- foundation
				pos = table.copy(box.pos)
				pos.y = pos.y - 1
				size = table.copy(box.size)
				size.y = 1
				geo:add({
					action = 'cube',
					node = 'default:cobble',
					location = pos,
					size = size,
				})

				pos = table.copy(box.pos)
				pos.y = pos.y + lev * 5
				size = table.copy(box.size)
				if pr:next(1, 3) == 1 then
					size.y = 1
					geo:add({
						action = 'cube',
						node = roof1,
						location = pos,
						size = size,
					})
				elseif box.size.x <= box.size.z then
					size.x = math_floor(size.x / 2)

					local pos2 = table.copy(pos)
					pos2.x = pos2.x + size.x
					pos2.y = pos2.y + size.x - 1

					pos = table.copy(pos)
					pos.x = pos.x + box.size.x - size.x
				else
					size.z = math_floor(size.z / 2)

					local pos2 = table.copy(pos)
					pos2.z = pos2.z + size.z
					pos2.y = pos2.y + size.z - 1

					pos = table.copy(pos)
					pos.z = pos.z + box.size.z - size.z
				end
				pos = table.copy(box.pos)
				pos.y = box.pos.y
				size = table.copy(box.size)
				size.y = lev * 5
				geo:add({
					action = 'cube',
					node = walls1,
					location = pos,
					size = size,
				})
				for y = 0, lev - 1 do
					local pos2 = vector.add(pos, 1)
					local sz2 = vector.add(size, -2)
					pos2.y = box.pos.y + y * 5 + 1
					sz2.y = 4
					geo:add({
						action = 'cube',
						node = 'air',
						location = pos2,
						size = sz2,
					})
				end

				for y = 0, lev - 1 do
					for z = box.pos.z + 2, box.pos.z + box.size.z, 4 do
						geo:add({
							action = 'cube',
							node = 'air',
							location = VN(box.pos.x, box.pos.y + y * 5 + 2, z),
							size = VN(box.size.x, 2, 2),
						})
					end
					for x = box.pos.x + 2, box.pos.x + box.size.x, 4 do
						geo:add({
							action = 'cube',
							node = 'air',
							location = VN(x, box.pos.y + y * 5 + 2, box.pos.z),
							size = VN(2, 2, box.size.z),
						})
					end
				end

				do
					local l = math_max(box.size.x, box.size.z)
					local f = pr:next(0, 2)
					pos = vector.round(vector.add(box.pos, vector.divide(box.size, 2)))
					pos = vector.subtract(pos, math_floor(l / 2 + 0.5) - f)
					pos.y = pos.y + lev * 5
					geo:add({
						action = 'sphere',
						node = 'air',
						intersect = {walls1, roof1},
						location = pos,
						size = VN(l - 2 * f, 20, l - 2 * f),
					})

					for _ = 1, 3 do
						local pos2 = table.copy(pos)
						pos2.x = pos2.x + pr:next(0, box.size.x) - math_floor(box.size.x / 2)
						pos2.z = pos2.z + pr:next(0, box.size.z) - math_floor(box.size.z / 2)

						geo:add({
							action = 'sphere',
							node = 'air',
							intersect = {walls1, roof1},
							location = pos2,
							size = VN(l, 20, l),
						})
					end
				end
			end

			do
				local ff_alt = math_max(0, pr:next(1, 3) + pr:next(1, 3) - 4)
				local ore = self:get_ore(ff_alt)
				pos = table.copy(box.pos)
				size = table.copy(box.size)

				geo:add({
					action = 'cube',
					node = ore,
					intersect = {walls1, roof1},
					location = pos,
					size = size,
					random = 100,
				})
			end

			do
				local index = pos.z * csize.x + pos.x
				local biome = self.biomemap[index]
				local dirt = biome and biome.node_top or 'default:dirt'

				local ivm = self.area:indexp(vector.add(self.minp, box.pos))
				local p2 = self.p2data[ivm]

				pos = table.copy(box.pos)
				size = table.copy(box.size)
				size.y = 1
				geo:add({
					action = 'cube',
					node = dirt,
					location = pos,
					intersect = 'air',
					param2 = p2,
					size = size,
				})
			end

			geo:write_to_map(self, 0)
		end
	end
end


function Roads_Mapgen:map_height()
	-- nop
end


-- check
local road_w = 3
function Roads_Mapgen:map_roads()
	local csize = self.csize
	local roads = {}
	local tracks = {}
	local has_roads = false

	local index
	local road_ws = road_w * road_w
	for x = -road_w, csize.x + road_w - 1 do
		index = x + road_w + 1
		local l_road = self.noise['road_1'].map[index]
		for z = -road_w, csize.z + road_w - 1 do
			local road_1 = self.noise['road_1'].map[index]
			if (l_road < 0) ~= (road_1 < 0) then
				local index2 = z * csize.x + x + 1
				if make_tracks then
					tracks[index2] = true
				end
				for zo = -road_w, road_w do
					local zos = zo * zo
					for xo = -road_w, road_w do
						if x + xo >= 0 and x + xo < csize.x
						and z + zo >= 0 and z + zo < csize.z then
							if xo * xo + zos < road_ws then
								roads[index2 + zo * csize.x + xo] = true
								has_roads = true
							end
						end
					end
				end
			end
			l_road = road_1
			index = index + csize.x + road_w * 2
		end
	end

	-- Mark the road locations.
	index = 1
	for z = -road_w, csize.z + road_w - 1 do
		local l_road = self.noise['road_1'].map[index]
		for x = -road_w, csize.x + road_w - 1 do
			local road_1 = self.noise['road_1'].map[index]
			if (l_road < 0) ~= (road_1 < 0) then
				local index2 = z * csize.x + x + 1
				if make_tracks then
					tracks[index2] = true
				end
				for zo = -road_w, road_w do
					local zos = zo * zo
					for xo = -road_w, road_w do
						if x + xo >= 0 and x + xo < csize.x and z + zo >= 0 and z + zo < csize.z then
							if xo * xo + zos < road_ws then
								roads[index2 + zo * csize.x + xo] = true
								has_roads = true
							end
						end
					end
				end
			end
			l_road = road_1
			index = index + 1
		end
	end

	if make_tracks then
		for z = -1, csize.z + 1 do
			for x = -1, csize.x + 1 do
				index = z * csize.x + x + 1
				if tracks[index] then
					for zo = -1, 1 do
						for xo = -1, 1 do
							local index2 = (z + zo) * csize.x + (x + xo) + 1
							if tracks[index2] then
								if xo == 0 and zo == 0 then
									-- nop
								elseif math_abs(xo) == math_abs(zo) then
									local index3 = (z + 0) * csize.x + (x + xo) + 1
									local index4 = (z + zo) * csize.x + (x + 0) + 1
									if tracks[index3] or tracks[index4] then
										-- nop
									else
										tracks[index3] = true
									end
								end
							end
						end
					end
				end
			end
		end
	end

	self.has_roads = has_roads
	self.roads = roads
	self.tracks = tracks
end


function Roads_Mapgen:mark_plots()
	local csize = self.csize
	local chunk_offset = self.chunk_offset
	local base_level = self.base_level + chunk_offset  -- Figure from height?
	local plots = {}
	local roads = self.roads
	local pr = self.gpr

	-- Generate plots for constructions.
	for _ = 1, 15 do
		local scale = pr:next(1, 2) * 4
		local size = VN(pr:next(1, 2), 1, pr:next(1, 2))
		size.x = size.x * scale + 9
		size.y = size.y * 8
		size.z = size.z * scale + 9

		for _ = 1, 10 do
			local pos = VN(pr:next(2, csize.x - size.x - 3), base_level, pr:next(2, csize.z - size.z - 3))
			local good = true
			for _, box in pairs(plots) do
				if box.pos.x + box.size.x < pos.x
				or pos.x + size.x < box.pos.x
				or box.pos.z + box.size.z < pos.z
				or pos.z + size.z < box.pos.z then
					-- nop
				else
					good = false
					break
				end
			end
			for z = pos.z, pos.z + size.z do
				for x = pos.x, pos.x + size.x do
					local index = z * csize.x + x + 1
					if roads[index] then
						good = false
						break
					end
				end
				if not good then
					break
				end
			end
			if good then
				pos.y = pos.y - 2
				table.insert(plots, {
					pos = vector.add(pos, 2),
					size = vector.add(size, -4)
				})
				break
			end
		end
	end

	self.plots = plots
end


function Roads_Mapgen:place_puzzles()
	local width = 7
	local geo = Geomorph.new()

	for _, puz in pairs(self.puzzle_boxes) do
		local pos = vector.add(puz.pos, -1)
		pos.y = pos.y + 4
		local size = vector.add(puz.size, 2)
		geo:add({
			action = 'cube',
			node = 'air',
			clear_up = 13,
			location = pos,
			size = size,
		})

		pos = table.copy(puz.pos)
		pos.y = pos.y + 4
		geo:add({
			action = 'puzzle',
			chance = 1,
			clear_up = 13,
			location = pos,
			size = VN(width, width, width),
		})

		-- Only the first.
		--break
	end
	geo:write_to_map(self, 0)
end


-- This mapgen only adds to already placed terrain.
function Roads_Mapgen:place_terrain()
	-- nop
end


function Roads_Mapgen:prepare()
	if self.disruptive then
		return
	end

	self.gpr = PcgRandom(self.seed + 5245)

	self:map_roads()
	self:mark_plots()
end


-----------------------------------------------
-- Register the mapgen(s)
-----------------------------------------------


do
	local terrain_scale = 100
	local max_chunks = layer_mod.max_chunks

	local noises = {
		-----------------------------------------------
		-- Copy from terrain somehow?
		-----------------------------------------------
		['road_1'] = { def = {offset = 0, scale = terrain_scale, seed = 4382, spread = {x = 320, y = 320, z = 320}, octaves = 3, persist = 0.5, lacunarity = 2.0} },
	}


	layer_mod.register_map({
		name = 'roads',
		mapgen = Roads_Mapgen,
		mapgen_name = 'roads',
		minp = VN(-max_chunks, 0, -max_chunks),
		maxp = VN(max_chunks, 0, max_chunks),
		noises = noises,
		params = {},
		water_level = 1,
	})
end