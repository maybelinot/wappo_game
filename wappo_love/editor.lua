local class = require 'libs/middleclass'
require 'animation'
Panel = require 'panel'
-- flux = require "libs/flux"


local Editor = class('Editor')

function Editor:initialize()
    self.panel = Panel:new({550, 0}, {0, 1})
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
end

function Editor:draw()
    self.panel:draw()
end


return Editor