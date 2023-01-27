extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"f

var health = 1.0
var energy = 1.0
var stamina = 100
var strength = 1.0
var base_size = 1.0
var energy_regen = 1.0
var agility = 1.0
var dexterity = 1.0
var friendliness = 1.0
var patience = 1.0
var pride = 1.0
var anxiety = 1.0
var observation = 1.0
var magic = 1.0
var age = 25
var intelligence = 1.0
var ideal_temperature = 72
var temper = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_movespeed():
	return agility*(get_temperature_coefficient())*pow(energy, 0.2)/(get_equipment_size_coefficient())

func get_melee_attack_speed():
	return agility*strength*(get_temperature_coefficient())*pow(energy, 0.2)/(get_equipment_size_coefficient())
	
func get_anxiety_coefficient():
	return 1.0
	
func get_ranged_attack_speed():
	return agility*dexterity*(get_temperature_coefficient())*pow(energy, 0.2)*get_anxiety_coefficient()

func get_movement_energy():
	return get_size()*0.2
	
func get_size():
	return base_size*strength*get_equipment_size_coefficient()
	
func get_learning_coefficient():
	return patience*intelligence*observation/(pride*temper)
	
func get_teaching_coefficient():
	return patience*intelligence*observation*friendliness/(temper)

func get_max_health():
	return strength*stamina
	
func get_after_movement_cooldown():
	return 1.0/(stamina*dexterity*(get_anxiety_coefficient())*pow(energy, 0.2))

func get_equipment_size_coefficient():
	return get_parent().get_node("inventory").get_equipment_size_coefficient()
	
func get_temperature_coefficient():
	var current_temperature = get_parent().get_node("env_sensor").get_temperature()
	return 1.0/abs((ideal_temperature) - (current_temperature) + 1)
	
	
func add_energy(delta):
	energy += delta/stamina
	energy = max(min(energy, 1.0), 0)
	
func add_health(delta):
	health += delta/get_max_health()
	health = max(min(health, 1.0), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_energy(delta*energy_regen*2)
