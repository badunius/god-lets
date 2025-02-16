extends Node2D

const MAX_POINTS = 1000
const UNIT = 120

var mode: int = 0
var points: Array[Vector2] = []

@onready var mode_selector: OptionButton = %ModeSelector


func _ready() -> void:
	mode_selector.item_selected.connect(select_mode)
	pass


func _draw() -> void:
	for p in points:
		draw_circle(p * UNIT, 2, Color.WHITE)
	pass


func _physics_process(_delta: float) -> void:
	match mode:
		0: points.push_back(Rand.v2())
		1: points.push_back(Rand.v2u())
		2: points.push_back(Rand.v2m())
	if len(points) > MAX_POINTS:
		points = points.slice(-MAX_POINTS)
	queue_redraw()
	pass


func select_mode(index: int) -> void:
	mode = index
	points = []
	pass
