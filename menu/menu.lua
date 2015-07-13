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
function Menu:load_main_menu()
    self.bcg = love.graphics.newImage('sprites/bgmenu.png')
    self.frame = nil
    self.ad = love.graphics.newImage('sprites/advert.png')
    local button_sprite = love.graphics.newImage('sprites/button.png')
    self.panel_positions = {20, 110, 200, 200}
    self.panel = Panel(self.panel_positions, 5, {40, 5, 120, 35}, button_sprite, false)
    self.panel:add_button('Campaign', function () self:load_campaign_menu() end)
    self.panel:add_button('Own level', function () self:gotoState('Editor') self:load_editor() end)
    self.panel:add_button('Exit', function () love.event.quit() end)
end

function Menu:load_campaign_menu()
    self.bcg = nil
    self.frame = love.graphics.newImage('sprites/bgmenuCampaign.png')
    self.ad = love.graphics.newImage('sprites/advert.png')
    local button_sprite = love.graphics.newImage('sprites/buttonCampaign.png')
    self.panel_positions = {20, 60, 200, 250}
    self.panel = Panel(self.panel_positions,  1, {5, 5, 190, 20}, button_sprite, true)
    for i=1, #require 'maps/original_levels' do
        self.panel:add_button('Level'..tostring(i), function () self:gotoState('Level') self:load_level(i, 'Campaign') end)
    end
end

function Menu:draw()
    if self.bcg then
        love.graphics.draw(self.bcg, 0, 0)
    end
    self.panel:draw()
    if self.frame then
        love.graphics.draw(self.frame, 0, 0)
    end
    love.graphics.draw(self.ad, 0, 320)
end

function Menu:update(dt)
    self.panel:update(dt)
end

function Menu:keypressed(key)
    if key == 'escape' then
        self:load_main_menu()
        return
    end
end

function Menu:mousepressed(x, y, button)
    if button =='l' then
        self.panel:mousepressed(x, y)
    elseif x >self.panel_positions[1] and x < self.panel_positions[3] and
            y >self.panel_positions[2] and y < self.panel_positions[4] then
        if button == "wu" then
            self.panel:scroll_down()
        elseif button == "wd" then
            self.panel:scroll_up()
        end
    end
end

function Menu:mousereleased(x, y)

end
-- return Menu
