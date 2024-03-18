extends Object
class_name ButtonState

var just := false
var currently := false
var just_released := false

func _init(_just: bool, _currently: bool, _just_released: bool):
	self.just = _just
	self.currently = _currently
	self.just_released = _just_released


static func from_input(input_name: StringName) -> ButtonState:
	return ButtonState.new(Input.is_action_just_pressed(input_name), 
						   Input.is_action_pressed(input_name), 
						   Input.is_action_just_released(input_name))
