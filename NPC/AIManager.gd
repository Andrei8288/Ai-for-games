extends CharacterBody2D
class_name AIManager

#region exported
@export var target_node: Node2D
@export var max_speed: float = 100.0
@export var max_acceleration: float = 170.0
#endregion

#region behaviors
const Behavior = SteeringBehaviors.Behavior
var current_behavior: Behavior = Behavior.NONE

var seek_behavior: DynamicSeek
var flee_behavior: DynamicFlee
var arrive_behavior: DynamicArrive
var flocking_behavior: DynamicFlocking
var grappling_behavior: DynamicGrapplingHook
#endregion

var steering_force: Vector2 = Vector2.ZERO
var buddies: Array = []

var nav_graph: NavGraph = null
var nav_path: Array[int] = []


func _ready() -> void:
	add_to_group("boids")
	_init_behaviors()
	velocity = Vector2(randf_range(-40, 40), randf_range(-40, 40))


func _init_behaviors() -> void:
	seek_behavior = DynamicSeek.new()
	seek_behavior.owner = self

	flee_behavior = DynamicFlee.new()
	flee_behavior.owner = self

	arrive_behavior = DynamicArrive.new()
	arrive_behavior.owner = self

	flocking_behavior = DynamicFlocking.new()
	flocking_behavior.owner = self

	grappling_behavior = DynamicGrapplingHook.new()
	grappling_behavior.owner = self


func on_behavior_input(keycode: int) -> void:
	match keycode:
		KEY_B:
			current_behavior = Behavior.DYN_FLOCK if current_behavior != Behavior.DYN_FLOCK else Behavior.NONE
		KEY_S:
			current_behavior = Behavior.DYN_SEEK if current_behavior != Behavior.DYN_SEEK else Behavior.NONE
		KEY_F:
			current_behavior = Behavior.DYN_FLEE if current_behavior != Behavior.DYN_FLEE else Behavior.NONE
		KEY_A:
			current_behavior = Behavior.DYN_ARRIVE if current_behavior != Behavior.DYN_ARRIVE else Behavior.NONE
		KEY_G:
			current_behavior = Behavior.DYN_GRAPPLE if current_behavior != Behavior.DYN_GRAPPLE else Behavior.NONE


func compute_steering() -> void:
	match current_behavior:
		Behavior.DYN_FLOCK:
			steering_force = flocking_behavior.calculate()
		Behavior.DYN_SEEK:
			steering_force = seek_behavior.calculate()
		Behavior.DYN_FLEE:
			steering_force = flee_behavior.calculate()
		Behavior.DYN_ARRIVE:
			steering_force = arrive_behavior.calculate()
		Behavior.DYN_GRAPPLE:
			steering_force = grappling_behavior.calculate()
		Behavior.NONE:
			steering_force = Vector2.ZERO
			stop()


func apply_movement(delta):
	if current_behavior == Behavior.DYN_GRAPPLE:
		velocity += steering_force
	else:
		velocity += steering_force * delta
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	move_and_slide()
	# Animations
	if velocity.length_squared() > 0.01:
		update_animation(velocity, "walk")
	else:
		update_animation(Vector2.ZERO, "idle")



func stop() -> void:
	velocity = Vector2.ZERO
	steering_force = Vector2.ZERO
	update_animation(Vector2.ZERO, "idle")


func set_nav_data(graph: NavGraph, path: Array[int]) -> void:
	nav_graph = graph
	nav_path = path
	grappling_behavior.graph = nav_graph
	grappling_behavior.path = nav_path
	grappling_behavior.current_index = 0


func update_animation(m_velocity: Vector2, state: String = "idle") -> void:
	var angle = fmod(450.0 - rad_to_deg(atan2(m_velocity.y, m_velocity.x)), 360.0)
	var directions = [0, 45, 90, 135, 180, 225, 270, 315]
	var closest = 0
	var min_diff = 360.0

	for i in range(directions.size()):
		var diff = abs(angle - directions[i])
		if diff > 180.0:
			diff = 360.0 - diff
		if diff < min_diff:
			min_diff = diff
			closest = i

	var anims = ["down", "down_left", "left", "up_left", "up", "up_left", "left", "down_left"]
	var flips = [false, true, true, true, false, false, false, false]
	var anim = anims[closest]
	var flip = flips[closest]

	$AnimatedSprite2D.flip_h = flip
	var full_anim = state + "_" + anim
	if $AnimatedSprite2D.animation != full_anim:
		$AnimatedSprite2D.play(full_anim)
