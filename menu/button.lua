local class = require 'libs/middleclass'


local Button = class('Button')

function Button:initialize(positions, text, callback, sprite)
	self.sprite = sprite
	self.text = text
	self.x = positions[1]
	self.y = positions[2]
	self.size = {}
	self.size.x = positions[3]
	self.size.y = positions[4]
	self.callback = callback
end

function Button:draw(x,y)
	love.graphics.draw(self.sprite, x + self.x , y + self.y)
	love.graphics.print(self.text, x + self.x, y + self.y)
end

function Button:update(dt)
end

function Button:callback()
	self.callback()
end


return Button
