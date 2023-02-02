extends Node

var weapon_scene = preload("res://weapon/weapon.tscn")

var weapons = {}

# Called when the node enters the scene tree for the first time.
func gen(in_name):
	if in_name == "Sniper":
		weapons["Sniper"] = weapon_scene.instantiate()
		weapons["Sniper"].projectile_speed = 100
		weapons["Sniper"].base_damage = 20
		weapons["Sniper"].range = 70
		weapons["Sniper"].weight = 10
		weapons["Sniper"].base_attack_speed = 30
		weapons["Sniper"].weapon_name = "Sniper"
		weapons["Sniper"].weapon_type = 1
		weapons["Sniper"].animation = "rifle"
		return weapons["Sniper"]
		
	if in_name == "Shotgun":
		weapons["Shotgun"] = weapon_scene.instantiate()
		weapons["Shotgun"].projectile_speed = 100
		weapons["Shotgun"].base_damage = 15
		weapons["Shotgun"].range = 30
		weapons["Shotgun"].weight = 10
		weapons["Shotgun"].base_attack_speed = 40
		weapons["Shotgun"].weapon_name = "Shotgun"
		weapons["Shotgun"].weapon_type = 1
		weapons["Shotgun"].animation = "rifle"
		weapons["Shotgun"].hit_chance_multiplier = 2.0
		return weapons["Shotgun"]
		
	if in_name == "Long Bow":
		weapons["Long Bow"] = weapon_scene.instantiate()
		weapons["Long Bow"].projectile_speed = 50
		weapons["Long Bow"].base_damage = 15
		weapons["Long Bow"].range = 50
		weapons["Long Bow"].weight = 5
		weapons["Long Bow"].base_attack_speed = 30
		weapons["Long Bow"].weapon_name = "Long Bow"
		weapons["Long Bow"].weapon_type = 1
		weapons["Long Bow"].animation = "bow"
		return weapons["Long Bow"]
	
	if in_name == "Revolver":
		var new_weap = weapon_scene.instantiate()
		new_weap.projectile_speed = 75
		new_weap.base_damage = 10
		new_weap.range = 30
		new_weap.weight = 4
		new_weap.base_attack_speed = 60
		new_weap.weapon_name = "Revolver"
		new_weap.weapon_type = 1
		new_weap.animation = "rifle"
		return new_weap
	
	if in_name == "Battle Axe":
		weapons["Battle Axe"] = weapon_scene.instantiate()
		weapons["Battle Axe"].base_damage = 20
		weapons["Battle Axe"].range = 5
		weapons["Battle Axe"].weight = 15
		weapons["Battle Axe"].base_attack_speed = 50
		weapons["Battle Axe"].weapon_name = "Battle Axe"
		weapons["Battle Axe"].weapon_type = 0
		weapons["Battle Axe"].animation = "axe"
		return weapons["Battle Axe"]
		
	if in_name == "Short Sword":
		weapons["Short Sword"] = weapon_scene.instantiate()
		weapons["Short Sword"].base_damage = 10
		weapons["Short Sword"].range = 4
		weapons["Short Sword"].weight = 8
		weapons["Short Sword"].base_attack_speed = 70
		weapons["Short Sword"].weapon_name = "Battle Axe"
		weapons["Short Sword"].weapon_type = 0
		weapons["Short Sword"].animation = "axe"
		return weapons["Short Sword"]
	
	if in_name == "Dagger":
		weapons["Dagger"] = weapon_scene.instantiate()
		weapons["Dagger"].base_damage = 10
		weapons["Dagger"].range = 5
		weapons["Dagger"].weight = 2
		weapons["Dagger"].base_attack_speed = 150
		weapons["Dagger"].weapon_name = "Dagger"
		weapons["Dagger"].weapon_type = 0
		weapons["Dagger"].animation = "axe"
		return weapons["Dagger"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
