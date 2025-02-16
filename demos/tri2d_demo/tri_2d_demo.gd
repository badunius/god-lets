extends Node2D

const UNIT = 240
const SNAP = 12

var tri: Tri2D
var point: Vector2 = Vector2.ZERO

@onready var x: Handle = %X
@onready var a: Handle = %A
@onready var b: Handle = %B
@onready var c: Handle = %C


func _ready() -> void:
	var vx: Array[Vector2] = []
	for i in 3:
		var v = Vector2.UP.rotated(PI * 2.0 / 3.0 * i) * UNIT
		vx.push_back(v)
	tri = Tri2D.new(vx)
	
	x.position = point
	a.position = tri.a
	a.color = Color.RED
	b.position = tri.b
	b.color = Color.GREEN
	c.position = tri.c
	c.color = Color.BLUE
	
	pass


func _draw() -> void:
	var w = tri.weight(point).clamp(Vector3.ZERO, Vector3.ONE)
	var color = Color(w.x, w.y, w.z)
	draw_tri(tri.a, tri.b, tri.c, Color.WHITE, color)
	draw_tri(tri.a, tri.b, point, Color.WHITE)
	draw_tri(tri.b, tri.c, point, Color.WHITE)
	draw_tri(tri.a, tri.c, point, Color.WHITE)
	pass


func _process(_delta: float) -> void:
	tri = Tri2D.new([
		a.position,
		b.position,
		c.position,
	])
	var w = tri.weight(point)
	if tri.is_valid(w):
		x.color = Color.WHITE
	else:
		x.color = Color.BLACK
	point = x.position
	queue_redraw()
	pass

func draw_tri(a: Vector2, b: Vector2, c: Vector2, stroke: Color, fill: Color = Color.TRANSPARENT) -> void:
	var pts = PackedVector2Array([a, b, c, a])
	draw_colored_polygon(pts, fill)
	draw_polyline(pts, stroke, 0.5, true)
	pass


func _unhandled_input(event: InputEvent) -> void:
	pass


func on_handle_hover(id: int) -> void:
	pass


func on_handle_leave(id: int) -> void:
	pass
