extends CharacterBody2D
class_name AIManager

# --- Exported Properties ---
@export var target_node: Node2D 
@export var max_speed: float = 300.0 
@export var max_acceleration: float = 800.0
# --- Proprieties --- #
var steering_force: Vector2 = Vector2.ZERO
# --- Behavior Management --- #
var Behavior = SteeringBehaviors.Behavior 
var current_behavior = Behavior.NONE
var active_behavior: SteeringBehaviors = null
# ---Behaviors Instances--- #
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
	var next_behavior:SteeringBehaviors = null
	
	match current_behavior:
		Behavior.DYN_SEEK:
			next_behavior = seek_behavior
		Behavior.DYN_FLEE:
			next_behavior = flee_behavior
		Behavior.ARRIVE:
			next_behavior = arrive_behavior
		Behavior.NONE:
			behavior_none()
			return
	_behavior_calculate(next_behavior)
	_apply_movement(delta)

func _behavior_init() -> void:
	# --- SEEK ---#
	seek_behavior = DynamicSeek.new()
	seek_behavior.owner = self
	# --- FLEE ---#
	flee_behavior = DynamicFlee.new()
	flee_behavior.owner = self
	# --- ARRIVE ---#
	arrive_behavior = Arrive.new()
	arrive_behavior.owner = self

func _behavior_calculate(behavior_instance:SteeringBehaviors) -> void:
	active_behavior = behavior_instance
	steering_force = active_behavior.calculate()

func behavior_none() -> void:
	active_behavior = null
	velocity = Vector2.ZERO
	update_animation(Vector2.ZERO, "idle")
	
func stop() -> void:
	velocity = Vector2.ZERO
	update_animation(Vector2.ZERO, "idle")

func _apply_movement(delta:float) -> void:
	velocity += steering_force * delta
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
