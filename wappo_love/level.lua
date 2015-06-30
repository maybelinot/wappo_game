local class = require 'libs/middleclass'
require 'units'
Enemies = require 'enemies'
Player = require 'player'
Floor = require 'floor'
Movable = require 'movable'
flux = require "libs/flux"

local Level = class('Level')

function Level:initialize(number)
    local tiled_level = require("maps/level"..number)['layers'][1]
    local map_keys = {'player', 'red enemy', 'violet enemy', 'blue enemy', 'flame', 'exit', 'teleport', nil, nil, nil, 'wall', 'wall', 'wall', 'wall', 'wall', 'wall'}
    self.size = {}
    self.size.x = tiled_level['width']
    self.size.y = tiled_level['height']
    self.map = tiled_level['data']
    self.moved = true


    self.enemies = Enemies:new()
    self.floor = Floor:new()
    self.movable = Movable:new()

    for i=0,self.size.x-1 do
        for j=1,self.size.y do
            local cell = self.map[i*self.size.x + j]
            if map_keys[cell] ~= nil then
                if map_keys[cell] == 'player' then
                    self.player = Player:new(i, j)
                elseif cell >= 2 and cell <= 4 then
                    self.enemies:add_enemy(map_keys[cell], i, j)
                elseif cell == 5 then
                    self.movable:add_object(cell, i, j)
                elseif map_keys[cell] == 'wall' or map_keys[cell] == 'exit' or map_keys[cell] == 'teleport' then
                    self.floor:add_object(cell, i, j)
                end
            end
        end
    end
end

function take_element(list, x, y)
    for i=1, #list do
        if list[i].x==x and list[i].y==y then
            return list[i]
        end
    end
    return nil
end

function change_element_position(list, x, y, new_x, new_y)
    for i=1, #list do
        if list[i].x==x and list[i].y==y then
            list[i].x = new_x
            list[i].y = new_y
        end
    end
end

function change_element(list, x, y, new_element)
    for i=1, #list do
        if list[i].x==x and list[i].y==y then
            local object = new_element
            object.x = x
            object.y = y
            list[i] = object
        end
    end
end

function Level:draw()
    self.floor:draw()
    self.movable:draw()
    self.player:draw()
    self.enemies:draw()
end

function Level:update(dt)
    self.floor:update(dt)
    self.movable:update(dt)
    self.player.sprite:update(dt)
    self.enemies:update(dt)
end

function Level:move(way)
    if self.player:is_moved() == false then
        self.player:step_processing(way)
    elseif self.enemies:is_moved() == false then
        self.enemies:move()
    else
        self.player.moved = false
        self.enemies.moved = false
        self.moved = true
    end
end

function Level:is_moved()
    return self.moved
end

function Level:is_on_map(x, y)
    if x > self.size.x or x < 0 or y > self.size.y or y < 1 then
        return false
    end
    return true
end

return Level
