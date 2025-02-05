extends CharacterBody2D


const MOVE_SPEED = 200.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var moveInput = Input.get_vector("moveRight","moveLeft","moveDown","moveUp")

	if moveInput.y > 0:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY


	if moveInput.x:
		velocity.x = moveInput.x * MOVE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)

	move_and_slide()
