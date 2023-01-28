extends Node3D


# Declare member variables here. Examples:
# var a = 25
# var b = "text"

var charact = preload("res://unit_controller/unit_controller.tscn")
@onready var camera = $Camera3D
var rng = RandomNumberGenerator.new()

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
		spawn_pos = $team2_start.global_transform.origin
		radius = $team1_start.radius
	for unit in in_team.units:
		rng.randomize()
		var rand_radius = rng.randf_range(8.0, radius)
		rng.randomize()
		var rand_az = rng.randf_range(0, 2*PI)
		var rand_pos = spawn_pos + Vector3(rand_radius*cos(rand_az),0.0,rand_radius*sin(rand_az))
		unit.global_transform.origin = rand_pos
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):$
#	pass
