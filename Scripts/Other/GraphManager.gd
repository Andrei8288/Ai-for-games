extends Manager
class_name GraphTestManager

@export var nav_graph: NavGraph
@export var start_node: int = 0
@export var goal_node: int = 0

func _ready() -> void:
	set_process_input(true)
	super._ready()
	nav_graph.rebuild_from_scene()
	var path = nav_graph.find_path(start_node, goal_node)
	print("Computed path: ", path)
	_assign_paths_to_npcs(path)


func _assign_paths_to_npcs(path: Array[int]) -> void:
	for npc in boids:
		npc.call_deferred("set_nav_data", nav_graph, path)
