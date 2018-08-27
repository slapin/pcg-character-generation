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

func collect_meshes(root, where):
	var queue = root.get_children()
	while queue.size() > 0:
		var t = queue[0]
		queue.pop_front()
		if t is MeshInstance:
			where.append(t)
		for h in t.get_children():
			queue.append(h)
func _ready():
	var dir = Directory.new()
	var base_meshes = []
	var base_male_meshes = []
	var base_female_meshes = []
	var queue = []
	collect_meshes($charview/base_mesh, base_meshes)
	collect_meshes($charview/base_mesh_female, base_female_meshes)
	collect_meshes($charview/base_mesh_male, base_male_meshes)
	for i in range(base_meshes.size()):
		dir.remove("res://assets/base/female_" + str(i) + ".png")
		dir.remove("res://assets/base/male_" + str(i) + ".png")
		img1 = Image.new()
		img1.create(imgsize, imgsize, false, Image.FORMAT_RGB8)
		calc_difference(img1, base_meshes[i].get_mesh(), base_female_meshes[i].get_mesh())
		img1.save_png("res://assets/base/female_" + str(i) + ".png")
		img2 = Image.new()
		img2.create(imgsize, imgsize, false, Image.FORMAT_RGB8)
		calc_difference(img2, base_meshes[i].get_mesh(), base_female_meshes[i].get_mesh())
		img2.save_png("res://assets/base/male_" + str(i) + ".png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
