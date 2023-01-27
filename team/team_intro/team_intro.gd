extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_team():
	var radius = 4.0
	var spawn_pos = Vector3(0,0,0)
	for unit in get_parent().units:
		rng.randomize()
		var rand_radius = rng.randf_range(0, radius)
		rng.randomize()
		var rand_az = rng.randf_range(0, 2*PI)
		var rand_pos = spawn_pos + Vector3(rand_radius*cos(rand_az),0.0,rand_radius*sin(rand_az))
		unit.global_transform.origin = rand_pos
	$Camera.make_current()
	$Camera.global_transform.origin = Vector3(5,3,5)
	$Camera.look_at(spawn_pos, Vector3(0,1,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
