extends Node

class_name Controller

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum STATE {IDLE, MOVE, ATTACK}

var current_command = null
var command_queue = []
var state = STATE.IDLE
var new_command = false
var destination = Vector3(0,0,0)
var traits = null

var current_cooldown = null
var initial_cooldown = null

# Called when the node enters the scene tree for the first time.
func _ready():
	traits = get_parent().get_node("traits")

func process_move_command(in_command, delta):
	current_cooldown = 5.0
	initial_cooldown = current_cooldown
	state = STATE.MOVE
	if new_command:
		get_parent().nav.set_target_location(in_command["dest"])
		new_command = false
		print("DFSDFSDF")
	var to_vec = in_command["dest"] - get_parent().global_transform.origin
	var dist = to_vec.length()
	var dir = to_vec.normalized()
	var move_mult = get_parent().get_movespeed()
	if dist < 1:
		current_command = null
		#get_parent().global_transform.origin = in_command["dest"]
		state = STATE.IDLE
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
	state = STATE.IDLE
	print("sdfsdfsdf")
	
func process_idle(in_command, delta):
	if current_cooldown != null:
		current_cooldown -= delta
		if current_cooldown <= 0:
			current_cooldown = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if command_queue.size() > 0 and current_command == null:
		if current_command == null:
			current_command = command_queue.pop_front()
			new_command = true
			if current_command["type"] == STATE.MOVE:
				print("MOVE")
			elif current_command["type"] == STATE.ATTACK:
				print("ATTACK")
			elif current_command["type"] == STATE.IDLE:
				print("IDLE")
				get_parent().var.set_target_location(get_parent().transform.origin)
				current_command = null
				state = STATE.IDLE
	if current_command != null:
		if current_command["type"] == STATE.MOVE:
			process_move_command(current_command, delta)
		elif current_command["type"] == STATE.ATTACK:
			process_attack_command(current_command, delta)
		elif current_command["type"] == STATE.IDLE:
			process_idle(current_command, delta)
	else:
		process_idle(current_command, delta)

func _physics_process(delta):
	if state == STATE.MOVE:
		var current_location = get_parent().global_transform.origin
		var next_location = get_parent().nav.get_next_location()
		var dir = (next_location - current_location)
		var distance = dir.length()
		var new_velocity = dir.normalized()*20
		#get_parent().set_linear_velocity(new_velocity)
		get_parent().move_and_slide(new_velocity)
		traits.add_energy(-distance*traits.get_movement_energy()*delta)

func queue_command(in_command):
	command_queue.append(in_command)
	
func set_command(in_command):
	if current_cooldown == null:
		current_command = in_command
		new_command = true
	
func _input(event):
	return
	if event is InputEventMouseButton:
		if !event.pressed and event.button_index == 2:
			if Input.is_key_pressed(KEY_SHIFT):
				command_queue.append({"type": STATE.MOVE, "dest": event.global_position})
				print("QUEUED")
			else:
				current_command = {"type": STATE.MOVE, "dest": event.global_position}
				print("SET")
				
func set_cooldown(in_cooldown):
	initial_cooldown = in_cooldown
	current_cooldown = in_cooldown
				
