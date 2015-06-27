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
                local object = get_object[cell]()
                level.units_map[i*level.size.x + j] = object
                level.floor_map[i*level.size.x + j] = nil
                object.x = i
                object.y = j
                if cell == 1 then
                    level.player = object
                else
                    table.insert(level.units_obj, object)
                end
            elseif cell == 6 or cell == 7 or cell == 13 or cell == 14 or cell == 15 or cell == 16 then
                local object = get_object[cell]()
                level.units_map[i*level.size.x + j] = nil
                level.floor_map[i*level.size.x + j] = object
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
    local cell = level.floor_map[(level.player.x+way[1])*level.size.x + (level.player.y+way[2])]
    if cell ~= nil then
        print("cant move, obstacle")
    else
        local cell = level.units_map[(level.player.x+way[1]*2)*level.size.x + (level.player.y+way[2]*2)]
        if cell == nil then
            local cell = level.floor_map[(level.player.x+way[1]*2)*level.size.x + (level.player.y+way[2]*2)]
            if cell == nil then
                level.units_map[level.player.x*level.size.x + level.player.y] = nil
                level.units_map[(level.player.x+way[1]*2)*level.size.x + (level.player.y+way[2]*2)] = get_object[1]()
                level.player.x = level.player.x + way[1]*2
                level.player.y = level.player.y + way[2]*2
                print("move ok")
            elseif cell.index == 6 then
                level.player.x = level.player.x + way[1]*2
                level.player.y = level.player.y + way[2]*2
                print("WIN")
            elseif cell.index == 7 then
                level.units_map[level.player.x*level.size.x + level.player.y] = nil
                level.units_map[(level.player.x+way[1]*2)*level.size.x + (level.player.y+way[2]*2)] = get_object[1]()
                level.player.x = level.player.x + way[1]*2
                level.player.y = level.player.y + way[2]*2
                print("animation to portal")
                for i=1,#level.floor_obj do
                    if level.floor_obj[i].index==7 and (level.floor_obj[i].x ~= level.player.x or level.floor_obj[i].y ~= level.player.y) then
                        print('ok')
                        level.units_map[level.player.x*level.size.x + level.player.y] = nil
                        level.units_map[level.floor_obj[i].x*level.size.x + level.floor_obj[i].y] = get_object[1]()
                        level.player.x = level.floor_obj[i].x
                        level.player.y = level.floor_obj[i].y
                        break
                    end
                end
            end
        elseif cell.index == 5 then
            local cell = level.floor_map[(level.player.x+way[1]*3)*level.size.x + (level.player.y+way[2]*3)]
            if cell ~= nil and cell.index >=13 and cell.index <= 16 then
                print("cant move flame to obstacle")
            else
                local pos = (level.player.x+way[1]*4)*level.size.x + (level.player.y+way[2]*4)
                if level.units_map[pos] == nil and level.floor_map[pos] == nil then
                    for i=1,#level.units_obj do
                        if level.units_obj[i].index == 5 and level.units_obj[i].x == level.player.x+way[1]*2 and level.units_obj[i].y == level.player.y+way[2]*2 then
                            table.remove(level.units_obj, i)
                            break
                        end
                    end

                    local object = get_object[5]()
                    object.x = level.player.x+way[1]*4
                    object.y = level.player.y+way[2]*4
                    table.insert(level.units_obj, object)
                    level.units_map[level.player.x*level.size.x + level.player.y] = nil
                    level.units_map[(level.player.x+way[1]*2)*level.size.x + (level.player.y+way[2]*2)] = get_object[1]()
                    level.units_map[(level.player.x+way[1]*4)*level.size.x + (level.player.y+way[2]*4)] = get_object[5]()
                    level.player.x = level.player.x + way[1]*2
                    level.player.y = level.player.y + way[2]*2
                    print("move flame")
                else
                    print("cant move flame to obj")
                end
            end
        else
            print("Game over")
        end
    end
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
    if key=='w' or key=='up' then
        val = {-1, 0}
    elseif key=='s' or key=='down' then
        val = {1, 0}
    elseif key=='a' or key=='left' then
        val = {0, -1}
    elseif key=='d' or key=='right' then
        val = {0, 1}
    else
        return -- move only if previous cases
    end
    level_move(level, val)
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







