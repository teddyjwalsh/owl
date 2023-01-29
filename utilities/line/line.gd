extends Node3D

var last_line = null
var lines = []
var waypoint_scene = preload("res://utilities/waypoint/waypoint.tscn")
var waypoint = null

func _ready():
	pass

func clear():
	for l in lines:
		l.queue_free()
	lines.clear()
	if waypoint != null:
		waypoint.queue_free()
		
func count():
	return lines.size()

func path(in_points, y_offset, color = Color.WHITE_SMOKE):
	if in_points.size():
		for i in range(in_points.size() - 1):
			var new_seg = line(in_points[i] + Vector3(0,y_offset,0), in_points[i+1] + Vector3(0,y_offset,0), color)
			add_child(new_seg)
			lines.append(new_seg)
		var waypoint = waypoint_scene.instantiate()
		waypoint.global_transform.origin = in_points[in_points.size() - 1] + Vector3(0,y_offset,0)
		waypoint.visible = true
	else:
		pass#waypoint.visible = false
		
func dashed_path(in_points, y_offset, color = Color.WHITE_SMOKE, dash_length=1.0):
	if in_points.size():
		for i in range(in_points.size() - 1):
			dash_line(in_points[i] + Vector3(0,y_offset,0), in_points[i+1] + Vector3(0,y_offset,0), color, dash_length)
		waypoint = waypoint_scene.instantiate()
		waypoint.global_transform.origin = in_points[in_points.size() - 1] + Vector3(0,y_offset,0)
		get_tree().get_root().add_child(waypoint)
		#$Node3D/waypoint.transform.origin = Vector3(0,1,0)
		waypoint.visible = true
	else:
		waypoint.queue_free()
		
func dash_line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, dash_length=1.0):
	var vec = pos2 - pos1
	var dist = vec.length()
	var dir = vec.normalized()
	var t = 0
	while t < dist:
		var solid = line(pos1 + dir*t, pos1 + dir*(t + dash_length), color)
		add_child(solid)
		lines.append(solid)
		t += 2*dash_length
		

func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = false

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()	
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	#get_tree().get_root().add_child(mesh_instance)
	
	return mesh_instance


func point(pos:Vector3, radius = 0.05, color = Color.WHITE_SMOKE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()
		
	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = false
	mesh_instance.position = pos
	
	sphere_mesh.radius = radius
	sphere_mesh.height = radius*2
	sphere_mesh.material = material
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	#get_tree().get_root().add_child(mesh_instance)
	
	return mesh_instance
