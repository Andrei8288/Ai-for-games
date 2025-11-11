class_name SteeringBehaviors extends RefCounted # Extend RefCounted for easy creation

var owner:CharacterBody2D = null

enum Behavior{
	NONE,
	DYN_SEEK,
	DYN_FLEE,
	DYN_ARRIVE,
	DYN_FLOCK
}

func calculate() -> Vector2:
	return Vector2.ZERO
