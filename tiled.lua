local json = require "json"

local function Tile(firstGid, image, tileWidth, tileHeight, imageWidth, imageHeight)
  local self = {
    firstGid = firstGid,
    image = image,
    tileWidth = tileWidth,
    tileHeight = tileHeight,
    imageWidth = imageWidth,
    imageHeight = imageHeight
  }

  function self.asSheetInfo(tileGid)
    return {
      fileName = self.image,
      width = self.tileWidth,
      height = self.tileHeight,
      numFrames = self.getNumFrames(),
      id = tileGid - self.firstGid + 1
    }
  end

  function self.getNumFrames()
    return (self.imageWidth / self.tileWidth) * (self.imageHeight / self.tileHeight)
  end

  return self
end

local function Element(selector, id, classes, layerName, tileGid)
  local self = {}
  self.selector = selector
  self.id = id
  self.classes = classes
  self.layerName = layerName
  self.tileGid = tileGid

  function self.getSheetInfo()
    return self.selector.findTileByGid(self.tileGid).asSheetInfo(self.tileGid)
  end

  return self
end

local function TiledJsonAdapter(jsonString)
  local self = {}

  local jsonTable = json.decode(jsonString)

  function self.getElementDataIterator()
    local layerIdx = 1
    local objectIdx = 1
    return function()
      while layerIdx <= #jsonTable.layers do
        local layer = jsonTable.layers[layerIdx]
        if layer.objects ~= nil then
          while objectIdx <= #layer.objects do
            local object = layer.objects[objectIdx]
            objectIdx = objectIdx + 1
            return {
              object = object,
              layerName = layer.name
            }
          end
        end
        objectIdx = 1
        layerIdx = layerIdx + 1
      end
    end
  end

  function self.getTileDataIterator()
    local tilesetIdx = 1
    return function()
      while tilesetIdx <= #jsonTable.tilesets do
        local tileset = jsonTable.tilesets[tilesetIdx]
        tilesetIdx = tilesetIdx + 1
        return {
          object = tileset
        }
      end
    end
  end

  function self.adaptElementData(selector, data)
    local classes = {}
    if data.object.properties ~= nil then
      if data.object.properties.class ~= nil then
        for class in string.gmatch(data.object.properties.class, "[^%s]+") do
          table.insert(classes, class)
        end
      end
      return Element(selector, data.object.properties.id, classes, data.layerName, data.object.gid)
    end
  end

  function self.adaptTileData(selector, data)
    return Tile(
      data.object.firstgid, data.object.image,
      data.object.tilewidth, data.object.tileheight,
      data.object.imagewidth, data.object.imageheight
    )
  end

  return self
end

local function Selector(elementAdapter)
  local self = {}

  local elementIndex = {
    byId = {},
    byClass = {}
  }
  local elementDataIterator = elementAdapter.getElementDataIterator()
  for data in elementDataIterator do
    element = elementAdapter.adaptElementData(self, data)
    if element ~= nil then
      if element.id ~= nil then
        elementIndex.byId[element.id] = element
      end
      for idx, class in ipairs(element.classes) do
        if elementIndex.byClass[class] == nil then elementIndex.byClass[class] = {} end
        table.insert(elementIndex.byClass[class], element)
      end
    end
  end

  local tiles = {}
  local tileDataIterator = elementAdapter.getTileDataIterator()
  for data in tileDataIterator do
    local tile = elementAdapter.adaptTileData(self, data)
    for i=1, tile.getNumFrames() do
      tiles[tile.firstGid + i] = tile
    end
  end

  function self.getElementById(id)
    return elementIndex.byId[id]
  end

  function self.findElementsByClass(class)
    return elementIndex.byClass[class]
  end

  function self.findTiles()
    return tiles
  end

  function self.findTileByGid(id)
    return tiles[id]
  end

  return self
end

TiledFactory = function()
  local self = {}

  function self.create(fileName)
    local file = io.open(fileName)
    local jsonString = file:read("*all")
    local elementAdapter = TiledJsonAdapter(jsonString)
    return Selector(elementAdapter)
  end

  return self
end

return {
  create = function(fileName)
    local fullPath = system.pathForFile(fileName, system.ResourceDirectory)
    return TiledFactory().create(fullPath)
  end
}
