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

func test_export():
	var scale = 0.2
	var path = "user://perlin_1D_numbers_" +  str(scale)   +".txt"
	var file = FileAccess.open(path,FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file: " + path)
		return
	for i in range(200):
		var x = i * scale
		var y = perlin_1d(x)
		var y_norm = (y + 1)/2
		var formated = ("%0.3f" % y_norm).replace(".",",")
		file.store_line(formated)
	file.close()
