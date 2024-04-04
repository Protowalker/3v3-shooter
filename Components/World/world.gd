extends Node3D
class_name World

@onready var players: Node3D = $Players
@onready var projectiles: Node3D = $Projectiles

@onready var team_manager: TeamManager = $TeamManager

signal player_joined(id: int, player: Player)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WorldManager.world = self
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)

func _exit_tree() -> void:
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)

func add_player(id: int) -> void:
	var character: Player = preload("res://Components/Player/player.tscn").instantiate()
	character.bus.multiplayer_id = id
	character.name = str(id)
	
	var team_to_join := team_manager.team_with_fewest_players()
	team_to_join.add_player(id)
	
	players.add_child(character, true)
	_emit_player_joined.rpc(id)
	

func del_player(id: int) -> void:
	if not $Players.has_node(str(id)):
		return
	players.get_node(str(id)).queue_free()
	
@rpc("authority", "call_local")
func _emit_player_joined(id: int) -> void:
	var player := players.get_node(str(id))
	player_joined.emit(id, player)
	
	
func add_projectile(projectile: Projectile) -> void:
	projectiles.add_child(projectile, true)
