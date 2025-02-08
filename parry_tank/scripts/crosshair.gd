extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _input(event):
	if event is InputEventMouseMotion:
		position = get_global_mouse_position() - size / 2.0
		
