extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"f

var energy = 1.0
var stamina = 100
var strength = 1.0
var base_size = 1.0
var energy_regen = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_movement_energy():
	return get_size()*0.2
	
func get_size():
	return base_size*strength
	
func add_energy(delta):
	energy += delta/stamina
	energy = max(min(energy, stamina), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_energy(delta*energy_regen*2)
