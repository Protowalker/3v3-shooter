extends RefCounted
class_name Team

# TODO: dictionary instead of array
var player_ids: Array[int] = []
var id := 0

var packed: Dictionary:
	get:
		return {"player_ids": player_ids}
	set(new_data):
		player_ids.assign(new_data.player_ids)

func _init(_id: int) -> void:
	id = _id

func add_player(player_id: int) -> void:
	if !player_ids.has(player_id):
		player_ids.push_back(player_id)


