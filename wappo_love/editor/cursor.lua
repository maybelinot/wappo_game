local class = require 'libs/middleclass'
local EditorObj = require 'editor/objects'
local tilesize = {40, 52}


local Cursor = class('Cursor', EditorObj)

function Cursor:initialize(obj_type)
    EditorObj.initialize(self, obj_type)
end

function Cursor:draw(x, y)
	local x_map =  math.ceil((x-300-tilesize[1])/tilesize[1])*2
    local y_map = math.ceil((y-tilesize[2]+5)/tilesize[2])*2
    if self.index < 13 then
        x_map = x_map + 1
        y_map = y_map + 1
    elseif self.index <=14 then
        x_map =  math.ceil((x-300-tilesize[1]/2)/tilesize[1])*2
        y_map = y_map + 1
    else
        y_map = math.ceil((y-tilesize[2]/2+5)/tilesize[2])*2
        x_map = x_map + 1
    end    
    if x_map >0 and x_map <= editor.map.len and
        y_map >0 and y_map <= editor.map.len then
        self.sprite:draw(300 + (x_map-1)*tilesize[1]/2, (y_map-1)*tilesize[2]/2+5)
    else
        self.sprite:draw(x-tilesize[1]/2, y-tilesize[2]/2)
    end
end

return Cursor