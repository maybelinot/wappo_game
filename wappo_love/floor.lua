local class = require 'libs/middleclass'
local tilesize = {40, 52}

local FloorObj = class('FloorObj')


function FloorObj:initialize(index, x, y)
    -- """
    -- Class represent floor objects like walls, exit or teleports
    -- """
    self.index = index
    self.x = x
    self.y = y
    if index == 6 then
        self.sprite = load_animation('exitIdle.png', '1-3', 1, 0.1)
    elseif index == 7 then
        self.sprite = load_animation('tele.png', '1-4', 1, 0.1)
    elseif index == 11 then
        self.sprite = load_animation('cDHWall.png', 1, 1, 0.1)
    elseif index == 12 then
        self.sprite = load_animation('cDVWall.png', 1, 1, 0.1)
    elseif index == 13 then
        self.sprite = load_animation('vwall.png', 1, 1, 0.1)
    elseif index == 14 then
        self.sprite = load_animation('cVWall.png', 1, 1, 0.1)
    elseif index == 15 then
        self.sprite = load_animation('hwall.png', 1, 1, 0.1)
    elseif index == 16 then
        self.sprite = load_animation('cHWall.png', 1, 1, 0.1)
    else
        self = nil
    end
end

function FloorObj:update(dt)
    self.sprite:update(dt)
end

function FloorObj:draw()
    self.sprite:draw(self.y*tilesize[1]/2-20, self.x*tilesize[2]/2+5)
end

function FloorObj:is_permeable(x, y, unit)
    if unit=='player' or unit=='red enemy' or unit == 'blue enemy' or unit == 'flame' then
        if self.x==x and self.y==y and self.index >= 13 and self.index <= 16 then
            return false
        end
    elseif unit == 'violet enemy' then
        if self.x==x and self.y==y and (self.index == 13 or self.index == 15) then
            return false
        end
    end
    return true
end

function FloorObj:crash()
    if self.index == 14 then
        self.index = 12
        self.sprite = load_animation('cDVWall.png', 1, 1, 0.1)
    elseif self.index == 16 then
        self.index = 11
        self.sprite = load_animation('cDHWall.png', 1, 1, 0.1)
    end
end 


local Floor = class('Floor')

function Floor:initialize()
    self.list = {}
end

function Floor:update(dt)
    -- """
    -- Update FloorObj animations
    -- """
    for i=1,#self.list do
        self.list[i]:update(dt)
    end
end

function Floor:draw()
    -- """
    -- Draw FloorObj sprites
    -- """
    for i=1,#self.list do
        self.list[i]:draw()
    end
end

function Floor:add_object(index, x, y)
    -- """
    -- Add enemy to Floor object
    -- """
    table.insert(self.list, FloorObj:new(index, x, y))
end

function Floor:is_permeable(x, y, unit)
    -- """
    -- Check if unit can walk through this cell
    -- """
    for i=1,#self.list do
        return self.list[i]:is_permeable(x, y, unit)
    end
    return true
end

function Floor:get_index(x, y)
    for i=1,#self.list do
        if self.list[i].x == x and self.list[i].y == y then
            return self.list[i].index
        end
    end
    return nil
end

function Floor:teleportation(unit)
    for i=1,#self.list do
        if self.list[i].index == 7 and (self.list[i].x ~= unit.x or self.list[i].y ~= unit.y) then
            unit.x = self.list[i].x
            unit.y = self.list[i].y
            return
        end
    end
end

function Floor:crash(x,y)
    for i=1,#self.list do
        if self.list[i].x == x and self.list[i].y == y then
            self.list[i]:crash()
            return
        end
    end
end

return Floor
