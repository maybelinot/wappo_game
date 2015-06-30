Level = require 'level'
-- local level = Level(32)
level = Level(57)

function love.load()
    -- width, height = love.window.getDesktopDimensions( display )
    -- image = love.graphics.newImage('sprites/wicon.png')
    background = love.graphics.newImage('sprites/bggame.png')

    song1 = love.audio.newSource("audio/wappo2.ogg", "static")
    -- song1:setVolume(0.3)
    -- song1:play()
end

function love.update(dt)
    flux.update(dt)
    level:update(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    level:draw()
end

function love.keypressed(key)
    if key=='w' then
        key = 'up'
        val = {-1, 0}
    end
    if key=='s' then
        key = 'down'
        val = {1, 0}
    end
    if key=='a' then
        key = 'left'
        val = {0, -1}
    end
    if key=='d' then
        key = 'right'
        val = {0, 1}
    end
    if level:is_moved() == true then
        level.moved = false
        level:move(val)
    end
end

function love.mousepressed(x, y, button)
   -- if button == "l" then
   --      local delta_x = math.abs(x_pos-x)
   --      local delta_y = math.abs(y_pos-y)
   --      if delta_x > delta_y then
   --          if x > x_pos then
   --              x_pos = x_pos + deltax
   --          else
   --              x_pos = x_pos - deltax
   --          end
   --      else            
   --          if y > y_pos then
   --              y_pos = y_pos + deltay
   --          else
   --              y_pos = y_pos - deltay
   --          end
   --      end
   --  end
end