extends Node3D
class_name Projectile

var owning_player: Player

var owning_player_id: int

func owning_team() -> Team:
	return WorldManager.get_player_team(owning_player)
