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
    if unit=='player' then
        level.player.x = level.player.x + way[1]*2
        level.player.y = level.player.y + way[2]*2
        level.player.sprite = level.player.animations[key]
        level.player.anim_x = way[1]*(-52)
        level.player.anim_y = way[2]*(-40)
    else
        level[unit][id].x = level[unit][id].x + way[1]*2
        level[unit][id].y = level[unit][id].y + way[2]*2
        level[unit][id].anim_x = way[1]*(-52)
        level[unit][id].anim_y = way[2]*(-40)
        if unit=='floor_obj' then
            level[unit][id].sprite = level[unit][id].animations[key]
        end
    end
    level.is_moving = true 
    return level
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
        level.units_obj[i].sprite:update(dt)
    end
    level.player.sprite:update(dt)
end

function level_move(level, key, way)
    if level.player.x+way[1]*2 > level.size.x or level.player.x+way[1]*2 < 0 or level.player.y+way[2]*2 > level.size.y or level.player.y+way[2]*2 < 1 then
        level.player.sprite = level.player.animations[key]
        flux.to(level.player, 0.6, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease("circinout"):oncomplete(function () flux.to(level.player, 0.6, { anim_x = 0, anim_y = 0 }):ease("circinout") end)
        print('cant move to borders')
        return
    end
    local cell = take_element(level.floor_obj, level.player.x+way[1], level.player.y+way[2])
    if cell ~= nil then
        level.player.sprite = level.player.animations[key]
        flux.to(level.player, 0.6, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease("circinout"):oncomplete(function () flux.to(level.player, 0.6, { anim_x = 0, anim_y = 0 }):ease("circinout") end)
        return
        print("cant move, obstacle")
    end
    local cell = take_element(level.units_obj, level.player.x+way[1]*2, level.player.y+way[2]*2)
    if cell == nil then
        level = move_unit(level, way, key, 'player')
        local cell = take_element(level.floor_obj, level.player.x, level.player.y)
        if cell == nil then
            flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () level.is_moving = false end)
            print("move ok")
        elseif cell.index == 6 then
            flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () level.is_moving = false end)
            print("WIN")
        elseif cell.index == 7 then
            print("animation to portal")
            for i=1,#level.floor_obj do
                if level.floor_obj[i].index==cell.index and (level.floor_obj[i].x ~= level.player.x or level.floor_obj[i].y ~= level.player.y) then
                    print('ok')
                    flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () level.is_moving = false                        
                                                                                                                    level.player.x = level.floor_obj[i].x
                                                                                                                    level.player.y = level.floor_obj[i].y end)
                    break
                end
            end
        end
    elseif cell.index == 5 then
        local cell = take_element(level.floor_obj, level.player.x+way[1]*3, level.player.y+way[2]*3)
        if cell ~= nil and cell.index >=13 and cell.index <= 16 then
            level.player.sprite = level.player.animations[key]
            flux.to(level.player, 0.6, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease("circinout"):oncomplete(function () flux.to(level.player, 0.6, { anim_x = 0, anim_y = 0 }):ease("circinout") end)
            print("cant move flame to obstacle")
        else
            local unit = take_element(level.units_obj, level.player.x+way[1]*4, level.player.y+way[2]*4)
            local floor = take_element(level.floor_obj, level.player.x+way[1]*4, level.player.y+way[2]*4)
            if unit == nil and floor == nil then
                for i=1,#level.units_obj do
                    if level.units_obj[i].index == 5 and level.units_obj[i].x == level.player.x+way[1]*2 and level.units_obj[i].y == level.player.y+way[2]*2 then
                        level = move_unit(level, way, key, 'units_obj', i)
                        flux.to(level.units_obj[i], 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () level.is_moving = false end)
                        break
                    end
                end
                level = move_unit(level, way, key, 'player')
                flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () level.is_moving = false end)
                print("move flame")
            else
                level.player.sprite = level.player.animations[key]
                flux.to(level.player, 0.6, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease("circinout"):oncomplete(function () flux.to(level.player, 0.6, { anim_x = 0, anim_y = 0 }):ease("circinout") end)
                print("cant move flame to obj")
            end
        end
    else
        cell.animation = cell.animations.kill
        level = move_unit(level, way, key, 'player')
        flux.to(level.player, 1.2, { anim_x = 0, anim_y = 0 }):ease("circinout"):oncomplete(function () level.is_moving = false end)
        print("Game over")
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
ss = {}
ss.x = {}
ss.x.y = 5
print(ss['x']['self'])






