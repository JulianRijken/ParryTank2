extends MeshInstance3D

@export var materials: Array[Material] = [
	preload("res://parry_tank/materials/block1.tres"),
	preload("res://parry_tank/materials/block2.tres"),
	preload("res://parry_tank/materials/block3.tres"),
	preload("res://parry_tank/materials/block4.tres"),
	preload("res://parry_tank/materials/block5.tres")
]

func _ready() -> void:
	set_surface_override_material(0,materials.pick_random())
