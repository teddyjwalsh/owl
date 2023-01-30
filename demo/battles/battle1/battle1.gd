extends Node

var unit_controller_scene = preload("res://unit_controller/unit_controller.tscn")
var enemy_scene = preload("res://ai/basic_enemy_ai/basic_enemy_ai.tscn")
var character_scene = preload("res://character/character.tscn")
var barrier_scene = preload("res://map/solid_object/solid_object.tscn")
var map_scene = preload("res://map/map.tscn")
var map = null
var rng = RandomNumberGenerator.new()
var team = null
var enemy_ai = null
@onready var wg = get_node("/root/WeaponGenerator")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func generate_demo_warrior():
	rng.randomize()
	var new_unit = character_scene.instantiate()
	new_unit.get_node("traits").strength = rng.randfn(1.5, 0.25)
	new_unit.get_node("traits").pride = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").anxiety = rng.randfn(0.7, 0.25)
	new_unit.get_node("traits").patience = rng.randfn(0.9, 0.25)
	new_unit.get_node("traits").stamina = rng.randfn(110, 20)
	new_unit.get_node("inventory").set_weapon(wg.gen("Battle Axe"))
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
	new_unit.get_node("inventory").set_weapon(wg.gen("Long Bow"))
	return new_unit
	
func generate_demo_mage():
	rng.randomize()
	var new_unit = character_scene.instantiate()
	new_unit.get_node("traits").magic = rng.randfn(1.2, 0.25)
	new_unit.get_node("traits").age = rng.randfn(35, 10)
	new_unit.get_node("traits").patience = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").observation = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").intelligence = rng.randfn(1.4, 0.25)
	new_unit.get_node("inventory").set_weapon(wg.gen("Revolver"))
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
	new_unit.get_node("inventory").set_weapon(wg.gen("Dagger"))
	
	return new_unit
	
	
func generate_demo_team():
	var enemy_team = enemy_scene.instantiate()
	enemy_ai = enemy_team
	add_child(enemy_team)
	var unit_controller = enemy_team.uc
	unit_controller.main_team.team_number = 2
	unit_controller.main_team.add_unit(generate_demo_archer())
	unit_controller.main_team.add_unit(generate_demo_warrior())
	unit_controller.main_team.add_unit(generate_demo_mage())
	unit_controller.main_team.add_unit(generate_demo_monk())
	for unit in unit_controller.main_team.units:
		unit.get_node("controller").current_line.visible = false
	team = unit_controller.main_team

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func load_in(in_player_team):
	map = map_scene.instantiate()
	add_child(map)
	map.get_node("NavigationRegion3D").add_child(barrier_scene.instantiate())
	map.bake_navmesh()
	for _i in map.get_children():
		print(_i)
	var camera = map.get_node("Camera3D")
	camera.current = true
	self.generate_demo_team()
	enemy_ai.enemy_team = in_player_team
	enemy_ai.map = map
	map.load_team(in_player_team,1)
	map.load_team(team,2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
