extends Node
class_name PlayerBus

@export var input: InputController

signal aim_angle_changed(changed_euler_degs: Vector2)

func _on_aim_angle_changed(changed_euler_degs: Vector2) -> void:
	aim_angle_changed.emit(changed_euler_degs)
		
