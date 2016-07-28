local json = require "json"

local function Tileset(firstGid, image, tileWidth, tileHeight, imageWidth, imageHeight)
  local self = {
    firstGid = firstGid,
    image = image,
    tileWidth = tileWidth,
    tileHeight = tileHeight,
    imageWidth = imageWidth,
    imageHeight = imageHeight
  }

  function self.asTileInfo(tileGid)
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

local function Object(selector, id, classes, layerName, tileGid)
  local self = {}
  self.selector = selector
  self.id = id
  self.classes = classes
  self.layerName = layerName
  self.tileGid = tileGid

  function self.getTileInfo()
    return self.selector.findTilesetByGid(self.tileGid).asTileInfo(self.tileGid)
  end

  return self
end

local function TiledTableAdapter(tiledTable)
  local self = {}

  function self.getObjectDataIterator()
    local layerIdx = 1
    local objectIdx = 1
    return function()
      while layerIdx <= #tiledTable.layers do
        local layer = tiledTable.layers[layerIdx]
        if layer.objects ~= nil then
          while objectIdx <= #layer.objects do
            local objectData = layer.objects[objectIdx]
            objectIdx = objectIdx + 1
            return {
              objectData = objectData,
              layerName = layer.name
            }
          end
        end
        objectIdx = 1
        layerIdx = layerIdx + 1
      end
    end
  end

  function self.getTilesetDataIterator()
    local tilesetIdx = 1
    return function()
      while tilesetIdx <= #tiledTable.tilesets do
        local tileset = tiledTable.tilesets[tilesetIdx]
        tilesetIdx = tilesetIdx + 1
        return {
          objectData = tileset
        }
      end
    end
  end

  function self.adaptObjectData(selector, data)
    local classes = {}
    if data.objectData.properties ~= nil then
      if data.objectData.properties.class ~= nil then
        for class in string.gmatch(data.objectData.properties.class, "[^%s]+") do
          table.insert(classes, class)
        end
      end
      return Object(selector, data.objectData.properties.id, classes, data.layerName, data.objectData.gid)
    end
  end

  function self.adaptTilesetData(selector, data)
    return Tileset(
      data.objectData.firstgid, data.objectData.image,
      data.objectData.tilewidth, data.objectData.tileheight,
      data.objectData.imagewidth, data.objectData.imageheight
    )
  end

  return self
end

local function Selector(objectAdapter)
  local self = {}

  local objectIndex = {
    byId = {},
    byClass = {}
  }
  local objectDataIterator = objectAdapter.getObjectDataIterator()
  for data in objectDataIterator do
    object = objectAdapter.adaptObjectData(self, data)
    if object ~= nil then
      if object.id ~= nil then
        objectIndex.byId[object.id] = object
      end
      for idx, class in ipairs(object.classes) do
        if objectIndex.byClass[class] == nil then objectIndex.byClass[class] = {} end
        table.insert(objectIndex.byClass[class], object)
      end
    end
  end

  local tiles = {}
  local tileDataIterator = objectAdapter.getTilesetDataIterator()
  for data in tileDataIterator do
    local tile = objectAdapter.adaptTilesetData(self, data)
    for i=1, tile.getNumFrames() do
      tiles[tile.firstGid + i] = tile
    end
  end

  function self.getObjectById(id)
    return objectIndex.byId[id]
  end

  function self.findObjectsByClass(class)
    return objectIndex.byClass[class]
  end

  function self.findTilesets()
    return tiles
  end

  function self.findTilesetByGid(gid)
    return tiles[gid]
  end

  return self
end

return {
  createSelector = function(tiledTable)
    local objectAdapter = TiledTableAdapter(tiledTable)
    return Selector(objectAdapter)
  end
}
