local class = require 'libs/middleclass'
local Unit = require 'game/unit'

local Player = class('Player', Unit)

function Player:initialize(x, y)
    -- """
    -- represent Player class
    -- """
    Unit.initialize(self, 'player', x, y)
    self.moved = false
end

function Player:get_directions(x,y)
    -- """
    -- Return direction of given x,y coordinates to player position 
    -- """
    local function sign(x)
        -- """
        -- Return sign of given x : if x > 0 then 1
        --                          if x = 0 then 0
        --                          if x < 0 then -1
        -- """
      return x>0 and 1 or x<0 and -1 or 0
    end
    local direction = {sign(self.x - x), sign(self.y - y)}
    return {direction, {0,direction[2]}, {direction[1],0}}
end

function Player:is_moved()
    -- """
    -- Return bool is player already finished his movement
    -- """
    return self.moved
end

function Player:try_move(way)
    -- """
    -- Trying to move. Position is not changing.
    -- Animation in the direction of prospective movement abd back. 
    -- """
    self.sprite = self.animations[self:get_animation_key(way)]
    flux.to(self, level.tweeking_time/2, { anim_x = way[1]*15, anim_y = way[2]*10 }):ease(level.tweeking_ease):oncomplete(function () 
                    flux.to(self, level.tweeking_time/2, { anim_x = 0, anim_y = 0 }):ease(level.tweeking_ease):oncomplete(function () 
                        self.moved = true 
                        level.enemies.moved = true 
                        level:move() end) end)
end

function Player:step_processing(way)
    -- """
    -- Processing of players step
    -- """

    -- check if cell where player is going to move out of map dimension
    if level:is_on_map(self.x+way[1]*2, self.y+way[2]*2) == false then
        self:try_move(way)
        return
    end
    -- check if there is obstacle on the way
    if level.floor:is_permeable(self, way[1], way[2]) == false then
        self:try_move(way)
        return
    end
    -- check if there flame object on the way
    if level.movable:is_here(self.x+way[1]*2, self.y+way[2]*2) then
        -- check if there is obstacle on the way of flame object movement
        if level.floor:is_permeable(self, way[1]*3, way[2]*3) == false then
            self:try_move(way)
            return
        else
            -- if there is no obstacles then check if cell beyond flame is empty
            if level.enemies:is_here(self.x+way[1]*4, self.y+way[2]*4) == false and
                level.floor:get_index(self.x+way[1]*4, self.y+way[2]*4) ~= 5 then
                -- check if cell where flame is going to move out of map dimension
                if level:is_on_map(self.x+way[1]*4, self.y+way[2]*4) == false then
                    self:try_move(way)
                    return
                end
                -- move flame
                level.movable:move(self.x+way[1]*2, self.y+way[2]*2, way)
                -- move player
                self:move(way)
                -- set tweeking to player movement
                flux.to(self, level.tweeking_time, { anim_x = 0, anim_y = 0 }):ease(level.tweeking_ease):oncomplete(function () self.moved = true
                                                                                                        level:move() end)
            else
                self:try_move(way)
            end
        end
    else
        -- записываем в cell unit из клетки в стороне движения игрока
        if level.enemies:is_here(self.x+way[1]*2, self.y+way[2]*2) == false then
            -- если клетка пустая то игрок туда идет
            self:move(way)
            -- смотрим какие floor есть на этой клетке
            local index = level.floor:get_index(self.x, self.y)
            -- если никаких или выход то ставим обычный твининг
            if index == nil then
                flux.to(self, level.tweeking_time, { anim_x = 0, anim_y = 0 }):ease(level.tweeking_ease):oncomplete(function () self.moved = true
                                                                                                        level:move() end)
            elseif index == 6 then
                flux.to(self, level.tweeking_time, { anim_x = 0, anim_y = 0 }):ease(level.tweeking_ease):oncomplete(function () self.moved = true
                                                                                                        level:move() end)
                print("WIN")
            elseif index == 7 then
                flux.to(self, level.tweeking_time, { anim_x = 0, anim_y = 0 }):ease(level.tweeking_ease):oncomplete(function () level.floor:teleportation(self)
                                                                                                        self.moved = true
                                                                                                        level:move() end)
            end
        else
            -- если там enemy, ставим анимацию kill
            level.enemies:kills()
            -- двигаем игрока
            self:move(way)
            -- ставим твининг
            flux.to(self, level.tweeking_time, { anim_x = 0, anim_y = 0 }):ease(level.tweeking_ease):oncomplete(function () new_level() end)
            print("Game over")
        end
    end
end

return Player