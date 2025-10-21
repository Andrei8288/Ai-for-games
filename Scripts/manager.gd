extends Node2D


@export var npc_scene: PackedScene
@export var npc_count: int
@export var spawn_area: Vector2 = Vector2(310,310)
@onready var npc_container: Node2D = $"../NPCsContainer"

func _ready() -> void:
	spawn_npc()
	test_options()


func spawn_npc():
	for i in npc_count:
		var npc = npc_scene.instantiate()
		var x = randf_range(-spawn_area.x/2,spawn_area.y/2)
		var y = randf_range(-spawn_area.y / 2, spawn_area.y / 2)
		npc.set_position(Vector2(x, y))
		npc.name = "NPC" + str(i+1)
		npc_container.add_child(npc)

func test_options():
	for npc in npc_container.get_children():
		var option = npc.get_node("OptionTextOutput")
		option.duration = 2.0
		option.cooldown = 3.0
		option.text = "Testing " + npc.name
		call_deferred("start_test", option)

func start_test(option):
	option.start()
	option.pause()
	option.start()
