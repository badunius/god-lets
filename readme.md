# README

A set of GDScript code snippets and components.

Every script is documented to the best of my abilities, therefore this readme contains only an overview of the library.

## Classes

A list of classes derived from `RefCounted`.

### Grid2D

A non-uniform 2D grid. Primary use case is overland map structure (a set of interconnected PoI). Can import/export graph data from Astar2D. Can create a grid from `Geometry2D.triangulate_delaunay`. So basically you can triangulate a bunch of points and get an `Astar2D` from it like this:

```gdscript
	var grid := Grid2D.new()
	var vx := PackedVector2Array([...])
	var tris := Geometry2D.triangulate_delaunay(vx)
	grid.from_tris(tris, vx)
	var a_star := grid.a_star()
```

Also you can get a list of edges packed the way `Mesh.PRIMITIVE_LINES` expects it to be.

### Hex

Hex grid utils. Basically ported from https://www.redblobgames.com/grids/hexagons/. I used `Vector3i` for cube-coordinates and `Vector2i` for axial-coordinates. Implementing own data-types for hexes would be too much trouble for no obvious gain.

Nota Bene:

- Pixel<->Grid convertion was implemented for a grid of unit (1.0) wide pointy-top hexes.
- If you are going to work with flat-top hexes, you would probably need to switch X and Y components.
- If you are going to use those utilities along with a `TileMap(Layer)`, you're gonna need an apropriate convertion function for your specific tile size.

### Rand

An assortment of static functions for generating random vectors. Because `Rand.v2()` is much more handy than `Vector2(randf(), randf())`. There are `v2` functions for `Vector2` and `v3` functions for `Vector3`.

- `-u` functions returns a vector which components goes from -1 to 1. When you need a uni-directional offset
- `-m` functions do the same but limit the result to the circle using Monte-Carlo method

### Tri2D

Created to rasterize triangle. Original use case: generate randomized mesh -> triangulate delaunay -> rasterize the mesh on `TileMapLayer`.

Additionaly might be used to create Triangular adjustment slider, like the one used in Fallout 4 to adjust body build.

Code ported from here https://jtsorlinis.github.io/rendering-tutorial/  
Made some adjustments to include "pixels" that are directly on the edge, otherwise there was gaps sometimes when rendering adjanced triangles.

## Comps

A list of Components derived from `Node(2/3D)`

### USprite3D

Essentialy a `Sprite3D`, but limited to a 1 by 1 square. Solves the problem of `pixel_size`. I **don't** want to care which pixel size is. I want my sprite to be of fixed size, no matter the size of the image I drop there. This component solves this exact problem. It doesn't support animation frames. All it does is center, fit and snap the image to the bottom of the quad.

## Demos

Folder contains scenes demonstrating functionality of the classes/components from above.
