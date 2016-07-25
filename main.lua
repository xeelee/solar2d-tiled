display.setStatusBar(display.HiddenStatusBar)

local tiled = require "tiled"
local selector = tiled.create("example1.json")
local greenElements = selector.findByClass("green")
local testElement = selector.getById("test-id-1")


local testrunner = require "testrunner"
local test = {}

test["compare element found by id to the one found by class"] = function()
  for idx, element in ipairs(greenElements) do
    assert(element.id == testElement.id)
  end
end

test["always fail"] = function()
  assert(false)
end

testrunner.run(test)
