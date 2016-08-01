display.setDefault("isImageSheetSampledInsideFrame", true)
display.setStatusBar(display.HiddenStatusBar)

local tiledSelector = require "tiled.selector"
local corona = require "tiled.corona"
local exampleTable1 = require "example1"

local selector = tiledSelector.create(exampleTable1)

local brownElements = selector.findObjectsByClass("brown")
local yellowElements = selector.findObjectsByClass("yellow")
local mainBrownElement = selector.getObjectById("brown-main-thing")
local mainYellowElement = selector.getObjectById("yellow-main-thing")
local tiles = selector.findTilesByLayerName('Background')


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

test["find objects by layer name"] = function()
  local collisionObjects = selector.findObjectsByLayerName("Collision")
  assert(#collisionObjects == 2)
end

test["1 display tiles"] = function()
  images = corona.newImages(tiles)
  assert(#images == 64)
  assert(images[tiles[1]] == images[1])
end

test["2 display image"] = function()
  corona.newImages(brownElements)
  corona.newImages(yellowElements)

  local yellowShape = selector.getObjectById('yellow-shape')
  local polygon = corona.newPolygon(yellowShape)

  local brownShape = selector.getObjectById('brown-shape')
  local polygon = corona.newPolygon(brownShape)
end

test["display colision rectangles"] = function()
  local objects = selector.findObjectsByLayerName("Collision")
  for idx, object in ipairs(objects) do
    corona.newRect(object)
  end
end

testrunner.run(test)
