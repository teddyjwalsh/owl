extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var projectile = preload("res://projectile/projectile.tscn")
var projectile_speed = 75
var base_damage = 10
var range = 20
var weight = 5
var base_attack_speed = 1.0
var weapon_name = "default"
var weapon_type = 0 # 0 is melee, ranged is 1
var firer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attack(target):
	if weapon_type == 1:
		var new_projectile = projectile.instantiate()
		new_projectile.target = target
		new_projectile.global_transform.origin = get_parent().get_parent().global_transform.origin + Vector3(0,1,0)
		new_projectile.firer = firer
		add_child(new_projectile)
		new_projectile.damage = base_damage
		new_projectile.speed = projectile_speed
		new_projectile.owner = owner
		new_projectile.weapon = self
	else:
		var dir = (target.global_transform.origin - owner.global_transform.origin).normalized()
		var params = PhysicsRayQueryParameters3D.new()
		params.from = owner.global_transform.origin + Vector3(0,1,0)
		params.to = owner.global_transform.origin + dir * range  + Vector3(0,1,0)
		params.exclude = owner.team.units
		params.collision_mask = 1
		var space_state = get_world_3d().direct_space_state
		var selection = space_state.intersect_ray(params)
		if selection.has("collider"):
			if selection.collider != null:
				if selection.collider.get_class() == "character":
					selection.collider.traits.add_health(-base_damage*owner.traits.get_melee_attack_damage_multiplier())

func melee_attack(target):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
