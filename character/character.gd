extends Node

@onready var traits = get_node("traits")
@onready var controller = get_node("controller")
@onready var inventory = get_node("inventory")
@onready var select_indicator = get_node("highlight")
@onready var nav = $NavigationAgent3D
@onready var ray = $RayCast3D
@onready var name_gen = $name_gen
var base_width = 32
var team = 0
var full_name = "default"
var rng = RandomNumberGenerator.new()
var color = null

# Called when the node enters the scene tree for the first time.
func _ready():
	traits = get_node("traits")
	full_name = name_gen.gen_full_names(1)[0]
	full_name = full_name[0] + " " + full_name[1]
	print(full_name)

func get_movespeed():
	return 50
	
func get_graphical_width():
	return traits.size*base_width
	
func get_class():
	return "character"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var col_point = ray.get_collision_point()
	self.global_transform.origin.y = col_point.y
