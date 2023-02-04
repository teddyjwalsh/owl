extends Node3D

var unit_controller_scene = preload("res://unit_controller/unit_controller.tscn")
var character_scene = preload("res://character/character.tscn")
var main_menu_scene = preload("res://demo/main_menu/main_menu.tscn")
var team_intro_scene = preload("res://team/team_intro/team_intro.tscn")
var town_scene = preload("res://town/town.tscn")
var battle1_scene = preload("res://demo/battles/battle1/battle1.tscn")
var battle2_scene = preload("res://demo/battles/battle2/battle2.tscn")
var weapon_gen_scene = preload("res://weapon/weapon_generator/weapon_generator.tscn")
var equipment_room_scene = preload("res://equipment_room/equipment_room.tscn")
var battle1 = null
var main_menu = null
var rng = RandomNumberGenerator.new()
var team = null
var town1 = null
@onready var weapon_gen = weapon_gen_scene.instantiate()
@onready var battle_queue = get_node("/root/BattleQueue")

func _ready():
	generate_demo_team()
	battle_queue.team = team
	#main_menu = main_menu_scene.instantiate()
	add_child(weapon_gen)
	#battle_queue.push(main_menu)
	battle_queue.push(main_menu_scene)
	battle_queue.push(team_intro_scene)
	battle_queue.push(battle1_scene)
	battle_queue.push(town_scene)
	battle_queue.push(equipment_room_scene)
	battle_queue.push(battle2_scene)	
	battle_queue.next()
	
func generate_demo_warrior(team):
	rng.randomize()
	var new_unit = character_scene.instantiate()
	team.add_unit(new_unit)
	new_unit.get_node("traits").strength = rng.randfn(1.5, 0.25)
	new_unit.get_node("traits").pride = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").anxiety = rng.randfn(0.7, 0.25)
	new_unit.get_node("traits").patience = rng.randfn(0.9, 0.25)
	new_unit.get_node("traits").stamina = rng.randfn(110, 20)
	var new_weap = weapon_gen.gen("Hammer")
	new_unit.get_node("inventory").set_weapon(new_weap)
	team.inventory.append(new_weap)
	team.add_child(new_weap)
	
	return new_unit
	
func generate_demo_archer(team):
	rng.randomize()
	var new_unit = character_scene.instantiate()
	print(new_unit.traits)
	team.add_unit(new_unit)
	new_unit.get_node("traits").agility = rng.randfn(1.5, 0.25)
	new_unit.get_node("traits").dexterity = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").patience = rng.randfn(1.2, 0.25)
	new_unit.get_node("traits").stamina = rng.randfn(90, 20)
	new_unit.get_node("traits").observation = rng.randfn(1.2, 0.25)
	var new_weap = weapon_gen.gen("Long Bow")
	new_unit.get_node("inventory").set_weapon(new_weap)
	team.inventory.append(new_weap)
	team.add_child(new_weap)
	return new_unit
	
func generate_demo_mage(team):
	rng.randomize()
	var new_unit = character_scene.instantiate()
	team.add_unit(new_unit)
	new_unit.get_node("traits").magic = rng.randfn(1.2, 0.25)
	new_unit.get_node("traits").age = rng.randfn(35, 10)
	new_unit.get_node("traits").patience = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").observation = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").intelligence = rng.randfn(1.4, 0.25)
	var new_weap = weapon_gen.gen("Shotgun")
	new_unit.get_node("inventory").set_weapon(new_weap)
	team.inventory.append(new_weap)
	team.add_child(new_weap)
	return new_unit
	
func generate_demo_monk(team):
	rng.randomize()
	var new_unit = character_scene.instantiate()
	team.add_unit(new_unit)
	new_unit.get_node("traits").age = rng.randfn(35, 10)
	new_unit.get_node("traits").patience = rng.randfn(1.8, 0.25)
	new_unit.get_node("traits").observation = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").intelligence = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").anxiety = rng.randfn(0.25, 0.25)
	new_unit.get_node("traits").temper = rng.randfn(0.1, 0.01)
	var new_weap = weapon_gen.gen("Short Sword")
	new_unit.get_node("inventory").set_weapon(new_weap)
	team.inventory.append(new_weap)
	team.add_child(new_weap)
	return new_unit
	
	
func generate_demo_team():
	var unit_controller = unit_controller_scene.instantiate()
	
	add_child(unit_controller)
	unit_controller.set_human_control()
	generate_demo_archer(unit_controller.main_team)
	generate_demo_warrior(unit_controller.main_team)
	generate_demo_mage(unit_controller.main_team)
	generate_demo_monk(unit_controller.main_team)
	team = unit_controller.main_team
	#var er = equipment_room_scene.instantiate()
	#add_child(er)
	#er.load_inventory(team)
	
func _on_join_battle_press():
	print("JOIN BATTLE")
	battle1 = battle1_scene.instantiate()
	add_child(battle1)
	battle1.load_in(team)
	team.intro_scene.queue_free()

func _process(delta):
	return
	if battle1 != null:
		if battle1.map.winner != null:
			if battle1.map.winner == 1:
				battle1.queue_free()
				town1 = town_scene.instantiate()
				add_child(town1)
				town1.load_team(team)
	if town1 != null:
		if town1.done:
			town1.queue_free()
				#new_town.get_node("WorldEnvironment").acti
				
