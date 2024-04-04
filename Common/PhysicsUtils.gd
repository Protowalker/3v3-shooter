extends Node
class_name PhysicsUtils

const ENVIRONMENT_LAYER := 2
const SHIELD_LAYER := 4

static func is_environmental_body(pbody: PhysicsBody3D) -> bool:
	return pbody.get_collision_layer_value(ENVIRONMENT_LAYER)

static func is_shield(pbody: PhysicsBody3D) -> bool:
	return pbody.get_collision_layer_value(SHIELD_LAYER)
