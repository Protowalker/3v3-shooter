extends Node3D
class_name Home

enum Screen {
	MainMenu = 1,
	HostGame = 2,
	JoinGame = 3
}

@export var starting_screen: Screen
@export var main_menu: Control
@export var host_game: Control
@export var join_game: Control

@onready var screens := {Screen.MainMenu: main_menu, Screen.HostGame: host_game, Screen.JoinGame: join_game}


# TODO: should be reworked to have a single source of truth
@onready var current_screen := starting_screen :
	set(screen):
		screens[current_screen].process_mode = Node.PROCESS_MODE_DISABLED
		screens[current_screen].visible = false
		current_screen = screen
		screens[current_screen].process_mode = Node.PROCESS_MODE_INHERIT
		screens[current_screen].visible = true
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key: Screen in screens:
		if key == current_screen:
			screens.get(key).process_mode = Node.PROCESS_MODE_INHERIT
			screens.get(key).visible = true
		else:
			screens.get(key).process_mode = Node.PROCESS_MODE_DISABLED
			screens.get(key).visible = false
			

func change_screen(screen: Screen) -> void:
	if !screens.has(screen):
		return

	current_screen = screen


func _on_go_to_screen(screen: Screen) -> void:
	change_screen(screen)
