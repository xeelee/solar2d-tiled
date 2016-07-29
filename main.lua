display.setDefault("isImageSheetSampledInsideFrame", true)
display.setStatusBar(display.HiddenStatusBar)

local tiledSelector = require "tiled.selector"
local corona = require "tiled.corona"
local exampleTable1 = require "example1"

local selector = tiledSelector.create(exampleTable1)

local brownElements = selector.findObjectsByClass("brown")
local yellowElements = selector.findObjectsByClass("yellow")
local mainBrownElement = selector.getObjectById("brown-main-thing")
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

test["1 display tiles"] = function()
  images = corona.newImages(tiles)
  assert(#images == 64)
  assert(images[tiles[1]] == images[1])
end

test["2 display image"] = function()
  corona.newImages(brownElements)
  corona.newImages(yellowElements)
end

test["sandbox"] = function()
  local inspect = require "inspect"
  print(inspect(tiles[35]))
  print(inspect(mainBrownElement))
  print(inspect(mainBrownElement.getTileInfo()))
  print(inspect(tiles[1]))
end

testrunner.run(test)
