local function BaseObject(layerName, x, y, width, height)
  local self = {
    layerName = layerName,
    width = width,
    height = height
  }

  function self.setCoordinates(x, y)
    self.coordinates = {
      x = x + self.width / 2,
      y = y + self.height / 2
    }
  end

  function self.setSize(width, height)
    self.width = width
    self.height = height
  end

  self.setSize(width, height)
  self.setCoordinates(x, y)

  return self
end


local function WithIdAndClasses(object, id, classes)
  object.id = id
  object.classes = classes
  return object
end


local function Rectangle(layerName, x, y, width, height, id, classes)
  local self = BaseObject(layerName, x, y, width, height)
  return WithIdAndClasses(self, id, classes)
end


local function Shape(layerName, x, y, id, classes, boundsFactory, offsetX, offsetY)
  local offsetX = offsetX or 0
  local offsetY = offsetY or 0
  local bounds = boundsFactory.makeBounds()

  local self = Rectangle(
    layerName,
    x + bounds.minX, y + bounds.minY,
    bounds.maxX - bounds.minX, bounds.maxY - bounds.minY,
    id, classes
  )

  self.points = boundsFactory.createPoints(
    x - self.coordinates.x + offsetX,
    y - self.coordinates.y + offsetY
  )

  return self
end


local function Tile(selector, layerName, tileGid, x, y, width, height)
  local self = BaseObject(layerName, x, y, width, height)
  self.tileGid = tileGid

  function self.getTileInfo()
    return selector.findTilesetByGid(self.tileGid).asTileInfo(self.tileGid)
  end

  return self
end


local function Object(selector, layerName, tileGid, x, y, width, height, id, classes)
  local self = Tile(selector, layerName, tileGid, x, y, width, height)
  return WithIdAndClasses(self, id, classes)
end


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


local function BoundsFactory(polyline)
  local self = {}

  function self.makeBounds()
    local bounds = {
      minX = 9999,
      minY = 9999,
      maxX = 0,
      maxY = 0
    }

    for idx, pair in ipairs(polyline) do
      if pair.x < bounds.minX then bounds.minX = pair.x end
      if pair.y < bounds.minY then bounds.minY = pair.y end
      if pair.x > bounds.maxX then bounds.maxX = pair.x end
      if pair.y > bounds.maxY then bounds.maxY = pair.y end
    end

    return bounds
  end

  function self.createPoints(fullOffsetX, fullOffsetY)
    local points = {}

    for idx, pair in ipairs(polyline) do
      table.insert(points, pair.x + fullOffsetX)
      table.insert(points, pair.y + fullOffsetY)
    end

    return points
  end

  return self
end

return {
  Tile = Tile,
  Object = Object,
  Rectangle = Rectangle,
  Shape = Shape,
  Tileset = Tileset,
  BoundsFactory = BoundsFactory
}
