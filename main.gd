extends Spatial

var base
var female
var male
var img1
var img2

const imgsize = 1024


func find_closest_vertices(t, u, v):
	var ret = []
	var dist = 2.0
	var uv = Vector2(u, v)
	var current = -1
	var count = t.get_vertex_count()
	var distances = []
	distances.resize(count)
	for h in range(count):
		var cur_uv = t.get_vertex_uv(h)
		var dst = uv.distance_squared_to(cur_uv)
		distances[h] = dst
	for n in range(count):
		if dist > distances[n]:
			current = n
			dist = distances[n]
	ret.append(current)
	var faces = t.get_vertex_faces(current)
	var verts = []
	for k in faces:
		verts.append(t.get_face_vertex(k, 0))
		verts.append(t.get_face_vertex(k, 1))
		verts.append(t.get_face_vertex(k, 2))
	dist = 2.0
	current = -1
	while ret.size() < 3:
		for n in verts:
			if n in ret:
				continue
			if dist > distances[n]:
				current = n
				dist = distances[n]
		ret.append(current)
		dist = 2.0
	return ret
		
func get_weights(t, r, u, v):
	var ret = []
	for k in range(r.size()):
		var cur_uv = t.get_vertex_uv(r[k])
		var weight = 1.0 / 1.0 + cur_uv.distance_to(Vector2(u, v))
		ret.append(weight)
	return ret
func get_weight_sum(t, r, w):
	var ret = Vector3()
	for k in range(r.size()):
		ret = ret + t.get_vertex(r[k]) * w[k]
	return ret
		
func calc_difference(img, base_mesh, target_mesh):
	img.lock()
	for s in range(base_mesh.get_surface_count()):
		var tool1 = MeshDataTool.new()
		var tool2 = MeshDataTool.new()
		tool1.create_from_surface(base_mesh, s)
		tool2.create_from_surface(target_mesh, s)
		print(tool1.get_vertex_count())
		print(tool2.get_vertex_count())
		print("start")
		for x in range(img.get_width()):
			var u = float(x)/img.get_width()
			for y in range(img.get_height()):
				var v = float(y)/img.get_height()
				var r1 = find_closest_vertices(tool1, u, v)
				var r2 = find_closest_vertices(tool2, u, v)
				var w1 = get_weights(tool1, r1, u, v)
				var w2 = get_weights(tool2, r2, u, v)
				var v1 = get_weight_sum(tool1, r1, w1)
				var v2 = get_weight_sum(tool2, r2, w2)
				var diff = v2 - v1
				diff += Vector3(1.0, 1.0, 1.0)
				diff.x = clamp(diff.x, 0.0, 2.0)
				diff.y = clamp(diff.y, 0.0, 2.0)
				diff.z = clamp(diff.z, 0.0, 2.0)
				diff *= 0.5
				img.set_pixel(x, y, Color(diff.x, diff.y, diff.z, 1))
			print("u = ", u)
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
