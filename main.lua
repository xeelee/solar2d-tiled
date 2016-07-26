display.setStatusBar(display.HiddenStatusBar)

local tiled = require "tiled"
local selector = tiled.create("example1.json")
local brownElements = selector.findByClass("brown")
local mainBrownElement = selector.getById("brown-main-thing")


local testrunner = require "testrunner"
local test = {}

test["compare element found by id to the one found by class"] = function()
  for idx, element in ipairs(brownElements) do
    if element.id ~= nil then
      assert(element == mainBrownElement)
    end
  end
end

testrunner.run(test)
