extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var traits = get_node("traits")
onready var controller = get_node("controller")
onready var inventory = get_node("inventory")
onready var nav = $NavigationAgent
var base_width = 32;

# Called when the node enters the scene tree for the first time.
func _ready():
	traits = $traits

func get_movespeed():
	return 50
	
func get_graphical_width():
	return traits.size*base_width

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
