class_name AlignmentBehavior
extends SteeringBehaviors

@export var neighborhood_radius: float = 60.0

func calculate() -> Vector2:
	var neighbors = []
	var accumulated = Vector2.ZERO

	for neighbor in owner.buddies:
		var distance = owner.global_position.distance_to(neighbor.global_position)

		if distance < neighborhood_radius:
			accumulated += neighbor.velocity.normalized()
			neighbors.append(neighbor)

	if neighbors.is_empty():
		return Vector2.ZERO

	var avg_dir = accumulated.normalized()
	var desired_velocity = avg_dir * owner.max_speed
	var steering_force = desired_velocity - owner.velocity

	if steering_force.length() > owner.max_acceleration:
		steering_force = steering_force.normalized() * owner.max_acceleration

	return steering_force
