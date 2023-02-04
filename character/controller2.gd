extends Node

var state = "IDLE"
var prev_state = "IDLE"
var current_reload = null
var initial_reload = null
var current_cooldown = null
var initial_cooldown = null

var attack_animation = null
var has_attacked = false
var attack_target = null
var attack_point = 4.7/6.5

var animation_attack_points = {"axe": 0.9, "bow":0.9, "rifle": 4.7/6.5}

var command_queue = []

var line_scene = preload("res://utilities/line/line.tscn")
var nav_lines = null
var current_line = null

var dead = false

func _ready():
	current_line = line_scene.instantiate()
	add_child(current_line)
	
func set_command(in_command):
	command_queue.clear()
	command_queue.append(in_command)
	
func queue_command(in_command):
	command_queue.append(in_command)

func assess_state():
	var moving = !get_parent().get_node("NavigationAgent3D").is_navigation_finished()
	var reloading = current_reload != null
	var cooldown = current_cooldown != null
	if dead:
		state = "DEAD"
	elif attack_animation != null:
		state = "ATTACKING"
	elif moving:
		if reloading:
			state = "RELOADING_MOVE"
		state = "MOVE"
		if current_line.count() == 0:
			current_line.dashed_path(get_parent().nav.get_current_navigation_path(), 0.1, Color(0.3,0.8,0.5))
	elif cooldown:
		if reloading:
			state = "RELOADING_COOLDOWN"
		else:
			state = "COOLDOWN"
		current_line.clear()
	elif reloading:
		state = "RELOADING"
		current_line.clear()
	else:
		state = "IDLE"
		current_line.clear()
	return state
	
func process_attack_command(target):
	if target != null:
		print("sdfsdfsdf")
		has_attacked = false
		get_parent().look_at(target.global_transform.origin, Vector3(0,1,0))
		var anim_player = get_parent().get_node("character_model2").get_node("AnimationPlayer")
		anim_player.play(get_parent().inventory.weapon_slot.animation)
		get_parent().get_node("character_model2/Armature/Skeleton3D/weapon_attach").bone_name = "weapon"
		attack_animation = anim_player.current_animation_length
		attack_target = target
	
func process_attack(delta):
	var anim_player = get_parent().get_node("character_model2").get_node("AnimationPlayer")
	if anim_player.current_animation != get_parent().inventory.weapon_slot.animation:
		attack_animation = null
	if attack_animation != null:
		var anim_state = anim_player.current_animation_position/anim_player.current_animation_length
		attack_animation = anim_state
		if !has_attacked:
			if anim_state > animation_attack_points[get_parent().inventory.weapon_slot.animation]:
				get_parent().inventory.attack(attack_target)
				initial_reload = get_parent().get_node("traits").get_ranged_attack_period(get_parent().inventory.weapon_slot)
				current_reload = initial_reload
				has_attacked = true
		#if attack_animation <= 0:
		#	attack_animation = null

	
func process_new_command(in_command):
	if in_command["type"] == "STOP":
		get_parent().nav.target_position = get_parent().global_transform.origin
	elif in_command["type"] == "MOVE":
		get_parent().nav.target_position = in_command["dest"]
		current_cooldown = get_parent().traits.get_after_movement_cooldown()
		initial_cooldown = current_cooldown
	elif in_command["type"] == "ATTACK":
		process_attack_command(in_command["target"])

		
func update_cooldowns(delta):
	assess_state()
	if current_cooldown != null:
		current_cooldown -= delta
		if current_cooldown <= 0:
			current_cooldown = null
	if current_reload != null and (state == "ATTACK" or state == "RELOADING" or state == "RELOADING_COOLDOWN"):
		current_reload -= delta
		if current_reload <= 0:
			current_reload = null

		
func _process(delta):
	if dead:
		return
	assess_state()
	if command_queue.size() and assess_state() == "IDLE":
		process_new_command(command_queue.pop_front())
	elif command_queue.size():
		if command_queue.front()["type"] == "STOP":
			get_parent().nav.target_position = get_parent().global_transform.origin
			command_queue.pop_front()
		elif command_queue.front()["type"] == "MOVE" and \
				(assess_state() == "RELOADING" or assess_state() == "RELOADING_MOVE"):
			process_new_command(command_queue.pop_front())
			command_queue.pop_front()
	update_cooldowns(delta)
	if attack_animation != null:
		process_attack(delta)
	if get_parent().traits.health < 0.001:
		dead = true
		var anim_player = get_parent().get_node("character_model2").get_node("AnimationPlayer")	
		anim_player.play("death")
		get_parent().get_node("character_model2/Armature/Skeleton3D/weapon_attach").bone_name = "back"
		get_parent().get_node("unit_info").visible = false
	
func _physics_process(delta):
	assess_state()
	var anim_player = get_parent().get_node("character_model2").get_node("AnimationPlayer")
	var ms = get_parent().traits.get_movespeed()
	if state == "ATTACKING":
		return
	elif state == "MOVE" or state == "RELOADING_MOVE":
		if anim_player.current_animation != "run":
			anim_player.play("run", -1, 2.0*ms)
			get_parent().get_node("character_model2/Armature/Skeleton3D/weapon_attach").bone_name = "back"
		var current_location = get_parent().global_transform.origin
		var next_location = get_parent().nav.get_next_path_position()
		var dir = (next_location - current_location)
		var distance = dir.length()
		var new_velocity = dir.normalized()*10*ms
		#get_parent().set_linear_velocity(new_velocity)
		get_parent().set_velocity(new_velocity)
		get_parent().move_and_slide()
		get_parent().velocity
		next_location.y = get_parent().global_transform.origin.y
		get_parent().look_at(next_location, Vector3(0,1,0))
		get_parent().get_node("traits").add_energy(-distance*get_parent().get_node("traits").get_movement_energy()*delta)
	elif state != "DEAD":
		if anim_player.current_animation != "idle":
			anim_player.play("idle")
			get_parent().get_node("character_model2/Armature/Skeleton3D/weapon_attach").bone_name = "weapon"
		
		
	
	
