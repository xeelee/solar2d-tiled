local function Object(selector, id, classes, layerName, tileGid)
  local self = {}
  self.selector = selector
  self.id = id
  self.classes = classes
  self.layerName = layerName
  self.tileGid = tileGid

  function self.getTileInfo()
    return self.selector.findTilesetByGid(self.tileGid).asTileInfo(self.tileGid)
  end

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
  Object = Object,
  Tileset = Tileset
}
