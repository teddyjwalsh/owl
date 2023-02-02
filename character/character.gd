extends Node

var char_model_scene = preload("res://character_model.tscn")
var hat_scene = preload("res://character/hats/straw_hat.tscn")
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

# Called when the node enters the scene tree for the first time.
func _ready():
	traits = get_node("traits")
	full_name = name_gen.gen_full_names(1)[0]
	full_name = full_name[0] + " " + full_name[1]
	print(full_name)
	var chmod = char_model_scene.instantiate()
	chmod.name = "character_model2"
	chmod.rotate_object_local(Vector3(0,1,0),PI)
	chmod.scale = Vector3(0.45,0.45,0.45)
	
	add_child(chmod)
	$character_model2/AnimationPlayer.set_blend_time("idle", "run", 0.2)
	$character_model2/AnimationPlayer.set_blend_time("run", "idle", 0.2)
	$character_model2/AnimationPlayer.set_blend_time("rifle", "idle", 10.0)
	$character_model2/AnimationPlayer.set_blend_time("rifle", "run", 2.0)
	$character_model2/AnimationPlayer.set_blend_time("axe", "run", 1.0)
	$character_model2/AnimationPlayer.set_blend_time("axe", "idle", 1.0)
	$character_model2/AnimationPlayer.set_blend_time("bow", "idle", 1.0)
	$character_model2/AnimationPlayer.set_blend_time("bow", "run", 1.0)
	
	var straw_hat = hat_scene.instantiate()
	straw_hat.transform.origin.y += 0.4
	var bone_attach = BoneAttachment3D.new()
	$character_model2/Armature/Skeleton3D.add_child(bone_attach)
	bone_attach.set_bone_name("head")
	bone_attach.add_child(straw_hat)

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
	if targeted or $target_indicator.t < 1.0:
		$target_indicator.visible = true
	else:
		$target_indicator.visible = false
	
func set_color(in_color):
	var new_mat = $character_model2/Armature/Skeleton3D/Cube.get_active_material(0).duplicate()
	new_mat.albedo_color = in_color
	$character_model2/Armature/Skeleton3D/Cube.set_surface_override_material(0, new_mat)
	
func on_hit(direction):
	var blood_instance = blood_scene.instantiate()
	$character_model2/Armature/Skeleton3D/blood_attach.add_child(blood_instance)
	blood_instance.get_node("GPUParticles3D").process_material.direction = -direction
	
