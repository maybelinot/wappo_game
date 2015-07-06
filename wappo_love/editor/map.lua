local class = require 'libs/middleclass'
local EditorObj = require 'editor/objects'
local tilesize = {40, 52}

local Map = class('Map')

function Map:initialize()
    self.list = {}
end

function Map:add_object(unit_type, x, y)
    local obj = EditorObj:new(unit_type)
    obj.x = x
    obj.y = y
    if obj.description ~= 'empty' then
        table.insert(self.list, obj)
    end
end



function Map:update(dt)
    for i=1, #self.list do
        self.list[i]:update(dt)
    end
end

function Map:draw()
    for i=1, #self.list do
        self.list[i]:draw(300 + (self.list[i].x-1)*tilesize[1]/2, (self.list[i].y-1)*tilesize[2]/2+5)
    end
end


return Map