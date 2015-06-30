local class = require 'libs/middleclass'
local tilesize = {40, 52}

local Unit = class('Unit')

function Unit:initialize(unit_type, x, y)
    self.animations = {}
    self.description = unit_type
    local anim_letter = ''
    if unit_type == 'player' then
        anim_letter = 'w'
        self.index = 1
    else
        if unit_type == 'red enemy' then
            self.steps = 2
            self.index = 2
            self.ways = {3,2}
            anim_letter = 'y'
        elseif unit_type == 'blue enemy' then
            self.steps = 2
            self.index = 4
            self.ways = {2,3}
            anim_letter = 'x'
        elseif unit_type == 'violet enemy' then
            self.steps = 3
            self.index = 3
            self.ways = {1,2,3}
            anim_letter = 'p'
            self.animations.down_right = load_animation('diag.png', '1-4', 1, 0.3)
            self.animations.down_left = load_animation('diag.png', '1-4', 2, 0.3)
            self.animations.up_left = load_animation('diag.png', '1-4', 3, 0.3)
            self.animations.up_right = load_animation('diag.png', '1-4', 4, 0.3)
        end
        self.steps_left = 0
        self.animations.kill = load_animation(anim_letter..'kill.png', '1-3', 1, 0.1)
    end
    self.animations.down = load_animation(anim_letter..'strip.png', 1, '1-4', 0.3)
    self.animations.up = load_animation(anim_letter..'strip.png', 2, '1-4', 0.3)
    self.animations.left = load_animation(anim_letter..'strip.png', 3, '1-4', 0.3)
    self.animations.right = load_animation(anim_letter..'strip.png', 4, '1-4', 0.3)
    self.sprite = self.animations.down
    self.x = x
    self.y = y
    self.anim_x = 0
    self.anim_y = 0
end

function Unit:update(dt)
    self.sprite:update(dt)
end

function Unit:draw()
    self.sprite:draw(self.y*tilesize[1]/2-20 + self.anim_y, self.x*tilesize[2]/2+5 + self.anim_x)
end

function Unit:move(way)
    self.x = self.x + way[1]*2
    self.y = self.y + way[2]*2
    self.sprite = self.animations[self:get_animation_key(way)]
    self.anim_x = self.anim_x + way[1]*(-tilesize[2])
    self.anim_y = self.anim_y + way[2]*(-tilesize[1])
end

function Unit:get_animation_key(way)
    if way[1] == 1 then
        if way[2] == 0 then
            return 'down'
        elseif way[2] == 1 then
            return 'down_right'
        else
            return 'up_right'
        end 
    elseif way[1] == -1 then
        if way[2] == 0 then
            return 'up'
        elseif way[2] == 1 then
            return 'down_left'
        else
            return 'up_left'
        end
    else
        if way[2] == 1 then
            return 'right'
        elseif way[2] == -1 then
            return 'left'
        else
            return 'idle'
        end
    end
end

function Unit:is_here(x, y)
    if self.x==x and self.y==y  then
        return true
    end
    return false
end

return Unit