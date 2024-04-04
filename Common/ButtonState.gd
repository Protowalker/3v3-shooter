extends Object
class_name ButtonState

var input_name: StringName

var just := false
var currently := false
var just_released := false

var packed: int:
	get:
		return (int(just) << 2) | (int(currently) << 1) | int(just_released)
	set(new_state):
		var new_just := new_state >> 2
		var new_currently := (new_state >> 1) & 1
		var new_just_released := new_state & 1
		
		just = new_just
		currently = new_currently
		just_released = new_just_released


func _init(_input_name: StringName) -> void:
	self.input_name = _input_name

	update()

func input(event: InputEvent) -> void:
	just = just || event.is_action_pressed(input_name)
	just_released = just_released || event.is_action_released(input_name)
	

func update() -> void:
	currently = currently || Input.is_action_pressed(input_name)

func reset() -> void:
	just = false
	currently = false
	just_released = false


#static func get_value_for_input(input_name: StringName) -> Dictionary:
	#return {
		#"just": Input.is_action_just_pressed(input_name),
		#"currently": Input.is_action_pressed(input_name),
		#"just_released": Input.is_action_just_released(input_name)
	#}
#
#static func get_empty() -> Dictionary:
	#return {
		#"just": false,
		#"currently": false,
		#"just_released": false
	#}
