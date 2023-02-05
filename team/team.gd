extends Node

var team_intro_scene = preload("res://team/team_intro/team_intro.tscn")

var team_number = 0
var units = []
var intro_scene = null
var money = 0
var inventory = []
var colors = [Vector3(0.8, 0.3, 0.3), Vector3(0.3, 0.8, 0.3), Vector3(0.3, 0.3, 0.8), Vector3(0.8, 0.3, 0.8), Vector3(0.3, 0.8, 0.8), Vector3(0.8, 0.8, 0.3)]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func add_unit(in_unit):
	add_child(in_unit)
	units.append(in_unit)
	in_unit.team = self
	#var highlight = in_unit.get_node("highlight")
	#var mat = highlight.get_active_material(0).duplicate()
	#highlight.set_surface_override_material(0, mat)
	in_unit.color = colors[units.size() - 1]
	in_unit.set_teammate_color(in_unit.color)
	#Emat.set_shader_parameter("color", colors[units.size() - 1])
	for unit in units:
		unit.add_collision_exception_with(in_unit)
		in_unit.add_collision_exception_with(unit)

func load_intro():
	intro_scene = team_intro_scene.instantiate()
	add_child(intro_scene)
	intro_scene.load_team()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
