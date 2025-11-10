class_name DynamicSeek extends SteeringBehaviors

func calculate() -> Vector2:
	if owner.target_node.global_position == owner.global_position: 
		return Vector2.ZERO
	var direction = (owner.target_node.global_position - owner.global_position).normalized()
	var desired_velocity = direction * owner.max_speed
	var steering_force:Vector2 = desired_velocity - owner.velocity
	
	if steering_force.length() > owner.max_acceleration:
		steering_force = steering_force.normalized() * owner.max_acceleration
	return steering_force
