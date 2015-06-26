require 'units'

local level = level_load(32)

function love.load()

    

    -- width, height = love.window.getDesktopDimensions( display )
    image = love.graphics.newImage('sprites/wicon.png')
    bcg = love.graphics.newImage('sprites/bggame.png')
    -- -1 - borders
    -- 0 - empty
    -- 1 - player
    -- 2 - blue enemy
    -- 3 - red enemy
    -- 4 - violet enemy
    -- 5 - teleport
    -- 6 - exit
    -- 7 - flame
    -- 8 - grey obstacle horizontal
    -- 9 - grey obstacle vertical
    -- level 32
    -- map = { 
    --         {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
    --         {-1,  0,  0,  0,  0,  0,  0,  0,  0,  6,  0,  0, -1},
    --         {-1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1},
    --         {-1,  0,  0,  0,  0,  0,  0,  0,  9,  0,  0,  0, -1},
    --         {-1,  8,  0,  0,  0,  0,  0,  0,  0,  8,  0,  0, -1},
    --         {-1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1},
    --         {-1,  0,  0,  0,  0,  8,  0,  0,  0,  8,  0,  0, -1},
    --         {-1,  5,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0, -1},
    --         {-1,  8,  0,  0,  0,  0,  0,  0,  0,  0,  0,  8, -1},
    --         {-1,  0,  0,  7,  0,  0,  0,  0,  9,  0,  0,  3, -1},
    --         {-1,  0,  0,  0,  0,  0,  0,  8,  0,  0,  0,  8, -1},
    --         {-1,  0,  0,  0,  0,  5,  0,  0,  0,  0,  0,  0, -1},
    --         {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
    --       }
    -- player_imgset = love.graphics.newImage("Sprites/wstrip.png")
    -- red_enemy_imgset = love.graphics.newImage("Sprites/ystrip.png")
    -- blue_enemy_imgset = love.graphics.newImage("Sprites/xstrip.png")
    -- teleport_imgset = love.graphics.newImage("Sprites/tele.png")
    -- flame_imgset = love.graphics.newImage("Sprites/flame.png")
    -- hor_wall_img = love.graphics.newImage("Sprites/hwall.png")
    -- ver_wall_img = love.graphics.newImage("Sprites/vwall.png")
    -- exit_img = love.graphics.newImage("Sprites/exit.png")
 
    -- the Mesh DrawMode "fan" works well for 4-vertex Meshes.
    -- units_quad = love.graphics.newQuad(0, 0, player_imgset:getWidth()/4, player_imgset:getHeight()/4, player_imgset:getDimensions())
    -- obj_quad = love.graphics.newQuad(0, 0, teleport_imgset:getWidth()/4, teleport_imgset:getHeight(), teleport_imgset:getDimensions())
    -- love.graphics.setBackgroundColor(104, 136, 248)
    -- love.window.setMode(650, 650)

    song1 = love.audio.newSource("audio/wappo2.ogg", "static")
    -- song1:setVolume(0.3)
    -- song1:play()
    -- x_pos=0
    -- y_pos=0
    -- deltax = 40
    -- deltay = 52

end

function love.update(dt)
    flame.animation:update(dt)
end

function love.draw()
    flame.animation:draw(100, 100)

    -- love.graphics.draw(bcg, deltax, deltay)

    -- for i=1,#map-1 do
    --     for j=1,#map-1 do
    --         if map[j][i]==1 then
    --             love.graphics.draw(player_imgset, units_quad, i*deltax/2, j*deltay/2)
    --         elseif map[j][i]==2 then
    --             love.graphics.draw(blue_enemy_imgset, units_quad, i*deltax/2, j*deltay/2)
    --         elseif map[j][i]==3 then
    --             love.graphics.draw(red_enemy_imgset, units_quad, i*deltax/2, j*deltay/2)
    --         elseif map[j][i]==4 then
    --             -- love.graphics.draw(player_imgset, units_quad, i*deltax, j*(d-1)eltay)
    --         elseif map[j][i]==5 then
    --             love.graphics.draw(teleport_imgset, obj_quad, i*deltax/2, j*deltay/2)
    --         elseif map[j][i]==6 then
    --             love.graphics.draw(exit_img, i*deltax/2, j*deltay/2)
    --         elseif map[j][i]==7 then
    --             love.graphics.draw(flame_imgset, obj_quad, i*deltax/2, j*deltay/2)
    --         elseif map[j][i]==8 then
    --             love.graphics.draw(hor_wall_img, i*deltax/2, j*deltay+deltay/2)
    --         elseif map[j][i]==9 then
    --             love.graphics.draw(ver_wall_img, (i*deltax+deltax-6)/2, (j*deltay+hor_wall_img:getHeight())/2)
    --         end
    --     end
    -- end
    -- love.graphics.draw(player_imgset, units_quad, x_pos, y_pos)
end

function love.keypressed(key)
    if key=='w' then
        key = 'up'
    end
    if key=='s' then
        key = 'down'
    end
    if key=='a' then
        key = 'left'
    end
    if key=='d' then
        key = 'right'
    end
    level_move(level, key)
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


function level_load(number)
    local tiled_level = require("maps/level"..number)['layers'][1]
    local level = {}
    level.size = {}
    level.size.x = tiled_level['width']
    level.size.y = tiled_level['height']
    level.map = tiled_level['data']
    for i=1,level.size.x do
        for j=1,level.size.y do
            local cell = level.map[i*level.size.x + j]
            if cell == 1 then
                level.player = {i, j}
            end
        end
    end
    -- level.player = {1, 2}
    level.red = {{1, 2}, {2, 3}}
    level.violet = {{1, 2}, {2, 3}}
    level.blue = {{1, 2}, {2, 3}}
    print(level.player)
    return level
end

function level_move(level, way)

end






