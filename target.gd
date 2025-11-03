extends Node2D

var dragging:bool = false
var drag_offset = Vector2.ZERO
var target_pos = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_global_mouse_position().distance_to(global_position) < 16:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			dragging = false

func _process(_delta: float) -> void:
	if dragging:
		target_pos = get_global_mouse_position() + drag_offset
		global_position = target_pos
		
