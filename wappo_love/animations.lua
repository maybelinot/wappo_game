local anim8 = require 'libs/anim8'
local tilesize = {40, 52}

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
        self.animation:update(dt)
    end
    animation.draw = function(self, x, y)
        self.animation:draw(self.image, x, y)
    end 
    return animation
end

enemy_red = {}
enemy_red.animations = {}
enemy_red.animations.kill = load_animation('ykill.png', '1-3', 1, 0.1)
enemy_red.animations.up = load_animation('ystrip.png', '1-4', 1, 0.3)
enemy_red.animations.down = load_animation('ystrip.png', '1-4', 2, 0.3)
enemy_red.animations.left = load_animation('ystrip.png', '1-4', 3, 0.3)
enemy_red.animations.right = load_animation('ystrip.png', '1-4', 4, 0.3)
enemy_red.animation = enemy_red.animations.down

enemy_blue = {}
enemy_blue.animations = {}
enemy_blue.animations.kill = load_animation('xkill.png', '1-3', 1, 0.1)
enemy_blue.animations.up = load_animation('xstrip.png', '1-4', 1, 0.3)
enemy_blue.animations.down = load_animation('xstrip.png', '1-4', 2, 0.3)
enemy_blue.animations.left = load_animation('xstrip.png', '1-4', 3, 0.3)
enemy_blue.animations.right = load_animation('xstrip.png', '1-4', 4, 0.3)
enemy_blue.animation = enemy_blue.animations.down

enemy_violet = {}
enemy_violet.animations = {}
enemy_violet.animations.kill = load_animation('pkill.png', '1-3', 1, 0.1)
enemy_violet.animations.up = load_animation('pstrip.png', '1-4', 1, 0.3)
enemy_violet.animations.down = load_animation('pstrip.png', '1-4', 2, 0.3)
enemy_violet.animations.left = load_animation('pstrip.png', '1-4', 3, 0.3)
enemy_violet.animations.right = load_animation('pstrip.png', '1-4', 4, 0.3)
enemy_violet.animations.down_right = load_animation('diag.png', '1-4', 1, 0.3)
enemy_violet.animations.down_left = load_animation('diag.png', '1-4', 2, 0.3)
enemy_violet.animations.up_left = load_animation('diag.png', '1-4', 3, 0.3)
enemy_violet.animations.up_right = load_animation('diag.png', '1-4', 4, 0.3)
enemy_violet.animation = enemy_violet.animations.down_right

player = {}
player.animations = {}
player.animations.down = load_animation('wstrip.png', 1, '1-4', 0.3)
player.animations.up = load_animation('wstrip.png', 2, '1-4', 0.3)
player.animations.left = load_animation('wstrip.png', 3, '1-4', 0.3)
player.animations.right = load_animation('wstrip.png', 4, '1-4', 0.3)
player.animation = player.animations.down