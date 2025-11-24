class_name CohesionBehavior
extends SteeringBehaviors

@export var neighborhood_radius: float = 200.0


func calculate() -> Vector2:
	var neighbors = []
	var center_of_mass = Vector2.ZERO
	
	for neighbor in owner.buddies:
		var distance = owner.global_position.distance_to(neighbor.global_position)
		if distance < neighborhood_radius:
			neighbors.append(neighbor)
			center_of_mass += neighbor.global_position
	
	if neighbors.is_empty():
		return Vector2.ZERO
	
	center_of_mass /= neighbors.size()
	var direction = center_of_mass - owner.global_position
	var d = direction.length()
	
	if d < 10.0:
		return Vector2.ZERO
	
	var factor = clamp((d - 10.0) / neighborhood_radius, 0.0, 1.0)
	var desired_velocity = direction.normalized() * owner.max_speed * factor
	var steering_force = desired_velocity - owner.velocity
	
	if steering_force.length() > owner.max_acceleration:
		steering_force = steering_force.normalized() * owner.max_acceleration
	
	return steering_force
