extends Resource
class_name Ability

@export var cooldown: float
@export var symbol: Texture
@export var name: String
@export var description: String

var remaining_cooldown := 0.0

func _tick(delta: float) -> void:
	remaining_cooldown = max(0.0, remaining_cooldown - delta)

func can_be_used() -> bool:
	return remaining_cooldown <= 0.0
	
func use() -> void:
	remaining_cooldown = cooldown
