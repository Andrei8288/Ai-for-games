extends OptionAI
class_name  OptionTextOutput

@export var text:String = "Option running"
@onready var option: OptionTextOutput = $"."

func _ready():
	started.connect(Callable(self, "on_option_started"))
	stopped.connect(Callable(self, "on_option_stopped"))
	paused.connect(Callable(self, "on_option_paused"))

func on_option_started():
	print("Started ", text)
func on_option_stoped():
	print("Stopped ", text)
func on_option_paused():
	print("Paused ", text)
