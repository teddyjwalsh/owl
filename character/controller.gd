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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func process_move_command(in_command, delta):
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
	var to_vec = in_command["dest"] - get_parent().position
	var dist = to_vec.length()
	var dir = to_vec.normalized()
	var move_mult = get_parent().get_movespeed()
	if dist < delta*move_mult:
		current_command = null
		get_parent().position = in_command["dest"]
		state = STATE.IDLE
	get_parent().position += dir*move_mult*delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if command_queue.size() > 0:
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

func _physics_process(delta):
	if state == STATE.MOVE:
		var current_location = get_parent().global_transform.origin
		var next_location = get_parent().nav.get_next_location()
		var new_velocity = (next_location - current_location).normalized()*20
		#get_parent().set_linear_velocity(new_velocity)
		get_parent().move_and_slide(new_velocity)

func queue_command(in_command):
	command_queue.append(in_command)
	
func set_command(in_command):
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
				
