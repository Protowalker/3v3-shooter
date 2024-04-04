extends Node3D
class_name TeamManager

var teams := {0: Team.new(0), 1: Team.new(1)}

var packed: Dictionary:
	get:
		var dict := {}
		for team: int in teams:
			dict[team] = teams[team].packed
		return dict
	set(new_data):
		for team_id: int in new_data:
			teams[team_id].packed = new_data[team_id]

func team_with_fewest_players() -> Team:
	var player_count := INF
	var lowest_team: Team
	for team: int in teams:
		if len(teams[team].player_ids) < player_count:
			player_count = len(teams[team].player_ids)
			lowest_team = teams[team]
			
	print(lowest_team)
	return lowest_team
	
