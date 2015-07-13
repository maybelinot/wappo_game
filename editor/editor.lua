local class = require 'libs/middleclass'
local tilesize = {40, 52}
require 'animation'
local Panel = require 'editor/panel'
Cursor = require 'editor/cursor'
Map = require 'editor/map'

local Editor = Game:addState('Editor')

function Editor:load_editor()
    self.map = Map:new()
    self.location = {0, 320}
    self.len = 6
    self.position = {1, 0}
    self.cursor = Cursor:new('empty')
    self.panel = Panel:new(self.location, self.position, self.len)
    self.panel:add_object('vwall', 1)
    self.panel:add_object('hwall', 1)
    self.panel:add_object('player', 1)
    self.panel:add_object('flame', 1)
    self.panel:add_object('red enemy', 1)
    self.panel:add_object('blue enemy', 1)
    self.panel:add_object('cvwall', 1)
    self.panel:add_object('chwall', 1)
    self.panel:add_object('exit', 1)
    self.panel:add_object('teleport', 1)
    self.panel:add_object('violet enemy', 1)
    self.panel:add_object('empty', 1)
end


function Editor:update(dt)
    self.panel:update(dt)
    self.map:update(dt)
    self.cursor:update(dt)
end

function Editor:draw()
	love.graphics.draw(background, 0, 0)
    self.panel:draw()
    self.map:draw()
    local x, y =  love.mouse.getPosition()
    self.cursor:draw(x, y)
end

function Editor:mousepressed(x, y, button)
    -- print(self.cursor.description, math.ceil((x-300)/tilesize[1]*2), math.ceil((y)/tilesize[2]*2))
    if button == 'l' then 
	    local x_map =  math.ceil((x-tilesize[1])/tilesize[1])*2
	    local y_map = math.ceil((y-tilesize[2]+5)/tilesize[2])*2
	    if self.cursor.index < 13 then
	        x_map = x_map + 1
	        y_map = y_map + 1
	    elseif self.cursor.index <=14 then
	        x_map =  math.ceil((x-tilesize[1]/2)/tilesize[1])*2
	        y_map = y_map + 1
	    else
	        y_map = math.ceil((y-tilesize[2]/2+5)/tilesize[2])*2
	        x_map = x_map + 1
	    end
	    if x_map >0 and x_map <= self.map.len and
	        y_map >0 and y_map <= self.map.len then
	        self.map:add_object(self.cursor.description, x_map, y_map)
	    else
	        local obj_type = self.panel:get_object(x, y)
	        self.cursor = Cursor:new(obj_type)
	    end
	end
end

function Editor:mousereleased(x,y)

end

function Editor:keypressed(key)
    -- """
    -- Callback on key press
    -- """
    if key=='return' then
    	if self.map:is_ok() then
	    	self.map:save()
	    	self.map:load_maps()
	    	self:gotoState('Level') 
	    	self:load_level(0, 'Own level')
	    else
	    	print('You need player on you level')
	    end
    	return
    elseif key=='c' then
    	self.map.list = {}
    	return
    elseif key == 'escape' then
        self:gotoState('Menu')
        self:load_main_menu()
    else
    	return
    end
end


-- return Editor