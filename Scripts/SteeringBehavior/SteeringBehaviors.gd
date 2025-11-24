class_name SteeringBehaviors extends RefCounted

# Backing field for owner
var _owner: CharacterBody2D = null

# Public owner property
var owner: CharacterBody2D:
	get:
		return _owner
	set(value):
		_owner = value
		_on_owner_changed()

# Behavior enum stays here so AIManager can use it
enum Behavior {
	NONE,
	DYN_SEEK,
	DYN_FLEE,
	DYN_ARRIVE,
	DYN_FLOCK
}

# Called automatically whenever owner is assigned/changed.
# Subclasses override if they need to react.
func _on_owner_changed() -> void:
	pass

# Base interface – subclasses override this.
func calculate() -> Vector2:
	return Vector2.ZERO
