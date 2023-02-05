extends Node3D

var building_scene = preload("res://town/building/building.tscn")
var rng = RandomNumberGenerator.new()
var spawn_radius = 10
var spawn_pos = Vector3(0,0,0)
var mesh = null
var mat: StandardMaterial3D = StandardMaterial3D.new()
var done = false
var equipment_room_scene = preload("res://equipment_room/equipment_room.tscn")
var team = null
var time_limit = 60
@onready var battle_queue = get_node("/root/BattleQueue")
var human_input = get_node("/root/HumanInput")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/HumanInput").select_enabled = true
	mesh = ImmediateMesh.new()
	#mat.no_depth_test = true
	#mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	#mat.vertex_color_use_as_albedo = true
	#mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#mat.cull_mode = mat.CULL_DISABLED
	#$path.set_material_override(mat)
	#mat.
	$to_equip.connect("pressed", _to_equip_pressed)
	$ambient_noise.play()
	$ambient_noise2.play()
	if rng.randf_range(0,1) < 0.2:
		$ambient_noise3.play()
	$ambient_noise.stream.loop = true
	$ambient_noise2.stream.loop_mode = 1
	
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	mesh.surface_set_color(Color(0,1,1))
	
	var num_buildings = rng.randi_range(3,6)
	var angle_inc = 2*PI/num_buildings
	var mean_distance = 40
	var circle_radius = 20
	var distance_variance = 10
	var last_angle = 0
	var building_angles = []
	var building_types = ["Gym","Firing Range","Bar"]
	
	for i in range(num_buildings):
		var angle_vary = rng.randf_range(-0.3,0.3)
		var cur_angle = i*angle_inc + angle_vary
		var distance = rng.randf_range(mean_distance - distance_variance,mean_distance + distance_variance)
		var building = building_scene.instantiate()
		building.collision_layer = 3
		var building_size = 15
		building.global_transform.origin = Vector3(distance*cos(cur_angle), 0, distance*sin(cur_angle))
		$NavigationRegion3D.add_child(building)
		building_angles.append(cur_angle)
		building.scale = Vector3(15,15,15)
		building.look_at(Vector3(spawn_pos.x, building.global_transform.origin.y,spawn_pos.z), Vector3(0,1,0))
	
	angle_inc = 2*PI/100
	var noise = FastNoiseLite.new()
	var last_radius = 1*(noise.get_noise_1d(100*5)+1)*circle_radius
	var last_mult = 1.0
	for i in range(0,100):
		var cur_angle = i*angle_inc + angle_inc/2
		var prev_angle = i*angle_inc - angle_inc/2
		var max_rad_mult = 1.0
		for ba in building_angles:
			max_rad_mult = max(0.2/abs(i*angle_inc - ba),max_rad_mult)
		var cur_radius = min(40,max_rad_mult*(noise.get_noise_1d(i*5)+1)*circle_radius)
		mesh.surface_add_vertex(Vector3(cur_radius*cos(i*angle_inc + angle_inc/2),0.01,cur_radius*sin(i*angle_inc + angle_inc/2)))
		mesh.surface_add_vertex(Vector3(0,0.01,0))
		mesh.surface_add_vertex(Vector3(last_radius*cos(i*angle_inc - angle_inc/2),0.01,last_radius*sin(i*angle_inc - angle_inc/2)))
		
		last_radius = cur_radius
		last_mult = max_rad_mult
		
	mesh.surface_end()
	$path.mesh = mesh
	$Camera3D.position = Vector3(5,40,5)
	$Camera3D.look_at(Vector3(0,0,0))
	
	$NavigationRegion3D.bake_navigation_mesh()
	
func load_in(in_team):
	load_team(in_team)
	
func load_team(in_team):
	var radius = spawn_radius
	for unit in in_team.units:
		unit.controller.revive()
		unit.traits.health = 1.0
		rng.randomize()
		var rand_radius = rng.randf_range(8.0, radius)
		rng.randomize()
		var rand_az = rng.randf_range(0, 2*PI)
		var rand_pos = spawn_pos + Vector3(rand_radius*cos(rand_az),0.0,rand_radius*sin(rand_az))
		unit.global_transform.origin = rand_pos
	team = in_team

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_limit -= delta
	if time_limit <= 0:
		battle_queue.next()
	
func _to_equip_pressed():
	get_node("/root/HumanInput").select_enabled = false
	battle_queue.next()
