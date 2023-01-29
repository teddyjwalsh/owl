extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var num_units = 0

var chr = preload("res://character/character.tscn")
var team_scene = preload("res://team/team.tscn")

@onready var hi = get_node("/root/HumanInput")
var main_team = null;
var selected_unit = null

# Called when the node enters the scene tree for the first time.
func _ready():
	main_team = team_scene.instantiate()
	add_child(main_team)

	
func set_human_control():
	self.get_node("/root/HumanInput").connect("clicked_char",Callable(self,"_clicked_char"))
	self.get_node("/root/HumanInput").connect("right_clicked",Callable(self,"_right_clicked"))
	self.get_node("/root/HumanInput").connect("unit_right_clicked",Callable(self,"_unit_right_clicked"))
	self.get_node("/root/HumanInput").connect("unit_selected",Callable(self,"_unit_selected"))
	self.get_node("/root/HumanInput").connect("stop",Callable(self,"_stop"))

func set_command_selected(in_command):
	print("setggggg")
	if selected_unit != null:
		selected_unit.controller.set_meta_pressed(in_command)
		
func queue_command_selected(in_command):
	if selected_unit != null:
		selected_unit.controller.queue_command(in_command)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventKey and event.keycode == KEY_T and !event.pressed:
		var new_char = chr.instantiate()
		new_char.transform.origin = Vector3(20,5,5)
		new_char.name = "new_unit" + str(main_team.units.size())
		main_team.add_unit(new_char)
		selected_unit = new_char
		
func _clicked_char(chr):
	print("CLIEKCKDF")

func _right_clicked(pos, shift):
	if shift:
		queue_command_selected({"type": "MOVE", "dest": pos})
	else:
		set_command_selected({"type": "MOVE", "dest": pos})
		
func _unit_right_clicked(target, shift):
	if target.team != main_team.team_number:
		if shift:
			queue_command_selected({"type": "ATTACK", "target": target})
		else:
			set_command_selected({"type": "ATTACK", "target": target})

func _stop(shift):
	if shift:
		queue_command_selected({"type": "IDLE"})
	else:
		set_command_selected({"type": "IDLE"})

func _unit_selected(unit_index):
	if unit_index < main_team.units.size():
		selected_unit = main_team.units[unit_index]
		
func _process(delta):
	for unit in main_team.units:
		unit.select_indicator.visible = false
	if selected_unit != null:
		selected_unit.select_indicator.visible = true
		
