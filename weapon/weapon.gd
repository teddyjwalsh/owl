extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var projectile = preload("res://projectile/projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attack(target):
	var new_projectile = projectile.instantiate()
	new_projectile.target = target
	new_projectile.global_transform.origin = get_parent().get_parent().global_transform.origin + Vector3(0,1,0)
	
	add_child(new_projectile)
	new_projectile.owner = owner

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
