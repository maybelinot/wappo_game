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
    data_write = data_write..'\n'
    love.filesystem.append( "levels_new.lua", data_write, #data_write)
    local date = os.date()..'\n'
    love.filesystem.append( "levels_names.lua", date, #date)
end

function Map:is_ok()
    local cond = false
    for i=1, #self.list do
        if self.list[i].index == 1 then
            cond = true
        end
    end
    return cond
end


-- function Map:load_maps()
--     self.maps = {}
--     local s = "\n"
--     for token in love.filesystem.read( "levels_new.lua" ):gmatch("(.-)"..s.."()") do
--         table.insert(self.maps, token)
--     end
-- end

-- function Map:read()
--     local tmp_map
--     if self.reading == 'local' then
--         tmp_map = love.filesystem.read( "level0.lua" )
--     elseif self.reading == 'global' then
--         tmp_map = self.maps[#self.maps]
--         -- tmp_map = self.maps[self.current_map]
--         -- self.current_map = self.current_map + 1
--     end
--     local data = {}
--     for token in tmp_map:gmatch("%w+") do
--        table.insert(data, tonumber(token))
--     end
--     return data
-- end

function Map:update(dt)
    for i=1, #self.list do
        self.list[i]:update(dt)
    end
end

function Map:draw()
    for i=1, #self.list do
        self.list[i]:draw((self.list[i].x-1)*tilesize[1]/2, (self.list[i].y-1)*tilesize[2]/2+5)
    end
end


return Map