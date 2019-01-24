pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

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
	grid = make_grid(
		16,
		16,
		function(x,y)
			return rnd()
		end
	)
end

function _draw() 
	cls(0)
	for x = 1, #grid do
		for y = 1, #grid[x] do
			pset((x-1) * 8, (y-1) * 8, flr(grid[x][y] * 15))
		end
	end
end