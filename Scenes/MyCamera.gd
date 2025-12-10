extends Camera2D

var zoom_speed := 0.1
var min_zoom := 0.3
var max_zoom := 3.0

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom * (1.0 - zoom_speed)).clamp(
				Vector2(min_zoom, min_zoom),
				Vector2(max_zoom, max_zoom)
			)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom * (1.0 + zoom_speed)).clamp(
				Vector2(min_zoom, min_zoom),
				Vector2(max_zoom, max_zoom)
			)

	# Drag with middle mouse (wheel)
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		global_position -= event.relative / zoom
