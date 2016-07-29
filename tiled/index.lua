local function IndexBuilder(adapter)
  local self = {}

  function self.buildIndex(selector, tiledTable)
    local index = self.createIndex(adapter.indices)
    local dataIterator = adapter.getDataIterator(tiledTable)
    for data in dataIterator do
      local adapted = adapter.adaptData(selector, data)
      self.addToIndex(adapter.indices, adapted, index)
    end
    return index
  end

  function self.createIndex(indices)
    local index = {}
    for idx, indexObj in ipairs(indices) do
      indexObj.initialize(index)
    end
    return index
  end

  function self.addToIndex(indices, adapted, index)
    if adapted ~= nil then
      for idx, indexObj in ipairs(indices) do
        indexObj.apply(adapted, index)
      end
    end
  end

  return self
end


local function One2One(idxName, attrName)
  local self = {
    idxName = idxName,
    attrName = attrName
  }

  function self.initialize(index)
      index[idxName] = {}
  end

  function self.apply(adapted, index)
    if adapted[attrName] ~= nil then
      index[idxName][adapted[attrName]] = adapted
    end
  end

  return self
end

local function One2Many(idxName, attrName)
  local self = One2One(idxName, attrName)

  function self.apply(adapted, index)
    for idx, val in ipairs(self.getValuesTable(adapted)) do
      if index[idxName][val] == nil then index[idxName][val] = {} end
      table.insert(index[idxName][val], adapted)
    end
  end

  function self.getValuesTable(adapted)
    return {adapted[attrName]}
  end

  return self
end

local function Many2Many(idxName, attrName)
  local self = One2Many(idxName, attrName)

  function self.getValuesTable(adapted)
    return adapted[attrName]
  end

  return self
end


local function Range(rangeFactory)
  local self = {}

  function self.initialize(index)
  end

  function self.apply(adapted, index)
    local start, stop = rangeFactory(adapted)
    for i=start, stop do
      index[i] = adapted
    end
  end

  return self
end


return {
  IndexBuilder = IndexBuilder,
  One2One = One2One,
  One2Many = One2Many,
  Many2Many = Many2Many,
  Range = Range
}
