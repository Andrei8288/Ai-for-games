extends Node2D

@export var npc_scene: PackedScene
@export var npc_count: int
@export var spawn_area: Vector2 = Vector2(310,310)

@onready var npc_container: Node2D = $%NPCsContainer
@onready var random: RandomAI = $RandomAI
@onready var perlin: PerlinNoise = $PerlinNoise

var boids: Array = []     


func _ready():
	spawn_npc()
	call_deferred("_update_boid_list")

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		for b in boids:
			b.on_behavior_input(event.keycode)


func _physics_process(delta: float) -> void:
	_update_buddies()
	
	for b in boids:
		if b:
			b.compute_steering()
	 
	for b in boids:
		if b:
			b.apply_movement(delta)

func spawn_npc():
	for i in npc_count:
		var npc = npc_scene.instantiate()
		var x = random.uniform_float(-spawn_area.x/2, spawn_area.x/2)
		var y = random.uniform_float(-spawn_area.y/2, spawn_area.y/2)

		npc.position = Vector2(x, y)
		npc.name = "NPC_" + str(i+1)
		npc_container.add_child(npc)

		npc.target_node = $%DraggableTarget

		boids.append(npc) 

func spawn_npc_normal_dist():
	for i in npc_count:
		var npc = npc_scene.instantiate()
		var x = random.normal_float(0.0, spawn_area.x / 6)
		var y = random.normal_float(0.0, spawn_area.y / 6)

		npc.position = Vector2(x, y)
		npc.name = "NPC" + str(i+1)
		npc_container.add_child(npc)

		boids.append(npc)

func _update_boid_list():
	boids.clear()
	for npc in npc_container.get_children():
		if npc.is_in_group("boids"):
			boids.append(npc)

func _update_buddies():
	for b in boids:
		b.buddies = []
		for other in boids:
			if other != b:
				b.buddies.append(other)
