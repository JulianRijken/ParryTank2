extends CharacterBody3D

@export var _maxSpeed: float = 4.0
@export var _speedAxisMultiplier: Vector2 = Vector2(1, 1.2)
@export var _accelerationSpeed: float = 55
@export var _decellerationSpeed: float = 30
@export var _bodyRotationSpeed: float = 120
@onready var bodyMesh: MeshInstance3D = $body

var _currentRotation: Quaternion
var _currentTargetRotation: Quaternion

func _physics_process(delta: float) -> void:
	move_tank(delta)

func _process(delta: float) -> void:
	rotate_tank(delta)
	
func rotate_tank(delta: float):
	
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
	
	bodyMesh.rotation = _currentRotation.get_euler()


func move_tank(delta: float):
	var inputDirection := Input.get_vector("moveLeft", "moveRight", "moveDown", "moveUp")
	var moveDirection := Vector2(inputDirection.x, inputDirection.y).normalized()
	var targetVelocity := Vector2(moveDirection * _speedAxisMultiplier) * _maxSpeed
	var currentVelocity := Vector2(velocity.x,velocity.z)
	
	## change in speed allows the thank to have difference acceleration and decelleration speed
	#var velocityDifference = targetVelocity - currentVelocity	
	#print(velocityDifference.x)
	#var speedChange = Vector2(
		#_accelerationSpeed if velocityDifference.x > 0 else _decellerationSpeed,
		#_accelerationSpeed if velocityDifference.y > 0 else _decellerationSpeed)
	
	velocity.x = move_toward(currentVelocity.x,targetVelocity.x,_accelerationSpeed * delta)
	velocity.z = move_toward(currentVelocity.y,targetVelocity.y,_accelerationSpeed * delta)

	# Add the gravity. sureee
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	move_and_slide()
