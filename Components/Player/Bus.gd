extends Node
class_name PlayerBus

@export var input: InputController
@export var head: Node3D
@export var camera_controller: CameraController
@export var player: Player

var multiplayer_id := 1 :
	set(id):
		multiplayer_id = id
		input.set_multiplayer_authority(multiplayer_id)
		head.set_multiplayer_authority(multiplayer_id)
		camera_controller.set_multiplayer_authority(multiplayer_id)
		camera_controller.camera.set_multiplayer_authority(multiplayer_id)

signal aim_angle_changed(changed_euler_degs: Vector2)

func _on_aim_angle_changed(changed_euler_degs: Vector2) -> void:
	aim_angle_changed.emit(changed_euler_degs)
