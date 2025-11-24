class_name DynamicGrapplingHook
extends SteeringBehaviors

var graph: NavGraph = null
var path: Array[int] = []
var current_index: int = 0

var arrive_radius: float = 2.0

func calculate() -> Vector2:
	if graph == null or path.is_empty():
		return Vector2.ZERO

	if current_index >= path.size():
		owner.stop()
		return Vector2.ZERO

	var node_id: int = path[current_index]
	var target_pos: Vector2 = graph.get_node_position(node_id) + graph.global_position

	var to_target: Vector2 = target_pos - owner.global_position
	var dist: float = to_target.length()

	if dist <= arrive_radius:
		current_index += 1
		if current_index >= path.size():
			owner.stop()
			return Vector2.ZERO
		return Vector2.ZERO

	var desired_velocity: Vector2 = to_target.normalized() * owner.max_speed
	var steering_force: Vector2 = desired_velocity - owner.velocity

	if steering_force.length() > owner.max_acceleration:
		steering_force = steering_force.normalized() * owner.max_acceleration

	return steering_force
