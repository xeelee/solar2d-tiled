local function IndexBuilder(adapter)
  local self = {}

  function self.buildIndex(selector, tiledTable)
    local index = adapter.createIndex()
    local dataIterator = adapter.getDataIterator(tiledTable)
    for data in dataIterator do
      local adapted = adapter.adaptData(selector, data)
      adapter.addToIndex(adapted, index)
    end
    return index
  end

  return self
end


local function Single(idxName, attrName)
  local self = {
    idxName = idxName,
    attrName = attrName
  }

  function self.apply(adapted, index)
    if adapted[attrName] ~= nil then
      index[idxName][adapted[attrName]] = adapted
    end
  end

  return self
end


local function Multi(idxName, attrName)
  local self = {
    idxName = idxName,
    attrName = attrName
  }

  function self.apply(adapted, index)
    for idx, val in ipairs(adapted[attrName]) do
      if index[idxName][val] == nil then index[idxName][val] = {} end
      table.insert(index[idxName][val], adapted)
    end
  end

  return self
end


return {
  IndexBuilder = IndexBuilder,
  Single = Single,
  Multi = Multi
}
