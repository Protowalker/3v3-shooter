extends Node

var world: World


func add_projectile_to_world(projectile: Projectile) -> void:
	world.add_projectile(projectile)

func get_player_by_id(player_id: int) -> Player:
	return world.players.get_node(str(player_id))
