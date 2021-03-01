# Corona Tiled #

Library for connecting [Solar2D Game Engine](https://solar2d.com/) (previously known as Corona SDK) with [Tiled Map Editor](http://www.mapeditor.org/)

### Features ###
* Extendable selector for objects defined in tilemap (lua export format)
* Mapping from Tiled tileset to Corona image sheet (only tilesets - not single images - are currently supported)
* Tiled "polyline" conversion to Corona polygon or physics body shape

### Characteristics ###
* Nothing happens under the hood. Each element has to be retrieved (using selector) and used the way developer wants.
* Strict layer separation. Corona code doesn't touch Tiled map structure, but takes all needed informations from proxy objects.
* No programming in Tiled - only level design and object positioning (lua language is better suited for programming than Tiled)

### Repository structure ###

* The whole repo is Solar2D Game Engine project
* Library code resides in `tiled` directory (it can be included in other project by copying or creating symlink)
* Code snippets can be found in `main.lua` (it is also very simple test suite which is executed after corona simulator starts)
* `corona.lua` module contains helper methods which usually can do common operations on selector results

### Currently supported object types ###

* image (rectangle with image) -> `Object`
* tileset -> table of `Tile`
* rectangle -> `Rectangle`
* polyline -> `Shape`

### Object custom properties ###

* id (string)
* class (string values separated by space)
* offsetX (applies only for Shape and is used for adjusting shape position to match exactly i.e. some image physics body)
* offsetY (the same as above, but for Y axis)

### Examples ###
* create selector

```lua
local exportedTable = require "exported"
local tiledSelector = require "tiled.selector"
local selector = tiledSelector.create(exportedTable)
```
Tilemap has to be exported to `exported.lua` file and placed in project directory.

* get object by id

```lua
local proxyObject = selector.getObjectById("some-unique-id")
```
You have to set custom property `id` with (string) value `some-unique-id` in Tiled map editor object property inspector.

* display object above

```lua
local image = corona.newImage(proxyObject)
```
This helper method takes object found by selector as an argument and returns regular Corona SDK `DisplayObject`

* add polygonal shape physics body to image

```lua
local corona = require "tiled.corona"

local object = selector.getObjectById('some-unique-id')
local shape = selector.getObjectById('shape-for-my-object')
local params = {shape=shape.points, density=3.0, friction=0.5, bounce=0.3}
local image = corona.newImage(object)
physics.addBody(image, params)
```

* extend selector with method

```lua
local index = require "tiled.index"
local adapter = require "tiled.adapter"
local physics = require "physics"

selector.addAdapter(adapter.Object(
    index.One2Many("byGid", "tileGid")
  ), function(index)
    return {
      findObjectsByTileGid = function(gid)
        return index.byGid[gid]
      end
    }
  end
)
```
This adds method `findObjectsByTileGid` to selector. Object must contain `tileGid` attribute to be indexed (and found) by method.

* for more examples see `main.lua` module

### Contact ###
rzeszut.michal@gmail.com
