extends CharacterBody3D

@export var _maxSpeed: float = 4.0
@export var _barrelRotateSpeed: float = 10
@export var _speedAxisMultiplier: Vector2 = Vector2(1, 1.2)
@export var _accelerationSpeed: float = 60
@export var _decellerationSpeed: float = 20
@export var _bodyRotationSpeed: float = 1.5
@export var _bullet : PackedScene

@onready var bodyMesh: MeshInstance3D = $Body
@onready var topMesh: Marker3D = $RotatePoint
@onready var firePoint: Marker3D = $RotatePoint/Top/FirePoint
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var _currentRotation: Quaternion
var _currentTargetRotation: Quaternion

func _physics_process(delta: float) -> void:
	move_tank(delta)

func _process(delta: float) -> void:
	rotate_body(delta)
	rotate_barrel(delta)

func _input(event: InputEvent) -> void:
	if event.is_pressed() and event.is_action("fire"):
		fire()
		
func fire() -> void:
	var bulletInstance = _bullet.instantiate() as Node3D
	bulletInstance.global_transform = firePoint.global_transform
	add_sibling(bulletInstance)
	animationPlayer.stop()
	animationPlayer.play("fire")
	AudioManager.play_audio("fireSoft")

func rotate_barrel(delta: float):
	var aimPlane  = Plane(Vector3(0, 1, 0),topMesh.global_position)
	var mousePosition2D = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var mousePosition3D = aimPlane.intersects_ray(
							camera.project_ray_origin(mousePosition2D),
							camera.project_ray_normal(mousePosition2D))

	# Requires a cehck when failing to intersect
	if mousePosition3D != null:
		#DebugDraw3D.draw_sphere(mousePosition3D,0.2)
		var aimDirection = mousePosition3D - topMesh.global_position
		var targetRotation = Quaternion(Vector3.UP,atan2(-aimDirection.z,aimDirection.x))
		var smoothRotation = topMesh.quaternion.slerp(targetRotation,_barrelRotateSpeed * delta)
		topMesh.quaternion = smoothRotation

func rotate_body(delta: float):
	# Update target rotation
	var targetRotation = Quaternion(Vector3.UP,atan2(-velocity.z,velocity.x))
	var angleDifference = _currentRotation.angle_to(targetRotation)
	if angleDifference > 0 and angleDifference < PI:
		_currentTargetRotation = targetRotation
	
	# Move rotation towards target
	var angleToTarget = _currentRotation.angle_to(_currentTargetRotation);
	if angleToTarget > 0:
		var rotateDelta = min(1.0,_bodyRotationSpeed * delta * velocity.length() / angleToTarget)
		_currentRotation = _currentRotation.slerp(_currentTargetRotation,rotateDelta)
	
	bodyMesh.quaternion = _currentRotation

func move_tank(delta: float):
	var inputDirection := Input.get_vector("moveLeft", "moveRight", "moveDown", "moveUp")
	var moveDirection := Vector2(inputDirection.x, inputDirection.y).normalized()
	var targetVelocity := Vector2(moveDirection * _speedAxisMultiplier) * _maxSpeed
	var currentVelocity := Vector2(velocity.x,velocity.z)
	var speedChange = Vector2(
		_accelerationSpeed if abs(moveDirection.x) > 0 else _decellerationSpeed,
		_accelerationSpeed if abs(moveDirection.y) > 0  else _decellerationSpeed)
	
	velocity.x = move_toward(currentVelocity.x,targetVelocity.x,speedChange.x * delta)
	velocity.z = move_toward(currentVelocity.y,targetVelocity.y,speedChange.y * delta)

	# Add the gravity. sureee
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
