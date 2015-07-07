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
    file = io.open("test.lua", "a")

    -- sets the default output file as test.lua
    io.output(file)

    -- appends a word test to the last line of the file
    io.write("-- End of the test.lua file")

    -- closes the open file
    io.close(file)
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