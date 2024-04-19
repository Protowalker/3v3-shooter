extends BaseNetInput
class_name PredictionController

@export var parent: Projectile
@export var rb_synchronizer: RollbackSynchronizer

var owner_position: Vector3

func _ready() -> void:
	super._ready()
	set_multiplayer_authority(parent.owning_player_id)
	rb_synchronizer.process_settings()

func _gather() -> void:
	owner_position = parent.owning_player.global_position
