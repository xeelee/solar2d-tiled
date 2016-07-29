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
  image.anchorX = 0
  image.anchorY = 0
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
  newImage = newImage,
  newImages = newImages
}
