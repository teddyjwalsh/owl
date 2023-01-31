extends Node3D


# Declare member variables here. Examples:
# var a = 25
# var b = "text"

var charact = preload("res://unit_controller/unit_controller.tscn")
@onready var camera = $Camera3D
var rng = RandomNumberGenerator.new()
var team1 = null
var team2 = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#var instance = charact.instantiate()
	#instance.name = "u"
	#add_child(instance)
	camera.transform.origin = Vector3(0,30,40)
	camera.look_at(Vector3(0,0,0),Vector3(0,1,0))
	camera.set_orthogonal(62,1,400)

func load_team(in_team, team_spawn_position):
	var radius = $team1_start.radius
	var spawn_pos = $team1_start.global_transform.origin
	if team_spawn_position == 2:
		for unit in in_team.units:
			unit.set_color(Color(0.7,0.2,0.3))
		spawn_pos = $team2_start.global_transform.origin
		radius = $team1_start.radius
		team2 = in_team
	else:
		for unit in in_team.units:
			unit.set_color(Color(0.3,0.8,0.5))
		team1 = in_team
		create_hud()
	for unit in in_team.units:
		rng.randomize()
		var rand_radius = rng.randf_range(8.0, radius)
		rng.randomize()
		var rand_az = rng.randf_range(0, 2*PI)
		var rand_pos = spawn_pos + Vector3(rand_radius*cos(rand_az),0.0,rand_radius*sin(rand_az))
		unit.global_transform.origin = rand_pos

func bake_navmesh():
	$NavigationRegion3D.bake_navigation_mesh()

func create_hud():
	var spawn_pos = Vector3(0,0,0)
	var unit_num = 0
	var bio_width = 100
	var margin = 20
	#$Node2D.set_size(Vector2(800, 30))
	#$Node2D/HBoxContainer.set_size(Vector2(800, 30))
	$status_vbox.add_theme_constant_override("separation",20)
	$status_vbox.position = Vector2(10,10)
	$status_vbox.set_size(Vector2(100,100))
	for unit in team1.units:
		var rt = RichTextLabel.new()
		var mc = MarginContainer.new()
		var cr = ColorRect.new()
		rt.bbcode_enabled = true
		cr.set_anchors_preset(Control.PRESET_FULL_RECT)
		cr.color = Color(unit.color.x, unit.color.y, unit.color.z)
		mc.add_child(rt)
		mc.add_child(cr)
		#mc.add_theme_constant_override("margin_left", 20)
		$status_vbox.add_child(mc)
		rt.append_text("[font_size=14]" + unit.full_name + "[/font_size]" + "\n")
		rt.append_text("[font_size=12]" + unit.inventory.weapon_slot.weapon_name + "[/font_size]")
		rt.fit_content = true
		unit_num += 1
		rt.z_as_relative = false
		cr.z_as_relative = false
		rt.z_index = 10
		cr.z_index = 8
	#get_tree().get_root().add_child($Node2D)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):$
#	pass
