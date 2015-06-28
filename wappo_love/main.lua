require 'units'
flux = require "libs/flux"

function level_load(number)
    local tiled_level = require("maps/level"..number)['layers'][1]
    local level = {}
    level.size = {}
    level.size.x = tiled_level['width']
    level.size.y = tiled_level['height']
    level.map = tiled_level['data']
    level.floor_obj = {}
    level.units_obj = {}
    level.player = nil
    level.is_moving = false
    for i=0,level.size.x-1 do
        for j=1,level.size.y do
            local cell = level.map[i*level.size.x + j]
            if cell == 1 or cell == 2 or cell == 3 or cell == 4 or cell == 5 then
                local object = get_object[cell]()
                object.x = i
                object.y = j
                if cell == 1 then
                    level.player = object
                else
                    table.insert(level.units_obj, object)
                end
            elseif cell == 6 or cell == 7 or cell == 13 or cell == 14 or cell == 15 or cell == 16 then
                local object = get_object[cell]()
                object.x = i
                object.y = j
                table.insert(level.floor_obj, object)
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

function take_element(list, x, y)
    for i=1, #list do
        if list[i].x==x and list[i].y==y then
            return list[i]
        end
    end
    return nil
end

function move_unit(level, way, key, unit, id)
    -- тут все понятно думаю, в anim_x и anim_y хранятся значения для твининга
    -- unit меняет свое положение по сетки сразу же, поэтому твининг начинается с отрицательного значения, то есть
    -- с той клетки на которой unit был раньше и стремится к 0, к той клетке
    -- на которой он находится сейчас по сетке
    if unit=='player' then
        level.player.x = level.player.x + way[1]*2
        level.player.y = level.player.y + way[2]*2
        level.player.sprite = level.player.animations[key]
        level.player.anim_x = level.player.anim_x + way[1]*(-52)
        level.player.anim_y = level.player.anim_y + way[2]*(-40)
    else
        level[unit][id].x = level[unit][id].x + way[1]*2
        level[unit][id].y = level[unit][id].y + way[2]*2
        level[unit][id].anim_x = level[unit][id].anim_x + way[1]*(-52)
        level[unit][id].anim_y = level[unit][id].anim_y + way[2]*(-40)
        -- if not a flame then add movement animation
        if level[unit][id].index ~= 5 then
            level[unit][id].sprite = level[unit][id].animations[key]
        end
    end
    level.is_moving = true 
end

function level_draw(level)
    for i=1,#level.floor_obj do
        level.floor_obj[i].sprite:draw(level.floor_obj[i].y*20-20, level.floor_obj[i].x*26+5)
    end
    level.player.sprite:draw(level.player.y*20-20 + level.player.anim_y, level.player.x*26+5 + level.player.anim_x)
    for i=1,#level.units_obj do
        level.units_obj[i].sprite:draw(level.units_obj[i].y*20-20 + level.units_obj[i].anim_y, level.units_obj[i].x*26+5 + level.units_obj[i].anim_x)
    end
end

function level_update(level, dt)
    for i=1,#level.floor_obj do
        level.floor_obj[i].sprite:update(dt)
    end
    for i=1,#level.units_obj do
        -- print(level.units_obj[i].index)
        level.units_obj[i].sprite:update(dt)
    end
    level.player.sprite:update(dt)
end

function level_move(level, key, way)
    player_move(level, key, way)
end

function player_move(level, key, way)
    --  проверка что игрок не выходит за границы
    if level.player.x+way[1]*2 > level.size.x or level.player.x+way[1]*2 < 0 or level.player.y+way[2]*2 > level.size.y or level.player.y+way[2]*2 < 1 then
        -- анимация движения
        level.player.sprite = level.player.animations[key]
        -- твининг на движение в сторону границы и обратно
        flux.to(level.player, 0.6, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease("circinout"):oncomplete(function () flux.to(level.player, 0.6, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enn(level) end) end)
        print('cant move to borders')
        return
    end
    -- записываем в cell границу/nil в стороне движения игрока
    local cell = take_element(level.floor_obj, level.player.x+way[1], level.player.y+way[2])
    if cell ~= nil then
        -- если не nil то тоже самое что выше, анимация движения и твининг туда обратно
        level.player.sprite = level.player.animations[key]
        flux.to(level.player, 0.6, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease("circinout"):oncomplete(function () flux.to(level.player, 0.6, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enn(level) end) end)
        return
        print("cant move, obstacle")
    end
    -- записываем в cell unit из клетки в стороне движения игрока
    local cell = take_element(level.units_obj, level.player.x+way[1]*2, level.player.y+way[2]*2)
    if cell == nil then
        -- если клетка пустая то игрок туда идет
        move_unit(level, way, key, 'player')
        -- смотрим какие floor_obj есть на этой клетке
        local cell = take_element(level.floor_obj, level.player.x, level.player.y)
        -- если никаких или выход то ставим обычный твининг
        if cell == nil then
            flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enn(level) end)
            print("move ok")
        elseif cell.index == 6 then
            flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enn(level) end)
            print("WIN")
        elseif cell.index == 7 then
            -- если там портал то ищем второй портал в массиве
            print("animation to portal")
            for i=1,#level.floor_obj do
                if level.floor_obj[i].index==cell.index and (level.floor_obj[i].x ~= level.player.x or level.floor_obj[i].y ~= level.player.y) then
                    print('ok')
                    -- ставим твининг на движение и функцию, которая после передвижения меняет позицию игрока на место второго портала
                    flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () level.is_moving = false                        
                                                                                                                    level.player.x = level.floor_obj[i].x
                                                                                                                    level.player.y = level.floor_obj[i].y
                                                                                                                    enn(level) end)
                    break
                end
            end
        end
        -- если на следующей клетке flame
    elseif cell.index == 5 then
        -- берем преграду за flame
        local cell = take_element(level.floor_obj, level.player.x+way[1]*3, level.player.y+way[2]*3)
        if cell ~= nil and cell.index >=13 and cell.index <= 16 then
            -- если преграда есть, то тоже самое что в начале, ставим анимацию движения и твининг туда обратно
            level.player.sprite = level.player.animations[key]
            flux.to(level.player, 0.6, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease("circinout"):oncomplete(function () flux.to(level.player, 0.6, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enn(level) end) end)
            print("cant move flame to obstacle")
        else
            -- если преграды нету то смотрим что на след клетке за flame, может ли он туда двигаться
            local unit = take_element(level.units_obj, level.player.x+way[1]*4, level.player.y+way[2]*4)
            local floor = take_element(level.floor_obj, level.player.x+way[1]*4, level.player.y+way[2]*4)
            if unit == nil and floor == nil then
                -- если пусто то ищем flame в массиве
                for i=1,#level.units_obj do
                    if level.units_obj[i].index == 5 and level.units_obj[i].x == level.player.x+way[1]*2 and level.units_obj[i].y == level.player.y+way[2]*2 then
                        -- если flame выйдет за границы поля
                        if level.units_obj[i].x+way[1]*2 > level.size.x or level.units_obj[i].x+way[1]*2 < 0 or level.units_obj[i].y+way[2]*2 > level.size.y or level.units_obj[i].y+way[2]*2 < 1 then
                            -- тоже что в начале, анимация и твининг туда сюда
                            level.player.sprite = level.player.animations[key]
                            flux.to(level.player, 0.6, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease("circinout"):oncomplete(function () flux.to(level.player, 0.6, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enn(level) end) end)
                            print('cant move flame to borders')
                            return
                        end
                        --  если не выходит за границы то двигаем flame
                        move_unit(level, way, key, 'units_obj', i)
                        -- ставим твининг передвижения
                        flux.to(level.units_obj[i], 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout")
                        break
                    end
                end
                -- после того как передвинули flame двигаем и игрока
                move_unit(level, way, key, 'player')
                -- твининг для игрока
                flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enn(level) end)
                print("move flame")
            else
                -- если на клетке за flame не пусто то анимация движения и твининг туда/cюда
                level.player.sprite = level.player.animations[key]
                flux.to(level.player, 0.6, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease("circinout"):oncomplete(function () flux.to(level.player, 0.6, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enn(level) end) end)
                print("cant move flame to obj")
            end
        end
    else
        -- если там enemy, ставим анимацию kill
        cell.sprite = cell.animations.kill
        -- двигаем игрока
        move_unit(level, way, key, 'player')
        -- ставим твининг
        flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enn(level) end)
        print("Game over")
    end
end

function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

function ways_to_keys(ways)
    local keys = {}
    for k,way in pairs(ways) do
        if way[1] == 1 then
            if way[2] == 0 then
                keys[k] = 'down'
            elseif way[2] == 1 then
                keys[k] = 'down_right'
            else
                keys[k] = 'up_right'
            end 
        elseif way[1] == -1 then
            if way[2] == 0 then
                keys[k] = 'up'
            elseif way[2] == 1 then
                keys[k] = 'down_left'
            else
                keys[k] = 'up_left'
            end
        else
            if way[2] == 1 then
                keys[k] = 'right'
            elseif way[2] == -1 then
                keys[k] = 'left'
            end
        end
    end
    return keys 
end

function enn(level)
    for i=1,#level.units_obj do
        if level.units_obj[i].index== 2 or level.units_obj[i].index== 4 then
            level.units_obj[i].steps = 2
        elseif level.units_obj[i].index == 3 then
            level.units_obj[i].steps = 3
        end
    end
    level.moving_enemy_count = 1
    enemy_step(level)
end
function enemy_step(level)
    level.moving_enemy_count = level.moving_enemy_count - 1
    if level.moving_enemy_count == 0 then
        enemy_move(level)
    end
end
function enemy_move(level)
    print("NEW MOVE")
    for i=1,#level.units_obj do
        condition = true
        if level.units_obj[i].index<=4 and level.units_obj[i].steps>0 then
            level.units_obj[i].steps = level.units_obj[i].steps - 1
            local direction = {sign(level.player.x - level.units_obj[i].x), sign(level.player.y - level.units_obj[i].y)}
            -- all possibles ways to move
            -- local directions = {direction}
            -- if direction[0]~=0 then
            --     table.insert(directions, {0,direction[2]})
            -- end
            -- if direction[1]~=0 then
            --     table.insert(directions, {direction[1],0})
            -- end
            local directions = {direction, {0,direction[2]}, {direction[1],0}}
            local ways = {}
            for k, v in pairs(level.units_obj[i].ways) do ways[k] = directions[v] end
            keys = ways_to_keys(ways)
            for k, way in pairs(ways) do
                local cell = take_element(level.floor_obj, level.units_obj[i].x+way[1], level.units_obj[i].y+way[2])
                if cell ~= nil then
                    print("obstacle")
                    condition = true
                else
                    print("not obstacle")
                    local cell = take_element(level.units_obj, level.units_obj[i].x+way[1]*2, level.units_obj[i].y+way[2]*2)
                    if cell ~= nil then
                        print("unit")
                        condition = true
                    else
                        print("not unit")
                        condition = false
                        -- если клетка пустая то unit туда идет
                        print("ADDED anim position", way[1], way[2])
                        level.moving_enemy_count = level.moving_enemy_count + 1
                        move_unit(level, way, keys[k], 'units_obj', i)
                        -- смотрим какие floor_obj есть на этой клетке
                        local cell = take_element(level.floor_obj, level.units_obj[i].x, level.units_obj[i].y)
                        if cell ~= nil then
                            print(cell.index)
                        end
                        -- если никаких или выход то ставим обычный твининг
                        if cell == nil or cell.index == 6 then
                            print(level.units_obj[i].anim_x, level.units_obj[i].anim_y)
                            flux.to(level.units_obj[i], 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () enemy_step(level) end)
                            print("move ok")
                            if level.units_obj[i].index == 2 or level.units_obj[i].index == 4 then
                                break
                            end
                        elseif cell.index == 7 then
                            -- если там портал то ищем второй портал в массиве
                            print("animation to portal")
                            for j=1,#level.floor_obj do
                                if level.floor_obj[j].index==cell.index and (level.floor_obj[j].x ~= level.units_obj[i].x or level.floor_obj[j].y ~= level.units_obj[i].y) then
                                    -- ставим твининг на движение и функцию, которая после передвижения меняет позицию игрока на место второго портала
                                    level.units_obj[i].steps = 0
                                    flux.to(level.units_obj[i], 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () level.units_obj[i].x = level.floor_obj[j].x
                                                                                                                                    level.units_obj[i].y = level.floor_obj[j].y
                                                                                                                                    level.is_moving = false
                                                                                                                                    enemy_step(level) end)
                                    break
                                end
                            end
                            if level.units_obj[i].index == 2 or level.units_obj[i].index == 4 then 
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    print(condition)
    if condition == true then
        level.is_moving = false
    end
end


local level = level_load(57)

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
    flux.update(dt)
    level_update(level, dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    level_draw(level)
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
    if level.is_moving~=true then
        level_move(level, key, val)
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