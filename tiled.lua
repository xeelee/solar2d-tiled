local json = require "json"

local function Element(id, classes, layerName)
  local self = {}
  self.id = id
  self.classes = classes
  self.layerName = layerName
  return self
end

local function TiledJsonAdapter(jsonString)
  local self = {}

  local jsonTable = json.decode(jsonString)

  function self.getDataIterator()
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

  function self.adaptData(data)
    local classes = {}
    if data.object.properties ~= nil then
      if data.object.properties.class ~= nil then
        for class in string.gmatch(data.object.properties.class, "[^%s]+") do
          table.insert(classes, class)
        end
      end
      return Element(data.object.properties.id, classes, data.layerName)
    end
  end

  return self
end

local function Selector(elementAdapter)
  local self = {}

  local elementIndex = {
    byId = {},
    byClass = {}
  }
  local iterator = elementAdapter.getDataIterator()
  for data in iterator do
    element = elementAdapter.adaptData(data)
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

  function self.getById(id)
    return elementIndex.byId[id]
  end

  function self.findByClass(class)
    return elementIndex.byClass[class]
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
