class_name SteeringBehaviors extends RefCounted

var _owner: CharacterBody2D = null

var owner: CharacterBody2D:
	get:
		return _owner
	set(value):
		_owner = value
		_on_owner_changed()

enum Behavior {
	NONE,
	DYN_SEEK,
	DYN_FLEE,
	DYN_ARRIVE,
	DYN_GRAPPLE,
	DYN_WANDER
}

func _on_owner_changed() -> void:
	pass

func calculate() -> Vector2:
	return Vector2.ZERO
