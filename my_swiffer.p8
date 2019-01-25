pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()

	colors= {2,5,6,7, 12}
	dims = {17, 11}

	x = 0
	y = 0


	field = make_field()
	exposed = make_all_val(false)
	flags = make_all_val(false)
	dirty = make_all_val(false)
	has_won = false
	has_lost = false
end

function in_bounds(coord)
	if (coord[1] < 0) then
		return false
	elseif (coord[2] < 0) then
		return false
	elseif (coord[1] > dims[1]) then
		return false
	elseif (coord[2] > dims[2]) then
		return false
	end

	return true
end

function make_field ()
	local field = {}


	for x=0,dims[1] do
		field[x] ={}
		for y=0,dims[2] do
			field[x][y] = flr(rnd(10)) == 0
		end
	end

	for x=0,dims[1] do
		for y=0,dims[2] do
			if (field[x][y] ~= true) do
				local neighbors = 0
				for _x=x-1,x+1 do
					for _y=y-1,y+1 do
						if (_x ==0 and _y == 0) then
						elseif (not in_bounds({_x,_y})) then
						elseif (field[_x][_y] == true) then
							neighbors += 1
						end
					end
				end
				field[x][y] = neighbors

			end
		end
	end

	return field
end


function make_all_val(val)
	local all_val = {}

	for x=0,dims[1] do
		all_val[x] ={}
		for y=0,dims[2] do
			all_val[x][y] = val
		end
	end

	return all_val
end



function check_win()
	for x=0,dims[1] do
		for y=0,dims[2] do
			if ((field[x][y] == true) and (flags[x][y] ~= true)) then
				return false
			end
		end
	end
	return true
end

function expose_cascade(x, y)
	if (dirty[x][y]) then
		return
	end

	exposed[x][y] = true
	dirty[x][y] = true
	if (field[x][y] ~= 0) then
		return
	end

	for _x=x-1,x+1 do
		for _y=y-1,y+1 do
			if ((_x - x) == (_y - y) ) then
			elseif (not in_bounds({_x,_y})) then
			elseif (field[_x][_y] == 0) then
				print(x .. " " .. y, 0, 6)
				expose_cascade(_x,_y)
			else
				exposed[_x][_y] = true
			end
		end
	end
end



function _update()

	if (btnp(4)) then
		if (flags[x][y] == true) then
			return
		end

		if  (field[x][y] == true) then
			exposed[x][y] = true
			has_lost = true
			return
		end
		dirty = make_all_val(false)
		expose_cascade(x,y)

		has_won = check_win()
	end

	if (btnp(0)) then x=x-1 end
	if (btnp(1)) then x=x+1 end
	if (btnp(2)) then y=y-1 end
	if (btnp(3)) then y=y+1 end


	if (x < 0) then
		x = 0
	end
	if (y < 0) then
		y = 0
	end
	if (x > dims[1]) then
		x = dims[1]
	end
	if (y > dims[2]) then
		y = dims[2]
	end

	if (btnp(5) and exposed[x][y] ~= true) then
		flags[x][y] = not flags[x][y]
	end
end

function draw_square(coord, off, dim)
	local cell_val = field[coord[1]][coord[2]]
	local selected = coord[1] == x and coord[2] == y
	local exposed = exposed[coord[1]][coord[2]]
	local flag = flags[coord[1]][coord[2]]

	local c
	if (flag) then
		c= colors[5]
	elseif (exposed) then
		c= colors[3]
	else
		c = colors[2]
	end

	rectfill(
	off[1],
	off[2],
	off[1] + dim[1] -1,
	off[2] + dim[2] -1 ,
	c
	)
	if (selected) then
		rect(
		off[1]-1,
		off[2]-1,
		off[1] + dim[1],
		off[2] + dim[2] ,
		colors[4]
		)
	end

	if (cell_val ~= true and cell_val ~= 0 and exposed) then
		print(cell_val, off[1]+ 1, off[2] +1, 0)
	elseif (cell_val == true and exposed) then
		print("*", off[1]+ 1, off[2] +1, 0)
	elseif (flag == true) then
		print("F", off[1]+ 1, off[2] +1, 0)
	end
	--[[
	pset(
	off[1],
	off[2],
	colors[3]
	)
	pset(
	off[1]+dim[1],
	off[2],
	colors[3]
	)
	pset(
	off[1],
	off[2]+dim[2],
	colors[3]
	)
	pset(
	off[1]+dim[1],
	off[2]+dim[2],
	colors[3]
	)
	--]]
end

function _draw()
	cls(colors[1])
	print(x .. " ".. y)
	if (has_lost) then
		print("has lost")
	end
	if (has_wom) then
		print("has wom")
	end
	camera(-2,0)
	for _x=0,dims[1] do
		for _y=0,dims[2] do
			draw_square(
			{_x,_y},
			{7*_x, 8*(_y + 4)},
			{5,7}
			)

		end
	end

	--[[
	draw_square(
	{0,0},
	{2,2}
	)
	--]]
end
__gfx__
00000000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000766666670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700766666670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000766666670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000766666670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700766666670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000766666670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
