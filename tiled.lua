local json = require "json"

local function Element(data, id, classes)
  local self = {}
  self.data = data
  self.id = id
  self.classes = classes
  return self
end

local function TiledJsonAdapter(jsonString)
  local self = {}

  local jsonTable = json.decode(jsonString)

  function self.getDataIterator()
    local empty = false
    return function()
      if empty == false then
        empty = true
        return {
          properties = {
            id = "test-id-1",
            class = "green blue"
          }
        }
      end
    end
  end

  function self.adaptData(data)
    local classes = {}
    for class in string.gmatch(data.properties.class, "[^%s]+") do
      table.insert(classes, class)
    end
    return Element(data, data.properties.id, classes)
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
    elementIndex.byId[element.id] = element
    for idx, class in ipairs(element.classes) do
      if elementIndex.byClass[class] == nil then elementIndex.byClass[class] = {} end
      table.insert(elementIndex.byClass[class], element)
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
