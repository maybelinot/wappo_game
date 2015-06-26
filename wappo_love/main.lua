function love.load()
    -- width, height = love.window.getDesktopDimensions( display )
    image = love.graphics.newImage('Sprites/wicon.png')
    bcg = love.graphics.newImage('Sprites/bggame.png')
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
    map = { 
            {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
            {-1,  0,  0,  0,  0,  0,  0,  0,  0,  6,  0,  0, -1},
            {-1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1},
            {-1,  0,  0,  0,  0,  0,  0,  0,  9,  0,  0,  0, -1},
            {-1,  8,  0,  0,  0,  0,  0,  0,  0,  8,  0,  0, -1},
            {-1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1},
            {-1,  0,  0,  0,  0,  8,  0,  0,  0,  8,  0,  0, -1},
            {-1,  5,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0, -1},
            {-1,  8,  0,  0,  0,  0,  0,  0,  0,  0,  0,  8, -1},
            {-1,  0,  0,  7,  0,  0,  0,  0,  9,  0,  0,  3, -1},
            {-1,  0,  0,  0,  0,  0,  0,  8,  0,  0,  0,  8, -1},
            {-1,  0,  0,  0,  0,  5,  0,  0,  0,  0,  0,  0, -1},
            {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
          }
    player_imgset = love.graphics.newImage("Sprites/wstrip.png")
    red_enemy_imgset = love.graphics.newImage("Sprites/ystrip.png")
    blue_enemy_imgset = love.graphics.newImage("Sprites/xstrip.png")
    teleport_imgset = love.graphics.newImage("Sprites/tele.png")
    flame_imgset = love.graphics.newImage("Sprites/flame.png")
    hor_wall_img = love.graphics.newImage("Sprites/hwall.png")
    ver_wall_img = love.graphics.newImage("Sprites/vwall.png")
    exit_img = love.graphics.newImage("Sprites/exit.png")
 
    -- the Mesh DrawMode "fan" works well for 4-vertex Meshes.
    units_quad = love.graphics.newQuad(0, 0, player_imgset:getWidth()/4, player_imgset:getHeight()/4, player_imgset:getDimensions())
    obj_quad = love.graphics.newQuad(0, 0, teleport_imgset:getWidth()/4, teleport_imgset:getHeight(), teleport_imgset:getDimensions())
    love.graphics.setBackgroundColor(104, 136, 248)
    love.window.setMode(650, 650)

    song1 = love.audio.newSource("Audio/wappo2.mid", "static")
    -- song1:setVolume(0.3)
    song1:play()
    x_pos=0
    y_pos=0
    deltax = 40
    deltay = 52
end

function love.update(dt)
end

function love.keypressed(key)
    if key=='up' or key=='w' then
        y_pos = y_pos - deltay
    end
    if key=='down' or key=='s' then
        y_pos = y_pos + deltay
    end
    if key=='left' or key=='a' then
        x_pos = x_pos - deltax
    end
    if key=='right' or key=='d' then
        x_pos = x_pos + deltax
    end
end

function love.mousepressed(x, y, button)
   if button == "l" then
        local delta_x = math.abs(x_pos-x)
        local delta_y = math.abs(y_pos-y)
        if delta_x > delta_y then
            if x > x_pos then
                x_pos = x_pos + deltax
            else
                x_pos = x_pos - deltax
            end
        else            
            if y > y_pos then
                y_pos = y_pos + deltay
            else
                y_pos = y_pos - deltay
            end
        end
    end
end

function love.draw()
    love.graphics.draw(bcg, deltax, deltay)

    for i=1,#map-1 do
        for j=1,#map-1 do
            if map[j][i]==1 then
                love.graphics.draw(player_imgset, units_quad, i*deltax/2, j*deltay/2)
            elseif map[j][i]==2 then
                love.graphics.draw(blue_enemy_imgset, units_quad, i*deltax/2, j*deltay/2)
            elseif map[j][i]==3 then
                love.graphics.draw(red_enemy_imgset, units_quad, i*deltax/2, j*deltay/2)
            elseif map[j][i]==4 then
                -- love.graphics.draw(player_imgset, units_quad, i*deltax, j*(d-1)eltay)
            elseif map[j][i]==5 then
                love.graphics.draw(teleport_imgset, obj_quad, i*deltax/2, j*deltay/2)
            elseif map[j][i]==6 then
                love.graphics.draw(exit_img, i*deltax/2, j*deltay/2)
            elseif map[j][i]==7 then
                love.graphics.draw(flame_imgset, obj_quad, i*deltax/2, j*deltay/2)
            elseif map[j][i]==8 then
                love.graphics.draw(hor_wall_img, i*deltax/2, (j*deltay+deltay/2)
            elseif map[j][i]==9 then
                love.graphics.draw(ver_wall_img, (i*deltax+deltax-6)/2, (j*deltay+hor_wall_img:getHeight())/2)
            end
        end
    end
    love.graphics.draw(player_imgset, units_quad, x_pos, y_pos)
end