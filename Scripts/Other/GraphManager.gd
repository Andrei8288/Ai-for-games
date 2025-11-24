extends Manager
class_name GraphTestManager

@export var nav_graph: NavGraph
@export var start_node: int = 0
@export var goal_node: int = 0

func _ready() -> void:
	set_process_input(true)
	call_deferred("_update_boid_list")
	nav_graph.rebuild_from_scene()
	var path = nav_graph.find_path(start_node, goal_node)
	print("Computed path: ", path)
	spawnGraph_npc(nav_graph.nodes[start_node])
	_assign_paths_to_npcs(path)


func _assign_paths_to_npcs(path: Array[int]) -> void:
	for npc in boids:
		npc.call_deferred("set_nav_data", nav_graph, path)

func spawnGraph_npc(startNode:Vector2):
	for i in npc_count:
		var npc = npc_scene.instantiate()
		npc.position = startNode
		npc.name = "NPC_" + str(i+1)
		npc_container.add_child(npc)
		npc.target_node = $%DraggableTarget
		boids.append(npc) 
