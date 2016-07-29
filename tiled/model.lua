local function Tile(selector, layerName, tileGid, x, y)
  local self = {
    layerName = layerName,
    tileGid = tileGid,
    coordinates = {
      x = x,
      y = y
    }
  }

  function self.getTileInfo()
    return selector.findTilesetByGid(self.tileGid).asTileInfo(self.tileGid)
  end

  function self.setCoordinates(x, y)
    self.coordinates.x = x
    self.coordinates.y = y
  end

  return self
end


local function Object(selector, layerName, tileGid, x, y, id, classes)
  local self = Tile(selector, layerName, tileGid, x, y)
  self.id = id
  self.classes = classes

  return self
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
  Tileset = Tileset
}
