class_name DecisionTree extends RefCounted

# -------------------------
# Context: what the tree knows
# -------------------------
class Context:
	var agent          
	var target_distance: float = INF
	var buddy_count: int = 0
	const NEIGHBORHOOD_RADIUS = 200
	const MAX_TARGET_RANGE := 300
	
	func _init(_agent):
		self.agent = _agent
	
	func update() -> void:
		# distance to target
		if agent.target_node:
			target_distance = agent.global_position.distance_to(agent.target_node.global_position)
		
		# number of buddies
		if "buddies" in agent:
			buddy_count = agent.buddies.size()
		else:
			buddy_count = 0
	
	func has_target() -> bool:
		return agent.target_node != null and target_distance <= MAX_TARGET_RANGE
	
	func is_target_far() -> bool:
		return target_distance > 200.0
	
	func has_many_buddies() -> bool:
		var near = 0
		var pos = agent.global_position
		
		for other in agent.buddies:
			if other == agent:
				continue
			if pos.distance_to(other.global_position) <= NEIGHBORHOOD_RADIUS:
				near += 1
		
		return near >= 1 



# -------------------------
# Leaf node
# -------------------------
class ActionNode:
	var action: Callable
	
	func _init(_action: Callable):
		self.action = _action
	
	func evaluate(ctx: Context) -> void:
		action.call(ctx)


# -------------------------
# Decision node
# -------------------------
class DecisionNode:
	var question: Callable
	var true_child
	var false_child
	
	func _init(_question: Callable, _true_child, _false_child):
		self.question = _question
		self.true_child = _true_child
		self.false_child = _false_child
	
	func evaluate(ctx: Context) -> void:
		if question.call(ctx):
			true_child.evaluate(ctx)
		else:
			false_child.evaluate(ctx)



static func build_tree(agent) -> Dictionary:
	var ctx = Context.new(agent)
	var Behavior = SteeringBehaviors.Behavior

	# ----------------------------------------
	# ACTION nodes (leaves)
	# ----------------------------------------

	@warning_ignore("unused_variable")
	# No target, but many buddies -> wander as a group
	var action_wander_with_flock = ActionNode.new(
		func(c):
			c.agent.set_base_behavior(Behavior.DYN_WANDER)
			c.agent.enable_flocking()
	)

	@warning_ignore("unused_variable")
	# No target and alone -> wander solo
	var action_wander_solo = ActionNode.new(
		func(c):
			c.agent.set_base_behavior(Behavior.DYN_WANDER)
			c.agent.disable_flocking()
	)

	@warning_ignore("unused_variable")
	# Target far & many buddies -> seek as a pack
	var action_seek_with_flock = ActionNode.new(
		func(c):
			c.agent.set_base_behavior(Behavior.DYN_SEEK)
			c.agent.enable_flocking()
	)

	@warning_ignore("unused_variable")
	# Target far & alone -> seek solo
	var action_seek_solo = ActionNode.new(
		func(c):
			c.agent.set_base_behavior(Behavior.DYN_SEEK)
			c.agent.disable_flocking()
	)

	@warning_ignore("unused_variable")
	# Target close -> arrive precisely, no flock
	var action_arrive_no_flock = ActionNode.new(
		func(c):
			c.agent.set_base_behavior(Behavior.DYN_ARRIVE)
			c.agent.disable_flocking()
	)

	@warning_ignore("unused_variable")
	var action_idle_no_flock = ActionNode.new(
		func(c):
			c.agent.set_base_behavior(Behavior.NONE)
			c.agent.disable_flocking()
	)

	# ----------------------------------------
	# DECISION nodes
	# ----------------------------------------

	var node_many_buddies_when_no_target = DecisionNode.new(
		func(c): return c.has_many_buddies(),
		action_wander_with_flock,   # true
		action_idle_no_flock        # false
	)

	var node_many_buddies_when_far = DecisionNode.new(
		func(c): return c.has_many_buddies(),
		action_seek_with_flock,     # true
		action_seek_solo            # false
	)
	
	# Node: is target far?
	var node_is_target_far = DecisionNode.new(
		func(c): return c.is_target_far(),
		node_many_buddies_when_far,   # true -> decide pack vs solo seek
		action_arrive_no_flock        # false -> close, arrive without flock
	)

	# ROOT: has target?
	var root_has_target = DecisionNode.new(
		func(c): return c.has_target(),
		node_is_target_far,                  # true  -> handle distance/buddies
		node_many_buddies_when_no_target     # false -> wander variants
	)

	return {
		"context": ctx,
		"root": root_has_target
	}


# Decision Tree:
#
#                    HasTarget?
#                 /              \
#              no                 yes
#             /                     \
#     HasManyBuddies?                IsTargetFar?
#        /      \                    /         \
#      yes      no                 yes           no
#      /         \                 /              \
# Wander+Flock  WanderSolo    Seek+Flock    ArriveNoFlock
