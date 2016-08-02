local function BaseObject(layerName, x, y, width, height)
  local self = {
    layerName = layerName,
    width = width,
    height = height
  }

  function self.setCoordinates(x, y)
    -- FIXME: delegate to separate object
    local _width = self.width or 0
    local _height = self.height or 0
    local _x = x or 0
    local _y = y or 0
    self.coordinates = {
      x = _x + _width / 2,
      y = _y + _height / 2
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


local function Shape(layerName, x, y, id, classes, polyline, offsetX, offsetY)
  local self = Rectangle(layerName, x, y, nil, nil, id, classes)
  self.points = {}
  self.minX = 9999
  self.minY = 9999
  self.maxX = 0
  self.maxY = 0

  local offsetX = offsetX or 0
  local offsetY = offsetY or 0

  -- TODO: refactor

  for idx, pair in ipairs(polyline) do
    if pair.x < self.minX then self.minX = pair.x end
    if pair.y < self.minY then self.minY = pair.y end
    if pair.x > self.maxX then self.maxX = pair.x end
    if pair.y > self.maxY then self.maxY = pair.y end
  end

  self.setSize(self.maxX - self.minX, self.maxY - self.minY)
  self.setCoordinates(x + self.minX, y + self.minY)

  for idx, pair in ipairs(polyline) do
    table.insert(self.points, pair.x + x - self.coordinates.x + offsetX)
    table.insert(self.points, pair.y + y - self.coordinates.y + offsetY)
  end

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


return {
  Tile = Tile,
  Object = Object,
  Rectangle = Rectangle,
  Shape = Shape,
  Tileset = Tileset
}
