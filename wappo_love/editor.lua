local class = require 'libs/middleclass'
local tilesize = {40, 52}
require 'animation'
Panel = require 'panel'
Cursor = require 'cursor'


local Editor = class('Editor')

function Editor:initialize()
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
    self.cursor:update(dt)
end

function Editor:draw()
    self.panel:draw()
    local x, y =  love.mouse.getPosition()
    self.cursor:draw(x-tilesize[1]/2, y-tilesize[2]/2)
end

function Editor:mousepressed(x, y)
    local obj_type = self.panel:get_object(x, y)
    self.cursor = Cursor:new(obj_type)

end

function Editor:mousereleased(x,y)

end


return Editor