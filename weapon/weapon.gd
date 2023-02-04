extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var projectile = preload("res://projectile/projectile.tscn")
var projectile_speed = 75
var base_damage = 10
var range = 20
var weight = 5
var size = 1.0
var base_attack_speed = 1.0
var weapon_name = "default"
var weapon_type = 0 # 0 is melee, ranged is 1
var firer = null
var animation = "axe"
var hit_chance_multiplier = 1.0
var model_name = "weapon_model"
#var hit_sound_file = "res://sounds/420675__sypherzent__cut-through-armor-slice-clang.wav"
var attack_sound_file = "res://sounds/184422__qubodup__sword-slash-attack.wav"
var hit_sound_file = "res://sounds/hit_flesh.wav"

# Called when the node enters the scene tree for the first time.
func _ready():
	if hit_sound_file != null:
		var sfx = load(hit_sound_file)
		$hit_sound.stream = sfx
		$hit_sound.volume_db = 15
	if attack_sound_file != null:
		var sfx = load(attack_sound_file)
		$attack_sound.stream = sfx

func swing():
	if weapon_type == 0:
		$attack_sound.play()

func attack(target):
	if target == null:
		return
	var dir = (target.global_transform.origin - firer.global_transform.origin).normalized()
	var target_face = -target.global_transform.basis.z
	var dir_factor = 1.0 + 0.3*dir.dot(target_face)
	if weapon_type == 1:
		var new_projectile = projectile.instantiate()
		new_projectile.target = target
		new_projectile.global_transform.origin = firer.get_node("character_model2").get_weapon_tip(weapon_name)
		#new_projectile.global_transform.origin = get_parent().get_parent().global_transform.origin + Vector3(0,4,0)
		new_projectile.firer = firer
		add_child(new_projectile)
		new_projectile.damage = base_damage
		new_projectile.speed = projectile_speed
		new_projectile.owner = firer
		new_projectile.weapon = self
		$attack_sound.play()
		new_projectile.hit_player = $hit_sound
	else:
		if get_world_3d() == null:
			return
		var params = PhysicsRayQueryParameters3D.new()
		params.from = firer.global_transform.origin + Vector3(0,1,0)
		params.to = firer.global_transform.origin + dir * range  + Vector3(0,1,0)
		params.exclude = firer.team.units
		params.collision_mask = 1
		var space_state = get_world_3d().direct_space_state
		var selection = space_state.intersect_ray(params)
		if selection.has("collider"):
			if selection.collider != null:
				if selection.collider.get_class() == "character":
					$hit_sound.play()
					selection.collider.traits.add_health(-base_damage*firer.traits.get_melee_attack_damage_multiplier()*dir_factor)
		target.on_hit(dir)

func melee_attack(target):
	pass
	
func size_coefficient():
	return weight*size/5

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
