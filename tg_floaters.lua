-- Duane's mapgen tg_floaters.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod, layers_mod = mapgen, mapgen
local mod_name = mod.mod_name
local falling = {}
local max_height = 31000
local shell_thick = 30


local node = layers_mod.node
local clone_node = layers_mod.clone_node


-- floater-specific nodes
do
	local newnode = mod.clone_node('air')
	newnode.description = 'Airy Barrier'
	newnode.walkable = true
	newnode.floodable = false
	minetest.register_node(':'..mod_name..':airy_barrier', newnode)
end


function mod.generate_floaters(params)
	local minp, maxp = params.isect_minp, params.isect_maxp
	local water_level = params.sealevel
	local area, data, p2data = params.area, params.data, params.vmparam2
	local csize = params.csize
	local ystride = area.ystride
	local ps = PcgRandom(params.chunk_seed + 7712)

	params.share.propagate_shadow = false
	params.share.no_ponds = true

	local n_stone = node['default:stone']
	local n_air = node['air']
	local n_water = node['default:water_source']
	local n_glass = node[mod_name..':airy_barrier']
	local n_placeholder_lining = node[layers_mod.mod_name .. ':placeholder_lining']

	-- Find all falling nodes.
	if not falling[node['default:sand'] ] then
		for k, v in pairs(minetest.registered_nodes) do
			if v.groups and v.groups.falling_node then
				falling[node[v.name] ] = true
			end
		end
	end

	-- just a few 2d noises
	local ground_noise_map = layers_mod.get_noise2d({
		name = 'floaters_over',
		pos = { x = minp.x, y = minp.z },
		size = {x=csize.x, y=csize.z},
	})
	local under_noise_map = layers_mod.get_noise2d({
		name = 'floaters_under',
		pos = { x = minp.x, y = minp.z },
		size = {x=csize.x, y=csize.z},
	})
	local base_noise_map = layers_mod.get_noise2d({
		name = 'floaters_base',
		pos = { x = minp.x, y = minp.z },
		size = {x=csize.x, y=csize.z},
	})

	local base_base_level = water_level + 63

	local height_min = max_height
	local height_max = max_height
	local surface = {}
	params.share.surface = surface

	-- terrain height calculations
	local index = 1
	for z = minp.z, maxp.z do
		surface[z] = {}
		for x = minp.x, maxp.x do
			local base_level = base_base_level + math.abs(base_noise_map[index])
			local ground_1 = ground_noise_map[index]
			local height = ground_1 + base_level
			local depth = base_level - under_noise_map[index]

			height = math.floor(height + 0.5)
			depth = math.floor(depth + 0.5)
			if depth >= base_level then
				height = -max_height
			end

			-- Figure out the tops and bottoms.
			local pheight = math.abs(math.floor((height - minp.y + math.abs(depth - minp.y)) / 10) - 10)
			local cave_high = math.min(height - shell_thick, maxp.y - pheight)
			local cave_low = math.max(depth + shell_thick, minp.y + pheight)

			surface[z][x] = {
				top = height,
				bottom = depth,
				cave_floor = cave_low,  -- Not cave_top; that's confusing.
				cave_ceiling = cave_high,
			}

			if height > params.sealevel then
				surface[z][x].biome = layers_mod.undefined_biome
			else
				surface[z][x].biome = layers_mod.undefined_underwater_biome
			end

			height_max = math.max(ground_1, height_max)
			height_min = math.min(ground_1, height_min)

			local min_y = depth
			local min_y_chunk = math.max(minp.y, min_y)

			-- Start at the bottom and fill up.
			local ivm = area:index(x, min_y_chunk, z)
			for y = min_y_chunk, maxp.y do
				if y < min_y then
					-- below the terrain
				elseif y <= cave_high and y >= cave_low then
					-- This is a cave.
				elseif params.cave_biomes and not params.share.no_biome
				and y <= cave_high + 3 and y >= cave_low - 3 then
					data[ivm] = n_placeholder_lining
					p2data[ivm] = 0
				elseif y <= height then
					-- Otherwise, it's stoned.
					data[ivm] = n_stone
					p2data[ivm] = 0
				end

				ivm = ivm + ystride
			end

			-- Place water down to the bottom of the chunk.
			if minp.y < water_level then
				local ivm = area:index(x, minp.y, z)
				local y_max = math.min(water_level, maxp.y)
				for y = minp.y, y_max do
					if y == params.realm_minp.y then
						data[ivm] = n_glass
						p2data[ivm] = 0
					elseif data[ivm] == n_air then
						data[ivm] = n_water
						p2data[ivm] = 0
					end

					ivm = ivm + ystride
				end
			end

			index = index +	1
		end
	end

	if layers_mod.place_all_decorations then
		layers_mod.place_all_decorations(params)

		if not params.share.no_dust and layers_mod.dust then
			layers_mod.dust(params)
		end
	end

	if layers_mod.simple_ore then
		layers_mod.simple_ore(params, 9)
	end
end


function mod.get_spawn_level(realm, x, z, force)
	local water_level = realm.sealevel
	local base_base_level = water_level + 63

	local ground_noise = minetest.get_perlin(mod.registered_noises['floaters_over'])
	ground_noise = ground_noise:get_2d({x=x, y=z})
	local base_noise = minetest.get_perlin(mod.registered_noises['floaters_base'])
	base_noise = base_noise:get_2d({x=x, y=z})
	local under_noise = minetest.get_perlin(mod.registered_noises['floaters_under'])
	under_noise = under_noise:get_2d({x=x, y=z})

	local base_level = base_base_level + math.abs(base_noise)
	local height = ground_noise + base_level
	local depth = base_level - under_noise

	height = math.floor(height + 0.5)
	depth = math.floor(depth + 0.5)
	if depth >= base_level then
		height = realm.sealevel - 1
	end

	if not force and height <= realm.sealevel then
		return
	end

	return height
end


-- Define the noises.
layers_mod.register_noise( 'floaters_base', {offset = 0, scale = 50, seed = 2567, spread = {x = 250, y = 250, z = 250}, octaves = 3, persist = 0.5, lacunarity = 2} )
layers_mod.register_noise( 'floaters_over', {offset = -20, scale = 25, seed = 4877, spread = {x = 200, y = 200, z = 200}, octaves = 4, persist = 0.8, lacunarity = 2} )
layers_mod.register_noise( 'floaters_under', {offset = 0, scale = 75, seed = 4877, spread = {x = 200, y = 200, z = 200}, octaves = 7, persist = 0.6, lacunarity = 2} )

layers_mod.register_mapgen('tg_floaters', mod.generate_floaters)
if layers_mod.register_spawn then
	layers_mod.register_spawn('tg_floaters', mod.get_spawn_level)
end
