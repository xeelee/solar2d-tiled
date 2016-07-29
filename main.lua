display.setDefault("isImageSheetSampledInsideFrame", true)
display.setStatusBar(display.HiddenStatusBar)

local tiledSelector = require "tiled.selector"
local exampleTable1 = require "example1"
local selector = tiledSelector.create(exampleTable1)
local brownElements = selector.findObjectsByClass("brown")
local mainBrownElement = selector.getObjectById("brown-main-thing")


local testrunner = require "testrunner"
local test = {}

test["compare element found by id to the one found by class"] = function()
  for idx, element in ipairs(brownElements) do
    if element.id ~= nil then
      assert(element == mainBrownElement)
    end
  end
end

test["get tile info"] = function()
  local tileInfo = mainBrownElement.getTileInfo()
  assert(tileInfo.width == 64)
  assert(tileInfo.height == 64)
  assert(tileInfo.fileName == "example.png")
  assert(tileInfo.numFrames == 8)
end

test["1 display tiles"] = function()
  local tiles = selector.findTilesByLayerName('Background')
  for idx, tile in ipairs(tiles) do
    tileInfo = tile.getTileInfo()
    local options = {
      width = tileInfo.width,
      height = tileInfo.height,
      numFrames = tileInfo.numFrames
    }
    local sheet = graphics.newImageSheet(tileInfo.fileName, options)
    local frame = display.newImage(sheet, tileInfo.id)
    frame.x = tile.coordinates.x
    frame.y = tile.coordinates.y
  end
end

test["2 display image"] = function()
  local tileInfo = mainBrownElement.getTileInfo()
  local options = {
    width = tileInfo.width,
    height = tileInfo.height,
    numFrames = tileInfo.numFrames
  }
  local sheet = graphics.newImageSheet(tileInfo.fileName, options)
  local frame = display.newImage(sheet, tileInfo.id)
  frame.x = mainBrownElement.coordinates.x
  frame.y = mainBrownElement.coordinates.y
end

testrunner.run(test)
