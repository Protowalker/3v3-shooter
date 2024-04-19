extends HBoxContainer
class_name MovesetUI


@export var moveset: Moveset:
	set(new_moveset):
		moveset = new_moveset
		_update_moveset()

var AbilityScene: PackedScene = preload("ability.tscn")


func _ready() -> void:
	pass
	
	
func _update_moveset() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
	_add_ability(moveset.secondary_attack)
	_add_ability(moveset.special_attack)
	_add_ability(moveset.utility_attack)

func update_moveset_from_character(new_character: Character) -> void:
	moveset = new_character.moveset

func _add_ability(ability: Ability) -> void: 
	if ability != null:
		var ability_ui: AbilityUI = AbilityScene.instantiate()
		ability_ui.ability = ability
		add_child(ability_ui)
