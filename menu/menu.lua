local class = require 'libs/middleclass'

local Panel = require 'menu/panel'
-- require 'units'
-- require 'animation'
-- Unit = require 'unit'
-- Enemies = require 'game/enemies'
-- Player = require 'game/player'
-- Floor = require 'game/floor'
-- Movable = require 'game/movable'
-- flux = require "libs/flux"

local Menu = Game:addState('Menu')
-- Menu.static.sprite = love.graphics.newImage('sprites/bgmenu.png')
function Menu:load_menu()
    self.sprite = love.graphics.newImage('sprites/bgmenu.png')
    self.ad = love.graphics.newImage('sprites/advert.png')
    self.panel = Panel({20, 110, 200, 200}, 40)
    self.panel:add_button('Campaign', function () self:gotoState('Level') self:load_level(1, 'Campaign') end)
    self.panel:add_button('Own level', function () self:gotoState('Editor') self:load_editor() end)
    self.panel:add_button('Exit', function () love.event.quit() end)
end

function Menu:draw()
    love.graphics.draw(self.sprite, 0, 0)
    love.graphics.draw(self.ad, 0, 320)
    self.panel:draw()
end

function Menu:update(dt)
    self.panel:update(dt)
end

function Menu:keypressed(key)
    -- """
    -- Callback on key press
    -- """
end

function Menu:mousepressed(x, y)
    self.panel:mousepressed(x, y)
end

function Menu:mousereleased(x, y)

end
-- return Menu
