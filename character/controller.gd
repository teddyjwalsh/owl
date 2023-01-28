extends Node

class_name Controller

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum STATE {IDLE, MOVE, ATTACK}

var current_command = null
var command_queue = []
var state = "IDLE"
var new_command = false
var path_created = false
var destination = Vector3(0,0,0)
var traits = null

var current_cooldown = null
var initial_cooldown = null

var current_reload = null
var initial_reload = null

var line_scene = preload("res://utilities/line/line.tscn")
var nav_lines = null
var current_line = null


# Called when the node enters the scene tree for the first time.
func _ready():
	traits = get_parent().get_node("traits")
	current_line = line_scene.instantiate()
	add_child(current_line)

func process_move_command(in_command, delta):
	current_cooldown = traits.get_after_movement_cooldown()
	initial_cooldown = current_cooldown
	state = "MOVE"
	if !path_created and get_parent().nav.get_current_navigation_path().size():
		current_line.dashed_path(get_parent().nav.get_current_navigation_path(), 0.1, Color(0.3,0.8,0.5))
		path_created = true
	if new_command:
		get_parent().nav.target_position = (in_command["dest"])
		new_command = false
		print("DFSDFSDF")
		path_created = false
	var to_vec = in_command["dest"] - get_parent().global_transform.origin
	var dist = to_vec.length()
	var dir = to_vec.normalized()
	var move_mult = get_parent().get_movespeed()
	if dist < 1.0:
		current_command = null
		#get_parent().global_transform.origin = in_command["dest"]
		state = "IDLE"
		print("DFSDFSDF22")
	#print(get_parent().position)
	
func process_attack_command(in_command, delta):
	#var to_vec = in_command["target"].global_transform.origin - get_parent().position
	#var dist = to_vec.length()
	#var dir = to_vec.normalized()
	#var move_mult = get_parent().get_movespeed()
	get_parent().inventory.attack(in_command["target"])
	current_command = null
	#get_parent().global_transform.origin = in_command["dest"]
	state = "IDLE"
	print("sdfsdfsdf")
	initial_reload = traits.get_ranged_attack_period()
	current_reload = initial_reload
	
func process_idle(in_command, delta):
	if current_cooldown != null:
		current_cooldown -= delta
		if current_cooldown <= 0:
			current_cooldown = null
	if current_reload != null:
		current_reload -= delta
		if current_reload <= 0:
			current_reload = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if command_queue.size() > 0 and current_command == null:
		var next_command = command_queue.front()
		current_line.clear()
		if current_command == null and current_cooldown == null:
			
			new_command = true
			if next_command["type"] == "MOVE":
				print("MOVE")
				command_queue.pop_front()
				current_command = next_command
			elif next_command["type"] == "ATTACK":
				print("ATTACK")
				if current_reload != null:
					pass
				else:
					command_queue.pop_front()
					current_command = next_command
		if next_command["type"] == "IDLE":
			print("IDLE")
			get_parent().nav.target_position = (get_parent().transform.origin)
			current_command = null
			state = "IDLE"
			command_queue.pop_front()
			current_command = next_command
	elif command_queue.size() == 0 and current_command == null:
		current_line.clear()
	if current_command != null:
		if current_command["type"] == "MOVE":
			process_move_command(current_command, delta)
		elif current_command["type"] == "ATTACK":
			if current_reload == null:
				process_attack_command(current_command, delta)
		elif current_command["type"] == "IDLE":
			process_idle(current_command, delta)
	else:
		process_idle(current_command, delta)

func _physics_process(delta):
	if state == "MOVE":
		var current_location = get_parent().global_transform.origin
		var next_location = get_parent().nav.get_next_path_position()
		var dir = (next_location - current_location)
		var distance = dir.length()
		var new_velocity = dir.normalized()*20
		#get_parent().set_linear_velocity(new_velocity)
		get_parent().set_velocity(new_velocity)
		get_parent().move_and_slide()
		get_parent().velocity
		traits.add_energy(-distance*traits.get_movement_energy()*delta)

func queue_command(in_command):
	command_queue.append(in_command)
	
func set_meta_pressed(in_command):
	print("SET1")
	current_line.clear()
	if current_cooldown == null or in_command["type"] == "IDLE":
		print("SET2")
		current_command = in_command
		new_command = true
		get_parent().nav.target_position = (get_parent().transform.origin)
	
func _input(event):
	return
	if event is InputEventMouseButton:
		if !event.pressed and event.button_index == 2:
			if Input.is_key_pressed(KEY_SHIFT):
				command_queue.append({"type": "MOVE", "dest": event.global_position})
				print("QUEUED")
			else:
				current_command = {"type": "MOVE", "dest": event.global_position}
				print("SET")
				
func set_cooldown(in_cooldown):
	initial_cooldown = in_cooldown
	current_cooldown = in_cooldown
				
