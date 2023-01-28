extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/Button.connect("pressed",Callable(self,"_on_join_battle_presss"))

func load_team():
	var radius = 4.0
	var spawn_pos = Vector3(0,0,0)
	var unit_num = 0
	var bio_width = 200
	var margin = 20
	for unit in get_parent().units:
		var panel = Panel.new()
		var label = RichTextLabel.new()
		panel.add_child(label)
		label.add_text("Name:\n" + unit.full_name)
		label.add_text("\nAge: " + str(int(unit.traits.age)))
		label.name = "label" + str(unit_num)
		panel.set_size(Vector2(bio_width,300))
		label.set_size(Vector2(bio_width,300))
		label.set_position(Vector2(10,10))
		panel.set_position(Vector2((unit_num + 1)*margin + unit_num*bio_width, margin))
		add_child(panel)
		rng.randomize()
		var rand_radius = rng.randf_range(0, radius)
		rng.randomize()
		var rand_az = rng.randf_range(0, 2*PI)
		var rand_pos = spawn_pos + Vector3(rand_radius*cos(rand_az),0.0,rand_radius*sin(rand_az))
		unit.global_transform.origin = rand_pos
		unit_num += 1
	$Camera3D.make_current()
	$Camera3D.global_transform.origin = Vector3(5,3,5)
	$Camera3D.look_at(spawn_pos, Vector3(0,1,0))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
