-- Duane's mapgen tg_islands.lua
-- Copied (and lightly modified) from Termos' Islands
--  (https://github.com/TheTermos/islands/)
-- Copyright TheTermos (??), 2019
-- Distributed under the MIT License


--[[
MIT License

Copyright (c) 2019 TheTermos

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]


local floor = math.floor
local ceil = math.ceil
local min = math.min
local max = math.max
local random = math.random

local convex = false
--local mpath = minetest.get_modpath('islands')
local mod = {}
mod.mod_name = 'islands'
local layers_mod = mapgen

local mult = 1.0
-- Set the 3D noise parameters for the terrain.


local np_terrain = {
--	offset = -13,
	offset = -11*mult,						-- ratio 2:7 or 1:4 ?
	scale = 40*mult,
--	scale = 30,
	spread = {x = 256*mult, y =256*mult, z = 256*mult},
--	spread = {x = 128, y =128, z = 128},
	seed = 1234,
	octaves = convex and 1 or 5,
	persist = 0.38,
	lacunarity = 2.33,
	--flags = "eased"
}	--]]

local np_var = {
	offset = 0,						
	scale = 6*mult,
	spread = {x = 64*mult, y =64*mult, z = 64*mult},
	seed = 567891,
	octaves = 4,
	persist = 0.4,
	lacunarity = 1.89,
	--flags = "eased"
}

local np_hills = {
	offset = 2.5,					-- off/scale ~ 2:3
	scale = -3.5,
	spread = {x = 64*mult, y =64*mult, z = 64*mult},
--	spread = {x = 32, y =32, z = 32},
	seed = 2345,
	octaves = 3,
	persist = 0.40,
	lacunarity = 2.0,
	flags = "absvalue"
}

local np_cliffs = {
	offset = 0,					
	scale = 0.72,
	spread = {x = 180*mult, y =180*mult, z = 180*mult},
	seed = 78901,
	octaves = 2,
	persist = 0.4,
	lacunarity = 2.11,
--	flags = "absvalue"
}

local hills_offset = np_hills.spread.x*0.5
local hills_thresh = floor((np_terrain.scale)*0.5)
local shelf_thresh = floor((np_terrain.scale)*0.5) 
local cliffs_thresh=10

local function max_height(noiseprm)
	local height = 0
	local scale = noiseprm.scale
	for i=1,noiseprm.octaves do
		height=height + scale
		scale = scale * noiseprm.persist
	end	
	return height+noiseprm.offset
end

local function min_height(noiseprm)
	local height = 0
	local scale = noiseprm.scale
	for i=1,noiseprm.octaves do
		height=height - scale
		scale = scale * noiseprm.persist
	end	
	return height+noiseprm.offset
end

local base_min = min_height(np_terrain)
local base_max = max_height(np_terrain)
local base_rng = base_max-base_min
local easing_factor = 1/(base_max*base_max*4)
local base_heightmap = {}


-- Get the content IDs for the nodes used.

local c_sandstone = minetest.get_content_id("default:sandstone")
local c_stone = minetest.get_content_id("default:stone")
local c_sand = minetest.get_content_id("default:sand")
--local c_dirt = minetest.get_content_id("default:dirt_with_grass")
--local c_dirt = minetest.get_content_id("default:dirt_with_dry_grass")
local c_dirt = minetest.get_content_id("islands:dirt_with_grass_palm")
local c_snow = minetest.get_content_id("islands:dirt_with_snow")
local c_water     = minetest.get_content_id("default:water_source")


-- Initialize noise object to nil. It will be created once only during the
-- generation of the first mapchunk, to minimise memory use.

local nobj_terrain = nil
local nobj_var = nil
local nobj_hills = nil
local nobj_cliffs = nil


-- Localise noise buffer table outside the loop, to be re-used for all
-- mapchunks, therefore minimising memory use.

local nvals_terrain = {}
local isln_terrain = nil
local isln_var = nil
local isln_hills = nil
local isln_cliffs = nil


-- Localise data buffer table outside the loop, to be re-used for all
-- mapchunks, therefore minimising memory use.

local function get_terrain_height(theight,hheight,cheight, sealevel)
		-- parabolic gradient
	if theight > 0 and theight < shelf_thresh then
		theight = theight * (theight*theight/(shelf_thresh*shelf_thresh)*0.5 + 0.5)
	end	
		-- hills
	if theight > hills_thresh then
		theight = theight + max((theight-hills_thresh) * hheight,0)
		-- cliffs
	elseif theight > 1 and theight < hills_thresh then 
		local clifh = max(min(cheight,1),0) 
		if clifh > 0 then
			clifh = -1*(clifh-1)*(clifh-1) + 1
			theight = theight + (hills_thresh-theight) * clifh * ((theight<2) and theight-1 or 1)
		end
	end
	return theight + sealevel
end
 
-- On generated function.

-- 'minp' and 'maxp' are the minimum and maximum positions of the mapchunk that
-- define the 3D volume.
function mod.generate_islands(params)
	local minp, maxp = params.isect_minp, params.isect_maxp
	local data, area = params.data, params.area
	local water_level = params.sealevel

	local sidelen = maxp.x - minp.x + 1
--	local permapdims3d = {x = sidelen, y = sidelen, z = sidelen}
	local permapdims3d = {x = sidelen, y = sidelen, z = 0}
	local surface = {}
	
	-- base terrain
	nobj_terrain = nobj_terrain or
		minetest.get_perlin_map(np_terrain, permapdims3d)		
	isln_terrain=nobj_terrain:get_2d_map({x=minp.x,y=minp.z})
	
	-- base variation
	nobj_var = nobj_var or
		minetest.get_perlin_map(np_var, permapdims3d)		
	isln_var=nobj_var:get_2d_map({x=minp.x,y=minp.z})
	
	-- hills
	nobj_hills = nobj_hills or
		minetest.get_perlin_map(np_hills, permapdims3d)
	isln_hills=nobj_hills:get_2d_map({x=minp.x+hills_offset,y=minp.z+hills_offset})
	
	-- cliffs
	nobj_cliffs = nobj_cliffs or
		minetest.get_perlin_map(np_cliffs, permapdims3d)
	isln_cliffs=nobj_cliffs:get_2d_map({x=minp.x,y=minp.z})
	
	for z = minp.z, maxp.z do
		surface[z] = {}
		base_heightmap[z-minp.z+1]={}
		for x = minp.x, maxp.x do
			local theight = isln_terrain[z-minp.z+1][x-minp.x+1] + (convex and isln_var[z-minp.z+1][x-minp.x+1] or 0)
			local hheight = isln_hills[z-minp.z+1][x-minp.x+1]
			local cheight = isln_cliffs[z-minp.z+1][x-minp.x+1]
			local height =get_terrain_height(theight,hheight,cheight, water_level)
			base_heightmap[z-minp.z+1][x-minp.x+1]=height
			surface[z][x] = {
				top = height
			}
		end
	end	

	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			for x = minp.x, maxp.x do
				local vi = area:index(x, y, z)								
				local theight = surface[z][x].top
				
				if theight > y then
					data[vi] = c_stone
				--elseif y==ceil(theight) then
				--	data[vi]= y<3 and c_sand or (y<60-random(3) and c_dirt or c_snow)
				elseif y <= water_level then
					data[vi] = c_water
				end
			end
		end
	end

	params.share.surface = surface
end


function mod.get_spawn_level(realm, x, z, force)
	local height = 20 + realm.sealevel
	--local theight = isln_terrain[z-minp.z+1][x-minp.x+1] + (convex and isln_var[z-minp.z+1][x-minp.x+1] or 0)
	--local hheight = isln_hills[z-minp.z+1][x-minp.x+1]
	--local cheight = isln_cliffs[z-minp.z+1][x-minp.x+1]
	--local height =get_terrain_height(theight,hheight,cheight, water_level)

	if not force and height <= realm.sealevel then
		return
	end

	return height
end


layers_mod.register_mapgen('tg_islands', mod.generate_islands)
if layers_mod.register_spawn then
	layers_mod.register_spawn('tg_islands', mod.get_spawn_level)
end
