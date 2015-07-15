local class = require 'libs/middleclass'
local Button = require 'menu/button'

local Panel = class('Panel')

function Panel:initialize(positions, delta_buttons, button_positions, sprite, scrolled)
	self.list = {}
	self.sprite = sprite
	self.x = positions[1]
	self.y = positions[2]
	self.size = {}
	self.size.x = positions[3]
	self.size.y = positions[4]
	self.buttons = {}
	self.buttons.delta = delta_buttons
	self.buttons.positions = button_positions
	self.scrolled = scrolled
	self.scroll = 0
end

function Panel:add_button(text, callback)
	table.insert(self.list, Button(self.buttons.positions, text, callback, self.sprite))
end

function Panel:draw()
	for i=1, #self.list do
		self.list[i]:draw(self.x, self.y + (self.buttons.positions[4] + self.buttons.delta)*(i-1) + self.scroll)
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
    if x <= self.size.x and x>0 and 
    		y <= self.size.y and y>0  then
    	y = y - self.scroll
    	local i = y/(self.buttons.positions[4] + self.buttons.delta)
    	if (math.ceil(i)-i)*(self.buttons.positions[4] + self.buttons.delta) < self.buttons.positions[4]  and math.ceil(i)<=#self.list then
			self.list[math.ceil(i)].callback()
		end
    end
end

function Panel:scroll_up()
	if self.scrolled and self.scroll > - #self.list* (self.buttons.positions[4] + self.buttons.delta) + self.size.y then
		self.scroll = self.scroll - 10
	end
end

function Panel:scroll_down()
	if self.scrolled and self.scroll < 0 then
		self.scroll = self.scroll + 10
	end
end

return Panel
