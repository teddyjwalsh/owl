extends MeshInstance3D

var mat: StandardMaterial3D = StandardMaterial3D.new()
var trail_width = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh = ImmediateMesh.new()
	mat.no_depth_test = true
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.vertex_color_use_as_albedo = true
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#set_material_override(mat)
	#mat.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	mesh.surface_set_color(Color(1,1,1))
	
	var count = get_parent().last_positions.size()
	var cur_position = get_parent().global_transform.origin
	for i in count - 1:
		var falloff = (count - i)*1.0/count
		var p1 = get_parent().last_positions[i] - cur_position
		var p2 = get_parent().last_positions[i+1] - cur_position
		mesh.surface_add_vertex(p1 + Vector3(0,falloff*trail_width/2,0))
		mesh.surface_add_vertex(p2 + Vector3(0,-falloff*trail_width/2,0))
		mesh.surface_add_vertex(p1 + Vector3(0,-falloff*trail_width/2,0))
		
		
		mesh.surface_add_vertex(p1 + Vector3(0,falloff*trail_width/2,0))
		mesh.surface_add_vertex(p2 + Vector3(0,falloff*trail_width/2,0))
		mesh.surface_add_vertex(p2 + Vector3(0,-falloff*trail_width/2,0))

	mesh.surface_end()
