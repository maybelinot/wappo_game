local class = require 'libs/middleclass'
local EditorObj = require 'editor/objects'
local tilesize = {40, 52}


local Cursor = class('Cursor', EditorObj)

function Cursor:initialize(obj_type)
    EditorObj.initialize(self, obj_type)
end

return Cursor