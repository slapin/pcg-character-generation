extends Spatial

var base
var female
var male
var img1
var img2

const imgsize = 256

func calc_difference(img, base_mesh, target_mesh):
	img.lock()
	for x in range(img.get_width()):
		for y in range(img.get_height()):
			var u = float(x)/img.get_width()
			var v = float(y)/img.get_height()
			img.set_pixel(x, y, Color(randf(), randf(), randf(), 1))
	img.unlock()

func _ready():
	var dir = Directory.new()
	dir.remove("res://assets/base/female.png")
	dir.remove("res://assets/base/male.png")
	img1 = Image.new()
	img1.create(imgsize, imgsize, false, Image.FORMAT_RGB8)
	calc_difference(img1, null, null)
	img1.save_png("res://assets/base/female.png")
	img2 = Image.new()
	img2.create(imgsize, imgsize, false, Image.FORMAT_RGB8)
	calc_difference(img2, null, null)
	img2.save_png("res://assets/base/male.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
