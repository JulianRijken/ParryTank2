extends MultiplayerSynchronizer

@onready var tank: Tank = $Tank
@onready var tankTop: Node3D = $Tank/RotatePoint/Top

# Replicated
var input_aim_direction: Vector2
var input_move_direction: Vector2

func _input(event: InputEvent) -> void:
	if get_multiplayer_authority() == multiplayer.get_unique_id():	
		if event.is_pressed() and event.is_action("fire"):
			fire_input.rpc_id(1)

@rpc("call_local","reliable")
func fire_input():
	tank.fire()

func _process(_delta: float) -> void:

	# Allow authority to change input
	if get_multiplayer_authority() == multiplayer.get_unique_id():	
		# Update move input
		var inputDirection := Input.get_vector("moveLeft", "moveRight", "moveDown", "moveUp")
		input_move_direction = inputDirection
		
		# Update aim input
		var aimPlane  = Plane(Vector3(0, 1, 0),tankTop.global_position)
		var mousePosition2D = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_3d()
		var mousePosition3D = aimPlane.intersects_ray(
									camera.project_ray_origin(mousePosition2D),
									camera.project_ray_normal(mousePosition2D))
		if mousePosition3D != null:
			var aimDirection = mousePosition3D - tankTop.global_position
			input_aim_direction = Vector2(aimDirection.x,aimDirection.z)
			
	# Allow the server to apply input
	if multiplayer.is_server():
		tank.set_move_input(input_move_direction)
		tank.set_aim_input(input_aim_direction)
