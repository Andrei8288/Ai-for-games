extends CharacterBody2D

@export var target_node:Node2D
@export var max_speed:float = 30.0
@export var max_acceleration = 10.0
var curren_behavior:Behavior = Behavior.NONE
var active_behavior:SteeringBehaviors = null
var seek_behavior:DynamicSeek = DynamicSeek.new()


enum Behavior{
	NONE,
	DYN_SEEK,
	DYN_FLEE,
	ARRIVE
	}

func _ready() -> void:
	seek_behavior.position = global_position
	seek_behavior.velocity = velocity
	active_behavior = null


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_S:
				curren_behavior = Behavior.DYN_SEEK if curren_behavior != Behavior.DYN_SEEK else Behavior.NONE
			KEY_F:
				curren_behavior = Behavior.DYN_FLEE if curren_behavior != Behavior.DYN_FLEE else Behavior.NONE
			KEY_A:
				curren_behavior = Behavior.ARRIVE if curren_behavior != Behavior.ARRIVE else Behavior.NONE

func _physics_process(delta: float) -> void:
	match curren_behavior:
		Behavior.DYN_SEEK:
			active_behavior = seek_behavior
		Behavior.DYN_FLEE:
			pass
		Behavior.NONE:
			active_behavior = null
			velocity = Vector2.ZERO
			update_animation(Vector2.ZERO, "idle")
	#if velocity.length() > 0:
		#update_animation(velocity, "walk")   
	if active_behavior:
		active_behavior.position = global_position
		active_behavior.velocity = velocity 6





func kinematic_seek(target_pos:Vector2, _delta:float) -> void:
	velocity = target_pos - global_position
	var distance = velocity.length()
	
	if distance < 20:
		velocity = Vector2.ZERO
	else:
		velocity = velocity.normalized() * max_speed
	move_and_slide()


func update_animation(m_velocity: Vector2, state: String = "idle"):
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
