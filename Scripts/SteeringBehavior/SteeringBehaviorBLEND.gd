class_name BehaviorBlender extends SteeringBehaviors

# --- Properties for Blending ---


var m_behaviors: Array[SteeringBehaviors] = [] 
var m_weights: Array[float] = []

# Function to add a behavior and its corresponding weight
func add_behavior(behavior: SteeringBehaviors, weight: float) -> void:
	m_behaviors.append(behavior)
	m_weights.append(weight)

# Function to update the weight of an existing behavior (by index)
func set_weight_by_index(index: int, new_weight: float) -> void:
	if index >= 0 and index < m_weights.size():
		m_weights[index] = new_weight
	else:
		push_warning("Invalid index for setting behavior weight.")

# --- Blending Calculation (The equivalent of getForce()) ---

func calculate() -> Vector2:
	var blended_force = Vector2.ZERO
	
	for i in range(m_behaviors.size()):
		var force = m_behaviors[i].calculate()
		var weighted_force = force * m_weights[i]
		blended_force += weighted_force
	
	if blended_force.length_squared() > owner.max_acceleration * owner.max_acceleration:
		blended_force = blended_force.normalized() * owner.max_acceleration
	
	return blended_force
