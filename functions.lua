-- Duane's mapgen functions.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = mapgen
local mod_name = 'mapgen'


-- This tables looks up nodes that aren't already stored.
mod.node = setmetatable({}, {
	__index = function(t, k)
		if not (t and k and type(t) == 'table') then
			return
		end

		t[k] = minetest.get_content_id(k)
		return t[k]
	end
})
local node = mod.node


function vector.mod(v, m)
	local w = table.copy(v)
	for _, d in ipairs({'x', 'y', 'z'}) do
		if w[d] then
			w[d] = w[d] % m
		end
	end
	return w
end


-- These nodes will have their on_construct method called
--  when placed by the mapgen (to start timers).
mod.construct_nodes = {}
function mod.add_construct(node_name)
	mod.construct_nodes[node[node_name]] = true
end


-- Modify a node to add a group
function mod.add_group(node_name, groups)
	local def = minetest.registered_items[node_name]
	if not (node_name and def and groups and type(groups) == 'table') then
		return false
	end
	local def_groups = def.groups or {}
	for group, value in pairs(groups) do
		if value ~= 0 then
			def_groups[group] = value
		else
			def_groups[group] = nil
		end
	end
	minetest.override_item(node_name, {groups = def_groups})
	return true
end


function mod.clone_node(name)
	if not (name and type(name) == 'string') then
		return
	end
	if not minetest.registered_nodes[name] then
		return
	end

	local nod = minetest.registered_nodes[name]
	local node2 = table.copy(nod)
	return node2
end


-- memory issues?
function mod.node_string_or_table(n)
    if not n then
        return {}
    end

    local o
    if type(n) == 'string' then
        o = { n }
    elseif type(n) == 'table' then
        o = table.copy(n)
    else
        return {}
    end

    for i, v in pairs(o) do
        o[i] = node[v]
    end

    return o
end


-- Create and initialize a table for a schematic.
function mod.schematic_array(width, height, depth)
	if not (
		width and height and depth
		and type(width) == 'number'
		and type(height) == 'number'
		and type(depth) == 'number'
	) then
		return
	end

	-- Dimensions of data array.
	local s = {size={x=width, y=height, z=depth}}
	s.data = {}

	for z = 0,depth-1 do
		for y = 0,height-1 do
			for x = 0,width-1 do
				local i = z*width*height + y*width + x + 1
				s.data[i] = {}
				s.data[i].name = "air"
				s.data[i].param1 = 000
			end
		end
	end

	s.yslice_prob = {}

	return s
end


minetest.register_on_shutdown(function()
  print('time caves: '..math.floor(1000 * mod.time_caves / mod.chunks))
  print('time decorations: '..math.floor(1000 * mod.time_deco / mod.chunks))
  print('time ore: '..math.floor(1000 * mod.time_ore / mod.chunks))
  print('time overhead: '..math.floor(1000 * mod.time_overhead / mod.chunks))
  print('time terrain: '..math.floor(1000 * mod.time_terrain / mod.chunks))
  print('time terrain_f: '..math.floor(1000 * mod.time_terrain_f / mod.chunks))
  print('time y loop: '..math.floor(1000 * mod.time_y_loop / mod.chunks))

  print('Total Time: '..math.floor(1000 * mod.time_all / mod.chunks))
  print('chunks: '..mod.chunks)
end)
