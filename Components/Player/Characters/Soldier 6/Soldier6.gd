extends Character


enum BoomerangAttackStates {
	Held,
	Out
}
var boomerang_state := BoomerangAttackStates.Held

@export var BoomerangScene: PackedScene
@export var ShieldScene: PackedScene

var max_shield_count := 3
var shields: Array[DeployableShield] = []

signal shield_released()


func tick(delta: float) -> void:
	_tick_boomerang(delta)
	_tick_shield(delta)
	moveset._tick(delta)
	
func _tick_boomerang(delta: float) -> void:
	match boomerang_state:
		BoomerangAttackStates.Held:
			_boomerang_held(delta)
		BoomerangAttackStates.Out:
			_boomerang_out(delta)
	
func _boomerang_held(_delta: float) -> void:
	if player.bus.input.primary.just and moveset.primary_attack.can_be_used():
		boomerang_state = BoomerangAttackStates.Out
		moveset.primary_attack.use()
		_create_boomerang()
		
func _boomerang_out(_delta: float) -> void:
	pass

func _create_boomerang() -> void:
	if !player.multiplayer.is_server():
		return
	var boomerang: Boomerang = BoomerangScene.instantiate()
	boomerang.owning_player_id = player.bus.multiplayer_id
	WorldManager.add_projectile_to_world(boomerang)

func _tick_shield(_delta: float) -> void:
	if player.bus.input.secondary.just and moveset.secondary_attack.can_be_used():
		moveset.secondary_attack.use()
		_create_shield()
		
	if player.bus.input.secondary.just_released:
		shield_released.emit()
		
func _create_shield() -> void:
	if !player.multiplayer.is_server():
		return
		
	if len(shields) >= max_shield_count:
		var old_shield: DeployableShield = shields.pop_front()
		old_shield.queue_free()
		
	var shield: DeployableShield = ShieldScene.instantiate()
	shield.owning_player_id = player.bus.multiplayer_id
	shield_released.connect(shield.on_let_go)
	WorldManager.add_projectile_to_world(shield)
	shields.push_back(shield)

func projectile_destroyed(projectile: Projectile) -> void:
	if projectile is Boomerang:
		boomerang_state = BoomerangAttackStates.Held
