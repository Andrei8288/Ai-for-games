class_name DynamicFlee extends SteeringBehaviors

@export var panic_radius: float = 50.0
const STOP_THRESHOLD = 15

func calculate(target_position: Vector2) -> Vector2:
	var direction = target_position - position
	var distance = direction.length()
	
	# --- FLEE LOGIC ---
	if distance < panic_radius:
		var desired_velocity = -direction.normalized() * max_speed
		var steering: Vector2 = desired_velocity - velocity
		
		if steering.length() > max_acceleration:
			steering = steering.normalized() * max_acceleration
		return steering
	
	# --- DECELERATION/BRAKING LOGIC ---
	else:
		if velocity.length() < STOP_THRESHOLD:
			return Vector2.ZERO
		var desired_velocity = Vector2.ZERO
		var steering: Vector2 = desired_velocity - velocity
		return steering
