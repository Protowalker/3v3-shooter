extends Node


@export var camera: Camera3D

var MAX_ANGLE = deg_to_rad(89)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_aim_angle_changed(change_euler_degs: Vector2) -> void:
	camera.rotate_x(deg_to_rad(change_euler_degs.y))
	camera.rotation.x = clampf(camera.rotation.x, -MAX_ANGLE, MAX_ANGLE)
