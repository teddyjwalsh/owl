extends Node3D

var axe_scene = preload("res://weapon/weapons/axe.tscn")
var bow_scene = preload("res://weapon/weapons/bow.tscn")
var sniper_scene = preload("res://weapon/weapons/sniper.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mparent = get_parent()
	var inventory = mparent.get_node("inventory")
	
	var weapon_attach = $Armature/Skeleton3D/weapon_attach
	for child in weapon_attach.get_children():
		child.visible = false
	if inventory.weapon_slot != null:
		var model_name = inventory.weapon_slot.model_name
		weapon_attach.get_node(model_name).visible = true

func get_weapon_tip(in_name):
	if in_name == "Long Bow":
		return $Armature/Skeleton3D/weapon_attach/weapon_model.to_global(Vector3(0,0.0,0))
	else:
		return $Armature/Skeleton3D/weapon_attach/weapon_model.to_global(Vector3(0,0.5,0))
