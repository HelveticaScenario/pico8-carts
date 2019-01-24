pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function round(i) 
	local _i = i - flr(i)
	if (_i < 0.5) then
		return flr(i)
	else 
		return ceil(i)
	end
end

function lerp(a0, a1, w) 
	return (1.0 - w) * a0 + w * a1
end

function in_bounds(x,y,bound_x,bound_y)
	if (x < 0) then
		return false
	elseif (y < 0) then
		return false
	elseif (x > bound_x) then
		return false
	elseif (y > bound_y) then
		return false
	end
	return true
end

function make_grid(width, height, f)
	local grid = {}
	for x=1,width do
		grid[x] ={}
		for y=1,height do
			grid[x][y] = f(x,y)
		end
	end
	return grid
end


function _init()
	grid_dim = {width = 17, height = 17}
	
	grid = make_grid(
		grid_dim.width,
		grid_dim.height,
		function(x,y)
			return flr(rnd(16))
		end
	)
	-- printh(#grid)
	printh(flr(128/(grid_dim.width-1))-1)
end

function _draw() 
	cls(7)


	-- for x =0,127 do
	-- 	for y=0,127 do
	-- 		local v = round((lerp(0,15, x/127) + lerp(0,15, y/127))/2)
	-- 		pset(x,y,v)
	-- 	end
	-- end

	for qx = 2, grid_dim.width do
		for qy= 2, grid_dim.height do
			local points = {
				{grid[qx-1][qy-1], grid[qx][qy-1]},
				{grid[qx-1][qy], grid[qx][qy]},
				-- {grid[qx-1][qy-1], grid[qx][qy-1]}
			}
			for x = 0,flr(128/(grid_dim.width-1))-1 do
				for y = 0,flr(128/(grid_dim.height-1))-1 do
					local v = round((lerp(points[1][1],points[2][1], x/7) + lerp(points[1][2],points[2][2], y/7))/2)
					pset((qx-2) * flr(128/(grid_dim.width-1)) + x, (qy-2) * flr(128/(grid_dim.height-1)) + y, v)
				end
			end

		end
	end
	-- for x = 1, #grid do
	-- 	for y = 1, #grid[x] do
	-- 		pset((x-1) * 8, (y-1) * 8, flr(grid[x][y] * 15))
	-- 	end
	-- end
end