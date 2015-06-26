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

get_object = {}

get_object[2] = function ()
    local enemy_red = {}
    enemy_red.animations = {}
    enemy_red.animations.kill = load_animation('ykill.png', '1-3', 1, 0.1)
    enemy_red.animations.up = load_animation('ystrip.png', '1-4', 1, 0.3)
    enemy_red.animations.down = load_animation('ystrip.png', '1-4', 2, 0.3)
    enemy_red.animations.left = load_animation('ystrip.png', '1-4', 3, 0.3)
    enemy_red.animations.right = load_animation('ystrip.png', '1-4', 4, 0.3)
    enemy_red.sprite = enemy_red.animations.down
    enemy_red.index = 2
    return enemy_red
end 

get_object[4] = function ()
    local enemy_blue = {}
    enemy_blue.animations = {}
    enemy_blue.animations.kill = load_animation('xkill.png', '1-3', 1, 0.1)
    enemy_blue.animations.up = load_animation('xstrip.png', '1-4', 1, 0.3)
    enemy_blue.animations.down = load_animation('xstrip.png', '1-4', 2, 0.3)
    enemy_blue.animations.left = load_animation('xstrip.png', '1-4', 3, 0.3)
    enemy_blue.animations.right = load_animation('xstrip.png', '1-4', 4, 0.3)
    enemy_blue.sprite = enemy_blue.animations.down
    enemy_blue.index = 4
    return enemy_blue
end

get_object[3] = function ()
    local enemy_violet = {}
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
    enemy_violet.sprite = enemy_violet.animations.down_right
    enemy_violet.index = 3
    return enemy_violet
end

get_object[1] = function ()
    local player = {}
    player.animations = {}
    player.animations.down = load_animation('wstrip.png', 1, '1-4', 0.3)
    player.animations.up = load_animation('wstrip.png', 2, '1-4', 0.3)
    player.animations.left = load_animation('wstrip.png', 3, '1-4', 0.3)
    player.animations.right = load_animation('wstrip.png', 4, '1-4', 0.3)
    player.sprite = player.animations.down
    player.index = 1
    return player
end

get_object[5] = function ()
    local flame = {}
    flame.sprite = load_animation('flame.png', '1-4', 1, 0.1)
    flame.index = 5
    return flame
end

get_object[6] = function ()
    local exit = {}
    exit.sprite = load_animation('exitIdle.png', '1-3', 1, 0.1)
    exit.index = 6
    return exit
end

get_object[7] = function ()
    local teleport = {}
    teleport.sprite = load_animation('tele.png', '1-4', 1, 0.1)
    teleport.index = 7
    return teleport
end

get_object[13] = function ()
    local wall = {}
    wall.sprite = load_animation('vwall.png', 1, 1, 0.1)
    wall.index = 13
    return wall
end

get_object[14] = function ()
    local wall = {}
    wall.sprite = load_animation('cVWall.png', 1, 1, 0.1)
    wall.index = 14
    return wall
end

get_object[15] = function ()
    local wall = {}
    wall.sprite = load_animation('hwall.png', 1, 1, 0.1)
    wall.index = 15
    return wall
end

get_object[16] = function ()
    local wall = {}
    wall.sprite = load_animation('cHWall.png', 1, 1, 0.1)
    wall.index = 16
    return wall
end
