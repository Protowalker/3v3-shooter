extends Character


enum PrimaryAttackStates {
	Held,
	Out
}
var primary_state := PrimaryAttackStates.Held

@export var Boomerang: PackedScene

func tick(delta: float) -> void:
	_tick_primary(delta)
	
func _tick_primary(delta: float) -> void:
	match primary_state:
		PrimaryAttackStates.Held:
			_primary_held(delta)
		PrimaryAttackStates.Out:
			_primary_out(delta)
	
func _primary_held(delta: float) -> void:
	if player.bus.input.primary.just:
		primary_state = PrimaryAttackStates.Out
		_create_boomerang()
		

func _primary_out(delta: float) -> void:
	pass

func _create_boomerang() -> void:
	if !player.multiplayer.is_server():
		return
	var boomerang: Boomerang = Boomerang.instantiate()
	boomerang.owning_player_id = player.bus.multiplayer_id
	WorldManager.add_projectile_to_world(boomerang)
	print("boom")

func projectile_destroyed(projectile: Projectile) -> void:
	if projectile is Boomerang:
		primary_state = PrimaryAttackStates.Held
