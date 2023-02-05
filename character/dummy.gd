extends CharacterBody3D

var char_model_scene = preload("res://character/dummy_model.tscn")
var hat_scene = preload("res://character/hats/straw_hat.tscn")
var viking_hat_scene = preload("res://character/hats/viking_hat.tscn")
var beanie_scene = preload("res://character/hats/beanie.tscn")
var blood_scene = preload("res://character/effects/blood/blood.tscn")
@onready var traits = get_node("traits")
@onready var controller = get_node("controller")
@onready var inventory = get_node("inventory")
@onready var select_indicator = get_node("highlight")
@onready var nav = $NavigationAgent3D
@onready var ray = $RayCast3D
@onready var name_gen = $name_gen
var base_width = 32
var team = null
var full_name = "default"
var rng = RandomNumberGenerator.new()
var color = null
var targeted = false
var chmod = null
var default_model_scale = Vector3(0.45,0.45,0.45)

# Called when the node enters the scene tree for the first time.
func _ready():
	var hat_scenes = [hat_scene, viking_hat_scene, beanie_scene]
	traits = get_node("traits")
	full_name = name_gen.gen_full_names(1)[0]
	full_name = full_name[0]# + " " + full_name[1]
	traits.mean = 1.0
	traits.dev = 0.0
	traits.reinit()
	traits.health_regen = 2.0
#	var straw_hat = hat_scenes[rng.randi_range(0,hat_scenes.size()-1)].instantiate()
#	straw_hat.transform.origin.y += 0.4
#	var bone_attach = BoneAttachment3D.new()
#	$character_model2/Armature/Skeleton3D.add_child(bone_attach)
#	bone_attach.set_bone_name("head")
#	bone_attach.add_child(straw_hat)
	
func get_graphical_width():
	return traits.size*base_width
	
func get_class():
	return "character"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var col_point = ray.get_collision_point()
	self.global_transform.origin.y = col_point.y
	if targeted or $target_indicator.t < 1.0:
		$target_indicator.visible = true
	else:
		$target_indicator.visible = false
	#if controller.dead:
		#$CollisionShape3D.disabled = true
		#$unit_info.visible = false
	var cur_size = pow(traits.get_size(),0.2)
	#$character_model2.scale = cur_size*Vector3(default_model_scale.x,default_model_scale.y*cur_size,default_model_scale.z)
	
func set_color(in_color):
	var new_mat = $character_model2/Armature/Skeleton3D/Cube.get_active_material(0).duplicate()
	new_mat.albedo_color = in_color
	$character_model2/Armature/Skeleton3D/Cube.set_surface_override_material(0, new_mat)
	
func set_teammate_color(in_color):
	$highlight.set_instance_shader_parameter("color", in_color)
	$highlight/cylinder.set_instance_shader_parameter("color", in_color)
	
func on_hit(direction):
	pass
	#var blood_instance = blood_scene.instantiate()
	#$character_model2/Armature/Skeleton3D/blood_attach.add_child(blood_instance)
	#blood_instance.get_node("GPUParticles3D").process_material.direction = -direction
	
func unequip():
	inventory.weapon_slot.firer = null
	inventory.weapon_slot = null
	
func is_dead():
	return false

func equip(in_weapon):
	if in_weapon.firer != null:
		in_weapon.firer.inventory.weapon_slot = null
		in_weapon.firer = null
	if inventory.weapon_slot != null:
		inventory.weapon_slot.firer = null
	inventory.weapon_slot = in_weapon
	in_weapon.firer = self
