local function newPolygon(object)
  return display.newPolygon(object.coordinates.x, object.coordinates.y, object.points)
end


local function newRect(object)
    return display.newRect(object.coordinates.x, object.coordinates.y, object.width, object.height)
end


local function newImage(object)
  local tileInfo = object.getTileInfo()
  local options = {
    width = tileInfo.width,
    height = tileInfo.height,
    numFrames = tileInfo.numFrames
  }
  local sheet = graphics.newImageSheet(tileInfo.fileName, options)
  local image = display.newImage(sheet, tileInfo.id)
  image.x = object.coordinates.x
  image.y = object.coordinates.y
  -- debug
  --image:setStrokeColor(1, 0, 0)
  --image.strokeWidth = 1
  return image
end


local function newImages(objectTable)
  images = {}
  for idx, object in ipairs(objectTable) do
    local image = newImage(object)
    images[object] = image
    table.insert(images, image)
  end
  return images
end


return {
  newPolygon = newPolygon,
  newRect = newRect,
  newImage = newImage,
  newImages = newImages
}
