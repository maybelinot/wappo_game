local class = require 'libs/middleclass'
local tilesize = {40, 52}

local Select = class('Select')

function Select:initialize()
    self.list = {}
end

function Select:add_object(unit_type, x, y)
    local obj = EditorObj:new(unit_type)
    obj.x = x
    obj.y = y
    if obj.description ~= 'empty' then
        table.insert(self.list, obj)
    end
end


function Select:update(dt)
    for i=1, #self.list do
        self.list[i]:update(dt)
    end
end

function Select:draw()
    for i=1, #self.list do
        self.list[i]:draw((self.list[i].x-1)*tilesize[1]/2, (self.list[i].y-1)*tilesize[2]/2+5)
    end
end


return Select