## A set of functions to operate on a hex grid.
## Ported from [[https://www.redblobgames.com/grids/hexagons/implementation.html]].
## I skipped implementing structures, since godot already have Vec3 and Vec3i
class_name Hex
extends RefCounted


const CUBE_DIRECTIONS = [
	Vector3i(+1, 0, -1), Vector3i(+1, -1, 0), Vector3i(0, -1, +1), 
	Vector3i(-1, 0, +1), Vector3i(-1, +1, 0), Vector3i(0, +1, -1), 
]


## Returns cube-coordinates of hexes adjanced to the provided
static func around(hex: Vector3i) -> Array[Vector3i]:
	var res: Array[Vector3i] = []
	res.resize(6)
	for n in 6:
		res[n] = hex + CUBE_DIRECTIONS[n]
	return res


## Converts axial-coordinates to cube coordinates
static func from_axial(q: int, r: int) -> Vector3i:
	var s = -q - r
	return Vector3i(q, r, s)


## Rounds fractional cube-coordinates to the integer ones
static func cube_round(frac: Vector3) -> Vector3i:
	var q = round(frac.x)
	var r = round(frac.y)
	var s = round(frac.z)
	
	var q_diff = abs(q - frac.x)
	var r_diff = abs(r - frac.y)
	var s_diff = abs(s - frac.z)

	if q_diff > r_diff and q_diff > s_diff:
		q = -r-s
	elif r_diff > s_diff:
		r = -q-s
	else:
		s = -q-r

	return Vector3i(q, r, s)


## Rounds fractional axial-coordinates to the integer ones
static func axial_round(frac: Vector2) -> Vector2i:
	var cube = cube_round(Vector3(frac.x, frac.y, -frac.x - frac.y))
	
	return Vector2i(cube.x, cube.y)


## Calculates distance between two cube-coordinates
static func distance(a: Vector3i, b: Vector3i) -> int:
	var vec = a - b
	return max(abs(vec.x), abs(vec.y), abs(vec.z))


## Assuming the circle on a hexonal grid is a hexagon consisted of hexagonal cells
## that are no further from the center th
static func cube_circle(center: Vector3i, radius: int) -> Array[Vector3i]:
	var res: Array[Vector3i] = []
	var N = radius
	for q in range(-N, N + 1):
		var left = max(-N, -q-N) 
		var right = min(+N, -q+N)
		for r in range(left, right + 1):
			var s = -q - r
			res.append(center + Vector3i(q, r, s))
	return res


static func cube_ring(center: Vector3i, radius: int) -> Array[Vector3i]:
	var res: Array[Vector3i] = []
	var hex = center + CUBE_DIRECTIONS[4] * radius
	for i in 6:
		for j in radius:
			res.append(hex)
			hex = hex + CUBE_DIRECTIONS[i]
	return res


static func cube_to_pixel(cube: Vector3i) -> Vector2:
	var res = Vector2.ZERO
	res.x = (1 * cube.x  +  1./2 * cube.y)
	res.y = (sqrt(3)/2 * cube.y)
	return res


static func pixel_to_cube(pixel: Vector2) -> Vector3i:
	var q = (1. * pixel.x  +  -sqrt(3)/3. * pixel.y)
	var r = (0. * pixel.x  +  2. * sqrt(3)/3. * pixel.y)
	
	var axial = axial_round(Vector2(q, r))
	
	return from_axial(axial.x, axial.y)
