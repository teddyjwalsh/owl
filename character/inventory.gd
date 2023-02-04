extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var weapon = preload("res://weapon/weapon.tscn")

var weapon_slot = null
var armor_slot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_equipment_size_coefficient():
	return 1.0
	
func set_weapon(in_weapon):
	weapon_slot = in_weapon
	#add_child(weapon_slot)
	weapon_slot.owner = owner
	weapon_slot.firer = get_parent()

func attack(target):
	if weapon_slot != null:
		weapon_slot.attack(target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
