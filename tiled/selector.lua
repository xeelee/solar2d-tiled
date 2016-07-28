local adapter = require "tiled.adapter"
local index = require "tiled.index"


local function Selector(tiledTable)
  local self = {}

  function self.addAdapter(adapter, selectorMethodsFactory)
    local index = self.buildIndex(adapter)
    for name, method in pairs(selectorMethodsFactory(index)) do
      self.addSelectorMethod(name, method)
    end
  end

  function self.buildIndex(adapter)
    local indexBuilder = index.IndexBuilder(adapter)
    return indexBuilder.buildIndex(self, tiledTable)
  end

  function self.addSelectorMethod(name, method)
    self[name] = method
  end

  return self
end


return {
  create = function(tiledTable)
    selector = Selector(tiledTable)
    selector.addAdapter(adapter.Object(
        index.Single("byId", "id"),
        index.Multi("byClass", "classes")
      ), function(index)
        return {
          getObjectById = function(id)
            return index.byId[id]
          end,
          findObjectsByClass = function(class)
            return index.byClass[class]
          end
        }
      end
    )
    selector.addAdapter(adapter.Tileset(
        index.Range(
          function(adapted)
            return adapted.firstGid, adapted.getNumFrames()
          end
        )
      ), function(index)
        return {
          findTilesets = function()
            return index
          end,
          findTilesetByGid = function(gid)
            return index[gid]
          end
        }
      end
    )
    return selector
  end
}
