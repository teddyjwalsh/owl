extends Node2D

var weapon_drag_scene = preload("res://equipment_room/weapon_drag.tscn")
var dragged_weapon = null
var team = null
@onready var battle_queue = get_node("/root/BattleQueue")

var drags = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$to_battle.connect("pressed", _to_battle_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for item in team.inventory:
		drags[item].get_node("weapon_drag_text").clear()
		drags[item].get_node("weapon_drag_text").append_text(item.weapon_name + "\n")
		if item.firer != null:
			drags[item].get_node("weapon_drag_text").push_color(Color(item.firer.color.x,item.firer.color.y,item.firer.color.z))
			drags[item].get_node("weapon_drag_text").append_text(item.firer.full_name)
			drags[item].get_node("weapon_drag_text").pop()
	
func _input(event):
	if event is InputEventMouseMotion:
		var viewport = get_viewport()
		if viewport != null:
			var camera = viewport.get_camera_3d()
			if camera != null:
				var mouse_pos = event.position
				var world_pos = camera.project_position(event.position, 5)
				$drag_models.global_transform.origin = world_pos

func load_in(in_team):
	load_team(in_team)

func load_team(in_team):
	var separation = 6
	var start_pos = Vector3(0,0,0) - Vector3(separation*(in_team.units.size()-1)*1.0/2,0,0)
	var i = 0
	for unit in in_team.units:
		var rand_pos = start_pos + Vector3(separation*i,0,0)
		unit.global_transform.origin = rand_pos
		i += 1
	team = in_team
	load_inventory()

func load_inventory():
	for item in team.inventory:
		var weapon_drag = weapon_drag_scene.instantiate()
		weapon_drag.get_node("weapon_drag_text").append_text(item.weapon_name)
		$ScrollContainer/HBoxContainer.add_child(weapon_drag)
		weapon_drag.get_node("weapon_drag_text").connect("click_sig", _start_drag)
		weapon_drag.get_node("weapon_drag_text").connect("release_sig", _end_drag)
		weapon_drag.get_node("weapon_drag_text").data = item
		drags[item] = weapon_drag
		
func _start_drag(item):
	print("START DRAG", item.model_name)
	$drag_models.get_node(item.model_name).visible = true
	dragged_weapon = item

func _end_drag():
	for model in $drag_models.get_children():
		model.visible = false
	var result = get_object_under_mouse()
	if result != null:
		if "collider" in result:
			if result["collider"].get_class() == "character":
				result["collider"].equip(dragged_weapon)
				#result["collider"].inventory.weapon_slot = dragged_weapon
	dragged_weapon = null	

# cast a ray from camera at mouse position, and get the object colliding with the ray
func get_object_under_mouse():
	if get_viewport().get_camera_3d() == null:
		return null
	var mouse_pos = get_viewport().get_mouse_position()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	params.to = params.from + get_viewport().get_camera_3d().project_ray_normal(mouse_pos) * 1000
	params.collision_mask = 1
	var space_state = $drag_models.get_world_3d().direct_space_state
	var selection = space_state.intersect_ray(params)
	return selection
	
func _to_battle_pressed():
	battle_queue.next()
