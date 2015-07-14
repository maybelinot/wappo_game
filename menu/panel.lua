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
	self.scroll_pos = 0
	self.scroll_acc = 0
end

function Panel:add_button(text, callback)
	table.insert(self.list, Button(self.buttons.positions, text, callback, self.sprite))
end

function Panel:draw()
	for i=1, #self.list do
		self.list[i]:draw(self.x, self.y + (self.buttons.positions[4] + self.buttons.delta)*(i-1) + self.scroll_pos)
	end
end

function Panel:update(dt)
	-- for i=1, #self.list do
	-- 	self.list[i]:update(dt)
	-- end
	if self.scrolled then
		if self.scroll_pos+ self.scroll_acc*dt < - #self.list* (self.buttons.positions[4] + self.buttons.delta) + self.size.y then
			self.scroll_pos = - #self.list* (self.buttons.positions[4] + self.buttons.delta) + self.size.y
		elseif self.scroll_pos+ self.scroll_acc*dt > 0 then
			self.scroll_pos = 0
		else
			self.scroll_pos = self.scroll_pos + self.scroll_acc*dt
		end
		print()
		print(math.log(self.scroll_acc))
		if self.scroll_acc > 0  then
			self.scroll_acc = self.scroll_acc - math.log(math.abs(self.scroll_acc)+1)/3
		else
			self.scroll_acc = self.scroll_acc + math.log(math.abs(self.scroll_acc)+1)/3
		end
		print(self.scroll_acc)
	end
end

function Panel:mousepressed(x, y)
    -- print(self.cursor.description, math.ceil((x-300)/tilesize[1]*2), math.ceil((y)/tilesize[2]*2))
    x = x - self.x
    y = y - self.y
    if x <= self.size.x and x>0 and 
    		y <= self.size.y and y>0  then
    	y = y - self.scroll_pos
    	local i = y/(self.buttons.positions[4] + self.buttons.delta)
    	if (math.ceil(i)-i)*(self.buttons.positions[4] + self.buttons.delta) < self.buttons.positions[4]  and math.ceil(i)<=#self.list then
			self.list[math.ceil(i)].callback()
		end
    end
end

function Panel:scroll_up()
	if self.scroll_acc > 0 then
		self.scroll_acc = 0
		return
	end
	print(self.scroll_pos, - #self.list* (self.buttons.positions[4] + self.buttons.delta) + self.size.y, self.scroll_acc)
	if self.scrolled and self.scroll_pos > - #self.list* (self.buttons.positions[4] + self.buttons.delta) + self.size.y then
		self.scroll_acc = self.scroll_acc - 15
	else
		self.scroll_acc = 0
	end
end

function Panel:scroll_down()
	if self.scroll_acc < 0 then
		self.scroll_acc = 0
		return
	end
	if self.scrolled and self.scroll_pos <= 0 then
		self.scroll_acc = self.scroll_acc + 15
	else
		self.scroll_acc = 0
	end
end

return Panel
