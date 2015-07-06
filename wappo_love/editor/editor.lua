local class = require 'libs/middleclass'
local tilesize = {40, 52}
require 'animation'
Panel = require 'editor/panel'
Cursor = require 'editor/cursor'
Map = require 'editor/map'

local Editor = class('Editor')

function Editor:initialize()
    self.map = Map:new()
    self.location = {550, 0}
    self.len = 6
    self.position = {0, 1}
    self.cursor = Cursor:new('empty')
    self.panel = Panel:new(self.location, self.position, self.len)
    self.panel:add_object('vwall', 1)
    self.panel:add_object('hwall', 1)
    self.panel:add_object('player', 1)
    self.panel:add_object('flame', 1)
    self.panel:add_object('red enemy', 1)
    self.panel:add_object('blue enemy', 1)
    self.panel:add_object('cvwall', 1)
    self.panel:add_object('chwall', 1)
    self.panel:add_object('exit', 1)
    self.panel:add_object('teleport', 1)
    self.panel:add_object('violet enemy', 1)
end


function Editor:update(dt)
    self.panel:update(dt)
    self.map:update(dt)
    self.cursor:update(dt)
end

function Editor:draw()
    self.panel:draw()
    self.map:draw()
    local x, y =  love.mouse.getPosition()
    self.cursor:draw(x-tilesize[1]/2, y-tilesize[2]/2)
end

function Editor:mousepressed(x, y)
    -- print(self.cursor.description, math.ceil((x-300)/tilesize[1]*2), math.ceil((y)/tilesize[2]*2))
    local x_map =  math.ceil((x-300-tilesize[1])/tilesize[1])*2
    local y_map = math.ceil((y-tilesize[2]+5)/tilesize[2])*2
    print(x_map, y_map)
    if self.cursor.index < 13 then
        x_map = x_map + 1
        y_map = y_map + 1
    elseif self.cursor.index <=14 then
        x_map =  math.ceil((x-300-tilesize[1]/2)/tilesize[1])*2
        y_map = y_map + 1
    else
        y_map = math.ceil((y-tilesize[2]/2+5)/tilesize[2])*2
        x_map = x_map + 1
    end
    self.map:add_object(self.cursor.description, x_map, y_map)
    local obj_type = self.panel:get_object(x, y)
    self.cursor = Cursor:new(obj_type)

end

function Editor:mousereleased(x,y)

end


return Editor