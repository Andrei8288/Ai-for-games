class_name DynamicSeek extends SteeringBehaviors

func calculate(target_position:Vector2) -> void:
	if target_position == Vector2.ZERO:
		acceleration == Vector2.ZERO
		return
	var desired_velocity = (target_position - position).normalized() * max_speed
	acceleration = (desired_velocity - velocity).clamped(max_acceleration)
