local class = require 'libs/middleclass'
local EditorObj = require 'editor/objects'
local Select = require 'editor/select'
local tilesize = {40, 52}

local Panel = class('Panel')

function Panel:initialize(location, position, len)
    self.list = {}
    self.len = len
    self.location = location
    self.position = position
    self.selected = {}
    self.selected.sprite = love.graphics.newImage('sprites/select.png')
    self.selected.number = 1
end

function Panel:add_object(unit_type, count)
    local obj = EditorObj:new(unit_type,count)
    obj.count = count
    table.insert(self.list, obj)
end

function Panel:get_object(x, y)
    local a = math.ceil((x-self.location[1])*self.position[1]/tilesize[1])
    local b = math.ceil((y-self.location[2])*self.position[2]/tilesize[2])
    local c = math.floor((y-self.location[2])*self.position[1]/tilesize[2])*self.len
    local d = math.floor((x-self.location[1])*self.position[2]/tilesize[1])*self.len
    if a <= self.len and (a > 0 or b > 0) and b <= self.len and (c + a) <= #self.list and c >= 0 and (d + b) <= #self.list and d >= 0 then
        self.selected.number = a+b+c+d
        return self.list[(a+b+c+d)].description
    else
        -- if empty obj will be the last one
        self.selected.number = #self.list
        return 'empty'
    end
end

function Panel:update(dt)
    for i=1, #self.list do
        self.list[i]:update(dt)
    end
end

function Panel:draw()
    if self.selected.number>0 then
        love.graphics.draw(self.selected.sprite, self.location[1] + self.position[1]*tilesize[1]*(self.selected.number%(self.len+1) - 1) + tilesize[1]*math.floor(self.selected.number/(self.len+1)),
                                self.location[2] + self.position[2]*tilesize[2]*(self.selected.number%(self.len+1) - 1)+ tilesize[2]*math.floor(self.selected.number/(self.len+1)))
    end
    for i=1, #self.list do
        self.list[i]:draw(self.location[1] + self.position[1]*tilesize[1]*(i%(self.len+1) - 1) + tilesize[1]*math.floor(i/(self.len+1)),
                            self.location[2] + self.position[2]*tilesize[2]*(i%(self.len+1) - 1)+ tilesize[2]*math.floor(i/(self.len+1)))
    end
end


return Panel