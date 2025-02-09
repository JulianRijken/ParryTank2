extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

signal connect_success
signal connect_failed

@onready var playerScene: PackedScene = preload("res://parry_tank/scenes/gameplay/player.tscn")

func try_host_game() -> bool:
	print("Hosting Game Started")
	
	# Create server peer
	var server_peer = ENetMultiplayerPeer.new()
	var error = server_peer.create_server(SERVER_PORT,3)
	if error != OK:
		print("Hosting fialed: " + str(error))
		return false
		
	server_peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	# Update peer
	multiplayer.multiplayer_peer = server_peer
	
	# Remove in future
	connect_success.emit()
	
	# Bind connect and disconnect
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	
	spawn_player(1);
	return true;

func try_join_game() -> void:
	print("Joining Game Started")
	
	# Create client peer
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP,SERVER_PORT)
	client_peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	# Update peer
	multiplayer.multiplayer_peer = client_peer
	multiplayer.connected_to_server.connect(on_server_connect_succes)
	multiplayer.connection_failed.connect(on_server_connect_failed)
	
func on_server_connect_succes():
	print("Server connect succes")
	connect_success.emit()
	
func on_server_connect_failed():
	print("Server connect failed")
	connect_failed.emit()
	
func on_peer_connected(id: int):
	print("Player %s joined the game" % id)
	spawn_player(id)
	
func on_peer_disconnected(id: int):
	print("Player %s left the game" % id)
	
func spawn_player(id: int):
	var playerInstance = playerScene.instantiate()
	playerInstance.name = str(id)
	(playerInstance as Player).player_id = id
	add_child(playerInstance,true)
