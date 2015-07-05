local class = require 'libs/middleclass'
-- require 'units'
require 'animation'
-- Unit = require 'unit'
Enemies = require 'enemies'
Player = require 'player'
Floor = require 'floor'
Movable = require 'movable'
flux = require "libs/flux"


local Level = class('Level')

function Level:initialize(number)
	-- """
	-- Map and all required units loading
	-- """
    local tiled_level = require("maps/level"..number)['layers'][1]
    local map_keys = {'player', 'red enemy', 'violet enemy', 'blue enemy', 'flame', 'exit', 'teleport', nil, nil, nil, 'wall', 'wall', 'wall', 'wall', 'wall', 'wall'}
    self.size = {}
    self.size.x = tiled_level['width']
    self.size.y = tiled_level['height']
    self.map = tiled_level['data']

    -- Tweeking preferences
    self.tweeking_time = 0.5
    -- self.tweeking_ease = "circinout"
    self.tweeking_ease = "linear"

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

function Level:draw()
    self.floor:draw()
    self.movable:draw()
    self.player:draw()
    self.enemies:draw()
end

function Level:update(dt)
    flux.update(dt)
    self.floor:update(dt)
    self.movable:update(dt)
    self.player.sprite:update(dt)
    self.enemies:update(dt)
end

function Level:move(way)
    print(self.player:is_moved(), self.enemies:is_moved(), self.moved)
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
