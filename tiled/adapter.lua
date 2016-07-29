local model = require "tiled.model"


local function TileAdapter(...)
  local self = {
    indices = arg
  }

  function self.getDataIterator(tiledTable)
    local layerIdx = 1
    local dataIdx = 1
    return function()
      while layerIdx <= #tiledTable.layers do
        local layer = tiledTable.layers[layerIdx]
        if layer.data ~= nil then
          while dataIdx <= #layer.data do
            local gid = layer.data[dataIdx]
            horizontalOffset = ((dataIdx - 1) % layer.width)
            verticalOffset = math.floor((dataIdx - 1) / layer.width)
            dataIdx = dataIdx + 1
            return {
              objectData = layer,
              gid = gid,
              layerName = layer.name,
              horizontalOffset = horizontalOffset,
              verticalOffset = verticalOffset
            }
          end
        end
        dataIdx = 1
        layerIdx = layerIdx + 1
      end
    end
  end

  function self.adaptData(selector, data)
    local tile = model.Tile(selector, data.layerName, data.gid)
    local tileInfo = tile.getTileInfo()
    local x = data.objectData.x + tileInfo.width * data.horizontalOffset
    local y = data.objectData.y + tileInfo.height * data.verticalOffset
    tile.setCoordinates(x, y)
    return tile
  end

  return self
end


local function ObjectAdapter(...)
  local self = {
    indices = arg
  }

  function self.getDataIterator(tiledTable)
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

  function self.adaptData(selector, data)
    local classes = {}
    if data.objectData.properties ~= nil then
      if data.objectData.properties.class ~= nil then
        for class in string.gmatch(data.objectData.properties.class, "[^%s]+") do
          table.insert(classes, class)
        end
      end
      return model.Object(
        selector,
        data.layerName, data.objectData.gid,
        data.objectData.x, data.objectData.y,
        data.objectData.properties.id, classes
      )
    end
  end

  return self
end


local function TilesetAdapter(...)
  local self = {
    indices = arg
  }

  function self.getDataIterator(tiledTable)
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

  function self.adaptData(selector, data)
    return model.Tileset(
      data.objectData.firstgid, data.objectData.image,
      data.objectData.tilewidth, data.objectData.tileheight,
      data.objectData.imagewidth, data.objectData.imageheight
    )
  end

  return self
end

return {
  Tile = TileAdapter,
  Object = ObjectAdapter,
  Tileset = TilesetAdapter
}
