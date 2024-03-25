extends Node
class_name MultiplayerController

# position: Vector3
# cam_rotation: Vector2
var snapshots: Array[Dictionary] = []

var commands: Array[Dictionary] = []

var last_received_tick := -1000

@export var bus: PlayerBus

var position_error := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position_error.length_squared() < 1.0 and bus.player.velocity.length_squared() > 0:
		#var relative_input := (Vector3(input_direction.x, 0, input_direction.y) * bus.player.transform.basis).normalized()
		var dot_of_change := position_error.normalized().dot(bus.player.velocity.normalized())
		if dot_of_change > 0: 
			var difference := position_error*dot_of_change
			bus.player.position = bus.player.position + difference
			position_error = position_error.move_toward(Vector3.ZERO, dot_of_change)

func update_player(current_tick: int, server_tick: int, new_data: Dictionary):
	if server_tick < last_received_tick:
		return
	else:
		last_received_tick = server_tick
	
	snapshots.push_back(new_data)
	if len(snapshots) == 19:
		snapshots.pop_front()
	# Get rid of old commands
	for idx in range(len(commands)-1, -1, -1):
		if commands[idx].tick < new_data.last_received_tick:
			commands = commands.slice(idx + 1)
			break
	
	
	var unstepped_position := bus.player.position
	var unstepped_velocity := bus.player.velocity
	
	bus.player.position = new_data.position
	if bus.multiplayer_id != multiplayer.get_unique_id():
		bus.input.cam_rotation = new_data.cam_rotation
	bus.player.velocity = new_data.velocity

	position_error = bus.player.position - unstepped_position
	
	if server_tick - current_tick > 10:
		commands.clear()
		return
	
	var current_input := bus.input.pack(current_tick)		
	for command in commands:
		bus.input.unpack(command)
		bus.player._physics_process(1.0/(WorldNetworkManager.tick_rate))
		
		bus.input.unpack(current_input)
	
	
	var velocity_error := bus.player.velocity.distance_to(unstepped_velocity)
	
	position_error = bus.player.position - unstepped_position
	
	DebugDraw3D.draw_position(bus.player.global_transform, Color.RED, 1.0/WorldNetworkManager.tick_rate)
	
	var input_direction := bus.input.input_direction
	
	if velocity_error < 1.0:
		bus.player.velocity = unstepped_velocity
		
	

	if position_error.length_squared() < 0.2:
		bus.player.position = unstepped_position
	elif position_error.length_squared() < 1.0:
		bus.player.position = unstepped_position.move_toward(bus.player.position, 0.1)
		
		
		

	#bus.player._physics_process(1.0/(WorldNetworkManager.tick_rate))
	#bus.camera_controller._physics_process(1.0/(WorldNetworkManager.tick_rate))
	

func log_current_input(current_tick: int):
	commands.push_back(bus.input.pack(current_tick))
