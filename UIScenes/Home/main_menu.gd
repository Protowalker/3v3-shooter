extends Control

signal go_to_screen(screen: Home.Screen)

func _on_host_game_pressed() -> void:
	go_to_screen.emit(Home.Screen.HostGame)


func _on_join_game_pressed() -> void:
	go_to_screen.emit(Home.Screen.JoinGame)
