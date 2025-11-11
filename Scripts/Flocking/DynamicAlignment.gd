class_name AlignmentBehavior extends SteeringBehaviors

@export var neighborhood_radius: float = 100.0

func calculate() -> Vector2:
	var neighbors = []
	var average_velocity = Vector2.ZERO
	
	for neighbor in owner.buddies:
		if neighbor == owner:
			continue
		
		var distance = owner.global_position.distance_to(neighbor.global_position)
		if distance < neighborhood_radius:
			neighbors.append(neighbor)
			average_velocity += neighbor.velocity
			
	if neighbors.is_empty():
		return Vector2.ZERO
		
	average_velocity /= neighbors.size()
	
	if average_velocity.length_squared() > 0:
		var desired_velocity = average_velocity.limit_length(owner.max_speed)
		var steering_force = desired_velocity - owner.velocity
		return steering_force
		
	return Vector2.ZERO
