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

@export var area: Area3D

func _ready() -> void:
	owning_player = WorldManager.get_player_by_id(owning_player_id)
	global_position = owning_player.bus.head.global_position
	starting_position = position
	starting_basis = owning_player.bus.head.global_transform.basis
	rotation = starting_basis.get_euler()
	
	NetworkTime.on_tick.connect(_network_tick)
	

func _network_tick(delta: float, _tick: int) -> void:
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
	
var is_intersecting_owner := false
	
func _return() -> void:
	current_travel_state =  TravelState.Returning
	if is_intersecting_owner:
		_on_area_3d_body_entered(owning_player)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !multiplayer.is_server():
		return
		
	if !(body is PhysicsBody3D):
		return
	var pbody := body as PhysicsBody3D
	
	if pbody is Player and WorldManager.get_player_team(pbody).id != owning_team().id:
		_damage_player(pbody)
	
	if pbody == owning_player:
		is_intersecting_owner = true
	
	match current_travel_state:
		TravelState.Casting:
			_body_entered_during_casting(pbody)
		TravelState.Returning:
			_body_entered_during_returning(pbody)
			
func _on_area3d_body_exited(body: Node3D) -> void:
	if body == owning_player:
		is_intersecting_owner = false

func _body_entered_during_casting(pbody: PhysicsBody3D) -> void:
	if PhysicsUtils.is_environmental_body(pbody):
		_return()
	if PhysicsUtils.is_shield(pbody):
		# TODO: this is really fragile. We should come up with a better way to find the owner.
		# Maybe walk up the tree until we find a parent with the `owning_player` field?
		if pbody.owner != null:
			var shield_owner: Player = (pbody.owner.get_parent() as Variant).owning_player
			if WorldManager.get_player_team(shield_owner).id != owning_team().id:
				_return()
				
func _body_entered_during_returning(pbody: PhysicsBody3D) -> void:
	if pbody == owning_player:
		_cleanup.rpc()
		
@rpc("authority", "call_local")
func _cleanup() -> void:
	owning_player.character_projectile_destroyed(self)
	if multiplayer.is_server():
		queue_free()


func _damage_player(player: Player) -> void :
	player.damage(75, owning_player)
