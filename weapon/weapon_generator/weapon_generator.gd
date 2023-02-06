extends Node

var weapon_scene = preload("res://weapon/weapon.tscn")
var rng = RandomNumberGenerator.new()

var weapons = {}
var weapon_list = []
 
func _ready():
	pass

func gen_random():
	var name_list = []
	for k in weapons:
		name_list.append(k)
	var choice = name_list[rng.randi_range(0,name_list.size()-1)]
	return gen(choice)

func gen(in_name):
	if in_name == "Sniper":
		var new_weap = weapon_scene.instantiate()
		new_weap.projectile_speed = 100
		new_weap.base_damage = 20
		new_weap.range = 70
		new_weap.weight = 10
		new_weap.base_attack_speed = 30
		new_weap.weapon_name = "Sniper"
		new_weap.weapon_type = 1
		new_weap.animation = "rifle"
		new_weap.attack_sound_file = "res://sounds/522519__filmmakersmanual__gun-shots-from-a-long-distance-4.wav"
		new_weap.model_name = "rifle"
		weapon_list.append(new_weap)
		add_child(new_weap)
		return new_weap

	if in_name == "Shotgun":
		weapons["Shotgun"] = weapon_scene.instantiate()
		weapons["Shotgun"].projectile_speed = 100
		weapons["Shotgun"].base_damage = 15
		weapons["Shotgun"].range = 20
		weapons["Shotgun"].weight = 10
		weapons["Shotgun"].base_attack_speed = 40
		weapons["Shotgun"].weapon_name = "Shotgun"
		weapons["Shotgun"].weapon_type = 1
		weapons["Shotgun"].model_name = "shotgun"
		weapons["Shotgun"].animation = "rifle"
		weapons["Shotgun"].attack_sound_file = "res://sounds/522519__filmmakersmanual__gun-shots-from-a-long-distance-4.wav"
		weapons["Shotgun"].hit_chance_multiplier = 8.0
		weapon_list.append(weapons["Shotgun"])
		add_child(weapons["Shotgun"])
		return weapons["Shotgun"]
		
	if in_name == "Long Bow":
		weapons["Long Bow"] = weapon_scene.instantiate()
		weapons["Long Bow"].projectile_speed = 50
		weapons["Long Bow"].base_damage = 15
		weapons["Long Bow"].range = 40
		weapons["Long Bow"].weight = 5
		weapons["Long Bow"].base_attack_speed = 30
		weapons["Long Bow"].weapon_name = "Long Bow"
		weapons["Long Bow"].weapon_type = 1
		weapons["Long Bow"].animation = "bow"
		weapons["Long Bow"].model_name = "bow"
		weapons["Long Bow"].attack_sound_file = "res://sounds/384915__ali_6868__bow-release-bow-and-arrow.wav"
		weapon_list.append(weapons["Long Bow"])
		add_child(weapons["Long Bow"])
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
		new_weap.model_name = "sniper"
		new_weap.animation = "rifle"
		new_weap.attack_sound_file = "res://sounds/522519__filmmakersmanual__gun-shots-from-a-long-distance-4.wav"
		weapons["Revolver"] = new_weap
		weapon_list.append(weapons["Revolver"])
		add_child(weapons["Revolver"])
		return new_weap
		
	if in_name == "Hammer":
		weapons["Hammer"] = weapon_scene.instantiate()
		weapons["Hammer"].base_damage = 30
		weapons["Hammer"].range = 5
		weapons["Hammer"].weight = 20
		weapons["Hammer"].base_attack_speed = 30
		weapons["Hammer"].weapon_name = "Hammer"
		weapons["Hammer"].weapon_type = 0
		weapons["Hammer"].model_name = "hammer"
		weapons["Hammer"].animation = "axe"
		weapon_list.append(weapons["Hammer"])
		add_child(weapons["Hammer"])
		return weapons["Hammer"]
	
	if in_name == "Battle Axe":
		weapons["Battle Axe"] = weapon_scene.instantiate()
		weapons["Battle Axe"].base_damage = 20
		weapons["Battle Axe"].range = 5
		weapons["Battle Axe"].weight = 15
		weapons["Battle Axe"].base_attack_speed = 40
		weapons["Battle Axe"].weapon_name = "Battle Axe"
		weapons["Battle Axe"].weapon_type = 0
		weapons["Battle Axe"].model_name = "axe"
		weapons["Battle Axe"].animation = "axe"
		weapon_list.append(weapons["Battle Axe"])
		add_child(weapons["Battle Axe"])
		return weapons["Battle Axe"]
		
	if in_name == "Short Sword":
		weapons["Short Sword"] = weapon_scene.instantiate()
		weapons["Short Sword"].base_damage = 10
		weapons["Short Sword"].range = 4
		weapons["Short Sword"].weight = 8
		weapons["Short Sword"].base_attack_speed = 70
		weapons["Short Sword"].weapon_name = "Battle Axe"
		weapons["Short Sword"].weapon_type = 0
		weapons["Short Sword"].model_name = "axe"
		weapons["Short Sword"].animation = "axe"
		weapon_list.append(weapons["Short Sword"])
		add_child(weapons["Short Sword"])
		return weapons["Short Sword"]
	
	if in_name == "Dagger":
		weapons["Dagger"] = weapon_scene.instantiate()
		weapons["Dagger"].base_damage = 10
		weapons["Dagger"].range = 5
		weapons["Dagger"].weight = 2
		weapons["Dagger"].base_attack_speed = 150
		weapons["Dagger"].weapon_name = "Dagger"
		weapons["Dagger"].model_name = "weapon_model"
		weapons["Dagger"].weapon_type = 0
		weapons["Dagger"].animation = "axe"
		weapon_list.append(weapons["Dagger"])
		add_child(weapons["Dagger"])
		return weapons["Dagger"]
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
