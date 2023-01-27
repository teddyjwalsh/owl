extends Node

var team_intro_scene = preload("res://team/team_intro/team_intro.tscn")

var team_number = 0
var units = []
var intro_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func add_unit(in_unit):
	add_child(in_unit)
	units.append(in_unit)

func load_intro():
	intro_scene = team_intro_scene.instance()
	add_child(intro_scene)
	intro_scene.load_team()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
