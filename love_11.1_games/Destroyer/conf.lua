-- also serves as a utility file
function love.conf(t)

	t.window.width = 900
	t.window.height = 1000
	t.author = "Kai Hossbach (paranoiax)"	
	t.title = 'LSD - Little Sticky Destroyer'
	t.window.vsync = false
	t.window.fullscreen= false
	t.window.fsaa = 0
	t.identity = "LSD"
	t.console = true
	t.release = false

end

function intersect(x, y, w, h, x2, y2)
	local endx, endy = x+w, y+h
	return (x2<endx) and (x2>x) and (y2>y) and (y2<endy)
end

function distanceFrom(x1,y1,x2,y2)
	local distance = math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) * 0.375
	distance = distance>255 and 255 or distance
	return math.floor(distance + .5)
end

function math.clamp(input, mini, maxi)
	if input < mini then
		input = mini
	elseif input > maxi then
		input = maxi
	end
	return input
end