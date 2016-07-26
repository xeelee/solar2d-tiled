display.setStatusBar(display.HiddenStatusBar)

local tiled = require "tiled"
local selector = tiled.create("example1.json")
local brownElements = selector.findElementsByClass("brown")
local mainBrownElement = selector.getElementById("brown-main-thing")


local testrunner = require "testrunner"
local test = {}

test["compare element found by id to the one found by class"] = function()
  for idx, element in ipairs(brownElements) do
    if element.id ~= nil then
      assert(element == mainBrownElement)
    end
  end
end

test["get tile sheet info"] = function()
  local sheetInfo = mainBrownElement.getSheetInfo()
  assert(sheetInfo.width == 64)
  assert(sheetInfo.height == 64)
  assert(sheetInfo.fileName == "example.png")
  assert(sheetInfo.numFrames == 8)
end

test["display element"] = function()
  local sheetInfo = mainBrownElement.getSheetInfo()
  local options = {
    width = sheetInfo.width,
    height = sheetInfo.height,
    numFrames = sheetInfo.numFrames
  }
  local sheet = graphics.newImageSheet(sheetInfo.fileName, options)
  local frame = display.newImage(sheet, sheetInfo.id)
end

testrunner.run(test)
