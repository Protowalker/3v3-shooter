extends Object
class_name ButtonState

var input_name: StringName

var just := false
var currently := false
var just_released := false

func _init(_input_name: StringName) -> void:
	self.input_name = _input_name

	update()

func update() -> void:
	self.just = Input.is_action_just_pressed(input_name)
	self.currently = Input.is_action_pressed(input_name)
	self.just_released = Input.is_action_just_released(input_name)

static func get_value_for_input(input_name: StringName) -> Dictionary:
	return {
		"just": Input.is_action_just_pressed(input_name),
		"currently": Input.is_action_pressed(input_name),
		"just_released": Input.is_action_just_released(input_name)
	}

static func get_empty() -> Dictionary:
	return {
		"just": false,
		"currently": false,
		"just_released": false
	}
