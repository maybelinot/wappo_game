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




-- function love.mousepressed(x, y, button)
--   -- """
--   -- Callback on mouse press
--   -- """
--      -- if button == "l" then
--      --          local delta_x = math.abs(x_pos-x)
--      --          local delta_y = math.abs(y_pos-y)
--      --          if delta_x > delta_y then
--      --                if x > x_pos then
--      --                      x_pos = x_pos + deltax
--      --                else
--      --                      x_pos = x_pos - deltax
--      --                end
--      --          else                  
--      --                if y > y_pos then
--      --                      y_pos = y_pos + deltay
--      --                else
--      --                      y_pos = y_pos - deltay
--      --                end
--      --          end
--      --    end
-- end


