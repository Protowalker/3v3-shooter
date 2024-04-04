extends CharacterBody3D
class_name Player


@export var bus: PlayerBus
var character: Character:
	set(new_character):
		character = new_character
		_load_character()
@onready var stair_cast: ShapeCast3D = $StairCast
@onready var dont_stair_trigger: Area3D = $DontStairTrigger

@export var outer_view: Node3D
@export var inner_view: Node3D
@export var rendering: Node3D
@export var head: Node3D

var collision_shape_name := "CollisionShape"

const SPEED := 5.0
const ACCEL := 25.0
const AIR_ACCEL := 5.0
const JUMP_VELOCITY := 4.5

var max_health := 200.0:
	set(new_max_health):
		max_health = new_max_health
		health_changed.emit(health, max_health)
var health := 200.0:
	set(new_health):
		health = new_health
		health_changed.emit(new_health, max_health)
signal damaged(amount: float, perpetrator: Player)
signal health_changed(new_health: float, max_health: float)

func _load_character() -> void:
	character.player = self
	# Collision Shape
	var old_collision_shape := get_node(collision_shape_name)
	old_collision_shape.queue_free()
	remove_child(old_collision_shape)
	
	var new_collision_shape := character.collision_shape
	new_collision_shape.name = collision_shape_name

	new_collision_shape.get_parent().remove_child(new_collision_shape)
	add_child(new_collision_shape, true)
	
	# Outer View
	var old_outer := outer_view.get_node("_outer")
	old_outer.queue_free()
	outer_view.remove_child(old_outer)
	
	var new_outer := character.outer_view
	new_outer.name = "_outer"
	
	new_outer.get_parent().remove_child(new_outer)
	outer_view.add_child(new_outer, true)
	
	# Head
	var new_head := character.head
	head.position = new_head.position

	#Inner View
	var old_inner := head.get_node("_inner")
	old_inner.queue_free()
	head.remove_child(old_inner)
	
	var new_inner := character.inner_view
	new_inner.name = "_inner"
	
	new_inner.get_parent().remove_child(new_inner)
	head.add_child(new_inner, true)
	
	

var _soldier6 := preload("res://Components/Player/Characters/Soldier 6/Soldier6.tscn")

func _ready() -> void:
	character = _soldier6.instantiate()
	if bus.multiplayer_id == multiplayer.get_unique_id():
		outer_view.visible = false
		inner_view.visible = true
	else:
		outer_view.visible = true
		inner_view.visible = false

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
	
	character.tick(delta)
	
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

func character_projectile_destroyed(projectile: Projectile) -> void:
	character.projectile_destroyed(projectile)

func damage(amount: float, perpetrator: Player) -> void:
	health = max(0.0, health - amount)
	damaged.emit(amount, perpetrator)
