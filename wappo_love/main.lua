require 'units'


function level_load(number)
    local tiled_level = require("maps/level"..number)['layers'][1]
    local level = {}
    level.size = {}
    level.size.x = tiled_level['width']
    level.size.y = tiled_level['height']
    level.map = tiled_level['data']
    level.floor_obj = {}
    level.floor_map = {}
    level.units_obj = {}
    level.units_map = {}
    level.player = nil
    for i=0,level.size.x-1 do
        for j=1,level.size.y do
            local cell = level.map[i*level.size.x + j]
            if cell == 1 or cell == 2 or cell == 3 or cell == 4 or cell == 5 then
                level.units_map[i*level.size.x + j] = get_object[cell]()
                level.floor_map[i*level.size.x + j] = nil
                local object = get_object[cell]()
                object.x = i
                object.y = j
                if cell == 1 then
                    level.player = object
                else
                    table.insert(level.units_obj, object)
                end
            elseif cell == 6 or cell == 7 or cell == 13 or cell == 14 or cell == 15 or cell == 16 then
                level.units_map[i*level.size.x + j] = nil
                level.floor_map[i*level.size.x + j] = get_object[cell]()
                local object = get_object[cell]()
                object.x = i
                object.y = j
                table.insert(level.floor_obj, object)
            else
                level.units_map[i*level.size.x + j] = nil
                level.floor_map[i*level.size.x + j] = nil
            end
        end
    end
    -- level.player = {1, 2}
    -- level.red = {{1, 2}, {2, 3}}
    -- level.violet = {{1, 2}, {2, 3}}
    -- level.blue = {{1, 2}, {2, 3}}
    -- print(level.player)
    return level
end

local sum = 0
local num = 0

function level_draw(level)
    for i=1,#level.floor_obj do
        level.floor_obj[i].sprite:draw(level.floor_obj[i].y*20-20, level.floor_obj[i].x*26+5)
    end
    for i=1,#level.units_obj do
        level.units_obj[i].sprite:draw(level.units_obj[i].y*20-20, level.units_obj[i].x*26+5)
    end
    level.player.sprite:draw(level.player.y*20-20, level.player.x*26+5)
end

function level_update(level, dt)
    for i=1,#level.floor_obj do
        level.floor_obj[i].sprite:update(dt)
    end
    for i=1,#level.units_obj do
        level.units_obj[i].sprite:update(dt)
    end
    level.player.sprite:update(dt)
end

function level_move(level, way)

end

local level = level_load(32)

function love.load()
    -- width, height = love.window.getDesktopDimensions( display )
    -- image = love.graphics.newImage('sprites/wicon.png')
    background = love.graphics.newImage('sprites/bggame.png')

    song1 = love.audio.newSource("audio/wappo2.ogg", "static")
    -- song1:setVolume(0.3)
    -- song1:play()

    -- deltax = 40
    -- deltay = 52
end

function love.update(dt)
    level_update(level, dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    level_draw(level)
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







