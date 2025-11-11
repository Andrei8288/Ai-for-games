extends Node
class_name OptionAI

signal started
signal stopped
signal paused

var duration:float = 0.0
var cooldown:float = 0.0
var is_active:bool = false
var is_paused:bool = false
var start_time:float = 0.0
var last_stop_time: float = -1.0

func _init(_duration:float = 0.0, _cooldown: float = 0.0) -> void:
	duration = _duration
	cooldown = _cooldown

func start() -> void:
	if not is_on_cooldown():
		is_active = true
		is_paused = false
		last_stop_time = Time.get_ticks_msec()/1000.0
		emit_signal("started")

func stop() -> void:
	if is_active:
		is_active = false
		is_paused = false
		last_stop_time = Time.get_ticks_msec()/1000.0
		emit_signal("stopped")

func pause() -> void:
	if is_active:
		is_paused = true
		is_active = false
		emit_signal("paused")

func is_on_cooldown() -> bool:
	if last_stop_time < 0:
		return false
	var now = Time.get_ticks_msec()/1000.0
	return (now - last_stop_time) < cooldown
