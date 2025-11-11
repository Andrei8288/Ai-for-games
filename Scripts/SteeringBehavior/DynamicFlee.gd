class_name DynamicFlee extends SteeringBehaviors

@export var panic_radius: float = 100.0
const STOP_THRESHOLD = 20

func calculate() -> Vector2:
	var direction = owner.target_node.global_position - owner.global_position
	var distance = direction.length()
	
	# --- FLEE LOGIC ---
	if distance < panic_radius:
		var desired_velocity = -direction.normalized() * owner.max_speed
		var steering_force: Vector2 = desired_velocity - owner.velocity
		
		if steering_force.length() > owner.max_acceleration:
			steering_force = steering_force.normalized() * owner.max_acceleration
		return steering_force
	
	# --- DECELERATION/BRAKING LOGIC ---
	else:
		if owner.velocity.length() < STOP_THRESHOLD:
			owner.stop()
			return Vector2.ZERO
		var desired_velocity = Vector2.ZERO
		var steering_force: Vector2 = desired_velocity - owner.velocity
		return steering_force
