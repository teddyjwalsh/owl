extends Node3D

var unit_controller_scene = preload("res://unit_controller/unit_controller.tscn")
var character_scene = preload("res://character/character.tscn")
var main_menu_scene = preload("res://demo/main_menu/main_menu.tscn")
var battle1_scene = preload("res://demo/battles/battle1/battle1.tscn")
var weapon_gen_scene = preload("res://weapon/weapon_generator/weapon_generator.tscn")
var battle1 = null
var main_menu = null
var rng = RandomNumberGenerator.new()
var team = null
@onready var weapon_gen = weapon_gen_scene.instantiate()

func _ready():
	main_menu = main_menu_scene.instantiate()
	add_child(main_menu)
	add_child(weapon_gen)
	
func generate_demo_warrior():
	rng.randomize()
	var new_unit = character_scene.instantiate()
	new_unit.get_node("traits").strength = rng.randfn(1.5, 0.25)
	new_unit.get_node("traits").pride = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").anxiety = rng.randfn(0.7, 0.25)
	new_unit.get_node("traits").patience = rng.randfn(0.9, 0.25)
	new_unit.get_node("traits").stamina = rng.randfn(110, 20)
	new_unit.get_node("inventory").set_weapon(weapon_gen.gen("Battle Axe"))
	
	return new_unit
	
func generate_demo_archer():
	rng.randomize()
	var new_unit = character_scene.instantiate()
	print(new_unit.traits)
	new_unit.get_node("traits").agility = rng.randfn(1.5, 0.25)
	new_unit.get_node("traits").dexterity = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").patience = rng.randfn(1.2, 0.25)
	new_unit.get_node("traits").stamina = rng.randfn(90, 20)
	new_unit.get_node("traits").observation = rng.randfn(1.2, 0.25)
	new_unit.get_node("inventory").set_weapon(weapon_gen.gen("Long Bow"))
	return new_unit
	
func generate_demo_mage():
	rng.randomize()
	var new_unit = character_scene.instantiate()
	new_unit.get_node("traits").magic = rng.randfn(1.2, 0.25)
	new_unit.get_node("traits").age = rng.randfn(35, 10)
	new_unit.get_node("traits").patience = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").observation = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").intelligence = rng.randfn(1.4, 0.25)
	new_unit.get_node("inventory").set_weapon(weapon_gen.gen("Revolver"))
	return new_unit
	
func generate_demo_monk():
	rng.randomize()
	var new_unit = character_scene.instantiate()
	new_unit.get_node("traits").age = rng.randfn(35, 10)
	new_unit.get_node("traits").patience = rng.randfn(1.8, 0.25)
	new_unit.get_node("traits").observation = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").intelligence = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").anxiety = rng.randfn(0.25, 0.25)
	new_unit.get_node("traits").temper = rng.randfn(0.1, 0.01)
	new_unit.get_node("inventory").set_weapon(weapon_gen.gen("Dagger"))
	return new_unit
	
	
func generate_demo_team():
	var unit_controller = unit_controller_scene.instantiate()
	
	add_child(unit_controller)
	unit_controller.set_human_control()
	unit_controller.main_team.add_unit(generate_demo_archer())
	unit_controller.main_team.add_unit(generate_demo_warrior())
	unit_controller.main_team.add_unit(generate_demo_mage())
	unit_controller.main_team.add_unit(generate_demo_monk())
	unit_controller.main_team.load_intro()
	team = unit_controller.main_team
	var team_scene = team.intro_scene
	team_scene.get_node("MarginContainer/Button"). \
		connect("pressed",Callable(self,"_on_join_battle_press"))
	
	
func _on_join_battle_press():
	print("JOIN BATTLE")
	battle1 = battle1_scene.instantiate()
	add_child(battle1)
	battle1.load_in(team)
	team.intro_scene.queue_free()
