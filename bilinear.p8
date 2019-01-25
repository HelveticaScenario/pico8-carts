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

function inner(f00, f10, f01, f11, x, y) 
	local un_x = 1.0 - x
	local un_y = 1.0 - y
	return (f00 * un_x * un_y + f10 * x * un_y + f01 * un_x * y + f11 * x * y);
end

function wrap(v)
	while (v < 0) do
		v += 1
	end
	while (v > 1) do
		v -= 1
	end
	return v
end


function _init()
	grid_dim_min = {width = 2, height = 2}
	grid_dim_max = {width = 33, height = 33}
	grid_dim = {width = 3, height = 3}
	
	grid = make_grid(
		grid_dim.width,
		grid_dim.height,
		function(col,row)
			return rnd()
		end
	)
	

end

radius = 3
func = circ

change_by = 0.005
function _update()
	local needs_draw
	if (btnp(4)) then
		needs_draw = true
		if (rnd() > 0.5) then
			func = circ
		else
			func = circfill
		end
		radius = round(rnd(2) + 1)
	
	end

	if (btnp(0)) then
		-- grid_dim.width-=1
		-- grid_dim.height-=1
		-- grid_dim.width = ((grid_dim.width - 1) * 2) +  1
		-- grid_dim.height = ((grid_dim.height - 1) * 2) +  1
		-- grid_dim.width+=1
		-- grid_dim.height+=1
		needs_draw = true
	end
	if (btnp(1)) then
		-- grid_dim.width-=1
		-- grid_dim.height-=1
		-- grid_dim.width = ((grid_dim.width - 1) / 2) +  1
		-- grid_dim.height = ((grid_dim.height - 1) / 2) +  1
		-- grid_dim.width+=1
		-- grid_dim.height+=1
		needs_draw = true
	end
	if (btnp(2)) then
		change_by += 0.001
	end
	if (btnp(3)) then
		change_by -= 0.001
	end


	if (grid_dim.width < grid_dim_min.width) then
		grid_dim.width = grid_dim_min.width
	end
	if (grid_dim.height < grid_dim_min.height) then
		grid_dim.height = grid_dim_min.height
	end
	if (grid_dim.width > grid_dim_max.width) then
		grid_dim.width = grid_dim_max.width
	end
	if (grid_dim.height > grid_dim_max.height) then
		grid_dim.height = grid_dim_max.height
	end

	if (needs_draw) then
		grid = make_grid(
			grid_dim.width,
			grid_dim.height,
			function(col,row)
				return rnd()
			end
		)
	end

end
e = 0
has_video = false
has_started = false
first_frame = true
function _draw() 
	local _e = wrap(e)
	-- if (_e < e and has_video == false) then
	-- 	extcmd "video"
	-- 	has_video = true
	-- end
	e = _e

	cls()
	

	local inner_range_row = flr(32/(grid_dim.height-1))-1
	local inner_range_col = flr(32/(grid_dim.width-1))-1

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
					local v = inner(points[1][1], points[2][1], points[1][2], points[2][2], col_norm, row_norm)
					v = round(wrap(v + e) * 15)
					func(
						(
							(q_col-2) *
							inner_range_col +
							1 +
							col
						) * 4,
						(
							(q_row-2) *
							inner_range_row + 
							1 +
							row
						) * 4,
						radius,
						v
					)
				end
			end
		end
	end
	-- if (has_started == false and first_frame == false) then
	-- 	extcmd "rec"
	-- 	has_started = true
	-- end
	-- first_frame = false
	e += change_by
	

	-- rectfill(1,1, 40,7,7)
	-- print(inner_range_row .. " " .. inner_range_col .. " " .. grid_dim.height .. " " .. grid_dim.width .. " ", 2,2, 0)
end
