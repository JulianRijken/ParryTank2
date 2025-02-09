extends Control

@onready var server_label = $Panel/VBoxContainer/Server
@onready var id_label = $Panel/VBoxContainer/ID

func _process(_delta: float) -> void:
	if multiplayer.is_server():
		server_label.text = "Server"
	else:
		server_label.text = "-"
		
	id_label.text = "ID: %s" % str(multiplayer.multiplayer_peer.get_unique_id())
