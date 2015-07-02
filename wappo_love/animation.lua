local anim8 = require 'libs/anim8'
local tilesize = {40, 52}

local image, g

function load_animation(image, spritesx, spritesy, delay)
    local animation = {}
    animation.image = love.graphics.newImage('sprites/'..image)
    local g = anim8.newGrid(
        tilesize[1], 
        tilesize[2], 
        animation.image:getWidth(), 
        animation.image:getHeight())
    animation.animation = anim8.newAnimation(g(spritesx, spritesy), delay)
    animation.update = function(self, dt)
        if self.animation.update ~= nil then -- one sprite animation update is nil
            self.animation:update(dt)
        end 
    end
    animation.draw = function(self, x, y)
        self.animation:draw(self.image, x, y)
    end 
    return animation
end