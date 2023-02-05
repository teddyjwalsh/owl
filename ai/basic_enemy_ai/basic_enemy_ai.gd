extends Node

var unit_controller_scene = preload("res://unit_controller/unit_controller.tscn")
var uc = null
var enemy_team = null
var map = null
var unit_states = []
var unit_targets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	uc = unit_controller_scene.instantiate() # Replace with function body.
	add_child(uc)
	for i in range(8):
		unit_states.append("IDLE")
		unit_targets.append(null)
		
func reassess_target(unit):
	if enemy_team.units.size():
		var closest_unit = null
		for enemy_unit in enemy_team.units:
			if enemy_unit.controller.dead:
				continue
			elif closest_unit == null:
				closest_unit = enemy_unit
			var closest_dist = (closest_unit.global_transform.origin - unit.global_transform.origin).length()
			var this_dist = (enemy_unit.global_transform.origin - unit.global_transform.origin).length()
			if this_dist < closest_dist:
				closest_unit = enemy_unit
		return closest_unit
	else:
		return null
		
func process_idle_state(unit, cur_target):
	if cur_target != null and cur_target.controller.current_cooldown == null:
		uc.set_command({"type": "MOVE", "dest": cur_target.global_transform.origin}, unit)
		return "MOVE"
	else:
		return "IDLE"

func check_line_of_sight(unit, cur_target):
	var dir = (cur_target.global_transform.origin - unit.global_transform.origin).normalized()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = unit.global_transform.origin + Vector3(0,1,0)
	params.to = unit.global_transform.origin + dir * unit.inventory.weapon_slot.range*1.1  + Vector3(0,1,0)
	params.exclude = unit.team.units
	params.collision_mask = 1
	var space_state = unit.get_world_3d().direct_space_state
	var selection = space_state.intersect_ray(params)
	if selection.has("collider"):
		if selection["collider"] == cur_target:
			return true
	return false

func process_move_state(unit, cur_target):
	if cur_target != null:
		var cur_range = (cur_target.global_transform.origin - unit.global_transform.origin).length()
		if cur_range < unit.inventory.weapon_slot.range:
			if check_line_of_sight(unit,cur_target):
				uc.set_command({"type": "STOP"}, unit)
				uc.queue_command({"type": "ATTACK", "target": cur_target}, unit)					
				return "ATTACK"
		if unit.controller.state != "MOVE" and unit.controller.state != "RELOADING_MOVE":
			uc.set_command({"type": "STOP"}, unit)
			uc.set_command({"type": "MOVE", "dest": cur_target.global_transform.origin}, unit)
			return "MOVE"
		return "MOVE"
	else:
		return "IDLE"
	
func process_attack_state(unit, cur_target):
	if cur_target != null:
		var cur_range = (cur_target.global_transform.origin - unit.global_transform.origin).length()
		if cur_range > unit.inventory.weapon_slot.range*1.2:
			return "MOVE"
		if unit.controller.current_reload == null:
			if check_line_of_sight(unit, cur_target):
				uc.queue_command({"type": "ATTACK", "target": cur_target}, unit)
			else:
				uc.set_command({"type": "MOVE", "dest": cur_target.global_transform.origin}, unit)
				return "MOVE"
		return "ATTACK"
	else:
		return "IDLE"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var unit_num = 0
	for unit in uc.main_team.units:
		unit_targets[unit_num] = reassess_target(unit)
		if unit_states[unit_num] == "IDLE":
			unit_states[unit_num] = process_idle_state(unit, unit_targets[unit_num])
		elif unit_states[unit_num] == "MOVE":
			unit_states[unit_num] = process_move_state(unit, unit_targets[unit_num])
		elif unit_states[unit_num] == "ATTACK":
			unit_states[unit_num] = process_attack_state(unit, unit_targets[unit_num])
		unit_num += 1
