class_name CohesionBehavior extends SteeringBehaviors

@export var neighborhood_radius: float = 100.0

func calculate() -> Vector2:
	var neighbors = []
	var center_of_mass = Vector2.ZERO
	
	for neighbor in owner.buddies:
		if neighbor == owner:
			continue
		
		var distance = owner.global_position.distance_to(neighbor.global_position)
		if distance < neighborhood_radius:
			neighbors.append(neighbor)
			center_of_mass += neighbor.global_position
			
	if neighbors.is_empty():
		return Vector2.ZERO
	
	center_of_mass /= neighbors.size()
	
	var direction = center_of_mass - owner.global_position
	if direction.length_squared() > 0:
		var desired_velocity = direction.normalized() * owner.max_speed
		var steering_force = desired_velocity - owner.velocity
		
		return steering_force
		
	return Vector2.ZERO
