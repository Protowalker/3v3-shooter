extends BaseNetInput
class_name InputController

@export var bus: PlayerBus

@export var mouse_sensitivity := 10

var jump := ButtonState.new(InputActions.jump)
var primary := ButtonState.new(InputActions.primary_attack)
var secondary := ButtonState.new(InputActions.secondary_attack)

var input_direction := Vector2()

@export var cam_rotation: Vector2:
	set(rot):
		bus.camera_controller.set_pitch(rot.x)
		bus.player.set_yaw(rot.y)
		cam_rotation = rot

signal aim_angle_changed(change_euler_degs: Vector2)
signal aim_angle_set(euler_degs: Vector2)

func _ready() -> void:
	super._ready()
	var should_process := get_multiplayer_authority() == multiplayer.get_unique_id()
	if !should_process:
		return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_last_exclusive_window().focus_entered.connect(_on_focus_entered)
	NetworkTime.after_tick_loop.connect(_after_tick)

func _gather() -> void:
	_update_move()
	jump.update()
	primary.update()
	secondary.update()

func _after_tick() -> void:
	if !is_multiplayer_authority():
		return
	jump.reset()
	primary.reset()
	secondary.reset()


func _on_focus_entered() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	if !get_last_exclusive_window().has_focus():
		return	
	if event.is_action(InputActions.pause):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		
	if event is InputEventMouseMotion:
		var mouse_event: InputEventMouseMotion = event
		var change: Vector2 = -mouse_event.relative * mouse_sensitivity*get_process_delta_time()
		cam_rotation = Vector2(rad_to_deg(bus.head.rotation.x) + change.y, rad_to_deg(bus.player.rotation.y) + change.x)
	
	jump.input(event)
	primary.input(event)
	secondary.input(event)

func _update_move() -> void:
	input_direction = Input.get_vector(InputActions.move_left, 
									 InputActions.move_right, 
									 InputActions.move_forward, 
									 InputActions.move_backward)
	
