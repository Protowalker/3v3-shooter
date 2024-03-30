extends Node
class_name PhysicsUtils

const ENVIRONMENT_LAYER := 2

static func is_environmental_body(pbody: PhysicsBody3D) -> bool:
	return pbody.get_collision_layer_value(ENVIRONMENT_LAYER)
