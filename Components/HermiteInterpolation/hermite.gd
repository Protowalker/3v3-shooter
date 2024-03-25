extends Node3D
class_name Hermite

var last_position := Vector3.ZERO
var next_position := Vector3.ZERO

var last_velocity := Vector3.ZERO
var next_velocity := Vector3.ZERO

@export var source: Player

var previous_snapshot := {
	"position": Vector3.ZERO,
	"velocity": Vector3.ZERO
}
var current_snapshot := {
	"position": Vector3.ZERO,
	"velocity": Vector3.ZERO
}

func _ready() -> void:
	top_level = true

func _physics_process(_delta: float) -> void:
	last_position = next_position
	next_position = source.global_position
	
	last_velocity = next_velocity
	next_velocity = source.velocity

	if len(source.bus.mp.snapshots) < 2:
		global_position = source.global_position
		return


	previous_snapshot = current_snapshot
	current_snapshot = source.bus.mp.snapshots[-1]


func _process(_delta: float) -> void:
	var raw_interpolation_fraction: float = Engine.get_physics_interpolation_fraction()
	var interpolation_fraction: float = clamp(raw_interpolation_fraction, 0.0, 1.0)
	#
	#if is_multiplayer_authority() and source.bus.multiplayer_id == 1:
		#print(current_snapshot.position)
	
	#position = previous_snapshot.position.lerp(current_snapshot.position, interpolation_fraction)
	#if !multiplayer.is_server() and source.bus.multiplayer_id == multiplayer.get_unique_id():
		#if position != previous_snapshot.position and position != current_snapshot.position:
			#print(previous_snapshot.position.lerp(current_snapshot.position, 0.0))
	global_position = source.global_position
	#
	#if multiplayer.is_server():
		#global_position = source.global_position
	#else:
		#global_position = hermite(interpolation_fraction, previous_snapshot.position, current_snapshot.position, previous_snapshot.velocity*delta, current_snapshot.velocity*delta)


# Cubic Hermite interpolation
func hermite(t: float, p1: Vector3, p2: Vector3, v1: Vector3, v2: Vector3) -> Vector3:
	var t2 := pow(t, 2)
	var t3 := pow(t, 3)
	var a := 1 - 3*t2 + 2*t3
	var b := t2 * (3 - 2*t)
	var c := t * pow(t - 1, 2)
	var d := t2 * (t - 1)
	return a * p1 + b * p2 + c * v1 + d * v2
