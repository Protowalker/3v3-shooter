extends Node
class_name InputController

@export var mouse_sensitivity := 10

signal aim_angle_changed(change_euler_degs: Vector2)
signal aim_angle_set(euler_degs: Vector2)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_last_exclusive_window().focus_entered.connect(_on_focus_entered)

func _on_focus_entered():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent):
	if !get_window().has_focus():
		return
	if event.is_action(InputActions.pause):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event is InputEventMouseMotion:
		var change: Vector2 = -event.relative * mouse_sensitivity/360
		aim_angle_changed.emit(change)
		

func jump() -> ButtonState:
	return ButtonState.from_input(InputActions.jump)

func move() -> Vector2:
	var input_dir = Input.get_vector(InputActions.move_left, 
									 InputActions.move_right, 
									 InputActions.move_forward, 
									 InputActions.move_backward)
	return input_dir
