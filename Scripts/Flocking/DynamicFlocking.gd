class_name DynamicFlocking extends SteeringBehaviors

# --- Weights for blending ---
@export var cohesion_weight: float = 1.0
@export var separation_weight: float = 1.5
@export var alignment_weight: float = 1.0
# --- Sub-Behavior Instances ---
var cohesion_behavior: CohesionBehavior = CohesionBehavior.new()
var alignment_behavior: AlignmentBehavior = AlignmentBehavior.new()
var separation_behavior: SeparationBehavior = SeparationBehavior.new()

# --- Main Flocking Calculation (The Blender) ---
func calculate() -> Vector2:
	# 1. Calculate each component force
	var cohesion = cohesion_behavior.calculate() * cohesion_weight
	var alignment = alignment_behavior.calculate() * alignment_weight
	var separation = separation_behavior.calculate() * separation_weight
	var total_force = cohesion + alignment + separation

	return total_force
