extends CharacterBody3D
class_name Player


@export var bus: PlayerBus
@onready var stair_cast: ShapeCast3D = $StairCast
@onready var dont_stair_trigger: Area3D = $DontStairTrigger
const SPEED := 5.0
const ACCEL := 25.0
const AIR_ACCEL := 5.0
const JUMP_VELOCITY := 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _rollback_tick(delta: float, _tick: int, _is_fresh: bool) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if bus.input.jump.just and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := bus.input.input_direction
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var target_velocity := Vector3.ZERO
	target_velocity.y = velocity.y
	if direction:
		target_velocity.x = direction.x * SPEED
		target_velocity.z = direction.z * SPEED
	else:
		target_velocity.x = move_toward(velocity.x, 0, SPEED)
		target_velocity.z = move_toward(velocity.z, 0, SPEED)
	
	var accel := ACCEL if is_on_floor() else AIR_ACCEL
	
	velocity = velocity.move_toward(target_velocity, accel*delta)
	
	_try_to_step_up_small_ledges()
	
	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor
	
	
func set_yaw(yaw: float) -> void:
	self.rotation.y = deg_to_rad(yaw)

func _try_to_step_up_small_ledges() -> void:
	if !is_on_floor():
		return
	stair_cast.force_shapecast_update()
	for col_index in stair_cast.get_collision_count():
		var body: PhysicsBody3D = stair_cast.get_collider(col_index)
		if dont_stair_trigger.overlaps_body(body):
			continue
			
		var normal: Vector3 = stair_cast.get_collision_normal(col_index)
		var velocity_ignore_height := velocity * Vector3(1,0,1)
		var dot := velocity_ignore_height.dot(normal)
		
		if dot >= 0:
			continue
		
		var distance := 0.0
		var failure := false 
		while stair_cast.is_colliding():
			var collision := move_and_collide(Vector3.UP*0.01)
			if collision:
				move_and_collide(Vector3.DOWN*distance)
				failure = true
				break
			stair_cast.force_shapecast_update()
			distance += 0.01
		if !failure:
			move_and_collide(velocity_ignore_height.normalized()*0.02)
