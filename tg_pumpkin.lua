-- Duane's mapgen tg_pumpkin.lua

-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


tg_pumpkin = {}
local mod, layers_mod = tg_pumpkin, mapgen
local mod_name = 'tg_pumpkin'
local max_height = 31000
local node = layers_mod.node
local SECTIONS = 30
local SIZ = 100
local SIZ2 = SIZ * SIZ


function mod.generate_pumpkin(params)
				--local t_yloop = os.clock()
	local minp, maxp = params.isect_minp, params.isect_maxp
	local area, data, p2data = params.area, params.data, params.vmparam2

	local csize = vector.add(vector.subtract(maxp, minp), 1)
	local origin = vector.floor(vector.divide(vector.add(params.realm_maxp, params.realm_minp), 2))
	local ystride = area.ystride
	params.csize = csize

	local n_stone = node['wool:orange']
	local n_air = node['air']
	local n_ignore = node['ignore']

	params.share.propagate_shadow = true

	local index = 1
	for z = minp.z, maxp.z do
		local dz = z - origin.z
		for x = minp.x, maxp.x do
			local dx = x - origin.x
			local ax = math.abs(dx)

			local ang = math.atan2(dz, dx)
			local sect = (ang + math.pi) * SECTIONS / (2 * math.pi)
			local saw = math.sin((sect % 1) * math.pi) * SIZ2 / 10

			local ivm = area:index(x, minp.y, z)
			local rad = SIZ2 + saw
			for y = minp.y, maxp.y do
				local dy = y - origin.y
				local dist = dx * dx + dy * dy * 1.3 + dz * dz
				local tw = (SIZ * 0.2) - (dy - SIZ * 0.2) / 1.5

				if dz < 0 and ax < SIZ * 0.3 + tw  and ax > SIZ * 0.3 - tw and dy < SIZ * 0.6 and dy > SIZ * 0.2 then
					--nop
				elseif dist < rad and dist > rad * 0.9 then
					data[ivm] = n_stone

					if dz < 0 and ax < SIZ * 0.45 and - dy < SIZ * 0.4 and - dy > SIZ * 0.1 then
						if math.floor((ax / (SIZ / 15)) + 0.5) % 2 == 0 then
							data[ivm] = n_air
						end
						if - dy < SIZ * 0.3 and - dy > SIZ * 0.2 then
							data[ivm] = n_air
						end
						if ax > SIZ * 0.4 then
							data[ivm] = n_air
						end
					end
				end

				ivm = ivm + ystride
			end
		end
	end
end

layers_mod.register_mapgen('tg_pumpkin', mod.generate_pumpkin)
