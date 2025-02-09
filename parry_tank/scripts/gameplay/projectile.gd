extends RigidBody3D

@export var speed: float = 8
@export var rotateSpeed: float = 10
@export var angleRotateSpeed: float = 50
@export var maxBounces: float = 2
@export var maxLifeTime: float = 4
@export var damage: float = 100

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var timesBounced: int
var moveDirection: Vector3

func _ready() -> void:
	if not multiplayer.is_server():
		set_process(false)
		set_physics_process(false)
	else:
		moveDirection = transform.basis.z
		await get_tree().create_timer(maxLifeTime).timeout
		explode();

func _physics_process(delta: float) -> void:	
	var collision = move_and_collide(moveDirection.normalized() * speed * delta)
	if collision:
		on_collision(collision.get_normal())

func _process(delta: float) -> void:
	update_rotation(delta)
	
func update_rotation(delta: float) -> void:
	var targetQuaternion = transform.looking_at(position - moveDirection,Vector3.UP).basis.get_rotation_quaternion();
	var angleToTarget = quaternion.angle_to(targetQuaternion);
	
	quaternion = quaternion.slerp(targetQuaternion,(rotateSpeed + angleToTarget * angleRotateSpeed) * delta)
	
func on_collision(hit_normal: Vector3) -> void:
	if timesBounced >= maxBounces:
		explode();
	else:
		moveDirection = moveDirection.bounce(hit_normal)
		timesBounced += 1
	AudioManager.play_audio("bullet_bounce")

func explode() -> void:
	AudioManager.play_audio("bullet_explode")
	animationPlayer.play("explode")
