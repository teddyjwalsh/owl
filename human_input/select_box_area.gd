extends Area3D

var arr: PackedVector3Array

# Called when the node enters the scene tree for the first time.
func _ready():
	arr.resize(8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func construct_from_screen_coords(in_screen_coords):
	var viewport = get_viewport()
	if viewport != null:
		var collect_distance = 200
		var camera = viewport.get_camera_3d()
		if camera != null and in_screen_coords[0].x != in_screen_coords[1].x and in_screen_coords[0].y != in_screen_coords[1].y:
			#$CollisionShape3D.shape = ConvexPolygonShape3D.new()
			arr[0] = camera.project_position(in_screen_coords[0], 5)
			arr[2] = camera.project_position(Vector2(in_screen_coords[0].x, in_screen_coords[1].y), 5)
			arr[1] = camera.project_position(in_screen_coords[1], 5)
			arr[3] = camera.project_position(Vector2(in_screen_coords[1].x, in_screen_coords[0].y), 5)
			arr[6] = camera.project_position(in_screen_coords[1], collect_distance)
			arr[4] = camera.project_position(Vector2(in_screen_coords[0].x, in_screen_coords[1].y), collect_distance)
			arr[5] = camera.project_position(in_screen_coords[0], collect_distance)
			arr[7] = camera.project_position(Vector2(in_screen_coords[1].x, in_screen_coords[0].y), collect_distance)
			$CollisionShape3D.shape.set_points(arr)

func clear():
	$CollisionShape3D.shape
	var arr = PackedVector3Array()
	$CollisionShape3D.shape.set_points(arr)
