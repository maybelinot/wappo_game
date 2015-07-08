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
    -- Opens a file in append mode
    
    -- print(io.open("../map/level0.lua", "a"))
    love.filesystem.write( "level0.lua", "", 2)

    -- sets the default output file as test.lua

    -- appends a word test to the last line of the file
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

function Map:read()
    local data = {}
    for token in love.filesystem.read( "level0.lua" ):gmatch("%w+") do
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