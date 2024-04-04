extends Node

var world: World

func add_projectile_to_world(projectile: Projectile) -> void:
	world.add_projectile(projectile)

func get_player_by_id(player_id: int) -> Player:
	return world.players.get_node(str(player_id))

func get_player_team(player: Player) -> Team:
	var teams := world.team_manager.teams
	for team_id: int in world.team_manager.teams:
		if teams[team_id].player_ids.has(player.bus.multiplayer_id):
			return teams[team_id]
	return null
