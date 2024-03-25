extends Control

signal go_to_screen(screen: Home.Screen)

@onready var name_field: TextEdit = %ServerName
@onready var port_field: TextEdit = %ServerPort

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	var port := int(port_field.text)
	NetworkManager.host_game(port)
