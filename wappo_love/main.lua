function love.load()
    -- width, height = love.window.getDesktopDimensions( display )
    image = love.graphics.newImage('Sprites/wicon.png')


    love.graphics.setBackgroundColor(104, 136, 248)
    love.window.setMode(650, 650)

    song1 = love.audio.newSource("Audio/wappo2.mid", "static")
    -- song1:setVolume(0.3)
    song1:play()
    x_pos=100
    y_pos=100
    delta = 100
end

function love.update(dt)
end

function love.keypressed(key)
    if key=='up' or key=='w' then
        y_pos = y_pos - delta
    end
    if key=='down' or key=='s' then
        y_pos = y_pos + delta
    end
    if key=='left' or key=='a' then
        x_pos = x_pos - delta
    end
    if key=='right' or key=='d' then
        x_pos = x_pos + delta
    end
end

function love.mousepressed(x, y, button)
   if button == "l" then
        local delta_x = math.abs(x_pos-x)
        local delta_y = math.abs(y_pos-y)
        if delta_x > delta_y then
            if x > x_pos then
                x_pos = x_pos + delta
            else
                x_pos = x_pos - delta
            end
        else            
            if y > y_pos then
                y_pos = y_pos + delta
            else
                y_pos = y_pos - delta
            end
        end
    end
end

function love.draw()
    love.graphics.draw(image, x_pos, y_pos)
end