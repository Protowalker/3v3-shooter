extends Resource
class_name Ability

@export var cooldown: float
@export var symbol: Texture
@export var name: String
@export var description: String

var remaining_cooldown := cooldown
