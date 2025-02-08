extends Node

@onready var camera3D: Camera3D = $Camera3D
var tween: Tween

var transitioning: bool = false

func _ready() -> void:
	camera3D.current = false

func transition_camera3D(from: Camera3D, to: Camera3D, duration: float = 1.0) -> void:
	if transitioning: 
		return
	
	# Copy the parameters of the first camera
	camera3D.keep_aspect = from.keep_aspect
	camera3D.cull_mask = from.cull_mask
	camera3D.environment = from.environment
	camera3D.attributes = from.attributes
	camera3D.compositor = from.compositor
	camera3D.h_offset = from.h_offset
	camera3D.v_offset = from.v_offset
	camera3D.doppler_tracking = from.doppler_tracking
	camera3D.projection = from.projection;
	camera3D.fov = from.fov
	camera3D.size = from.size
	camera3D.near = from.near
	camera3D.far = from.far
	camera3D.global_transform = from.global_transform
	
	camera3D.current = true

	transitioning = true
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(camera3D, "fov", to.fov, duration).from(camera3D.fov)
	tween.tween_property(camera3D, "size", to.size, duration).from(camera3D.size)
	tween.tween_property(camera3D, "near", to.near, duration).from(camera3D.near)
	tween.tween_property(camera3D, "far", to.far, duration).from(camera3D.far)
	tween.tween_property(camera3D, "global_transform", to.global_transform, duration).from(camera3D.global_transform)
	
	
	await tween.finished
	to.current = true
	transitioning = false
