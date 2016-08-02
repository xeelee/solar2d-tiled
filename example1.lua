return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.16.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 8,
  height = 8,
  tilewidth = 64,
  tileheight = 64,
  nextobjectid = 14,
  properties = {},
  tilesets = {
    {
      name = "example",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "example.png",
      imagewidth = 512,
      imageheight = 64,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 8,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Background",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2,
        1, 1, 1, 1, 2, 2, 1, 1,
        1, 1, 1, 1, 2, 2, 1, 1,
        1, 1, 1, 1, 2, 2, 1, 1
      }
    },
    {
      type = "objectgroup",
      name = "Collision",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1.33333,
          y = 322,
          width = 252,
          height = 60,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 386,
          y = 322,
          width = 124,
          height = 60,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "Object",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 45,
          y = 294,
          width = 64,
          height = 64,
          rotation = 0,
          gid = 3,
          visible = true,
          properties = {
            ["class"] = "yellow thing",
            ["id"] = "yellow-main-thing"
          }
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 172,
          y = 289.333,
          width = 64,
          height = 64,
          rotation = 0,
          gid = 4,
          visible = true,
          properties = {
            ["class"] = "brown thing",
            ["id"] = "brown-main-thing"
          }
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 139,
          y = 199,
          width = 64,
          height = 64,
          rotation = 0,
          gid = 4,
          visible = true,
          properties = {
            ["class"] = "brown thing"
          }
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 408,
          y = 280,
          width = 64,
          height = 64,
          rotation = 0,
          gid = 3,
          visible = true,
          properties = {
            ["class"] = "yellow thing"
          }
        }
      }
    },
    {
      type = "objectgroup",
      name = "Shape",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 8,
          name = "",
          type = "",
          shape = "polyline",
          x = 46.5,
          y = 264,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polyline = {
            { x = 0, y = 0 },
            { x = 20, y = -21 },
            { x = 48.5, y = -20.5 },
            { x = 48.5, y = -1.5 },
            { x = 25, y = 23.5 },
            { x = 0.5, y = 1 }
          },
          properties = {
            ["id"] = "yellow-shape",
            ["offsetX"] = -5,
            ["offsetY"] = 4
          }
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "polyline",
          x = 177.5,
          y = 231,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polyline = {
            { x = 0, y = 0 },
            { x = 49, y = 0 },
            { x = 49, y = 49 },
            { x = 31, y = 42 },
            { x = 19, y = 35.5 },
            { x = 9.5, y = 22 },
            { x = 2.5, y = 8.5 },
            { x = 0.5, y = 1 }
          },
          properties = {
            ["id"] = "brown-shape",
            ["offsetX"] = -1,
            ["offsetY"] = -2
          }
        }
      }
    }
  }
}
