local model = require "tiled.model"


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
        selector, data.objectData.properties.id, classes,
        data.layerName, data.objectData.gid,
        data.objectData.x, data.objectData.y
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
  Object = ObjectAdapter,
  Tileset = TilesetAdapter
}
