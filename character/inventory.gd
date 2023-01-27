extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var weapon = preload("res://weapon/weapon.tscn")

var weapon_slot = null
var armor_slot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_slot = weapon.instance()
	add_child(weapon_slot)
	weapon_slot.owner = owner

func get_equipment_size_coefficient():
	return 1.0

func attack(target):
	if weapon_slot != null:
		weapon_slot.attack(target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
