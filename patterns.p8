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
	for col=1,width do
		grid[col] ={}
		for row=1,height do
			grid[col][row] = f(col,row)
		end
	end
	return grid
end


function _init()
	grid_dim = {width = 5, height = 5}
	
	grid = make_grid(
		grid_dim.width,
		grid_dim.height,
		function(col,row)
			return rnd()
		end
	)
end

 function inner(f00, f10, f01, f11, x, y) 
	local un_x = 1.0 - x
	local un_y = 1.0 - y
	return (f00 * un_x * un_y + f10 * x * un_y + f01 * un_x * y + f11 * x * y);
end

drawn_once = false

function _draw() 
	if (drawn_once) then
		return
	end
	drawn_once = true
	cls()

	local inner_range_row = flr(128/(grid_dim.height-1))-1
	local inner_range_col = flr(128/(grid_dim.width-1))-1

	for q_col = 2, grid_dim.width do
		for q_row= 2, grid_dim.height do
			local points = {
				{ grid[q_col-1][q_row-1], grid[q_col-1][q_row] },
				{ grid[q_col][q_row-1],   grid[q_col][q_row]   }
			}
			for col = 0, inner_range_col do
				for row = 0,inner_range_row do
					local row_norm = row / inner_range_row
					local col_norm = col / inner_range_col
					local v = flr(inner(points[1][1], points[2][1], points[1][2], points[2][2], col_norm, row_norm) * 15)
					pset((q_col-2) * flr(128/(grid_dim.width-1)) + col,(q_row-2) * flr(128/(grid_dim.height-1)) + row, v)
				end
			end
		end
	end
end