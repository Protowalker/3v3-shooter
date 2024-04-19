extends Resource
class_name Moveset

@export var primary_attack: Ability
@export var secondary_attack: Ability
@export var utility_attack: Ability
@export var special_attack: Ability
@export var ultimate_attack: Ability


func _tick(delta: float) -> void:
	if primary_attack != null:
		primary_attack._tick(delta)
	if secondary_attack != null:
		secondary_attack._tick(delta)
	if utility_attack != null:
		utility_attack._tick(delta)
	if special_attack != null:
		special_attack._tick(delta)
	if ultimate_attack != null:
		ultimate_attack._tick(delta)
