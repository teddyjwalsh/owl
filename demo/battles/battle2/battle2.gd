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

func generate_demo_warrior(in_team):
	var new_unit = character_scene.instantiate()
	in_team.add_unit(new_unit)
	new_unit.traits.init()
	new_unit.get_node("traits").strength = rng.randfn(1.5, 0.25)
	new_unit.get_node("traits").pride = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").anxiety = rng.randfn(0.7, 0.25)
	new_unit.get_node("traits").patience = rng.randfn(0.9, 0.25)
	new_unit.get_node("traits").stamina = rng.randfn(110, 20)
	var new_weap = wg.gen("Battle Axe")
	new_unit.get_node("inventory").set_weapon(new_weap)
	in_team.inventory.append(new_weap)
	in_team.add_child(new_weap)
	new_unit.get_node("traits").stamina = new_unit.get_node("traits").stamina*0.1
	new_unit.get_node("traits").strength = new_unit.get_node("traits").strength*0.1
	return new_unit
	
func generate_demo_archer(in_team):
	var new_unit = character_scene.instantiate()
	in_team.add_unit(new_unit)
	new_unit.traits.init()
	new_unit.get_node("traits").agility = rng.randfn(1.5, 0.25)
	new_unit.get_node("traits").dexterity = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").patience = rng.randfn(1.2, 0.25)
	new_unit.get_node("traits").stamina = rng.randfn(90, 20)
	new_unit.get_node("traits").observation = rng.randfn(1.2, 0.25)
	var new_weap = wg.gen("Long Bow")
	new_unit.get_node("inventory").set_weapon(new_weap)
	in_team.inventory.append(new_weap)
	in_team.add_child(new_weap)
	new_unit.get_node("traits").stamina = new_unit.get_node("traits").stamina*0.1
	new_unit.get_node("traits").strength = new_unit.get_node("traits").strength*0.1
	return new_unit
	
func generate_demo_mage(in_team):
	var new_unit = character_scene.instantiate()
	in_team.add_unit(new_unit)
	new_unit.traits.init()
	new_unit.get_node("traits").magic = rng.randfn(1.2, 0.25)
	new_unit.get_node("traits").age = rng.randfn(35, 10)
	new_unit.get_node("traits").patience = rng.randfn(1.3, 0.25)
	new_unit.get_node("traits").observation = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").intelligence = rng.randfn(1.4, 0.25)
	var new_weap = wg.gen("Revolver")
	new_unit.get_node("inventory").set_weapon(new_weap)
	in_team.inventory.append(new_weap)
	in_team.add_child(new_weap)
	new_unit.get_node("traits").stamina = new_unit.get_node("traits").stamina*0.1
	new_unit.get_node("traits").strength = new_unit.get_node("traits").strength*0.1
	return new_unit
	
func generate_demo_monk(in_team):
	var new_unit = character_scene.instantiate()
	in_team.add_unit(new_unit)
	new_unit.traits.init()
	new_unit.get_node("traits").age = rng.randfn(35, 10)
	new_unit.get_node("traits").patience = rng.randfn(1.8, 0.25)
	new_unit.get_node("traits").observation = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").intelligence = rng.randfn(1.4, 0.25)
	new_unit.get_node("traits").anxiety = rng.randfn(0.25, 0.25)
	new_unit.get_node("traits").temper = rng.randfn(0.1, 0.01)
	new_unit.get_node("traits").strength = new_unit.get_node("traits").strength*0.1
	new_unit.get_node("traits").stamina = new_unit.get_node("traits").stamina*0.1
	var new_weap = wg.gen("Dagger")
	new_unit.get_node("inventory").set_weapon(new_weap)
	in_team.inventory.append(new_weap)
	in_team.add_child(new_weap)
	return new_unit
	
	
func generate_demo_team():
	var enemy_team = enemy_scene.instantiate()
	enemy_ai = enemy_team
	add_child(enemy_team)
	var unit_controller = enemy_team.uc
	unit_controller.main_team.team_number = 2
	
	generate_demo_warrior(unit_controller.main_team)
	generate_demo_mage(unit_controller.main_team)
	generate_demo_monk(unit_controller.main_team)
	generate_demo_archer(unit_controller.main_team)
	for unit in unit_controller.main_team.units:
		#unit.controller.dead = true
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
