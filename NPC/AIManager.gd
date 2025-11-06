extends CharacterBody2D
class_name AIManager

# --- Exported Properties ---
@export var target_node: Node2D 
@export var max_speed: float = 300.0 
@export var max_acceleration: float = 800.0
# --- Proprieties ---
var steering_acceleration: Vector2 = Vector2.ZERO
# --- Behavior Management ---
var Behavior = SteeringBehaviors.Behavior 
var current_behavior = Behavior.NONE
var active_behavior: SteeringBehaviors = null
# ---Behaviors Instances---
var seek_behavior: DynamicSeek = null
var flee_behavior: DynamicFlee = null
var arrive_behavior: Arrive = null


func _ready() -> void:
	_behavior_init()
	velocity = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_S:
				if current_behavior != Behavior.DYN_SEEK:
					current_behavior = Behavior.DYN_SEEK
				else:
					current_behavior = Behavior.NONE
			KEY_F:
				if current_behavior != Behavior.DYN_FLEE:
					current_behavior = Behavior.DYN_FLEE
				else:
					current_behavior = Behavior.NONE
			KEY_A:
				if current_behavior != Behavior.ARRIVE:
					current_behavior = Behavior.ARRIVE
				else:
					current_behavior = Behavior.NONE

func _physics_process(delta: float) -> void:
	match current_behavior:
		Behavior.DYN_SEEK:
			_behavior_parameter_init(seek_behavior)
		Behavior.DYN_FLEE:
			_behavior_parameter_init(flee_behavior)
			_apply_stop_check()
		Behavior.ARRIVE:
			_behavior_parameter_init(arrive_behavior)
			_apply_stop_check()
		Behavior.NONE:
			_behavior_none()
			return
	
	_apply_movement(delta)

func _behavior_init() -> void:
	seek_behavior = DynamicSeek.new()
	_configure_behavior(seek_behavior)
	flee_behavior = DynamicFlee.new()
	_configure_behavior(flee_behavior)
	arrive_behavior = Arrive.new()
	_configure_behavior(arrive_behavior)

func _configure_behavior(behavior_instance: SteeringBehaviors) -> void:
	behavior_instance.max_speed = max_speed
	behavior_instance.max_acceleration = max_acceleration

func _behavior_parameter_init(behaviot_instance:SteeringBehaviors) -> void:
	active_behavior = behaviot_instance
	active_behavior.position = global_position
	active_behavior.velocity = velocity
	steering_acceleration = active_behavior.calculate(target_node.global_position)

func _apply_stop_check() -> void:
	if steering_acceleration == Vector2.ZERO:
				velocity = Vector2.ZERO

func _behavior_none() -> void:
	active_behavior = null
	velocity = Vector2.ZERO
	update_animation(Vector2.ZERO, "idle")

func _apply_movement(delta:float) -> void:
	velocity += steering_acceleration * delta
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	move_and_slide()
	if velocity.length_squared() > 0:
		update_animation(velocity, "walk")
	else:
		update_animation(Vector2.ZERO, "idle")

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
