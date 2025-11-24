class_name DynamicFlocking
extends SteeringBehaviors

@export var cohesion_weight: float = 0.8
@export var separation_weight: float = 1.4
@export var alignment_weight: float = 0.8

var cohesion_behavior := CohesionBehavior.new()
var alignment_behavior := AlignmentBehavior.new()
var separation_behavior := SeparationBehavior.new()

func _on_owner_changed():
	cohesion_behavior.owner = owner
	alignment_behavior.owner = owner
	separation_behavior.owner = owner

func calculate() -> Vector2:
	var cohesion = cohesion_behavior.calculate() * cohesion_weight
	var alignment = alignment_behavior.calculate() * alignment_weight
	var separation = separation_behavior.calculate() * separation_weight

	var steering = cohesion + alignment + separation

	if steering.length() > owner.max_acceleration:
		steering = steering.normalized() * owner.max_acceleration

	return steering
