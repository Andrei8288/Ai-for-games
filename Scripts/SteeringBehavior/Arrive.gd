class_name Arrive extends SteeringBehaviors

@export var break_radius: float = 200.0 
@export var stop_radius: float = 30.0 
var target_speed: float

func calculate() -> Vector2:
	var direction = owner.target_node.global_position - owner.global_position
	var distance = direction.length()
	
	if distance < stop_radius:
		owner.stop()
		return Vector2.ZERO
	

	if distance > break_radius:
		target_speed = owner.max_speed
	else:
		target_speed = owner.max_speed * (distance / break_radius)
	
	var desired_velocity = direction.normalized() * target_speed
	var steering_force: Vector2 = desired_velocity - owner.velocity
	
	if steering_force.length() > owner.max_acceleration:
		steering_force = steering_force.normalized() * owner.max_acceleration
	
	return steering_force
