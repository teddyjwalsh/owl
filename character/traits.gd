extends Node

var rng = RandomNumberGenerator.new()

var health = 1.0
var energy = 1.0
var stamina = 100
var strength = 1.0
var base_size = 1.0
#var energy_regen = 1.0
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
var aim = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	var mean = 1.0
	var dev = 0.5
	rng.randomize()	
	strength = rng.randfn(mean, dev)
	gen_trait_value("strength", mean, dev)
	stamina = rng.randfn(100, 20)
	gen_trait_value("stamina", 100, 20)
	base_size = rng.randfn(mean, dev)
	gen_trait_value("base_size", mean, dev)
	#energy_regen = rng.randfn(mean, dev)
	gen_trait_value("agility", mean, dev)
	gen_trait_value("dexterity", mean, dev)
	gen_trait_value("friendliness", mean, dev)
	gen_trait_value("patience", mean, dev)
	gen_trait_value("pride", mean, dev)
	gen_trait_value("anxiety", mean, dev)
	gen_trait_value("observation", mean, dev)
	gen_trait_value("magic", mean, dev)
	gen_trait_value("age", 28, 10)
	gen_trait_value("intelligence", mean, dev)
	gen_trait_value("temper", mean, dev)
	gen_trait_value("ideal_temperature", 72, 20)
	#dexterity = rng.randfn(mean, dev)
	#friendliness = rng.randfn(mean, dev)
	#patience = rng.randfn(mean, dev)
	#pride = rng.randfn(mean, dev)
	#anxiety = rng.randfn(mean, dev)
	#observation = rng.randfn(mean, dev)
	#magic = rng.randfn(0.5, dev)
	#age = rng.randfn(28, 10)
	#intelligence = rng.randfn(mean, dev)
	#temper = rng.randfn(mean, dev)
	#ideal_temperature = rng.randfn(72, 20)
	
func set_trait_value(in_trait, in_val):
	self.set(in_trait, max(0, in_val))
	
func gen_trait_value(in_trait, mean, dev):
	self.set(in_trait, max(0, rng.randfn(mean, dev)))
	
func get_age_coefficient():
	return pow(1.0/abs(age - 20), 0.04)

func get_movespeed():
	return get_age_coefficient()*(get_temperature_coefficient())*pow(energy, 0.2)/(get_equipment_size_coefficient())

func get_melee_attack_speed():
	return get_age_coefficient()*agility*strength*(get_temperature_coefficient())*pow(energy, 0.2)/(get_equipment_size_coefficient())
	
func get_melee_attack_energy():
	return get_age_coefficient()*get_size()*get_equipment_size_coefficient()
	
func get_anxiety_coefficient():
	return 1.0/get_age_coefficient()
	
func get_ranged_attack_speed():
	return get_age_coefficient()*agility*dexterity*(get_temperature_coefficient())*pow(energy, 0.2)*get_anxiety_coefficient()
	
func get_ranged_attack_period():
	return pow(1.0/get_ranged_attack_speed(), 0.3)
	
func get_melee_attack_period():
	return pow(1.0/get_melee_attack_speed(), 0.3)

func get_movement_energy():
	return get_age_coefficient()*get_size()*0.75
	
func get_size():
	return base_size*strength*get_equipment_size_coefficient()
	
func get_learning_coefficient():
	return patience*intelligence*observation/(pride*temper)
	
func get_teaching_coefficient():
	return patience*intelligence*observation*friendliness/(get_age_coefficient()*temper)

func get_max_health():
	return strength*stamina
	
func get_after_movement_cooldown():
	return 300.0/(get_age_coefficient()*stamina*dexterity*(get_anxiety_coefficient())*pow(energy, 0.2))

func get_equipment_size_coefficient():
	return get_parent().get_node("inventory").get_equipment_size_coefficient()
	
func get_temperature_coefficient():
	var current_temperature = get_parent().get_node("env_sensor").get_temperature()
	return 1.0/abs((ideal_temperature) - (current_temperature) + 1)

func get_energy_regen():
	return get_age_coefficient()*strength*(stamina/100.0)*get_temperature_coefficient()*pow(health,0.3)
	
func add_energy(delta):
	energy += delta/stamina
	energy = max(min(energy, 1.0), 0)
	
func add_health(delta):
	health += delta/get_max_health()
	health = max(min(health, 1.0), 0)
	
func sigmoid(x):
	return 1/(1+exp(-x))
	
func learning_curve(in_stat):
	var shift = 5
	return sigmoid(in_stat - shift)*(1 - sigmoid(in_stat - shift))
	
func get_learn_delta(delta, in_stat):
	return learning_curve(in_stat)*delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_energy(delta*get_energy_regen()*2)
