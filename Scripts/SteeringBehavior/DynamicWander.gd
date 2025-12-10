class_name DynamicWander extends SteeringBehaviors


@export var wander_circle_distance: float = 40.0
@export var wander_circle_radius: float = 30.0
@export var wander_jitter_degrees: float = 20.0

var _wander_angle: float = 0.0

func calculate() -> Vector2:
	var forward := owner.velocity
	if forward.length() < 0.1:
		forward = Vector2.RIGHT.rotated(randf() * TAU)
	forward = forward.normalized()
	
	_wander_angle += deg_to_rad(randf_range(-wander_jitter_degrees, wander_jitter_degrees))
	
	var circle_center := forward * wander_circle_distance
	var displacement := Vector2.RIGHT.rotated(_wander_angle) * wander_circle_radius

	var wander_force := circle_center + displacement

	var desired_velocity = wander_force.normalized() * owner.max_speed
	var steering_force: Vector2 = desired_velocity - owner.velocity

	if steering_force.length() > owner.max_acceleration:
		steering_force = steering_force.normalized() * owner.max_acceleration

	return steering_force
