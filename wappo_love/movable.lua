local class = require 'libs/middleclass'
local tilesize = {40, 52}
local MovableObj = class('MovableObj')

function MovableObj:initialize(index, x, y)
	-- """
	-- Class represent movable objects like flames
	-- """
	self.index = index
	-- will change when creation of movable objects will be through Unit class
	self.description = 'flame' 
	self.x = x
	self.y = y
    self.anim_x = 0
    self.anim_y = 0

	if index == 5 then
	    self.sprite = load_animation('flame.png', '1-4', 1, 0.1)
	else
		self = nil
	end
end

function MovableObj:update(dt)
    self.sprite:update(dt)
end

function MovableObj:draw()
    self.sprite:draw(self.y*tilesize[1]/2-20 + self.anim_y, self.x*tilesize[2]/2+5 + self.anim_x)
end

function MovableObj:move(way)
    self.x = self.x + way[1]*2
    self.y = self.y + way[2]*2
    self.anim_x = self.anim_x + way[1]*(-tilesize[2])
    self.anim_y = self.anim_y + way[2]*(-tilesize[1])
end

function MovableObj:is_here(x, y)
    if self.x==x and self.y==y  then
        return true
    end
    return false
end

local Movable = class('Movable')

function Movable:initialize()
	self.list = {}
end

function Movable:update(dt)
	-- """
	-- Update Movable animations
	-- """
    for i=1,#self.list do
        self.list[i]:update(dt)
    end
end

function Movable:draw()
	-- """
	-- Draw Movable sprites
	-- """
    for i=1,#self.list do
        self.list[i]:draw()
    end
end

function Movable:add_object(index, x, y)
	-- """
	-- Add enemy to Movable object
	-- """
	table.insert(self.list, MovableObj:new(index, x, y))
end

function Movable:is_here(x, y)
    -- """
    -- Check if movable objcect in this cell
    -- """
    for i=1,#self.list do
        return self.list[i]:is_here(x, y)
    end
    return false
end

function Movable:move(x, y, way)
    for i=1,#self.list do
    	if self.list[i].x==x and self.list[i].y==y then
	        self.list[i]:move(way)
	        flux.to(self.list[i], level.tweeking_time, { anim_x = 0, anim_y = 0 }):ease(level.tweeking_ease)
	        return
	    end
    end
end	

return Movable
