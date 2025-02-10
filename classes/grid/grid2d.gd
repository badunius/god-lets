class_name Grid2D
extends RefCounted



var vx: Dictionary = {}


func a_star() -> AStar2D:
	var res = AStar2D.new()
	
	for key in vx.keys():
		res.add_point(key, vx[key].pos)
	
	for key in vx.keys():
		for c in vx[key].conn:
			res.connect_points(key, c)
	
	return res


func from_a_star(star: AStar2D) -> void:
	vx = {}
	
	for key in star.get_point_ids():
		vx[key] = Vertex2D.new(star.get_point_position(key))
		for c in star.get_point_connections(key):
			vx[key].connect_to(c)
	pass


func from_tris(tris: PackedInt32Array, vertices: PackedVector2Array) -> void:
	vx = {}
	
	for t in range(0, len(tris), 3):
		for i in 3:
			var id = tris[t + i]
			add_vertex(id, vertices[id])
		for i in 3:
			var this = tris[t + i]
			var prev = tris[t + (i + 2) % 3]
			var next = tris[t + (i + 1) % 3]
			add_edge(this, prev)
			add_edge(this, next)
	pass


func add_vertex(id: int, pos: Vector2) -> void:
	if vx.has(id) == false:
		vx[id] = Vertex2D.new(pos)
	pass


func add_edge(a: int, b: int, two_way: bool = false) -> void:
	if vx.has(a) == false or vx.has(b) == false:
		return
	vx[a].connect_to(b)
	if two_way:
		vx[b].connect_to(a)
	pass


# Removes all edges from all vertices
func clear_edges() -> void:
	for id in vx.keys():
		vx[id].conn = []
	pass


func get_vertices() -> PackedVector2Array:
	var res = PackedVector2Array([])
	res.resize(vx.size())
	
	for key in vx.keys():
		res[key] = vx[key].pos
	
	return res


## Returns list of unique edges as pairs of vertex indices packed in an array
func get_edges() -> PackedInt32Array:
	var res = []
	var dict = {}
	
	for key in vx.keys():
		for c in vx[key].conn:
			var pair = [
				min(key, c),
				max(key, c)
			]
			dict[str(pair)] = pair
	
	for pair in dict.values():
		res.push_back(pair[0])
		res.push_back(pair[1])
	
	return PackedInt32Array(res)


class Vertex2D:
	var pos: Vector2
	var conn: Array[Vertex2D]
	
	func _init(position: Vector2) -> void:
		pos = position
		conn = []
	
	func connect_to(v: Vertex2D) -> void:
		if conn.has(v) == false:
			conn.push_back(v)
	
	func disconnect_from(v: Vertex2D) -> void:
		var key = conn.find(v)
		if key >= 0:
			conn.remove_at(key)
