extends Node2D


@export var npc_scene: PackedScene
@export var npc_count: int
@export var spawn_area: Vector2 = Vector2(310,310)
@onready var npc_container: Node2D = $"../NPCsContainer"
@onready var random: RandomAI = $RandomAI

func _ready() -> void:
	spawn_npc()
	#spawn_npc_normal_dist()
	#test_options()


func spawn_npc():
	for i in npc_count:
		var npc = npc_scene.instantiate()
		var x = random.uniform_int(-spawn_area.x/2,spawn_area.x/2)
		var y = random.uniform_int(-spawn_area.y/2,spawn_area.y/2)
		npc.set_position(Vector2(x, y))
		npc.name = "NPC" + str(i+1)
		npc_container.add_child(npc)

func spawn_npc_normal_dist():
	for i in npc_count:
		var npc = npc_scene.instantiate()
		var x = random.normal_float(0.0, spawn_area.x / 6)
		var y = random.normal_float(0.0, spawn_area.y / 6)
		npc.set_position(Vector2(x, y))
		npc.name = "NPC" + str(i+1)
		npc_container.add_child(npc)

func test_options():
	for npc in npc_container.get_children():
		var option = npc.get_node("OptionTextOutput")
		option.duration = 2.0
		option.cooldown = 0.0
		option.text = "Testing " + npc.name
		call_deferred("start_test", option)
		
func start_test(option):
	option.start()
	option.pause()
	option.start()
