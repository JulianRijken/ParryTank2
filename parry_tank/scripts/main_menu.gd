extends Node

func host_game_pressed() -> void:
	print("Hosting Game")
	if MultiplayerManager.try_host_game():
		$MultiplayerHud.hide()

	
func join_game_pressed() -> void:
	print("Joining Game")
	$MultiplayerHud.hide()
	MultiplayerManager.try_join_game()
