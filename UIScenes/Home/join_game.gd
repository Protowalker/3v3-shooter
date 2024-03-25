extends Control

@onready var server_address_field: TextEdit = %ServerAddress

signal go_to_screen(screen: Home.Screen)

func _on_join_button_pressed() -> void:
	var address_and_port := server_address_field.text.split(":")
	var address := address_and_port[0]
	var port := int(address_and_port[1])
	NetworkManager.join_game(address, port)
