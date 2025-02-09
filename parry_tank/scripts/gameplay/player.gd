class_name Player extends Node3D

@export var player_id: int = 1:
	set(id):
		player_id = id
		$InputSynchronizer.set_multiplayer_authority(id,false)

func _ready() -> void:
	if multiplayer.get_unique_id() != player_id:
		$Cursor.queue_free()
