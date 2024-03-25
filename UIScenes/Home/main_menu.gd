extends Control

signal go_to_screen(screen: Home.Screen)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_game_pressed():
	go_to_screen.emit(Home.Screen.HostGame)


func _on_join_game_pressed():
	go_to_screen.emit(Home.Screen.JoinGame)
