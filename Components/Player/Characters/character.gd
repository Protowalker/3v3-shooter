extends Node3D
class_name Character

@export var outer_view: Node3D
@export var inner_view: Node3D
@export var collision_shape: Node3D
@export var head: Node3D

var player: Player

@export var moveset: Moveset

func tick(delta: float) -> void:
	pass

func projectile_destroyed(projectile: Projectile) -> void:
	pass
