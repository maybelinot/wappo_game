local class = require 'libs/middleclass'
local EditorObj = require 'editor_objects'
local tilesize = {40, 52}

local Panel = class('Panel')

function Panel:initialize(location, position, len)
    self.list = {}
    self.len = len
    self.location = location
    self.position = position
end

function Panel:add_object(unit_type, count)
    table.insert(self.list, EditorObj:new(unit_type,count))
end

function Panel:get_object(x, y)
    local a = math.ceil((x-self.location[1])*self.position[1]/tilesize[1])
    local b = math.ceil((y-self.location[2])*self.position[2]/tilesize[2])
    local c = math.floor((y-self.location[2])*self.position[1]/tilesize[2])*self.len
    local d = math.floor((x-self.location[1])*self.position[2]/tilesize[1])*self.len
    if a <= self.len and (a > 0 or b > 0) and b <= self.len and (c + a) <= #self.list and c >= 0 and (d + b) <= #self.list and d >= 0 then
        return self.list[(a+b+c+d)].description
    else
        return 'empty'
    end
end

function Panel:update(dt)
    for i=1, #self.list do
        self.list[i]:update(dt)
    end
end

function Panel:draw()
    for i=1, #self.list do
        self.list[i]:draw(self.location[1] + self.position[1]*tilesize[1]*(i%(self.len+1) - 1) + tilesize[1]*math.floor(i/(self.len+1)),
                            self.location[2] + self.position[2]*tilesize[2]*(i%(self.len+1) - 1)+ tilesize[2]*math.floor(i/(self.len+1)))
    end
end


return Panel