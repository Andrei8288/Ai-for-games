class_name Arrive extends SteeringBehaviors

@export var slow_radius: float = 200.0 
@export var target_radius: float = 30.0 

func calculate(target_position: Vector2) -> Vector2:
	var direction = target_position - position
	var distance = direction.length()
	
	if distance < target_radius:
		return Vector2.ZERO
	
	var target_speed: float
	
	if distance > slow_radius:
		target_speed = max_speed
	else:
		target_speed = max_speed * (distance / slow_radius)

	var desired_velocity = direction.normalized() * target_speed
	var steering: Vector2 = desired_velocity - velocity
	
	if steering.length() > max_acceleration:
		steering = steering.normalized() * max_acceleration
	
	return steering
