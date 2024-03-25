extends Node
class_name WorldNetworkManager

enum MessageType {
	Sync = 1,
	Update = 2,
}

@export var players_node: Node3D
static var tick_rate := 20

var _tick_timer := 0.0
var _tick_count := 0
@onready var scene_mp: SceneMultiplayer = multiplayer

var logged_in_player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	for player in players_node.get_children():
		if player.bus.multiplayer_id == multiplayer.get_unique_id():
			logged_in_player = player
			break

	scene_mp.peer_packet.connect(_on_packet_received)

func _on_player_joined(id: int, player: Player):
	if id == multiplayer.get_unique_id():
		logged_in_player = player

func _process(delta: float):
	if !multiplayer.is_server() and logged_in_player == null:
		return
	_tick_timer += delta
	if _tick_timer >= (1.0 / tick_rate):
		if multiplayer.is_server():
			_send_updates()
		else:
			_send_sync()
		
		_tick_timer = 0.0
		_tick_count += 1

func _send_sync():
	var packed := {
		"message_type": MessageType.Sync,
		"client_tick": _tick_count,
	}
	logged_in_player.log_current_input(_tick_count)
	scene_mp.send_bytes(var_to_bytes(packed))

func _send_updates():
	var players := players_node.get_children()
	var packed_players := {}
	
	for player in players:
		packed_players[player.bus.multiplayer_id] = player.pack()
		packed_players[player.bus.multiplayer_id].last_received_tick = player.bus.mp.last_received_tick
	
	var packed := {
		"message_type": MessageType.Update,
		"server_tick": _tick_count,
		"packed_players": packed_players
	}
	
	scene_mp.send_bytes(var_to_bytes(packed))
	
func _on_packet_received(id: int, packet: PackedByteArray):
	var packed: Dictionary = bytes_to_var(packet)
	match packed.message_type:
		MessageType.Update:
			if id == get_multiplayer_authority():
				_update(packed)
		MessageType.Sync:
			_sync(id, packed)


func _update(packed: Dictionary):
	var players := players_node.get_children()
	for player in players:
		var new_data: Dictionary = packed.packed_players[player.bus.multiplayer_id]
		player.unpack(_tick_count, packed.server_tick, new_data)
		if player.bus.multiplayer_id == multiplayer.get_unique_id():
			if packed.server_tick - _tick_count > 10:
				_tick_timer = 1./(tick_rate)
				_tick_count = packed.server_tick

func _sync(id: int, packed: Dictionary):
	players_node.get_node(str(id)).bus.mp.last_received_tick = packed.client_tick
	
