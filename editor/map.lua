local class = require 'libs/middleclass'
local EditorObj = require 'editor/objects'
local tilesize = {40, 52}

local Map = class('Map')

function Map:initialize()
    self.list = {}
    self.len = 11
end

function Map:add_object(unit_type, x, y)
    for i=1,#self.list do
        if self.list[i].x == x and self.list[i].y == y then
            table.remove(self.list, i)
            break
        end
    end
    local obj = EditorObj:new(unit_type)
    obj.x = x
    obj.y = y
    if obj.description ~= 'empty' then
        table.insert(self.list, obj)
    end
end

function Map:save()
    local data = {}
    for i=1, #self.list do 
        data[self.list[i].x+(self.list[i].y-1)*self.len] = self.list[i].index
    end
    local data_write = ''
    for i=1, self.len do
        for j=1, self.len do
            if data[j+(i-1)*self.len]~=nil then
                data_write = data_write..tostring(data[j+(i-1)*self.len])..' '
            else
                data_write = data_write..'0 '
            end
        end
    end
    love.filesystem.write( "level0.lua", data_write, #data_write)
end

function Map:add_level()
    local data = {}
    for i=1, #self.list do 
        data[self.list[i].x+(self.list[i].y-1)*self.len] = self.list[i].index
    end
    for i=1, self.len do
        for j=1, self.len do
            if data[j+(i-1)*self.len]~=nil then
                love.filesystem.append( "level0.lua",tostring(data[j+(i-1)*self.len])..' ', 3)
            else
                love.filesystem.append( "level0.lua",'0 ', 2)
            end
        end
    end
end

function Map:read(map)
    local data = {}
    for token in map:gmatch("%w+") do
       table.insert(data, tonumber(token))
    end
    return data
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