class_name RandomAI extends Node

var noise := FastNoiseLite.new()
@export var noise_frequency:float = 0.4

func _init() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = randi()
	noise.frequency = noise_frequency

func _ready():
	pass
	test_export()


func perlin1D(x:float):
	var val = noise.get_noise_1d(x)
	return(val + 1) * 0.5

func uniform_float(min_val:float,max_val:float) -> float:
	return lerp(min_val,max_val,randf())

func uniform_int(min_val:int, max_val:int) -> int:
	return randi() % (max_val - min_val + 1) + min_val

func normal_float(mean:float = 0.0, stddev: float = 1.0) -> float:
	var u1 = randf()
	var u2 = randf()
	var z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * PI * u2)
	return z0 * stddev + mean

func normal_int(mean:float = 0.0, stddev: float = 1.0) -> int:
	return int(round(normal_float(mean,stddev)))

func test_export():
	var path = "user://perlin_1D_numbers"+ str(noise_frequency) +".txt"
	var file = FileAccess.open(path,FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file: " + path)
		return
	for i in range(200):
		var x = i
		var n = perlin1D(x)
		print(n)
		var formated = ("%0.3f" % n).replace(".",",")
		file.store_line(formated)
	file.close()
	#print("Random number exported to: ", path)
	
