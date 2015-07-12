local class = require 'libs/middleclass'
local Button = require 'menu/button'

local Panel = class('Panel')

function Panel:initialize(positions, delta_buttons)
	self.list = {}
	self.x = positions[1]
	self.y = positions[2]
	self.size = {}
	self.size.x = positions[3]
	self.size.y = positions[4]
	self.delta = delta_buttons
end

function Panel:add_button(text, callback)
	table.insert(self.list, Button({40, 5, 120, 35}, text, callback))
end

function Panel:draw()
	for i=1, #self.list do
		self.list[i]:draw(self.x, self.y + self.delta*(i-1))
	end
end

function Panel:update(dt)
	-- for i=1, #self.list do
	-- 	self.list[i]:update(dt)
	-- end
end

function Panel:mousepressed(x, y)
    -- print(self.cursor.description, math.ceil((x-300)/tilesize[1]*2), math.ceil((y)/tilesize[2]*2))
    x = x - self.x
    y = y - self.y
    local i = y/self.delta
    if x <= self.size.x and x>0 and 
    		y <= self.size.y and y>0  and
    		(math.ceil(i)-i)*40 < 35  and math.ceil(i)<=#self.list then
		self.list[math.ceil(i)].callback()
    end
end

return Panel
