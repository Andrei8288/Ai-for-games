class_name DynamicSeek extends SteeringBehaviors

func calculate(target_position:Vector2) -> Vector2:
	if target_position == position: 
		return Vector2.ZERO
	var direction = (target_position - position).normalized()
	var desired_velocity = direction * max_speed
	var steering:Vector2 = desired_velocity - velocity
	
	if steering.length() > max_acceleration:
		steering = steering.normalized() * max_acceleration
	return steering
