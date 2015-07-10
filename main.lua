Level = require 'game/level'
Editor = require 'editor/editor'
level_map = require 'maps/original_levels'
love.filesystem.setIdentity( "wappo_game")
editor = Editor()
editor.map:load_maps()
function love.load()
    -- width, height = love.window.getDesktopDimensions( display )
    -- image = love.graphics.newImage('sprites/wicon.png')
    background = love.graphics.newImage('sprites/bggame.png')

    song1 = love.audio.newSource("audio/wappo2.ogg", "static")
    -- song1:setVolume(0.3)
    -- song1:play()
end

function love.update(dt)
    level:update(dt)
    editor:update(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    level:draw()

    love.graphics.draw(background, 300, 0)
    editor:draw()
end

function new_level(num)
  -- """
  -- Start new level
  -- """
  -- level = Level(32)
  level = Level(num)
end

function love.keypressed(key)
  -- """
  -- Callback on key press
  -- """
    if key=='w' then
        key = 'up'
        val = {-1, 0}
    elseif key=='s' then
        key = 'down'
        val = {1, 0}
    elseif key=='a' then
        key = 'left'
        val = {0, -1}
    elseif key=='d' then
        key = 'right'
        val = {0, 1}
    elseif key=='m' then
      editor.map:save()
      editor.map:load_maps()
      return
    elseif key=='r' then
      new_level(0)
      return
    elseif key=='c' then
      editor.map.list = {}
      return
    else
      return
    end
    -- Will be changed when menu will be added
    if level:is_moved() == true then
        level.moved = false
        level:move(val)
    end
end

-- function love.mousepressed(x, y, button)
--   -- """
--   -- Callback on mouse press
--   -- """
--    -- if button == "l" then
--    --      local delta_x = math.abs(x_pos-x)
--    --      local delta_y = math.abs(y_pos-y)
--    --      if delta_x > delta_y then
--    --          if x > x_pos then
--    --              x_pos = x_pos + deltax
--    --          else
--    --              x_pos = x_pos - deltax
--    --          end
--    --      else            
--    --          if y > y_pos then
--    --              y_pos = y_pos + deltay
--    --          else
--    --              y_pos = y_pos - deltay
--    --          end
--    --      end
--    --  end
-- end

function love.mousepressed(x, y, button)
  -- """
  -- Callback on mouse press
  -- """
    if button == "l" then
        editor:mousepressed(x, y)
    end
end
function love.mousereleased(x, y, button)
   if button == "l" then
      editor:mousereleased(x, y)
   end
end

new_level(50)