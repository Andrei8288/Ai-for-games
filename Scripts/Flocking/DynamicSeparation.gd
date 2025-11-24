class_name SeparationBehavior
extends SteeringBehaviors

@export var separation_radius: float = 20.0

func calculate() -> Vector2:
	var force = Vector2.ZERO
	var count = 0

	for neighbor in owner.buddies:
		var offset = owner.global_position - neighbor.global_position
		var distance = offset.length()

		if distance > 0.001 and distance < separation_radius:
			var falloff = (separation_radius - distance) / separation_radius
			falloff = falloff * falloff
			force += offset.normalized() * falloff
			count += 1

	if count == 0:
		return Vector2.ZERO

	var desired_velocity = force.normalized() * owner.max_speed
	var steering_force = desired_velocity - owner.velocity

	if steering_force.length() > owner.max_acceleration:
		steering_force = steering_force.normalized() * owner.max_acceleration

	return steering_force
