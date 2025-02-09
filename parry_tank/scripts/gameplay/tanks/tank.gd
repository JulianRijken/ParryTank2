class_name Tank extends CharacterBody3D

@export var maxSpeed: float = 4.0
@export var barrelRotateSpeed: float = 10
@export var speedAxisMultiplier: Vector2 = Vector2(1, 1.2)
@export var accelerationSpeed: float = 60
@export var decellerationSpeed: float = 20
@export var bodyRotationSpeed: float = 1.5
@export var bulletScene: PackedScene
@export var spawnRootNode: Node3D


@onready var bodyMesh: MeshInstance3D = $Body
@onready var topMesh: Marker3D = $RotatePoint
@onready var firePoint: Marker3D = $RotatePoint/Top/FirePoint
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var currentRotation: Quaternion
var currentTargetRotation: Quaternion
var moveInput: Vector2
var aimInput: Vector2

func _ready() -> void:
	if not multiplayer.is_server():
		set_process(false)
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	move_tank(delta)

func _process(delta: float) -> void:
	rotate_body(delta)
	rotate_barrel(delta)

func set_move_input(input: Vector2):
	moveInput = input
func set_aim_input(input: Vector2):
	aimInput = input

func fire() -> void:
	var bulletInstance = bulletScene.instantiate() as Node3D
	bulletInstance.global_transform = firePoint.global_transform
	spawnRootNode.get_parent().add_child(bulletInstance,true)
	fire_effect.rpc()
	
# We only wanna replicate for all
@rpc("call_local")
func fire_effect() -> void:
	animationPlayer.stop()
	animationPlayer.play("fire")
	AudioManager.play_audio("fireSoft")

func rotate_barrel(delta: float):
	var targetRotation = Quaternion(Vector3.UP,atan2(-aimInput.y,aimInput.x))
	var smoothRotation = topMesh.quaternion.slerp(targetRotation,barrelRotateSpeed * delta)
	topMesh.quaternion = smoothRotation

func rotate_body(delta: float):
	# Update target rotation
	var targetRotation = Quaternion(Vector3.UP,atan2(-velocity.z,velocity.x))
	var angleDifference = currentRotation.angle_to(targetRotation)
	if angleDifference > 0 and angleDifference < PI:
		currentTargetRotation = targetRotation
	
	# Move rotation towards target
	var angleToTarget = currentRotation.angle_to(currentTargetRotation);
	if angleToTarget > 0:
		var rotateDelta = min(1.0,bodyRotationSpeed * delta * velocity.length() / angleToTarget)
		currentRotation = currentRotation.slerp(currentTargetRotation,rotateDelta)
	
	bodyMesh.quaternion = currentRotation

func move_tank(delta: float):
	moveInput = moveInput.normalized()
	var targetVelocity := Vector2(moveInput * speedAxisMultiplier) * maxSpeed
	var currentVelocity := Vector2(velocity.x,velocity.z)
	var speedChange = Vector2(
		accelerationSpeed if abs(moveInput.x) > 0 else decellerationSpeed,
		accelerationSpeed if abs(moveInput.y) > 0  else decellerationSpeed)
	
	velocity.x = move_toward(currentVelocity.x,targetVelocity.x,speedChange.x * delta)
	velocity.z = move_toward(currentVelocity.y,targetVelocity.y,speedChange.y * delta)

	# Add the gravity. sureee
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
