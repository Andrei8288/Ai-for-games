class_name SteeringBehaviors

var max_speed:float = 50.0
var max_acceleration:float = 10.0
var position:Vector2 = Vector2.ZERO
var velocity:Vector2 = Vector2.ZERO
var acceleration:Vector2 = Vector2.ZERO

func update(delta:float) -> void:
	velocity += acceleration * delta
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	position += velocity * delta

func calculate(target_position:Vector2) -> void:
	acceleration = Vector2.ZERO
