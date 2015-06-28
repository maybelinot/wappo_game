return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 11,
  height = 11,
  tilewidth = 40,
  tileheight = 52,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "Wappo",
      firstgid = 1,
      tilewidth = 40,
      tileheight = 52,
      spacing = 0,
      margin = 0,
      image = "../Sprites/tiled.png",
      imagewidth = 160,
      imageheight = 208,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Слой тайлов 1",
      x = 0,
      y = 0,
      width = 11,
      height = 11,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        8, 0, 8, 0, 8, 0, 8, 0, 6, 0, 8,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        8, 0, 8, 0, 8, 0, 8, 13, 8, 0, 8,
        15, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0,
        8, 0, 8, 0, 8, 0, 8, 0, 8, 0, 8,
        0, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0,
        1, 0, 5, 0, 8, 0, 8, 0, 8, 0, 8,
        15, 0, 0, 0, 15, 0, 0, 0, 0, 0, 15,
        8, 0, 0, 0, 8, 0, 8, 13, 8, 0, 0,
        0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 15,
        8, 0, 8, 0, 2, 0, 8, 0, 8, 0, 8
      }
      -- data = {
      --   8, 0, 8, 0, 8, 0, 8, 0, 6, 0, 8,
      --   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      --   8, 0, 8, 0, 8, 0, 8, 13, 8, 0, 8,
      --   15, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0,
      --   8, 0, 8, 0, 8, 0, 8, 0, 8, 0, 8,
      --   0, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0,
      --   7, 0, 1, 0, 8, 0, 8, 0, 8, 0, 8,
      --   15, 0, 0, 0, 15, 0, 0, 0, 0, 0, 15,
      --   8, 0, 5, 0, 8, 0, 8, 13, 8, 0, 2,
      --   0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 15,
      --   8, 0, 8, 0, 7, 0, 8, 0, 8, 0, 8
      -- }
    }
  }
}
