@tool
class_name NSprite3D
extends Node3D


@export var texture: Texture2D: set = set_texture, get = get_texture

@onready var mesh: MeshInstance3D = %Mesh


func set_texture(value: Texture2D) -> void:
	texture = value
	if is_instance_valid(mesh):
		var material: ShaderMaterial = mesh.mesh.material
		material.set_shader_parameter(&"texture_albedo", texture)
	pass


func get_texture() -> Texture2D:
	return texture
