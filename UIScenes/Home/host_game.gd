extends Control

signal go_to_screen(screen: Home.Screen)

@onready var name_field: TextEdit = %ServerName
@onready var port_field: TextEdit = %ServerPort

func _on_start_button_pressed() -> void:
	var port := int(port_field.text)
	NetworkManager.host_game(port)
