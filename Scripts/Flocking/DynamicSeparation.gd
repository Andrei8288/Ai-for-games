class_name SeparationBehavior extends SteeringBehaviors

@export var separation_radius: float = 40.0 

func calculate() -> Vector2:
	var total_repulsion_vector = Vector2.ZERO
	var neighbors_found = 0
	
	for neighbor in owner.buddies:
		if neighbor == owner:
			continue
		
		var direction = owner.global_position - neighbor.global_position
		var distance = direction.length()
		
		if distance < separation_radius and distance > 0.001:
			var strength = 1.0 / distance 
			total_repulsion_vector += direction.normalized() * strength
			neighbors_found += 1
			
	if neighbors_found == 0:
		return Vector2.ZERO

	var desired_velocity = (total_repulsion_vector / neighbors_found).normalized() * owner.max_speed
	var steering_force = desired_velocity - owner.velocity
	
	return steering_force
