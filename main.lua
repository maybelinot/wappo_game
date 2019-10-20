love.filesystem.setIdentity( "wappo_game")
love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")
local class    = require 'libs/middleclass'
local Stateful = require 'libs/stateful'

Game = class('Game')
Game:include(Stateful)

function Game:initialize()

end

require 'game/level'
require 'editor/editor'
require 'menu/menu'

function love.load()
    -- width, height = love.window.getDesktopDimensions( display )
    -- image = love.graphics.newImage('sprites/wicon.png')
    -- song1 = love.audio.newSource("audio/wappo2.ogg", "static")
    -- song1:setVolume(0.3)
    -- song1:play()
    background = love.graphics.newImage('sprites/bggame.png')

    game = Game:new()
    game:gotoState('Menu')
    game:load_main_menu()
    -- game:load_level(1)
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.mousepressed(x, y, button)
    -- """
    -- Callback on mouse press
    -- """
    game:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    if button == "l" then
        game:mousereleased(x, y)
    end
end

function love.wheelmoved( dx, dy )
    game:wheelmoved(dx, dy)
end
