local class = require 'libs/middleclass'
local EditorObj = require 'editor_objects'
local tilesize = {40, 52}


local Cursor = class('Cursor', EditorObj)

function Cursor:initialize(obj_type)
    print(obj_type, 0)
    EditorObj.initialize(self, obj_type, 0)
end

return Cursor