extends Node

var lobby_scene = preload("res://parry_tank/scenes/levels/lobby.tscn").instantiate()

func _ready() -> void:
	MultiplayerManager.connect_success.connect(on_connected)

func on_connected():
	show_lobby()

func show_lobby():
	get_tree().root.add_child(lobby_scene)
