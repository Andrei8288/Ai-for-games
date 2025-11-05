class_name PerlinNoise extends Node

var perm =[]
var seed_u = 1337

func _ready() -> void:
	randomize_permutation()
	test_export()

func randomize_permutation() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = seed_u
	perm.resize(256)
	for i in range(256):
		perm[i] = i
	perm.shuffle()
	perm += perm

func fade(t:float) -> float:
	return t * t * t *(t * (t * 6 - 15) + 10)

func lerp(a:float , b:float , t:float) -> float:
	return a + t * (b - a)

func grad(p:int, x:float) -> float:
	if (p % 2 == 0):
		return x
	else:
		return -x

func perlin_1d(x:float) -> float:
	var xi = int(floor(x)) % 256
	var xf = x - floor(x)
	
	var g0 = grad(perm[xi],xf)
	var g1 = grad(perm[(xi + 1) % 256],xf - 1 )
	
	var u = fade(xf)
	return lerp(g0,g1,u)

func perlin_1d_octaves(x: float,frequency:float = 1,amplitude:float = 1, octaves: int = 4, 
	persistence: float = 0.5) -> float:
	var total = 0.0

	for i in range(octaves):
		total += perlin_1d(x * frequency) * amplitude
		amplitude *= persistence    
		frequency *= 2.0
	return total

func test_export():
	var path = "user://perlin_1D_numbers_.txt"
	var file = FileAccess.open(path,FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file: " + path)
		return
	for i in range(50):
		var x = i
		var y = perlin_1d_octaves(x, 0.2, 1.5, 5, 0.5)
		var y_norm = (y + 1)/2
		var formated = ("%0.3f" % y_norm).replace(".",",")
		file.store_line(formated)
	file.close()
