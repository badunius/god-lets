class_name Handle
extends Area2D


@export var color: Color: set = set_color
@export var size: float = 12: set = set_size

var hover: bool = false: set = set_hover
var dragged: bool = false

func _ready() -> void:
	mouse_entered.connect(func (): set_hover(true))
	mouse_exited.connect(func (): set_hover(false))
	input_event.connect(on_input)
	pass


func _draw() -> void:
	if hover:
		draw_circle(Vector2.ZERO, size, color, true, -1.0, true)
	else:
		draw_circle(Vector2.ZERO, size, color, false, 1.0, true)
	pass


func set_color(value: Color) -> void:
	color = value
	queue_redraw()
	pass


func set_size(value: float) -> void:
	size = value
	queue_redraw()
	pass


func set_hover(value: bool) -> void:
	hover = value
	if hover:
		Input.set_default_cursor_shape(Input.CURSOR_MOVE)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	queue_redraw()
	pass


func on_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		dragged = event.pressed
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed == false:
			dragged = false
	if event is InputEventMouseMotion:
		if dragged:
			position += event.relative
	pass
