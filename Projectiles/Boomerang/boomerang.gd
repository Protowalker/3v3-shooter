extends Projectile
class_name Boomerang

var speed := 13.0

var starting_position := Vector3.ZERO
var starting_basis := Basis.IDENTITY
var starting_direction: Vector3:
	get:
		return (starting_basis * Vector3.FORWARD).normalized()

var max_distance := 8.0

enum TravelState {
	Casting,
	Returning
}

var current_travel_state := TravelState.Casting


func _ready() -> void:
	owning_player = WorldManager.get_player_by_id(owning_player_id)
	global_position = owning_player.bus.head.global_position
	starting_position = position
	starting_basis = owning_player.bus.head.global_transform.basis
	rotation = starting_basis.get_euler()
	
	NetworkTime.on_tick.connect(_tick)

func _process(delta: float) -> void:
	pass
	#$local.rotation_degrees.y += 720*delta

func _tick(delta: float, _tick: int) -> void:
	match current_travel_state:
		TravelState.Casting:
			_casting_tick(delta)
		TravelState.Returning:
			_returning_tick(delta)

	
func _casting_tick(delta: float) -> void:
	position += starting_direction * speed * delta
	if starting_position.distance_squared_to(position) >= max_distance**2:
		_return()
	
func _returning_tick(delta: float) -> void:
	var target_position := owning_player.bus.head.global_position
	global_position = global_position.move_toward(target_position, speed*delta)
	
	
func _return() -> void:
	current_travel_state =  TravelState.Returning
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if !(body is PhysicsBody3D):
		return
	var pbody := body as PhysicsBody3D
	
	if pbody is Player and pbody != owning_player:
		pass
	
	match current_travel_state:
		TravelState.Casting:
			_body_entered_during_casting(pbody)
		TravelState.Returning:
			_body_entered_during_returning(pbody)
	
func _body_entered_during_casting(pbody: PhysicsBody3D) -> void:
	if PhysicsUtils.is_environmental_body(pbody):
		_return()


func _body_entered_during_returning(pbody: PhysicsBody3D) -> void:
	if pbody == owning_player:
		pbody.character_projectile_destroyed(self)
		queue_free()
