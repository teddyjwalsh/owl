extends MeshInstance3D

var mat: StandardMaterial3D = StandardMaterial3D.new()
var trail_width = 0.3

var start_point = null
var end_point = null

func _ready():
	mesh = ImmediateMesh.new()
	#mat.no_depth_test = true
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.vertex_color_use_as_albedo = true
	#mat.vertex_color_use_as_albedo = true
	#mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.cull_mode = mat.CULL_DISABLED
	set_material_override(mat)
	#mat.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_point == null or end_point == null:
		visible = false
		return
	visible = true
		
	var dir = end_point - start_point
	var up = Vector3(0,1,0)
	var perp_left = up.cross(dir).normalized()
	var perp_right = -perp_left
		
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	mesh.surface_set_color(Color(1,0.8,0.8,0.1))

	mesh.surface_add_vertex(start_point + perp_right*trail_width/2.0)
	mesh.surface_add_vertex(start_point + perp_left*trail_width/2.0)
	mesh.surface_add_vertex(end_point + perp_right*trail_width/2.0)
	
	mesh.surface_add_vertex(start_point + perp_left*trail_width/2.0)
	mesh.surface_add_vertex(end_point + perp_right*trail_width/2.0)
	mesh.surface_add_vertex(end_point + perp_left*trail_width/2.0)

	mesh.surface_end()
