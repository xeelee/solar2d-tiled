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

test["display image"] = function()
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
