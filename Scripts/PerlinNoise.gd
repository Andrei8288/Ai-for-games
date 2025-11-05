class_name PerlinNoise
extends Node

var perm = []
var seed_u = randi()

func _ready() -> void:
	randomize_permutation()
	test_export()

func randomize_permutation() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = seed_u
	perm.resize(256)
	for i in range(256):
		perm[i] = i
		
	for i in range(255, -1, -1):
		var j = rng.randi_range(0, i)
		var temp = perm[i]
		perm[i] = perm[j]
		perm[j] = temp
	perm += perm


func fade(t: float) -> float:
	return t * t * t * (t * (t * 6 - 15) + 10)


func lerp(a: float, b: float, t: float) -> float:
	return a + t * (b - a)


func grad(_hash: int, x: float) -> float:
	var h = _hash & 1
	return x if h == 0 else -x

func perlin_1d(x: float) -> float:
	var xi = int(floor(x)) & 255
	var xf = x - floor(x)
	
	var g0 = grad(perm[xi], xf)
	var g1 = grad(perm[xi + 1], xf - 1)
	
	var u = fade(xf)
	return lerp(g0, g1, u)

func perlin_1d_octaves(x: float, frequency: float = 1, amplitude: float = 1, octaves: int = 4, persistence: float = 0.5, lacunarity: float = 2.0) -> float:
	var total = 0.0
	var max_value = 0.0
	for i in range(octaves):
		total += perlin_1d(x * frequency) * amplitude
		max_value += amplitude
		amplitude *= persistence
		frequency *= lacunarity
	return total / max_value     # normalizing to [-1,1]

func test_export():
	var path = "user://perlin_1D_numbers.txt"
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file: " + path)
		return
	var scale = 0.01 
	for i in range(400):
		var x = i * scale
		var y = perlin_1d_octaves(x, 2.0, 1.0, 4, 0.5, 1.2)
		var y_norm = (y + 1) / 2 
		file.store_line(("%0.3f" % y_norm).replace(".", ","))
	file.close()
