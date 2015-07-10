local class = require 'libs/middleclass'
local EditorObj = require 'editor/objects'
local tilesize = {40, 52}

local Map = class('Map')

function Map:initialize()
    self.list = {}
    self.len = 11
    -- self.saving = 'local'
    self.saving = 'global'
    self.reading = 'global'
    self.current_map = 1
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
    local data_write = ''
    for i=1, #self.list do
        data_write = data_write..tostring(self.list[i].index)..' '..tostring(self.list[i].y-1)..' '..tostring(self.list[i].x)..' '
    end
    if self.saving == 'local' then
        love.filesystem.write( "level0.lua", data_write, #data_write)
    elseif self.saving == 'global' then
        data_write = data_write..'\n'
        love.filesystem.append( "levels_new.lua", data_write, #data_write)
    end    
end

function Map:old_to_new()
    for u=1, #self.maps do
        local data_write = ''
        local data = {}
        local tmp = self.maps[u]
        for token in tmp:gmatch("%w+") do
            table.insert(data, tonumber(token))
        end
        for i=1, self.len do
            for j=1, self.len do
                if data[j+(i-1)*self.len]~=0 then
                    data_write = data_write..tostring(data[j+(i-1)*self.len])..' '..tostring(i-1)..' '..tostring(j)..' '
                end
            end
        end
        data_write = data_write..'\n'
        love.filesystem.append( "levels_new.lua", data_write, #data_write)
    end   
end

function Map:load_maps()
    self.maps = {}
    local s = "\n"
    for token in love.filesystem.read( "levels_new.lua" ):gmatch("(.-)"..s.."()") do
        table.insert(self.maps, token)
    end
end

function Map:read()
    local tmp_map
    if self.reading == 'local' then
        tmp_map = love.filesystem.read( "level0.lua" )
    elseif self.reading == 'global' then
        tmp_map = self.maps[#self.maps]
        -- tmp_map = self.maps[self.current_map]
        -- self.current_map = self.current_map + 1
    end
    local data = {}
    for token in tmp_map:gmatch("%w+") do
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