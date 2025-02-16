extends Node2D

enum Tool {
	Point = 1,
	Circle = 2,
	Ring = 3,
	Line = 4
}

var tiles: Dictionary = {}
var ghost: Array[Vector3i] = []
var anchor: Vector3i
var unit: float = 48.0
var tool: Tool = Tool.Point
var pressed: bool = false

@onready var tool_selector: OptionButton = %ToolSelector


func _ready() -> void:
	tool_selector.item_selected.connect(select_tool)
	#tiles.push_back(Vector3i.ZERO)
	queue_redraw()
	pass


func _draw() -> void:
	for t in tiles.values():
		draw_hex(t, Color.WHITE)
	for s in ghost:
		draw_hex(s, Color.ROYAL_BLUE)
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		update_tool()
		pass
	if event is InputEventMouseButton:
		pressed = event.pressed
		if event.pressed:
			start_tool()
		else:
			finish_tool()
		pass
	pass


func select_tool(index: int) -> void:
	tool = tool_selector.get_item_id(index) as Tool
	pass


func start_tool() -> void:
	var pos = get_global_mouse_position()
	var hex = Hex.pixel_to_cube(pos / unit)
	match tool:
		Tool.Point:
			pass
		Tool.Circle:
			anchor = hex
			pass
		Tool.Ring:
			anchor = hex
			pass
		Tool.Line:
			anchor = hex
			pass
			
	queue_redraw()
	pass


func finish_tool() -> void:
	var pos = get_global_mouse_position()
	var hex = Hex.pixel_to_cube(pos / unit)
	match tool:
		Tool.Point:
			pass
		Tool.Circle:
			for h in Hex.cube_circle(anchor, Hex.distance(anchor, hex)):
				put(h)
			pass
		Tool.Ring:
			for h in Hex.cube_ring(anchor, Hex.distance(anchor, hex)):
				put(h)
			pass
		Tool.Line:
			for h in Hex.cube_line(anchor, hex):
				put(h)
			pass
		
	queue_redraw()
	pass


func update_tool() -> void:
	var pos = get_global_mouse_position()
	var hex = Hex.pixel_to_cube(pos / unit)
	
	match tool:
		Tool.Point:
			ghost = [hex]
			if pressed:
				put(hex)
			pass
		Tool.Circle:
			if pressed:
				ghost = Hex.cube_circle(anchor, Hex.distance(anchor, hex))
			else:
				ghost = [hex]
			pass
		Tool.Ring:
			if pressed:
				ghost = Hex.cube_ring(anchor, Hex.distance(anchor, hex))
			else:
				ghost = [hex]
			pass
		Tool.Line:
			if pressed:
				ghost = Hex.cube_line(anchor, hex)
			else:
				ghost = [hex]
			pass
	
	queue_redraw()
	pass


func draw_hex(hex: Vector3i, color: Color) -> void:
	var turn = PI / 3.0
	var c = Hex.cube_to_pixel(hex)
	var r = 1.0 / sqrt(3)
	for i in 6:
		var a = i * turn
		var b = a + turn
		var va = c + Vector2.UP.rotated(a) * r
		var vb = c + Vector2.UP.rotated(b) * r
		draw_line(va * unit, vb * unit, color, 1.0, true)
	pass


func put(hex: Vector3i) -> void:
	tiles[str(hex)] = hex
	pass
