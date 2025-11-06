class_name SteeringBehaviors extends RefCounted # Extend RefCounted for easy creation

var max_speed:float = 50.0
var max_acceleration:float = 10.0
var position:Vector2 = Vector2.ZERO 
var velocity:Vector2 = Vector2.ZERO 

enum Behavior{
	NONE,
	DYN_SEEK,
	DYN_FLEE,
	ARRIVE
}

func calculate(_target_position:Vector2) -> Vector2:
	return Vector2.ZERO
