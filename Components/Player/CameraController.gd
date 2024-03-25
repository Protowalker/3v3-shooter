extends Node
class_name CameraController


@export var camera: Camera3D
@export var head: Node3D

@export var bus: PlayerBus


var camera_gt_previous: Transform3D
var camera_gt_current: Transform3D

var MAX_ANGLE = deg_to_rad(89)

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.top_level = true
	camera_gt_previous = head.global_transform
	camera_gt_current = head.global_transform
	if multiplayer.get_unique_id() == bus.multiplayer_id:
		camera.current = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var interpolation_fraction: float = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
	camera.global_transform = camera_gt_previous.interpolate_with(camera_gt_current, interpolation_fraction)
	
func _physics_process(delta):
	camera_gt_previous = camera_gt_current
	camera_gt_current = head.global_transform

func set_pitch(pitch: float) -> void:
	head.rotation.x = clampf(deg_to_rad(pitch), -MAX_ANGLE, MAX_ANGLE)
