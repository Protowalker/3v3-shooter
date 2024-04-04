extends Projectile
class_name DeployableShield

enum AttachmentState {
	Attached,
	Detached
}

var attachment_state := AttachmentState.Attached



@export var base: CharacterBody3D

@onready var mesh := $Mesh
@onready var tick_interpolator: TickInterpolator = $TickInterpolator

func _ready() -> void:
	owning_player = WorldManager.get_player_by_id(owning_player_id)
	global_position = owning_player.global_position
	global_rotation = owning_player.global_rotation
	
	NetworkTime.on_tick.connect(_network_tick)
	tick_interpolator.teleport()
	
func _network_tick(delta: float, _tick: int) -> void:
	match attachment_state:
		AttachmentState.Attached:
			_tick_attached(delta)
		AttachmentState.Detached:
			_tick_detached(delta)
			
func _tick_attached(_delta: float) -> void:
	global_position = owning_player.global_position + -owning_player.bus.head.global_basis.z
	global_position.y = max(owning_player.global_position.y - 0.3, global_position.y)
	global_rotation = owning_player.global_rotation
		
func _tick_detached(_delta: float) -> void:
	base.velocity.y += -1.5*_delta
	
	base.velocity *= NetworkTime.physics_factor
	base.move_and_slide()
	base.velocity /= NetworkTime.physics_factor	
	
	global_position = base.global_position
	base.position = Vector3.ZERO
	

func on_let_go() -> void:
	attachment_state = AttachmentState.Detached
	base.process_mode = Node.PROCESS_MODE_INHERIT
