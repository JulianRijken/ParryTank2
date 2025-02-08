extends Node3D

@onready var topView: Camera3D = $TopView
@onready var sideView: Camera3D = $SideView

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	CameraTransition.transition_camera3D(sideView,topView,4)
	
