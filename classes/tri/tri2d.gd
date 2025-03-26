class_name Tri2D
extends RefCounted


var a: Vector2
var b: Vector2
var c: Vector2
var basis: float


func _init(vx: Array[Vector2]) -> void:
	a = vx[0]
	b = vx[1]
	c = vx[2]
	basis = edge(a, b, c)


## Edge fuction (signed area of a triangle)
static func edge(_a: Vector2, _b: Vector2, _c: Vector2) -> float:
	return (_b.x - _a.x) * (_c.y - _a.y) - (_b.y - _a.y) * (_c.x - _a.x)


## Returns how close the point to each of the vertices X -> A, Y -> B, Z -> C
func weight(p: Vector2) -> Vector3:
	return Vector3(
		edge(b, c, p) / basis,
		edge(c, a, p) / basis,
		edge(a, b, p) / basis,
	)


## If all the weights are positive, then the point belongs to the triangle
func is_valid(weights: Vector3) -> bool:
	return weights.x >= 0 and weights.y >= 0 and weights.z >= 0


## Bounding rect of a triangle
func bounds() -> Rect2:
	var v_min = a
	var v_max = a
	for v in [b, c]:
		v_min = v_min.min(v)
		v_max = v_max.max(v)
	return Rect2i(v_min, v_max - v_min)


static func delaunay(points: PackedVector2Array) -> Array[Tri2D]:
	var res: Array[Tri2D] = []
	
	var tx = Geometry2D.triangulate_delaunay(points)
	for t in range(0, len(tx), 3):
		res.push_back(Tri2D.new([
			points[tx[t + 0]],
			points[tx[t + 1]],
			points[tx[t + 2]],
		]))
	
	return res
