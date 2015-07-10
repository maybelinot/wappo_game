local class = require 'libs/middleclass'
-- require 'units'
require 'animation'
-- Unit = require 'unit'
Enemies = require 'game/enemies'
Player = require 'game/player'
Floor = require 'game/floor'
Movable = require 'game/movable'
flux = require "libs/flux"


local Level = class('Level')

function Level:initialize(number)
	-- """
	-- Map and all required units loading
	-- """
    self.size = {}
    self.size.x = 11
    self.size.y = 11
    if number == 0 or number == nil then
        self.map = editor.map:read()
    else
        self.map = level_map[number]
    end
    local map_keys = {'player', 'red enemy', 'violet enemy', 'blue enemy', 'flame', 'exit', 'teleport', nil, nil, nil, 'wall', 'wall', 'wall', 'wall', 'wall', 'wall'}
        -- Tweeking preferences
    self.tweeking_time = 0.5
    -- self.tweeking_ease = "circinout"
    self.tweeking_ease = "linear"

    self.moved = true
    
    self.enemies = Enemies:new()
    self.floor = Floor:new()
    self.movable = Movable:new()

    for i=1,#self.map,3 do
        local cell = {self.map[i], self.map[i+1], self.map[i+2]}
        if map_keys[cell[1]] ~= nil then
            if map_keys[cell[1]] == 'player' then
                self.player = Player:new(cell[2], cell[3])
            elseif cell[1] >= 2 and cell[1] <= 4 then
                self.enemies:add_enemy(map_keys[cell[1]], cell[2], cell[3])
            elseif cell[1] == 5 then
                self.movable:add_object(cell[1], cell[2], cell[3])
            elseif map_keys[cell[1]] == 'wall' or map_keys[cell[1]] == 'exit' or map_keys[cell[1]] == 'teleport' then
                self.floor:add_object(cell[1], cell[2], cell[3])
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
    -- print(self.player:is_moved(), self.enemies:is_moved(), self.moved)
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
