@tool
extends Node2D
class_name NavGraph

@onready var label_font := preload("res://Roboto.ttf")
@export var edge_list: Array[PackedInt32Array] = []:
	set(value):
		edge_list = value
		rebuild_from_scene()

var nodes: Array[Vector2] = []
var edges: Dictionary = {}


func _enter_tree() -> void:
	rebuild_from_scene()


func _ready() -> void:
	rebuild_from_scene()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		rebuild_from_scene()


func rebuild_from_scene() -> void:
	nodes.clear()
	edges.clear()
	for child in get_children():
		if child is Node2D:
			nodes.append(child.position)
			
	for pair in edge_list:
		if pair.size() != 2:
			continue
		var a = pair[0]
		var b = pair[1]
		if a < 0 or b < 0 or a >= nodes.size() or b >= nodes.size():
			continue
		if not edges.has(a): edges[a] = []
		if not edges.has(b): edges[b] = []
		if b not in edges[a]:
			edges[a].append(b)
		if a not in edges[b]:
			edges[b].append(a)
	queue_redraw()

func find_path(start_id: int, goal_id: int) -> Array[int]:
	if start_id == goal_id:
		return [start_id]
	
	var open_set := PriorityQueue.new()
	open_set.push(start_id, 0)
	
	var came_from: Dictionary = {}
	var g_score: Dictionary = {}
	var f_score: Dictionary = {}
	
	for i in range(nodes.size()):
		g_score[i] = INF
		f_score[i] = INF
	
	g_score[start_id] = 0
	f_score[start_id] = nodes[start_id].distance_to(nodes[goal_id])
	
	var visited: Dictionary = {}
	
	while not open_set.is_empty():
		var current = open_set.pop()
		
		if current == goal_id:
			return _reconstruct_path(came_from, current)
		
		visited[current] = true
		
		for neighbor in edges.get(current, []):
			if visited.has(neighbor):
				continue
			
			var tentative_g = g_score[current] + nodes[current].distance_to(nodes[neighbor])
			
			if tentative_g < g_score[neighbor]:
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g
				f_score[neighbor] = tentative_g + nodes[neighbor].distance_to(nodes[goal_id])
				
				open_set.push(neighbor, f_score[neighbor])
	
	return []

func _reconstruct_path(came_from: Dictionary, current: int) -> Array[int]:
	var total_path:Array[int] = [current]
	
	while came_from.has(current):
		current = came_from[current]
		total_path.insert(0, current)
	
	return total_path

func get_node_position(id: int) -> Vector2:
	return nodes[id]

func _draw() -> void:
	for pos in nodes:
		draw_circle(pos, 6.0, Color.RED)
	# draw edges
	for a in edges.keys():
		for b in edges[a]:
			if b > a:
				draw_line(nodes[a], nodes[b], Color.WHITE, 2.0)
	for i in range(nodes.size()):
		var pos = nodes[i]
		draw_circle(pos, 6.0, Color.RED)
		draw_string(label_font, pos + Vector2(10, -10), str(i), HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)


class PriorityQueue:
	var items: Array = []
	
	func push(item, priority: float) -> void:
		items.append({"i": item, "p": priority})
		items.sort_custom(func(a, b): return a["p"] < b["p"])
	
	func pop():
		return items.pop_front()["i"]
	
	func is_empty() -> bool:
		return items.is_empty()
