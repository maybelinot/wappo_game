-- local class = require 'libs/middleclass'
-- require 'units'
require 'animation'
Maps = require 'maps/maps'
Enemies = require 'game/enemies'
Player = require 'game/player'
Floor = require 'game/floor'
Movable = require 'game/movable'
flux = require "libs/flux"

local Level = Game:addState('Level')

function Level:load_level(number, level_relation)
	-- """
	-- Map and all required units loading
	-- """
    self.level_relation = level_relation
    if self.level_relation == 'Campaign' then
        self.level_map = require 'maps/original_levels'
    elseif self.level_relation == 'Own level' then
        print('ok')
        maps = Maps()
        self.level_map = maps:get_maps()
        print(#self.level_map)
    end
    if number <1 or number > #self.level_map then
        self.current_map = #self.level_map
    else
        self.current_map = number
    end
    self.size = {}
    self.size.x = 11
    self.size.y = 11

    -- Tweeking preferences
    self.tweeking_time = 0.5
    -- self.tweeking_ease = "circinout"
    self.tweeking_ease = "linear"
    self:load()
end

function Level:draw()
    love.graphics.print( 'Level #' .. tostring(self.current_map), 50, 350, 0,2.5 )
    love.graphics.draw(background, 0, 0)
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

function Level:load()
    local map = self.level_map[self.current_map]
    local map_keys = {'player', 'red enemy', 'violet enemy', 'blue enemy', 'flame', 'exit', 'teleport', nil, nil, nil, 'wall', 'wall', 'wall', 'wall', 'wall', 'wall'}
    self.moved = true
    
    self.enemies = Enemies:new()
    self.floor = Floor:new()
    self.movable = Movable:new()

    for i=1,#map,3 do
        local cell = {map[i], map[i+1], map[i+2]}
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

function Level:next()
  -- """
  -- Start new level
  -- """
  -- level = Level(32)
    if self.current_map < #self.level_map then
        self.current_map = self.current_map +1
    end
    self:load()
end

function Level:restart()
  -- """
  -- Start new level
  -- """
    self:load()
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

function Level:keypressed(key)
    -- """
    -- Callback on key press
    -- """
    if key=='w' then
        key = 'up'
        val = {-1, 0}
    elseif key=='s' then
        key = 'down'
        val = {1, 0}
    elseif key=='a' then
        key = 'left'
        val = {0, -1}
    elseif key=='d' then
        key = 'right'
        val = {0, 1}
    elseif key == 'escape' then
        if self.level_relation == 'Campaign' then
            self:gotoState('Menu')
            self:load_campaign_menu()
        elseif self.level_relation == 'Own level' then
            self:gotoState('Menu')
            self:load_own_level_menu()
        end
        return
    else
      return
    end
    -- Will be changed when menu will be added
    if self:is_moved() == true then
        self.moved = false
        self:move(val)
    end
end

function Level:mousepressed(x, y, button)
end

function Level:mousereleased(x, y)
end
