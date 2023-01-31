extends Node3D

var miss_scene = preload("res://indicators/miss_indicator/miss_indicator.tscn")

var is_homing = true
var target = null
var speed = 50.0
var damage = 10
var weapon = null
var firer = null
var friendly_fire = false
var imm_mesh = null

var last_positions = []
var max_history = 20

func sigmoid(x):
	return 1/(1+exp(-x))

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",Callable(self,"body_entered"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_homing:
		var dir = (target.global_transform.origin  + Vector3(0,4,0) - global_transform.origin)
		var norm_dir = dir.normalized()
		var dist = dir.length()
		global_transform.origin += norm_dir*delta*speed
		#look_at(target.global_transform.origin)
		last_positions.push_front(global_transform.origin)
		if last_positions.size() > max_history:
			last_positions.pop_back()
		
func calculate_miss_chance(in_attacker, in_enemy, in_weapon):
	var vec = in_enemy.global_transform.origin - in_attacker.global_transform.origin
	var dist = vec.length()
	var hit_chance = (-sigmoid(in_attacker.traits.get_aim()*in_enemy.traits.get_size()*0.1*(dist - in_weapon.range*1.1)) + 1)
	return 1 - hit_chance
	
func spawn_miss(pos):
	var new_miss = miss_scene.instantiate()
	new_miss.cur_pos = pos
	get_tree().get_root().add_child(new_miss)

func body_entered(body):
	print("collide")
	print(body)
	if body.get_class() == "character":
		if friendly_fire or body.team != firer.team:
			if body != firer:
				var miss_chance = calculate_miss_chance(firer, body, weapon)
				var draw = firer.rng.randf_range(0,1.0)
				if draw > miss_chance:
					body.traits.add_health(-damage)
				else:
					spawn_miss(global_transform.origin)
				queue_free()
	elif body.get_class() == "StaticBody3D":
		queue_free()
			
