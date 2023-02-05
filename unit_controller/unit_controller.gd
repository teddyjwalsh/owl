extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var num_units = 0

var chr = preload("res://character/character.tscn")
var team_scene = preload("res://team/team.tscn")

@onready var hi = get_node("/root/HumanInput")
var main_team = null
var selected_units = []
var targeted_unit = null
var is_human_controlled = false

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
	self.get_node("/root/HumanInput").connect("unit_hovered",Callable(self,"_unit_hovered"))
	self.get_node("/root/HumanInput").connect("non_unit_hovered",Callable(self,"_non_unit_hovered"))
	self.get_node("/root/HumanInput").connect("drag_target_sig",Callable(self,"_drag_targeted"))
	self.get_node("/root/HumanInput").connect("boxed_characters",_boxed_characters)
	is_human_controlled = true

func set_command_selected(in_command):
	for unit in selected_units:
		unit.controller.set_command(in_command)
		
		
func queue_command_selected(in_command):
	for unit in selected_units:
		unit.controller.queue_command(in_command)
		
func set_command(in_command, in_unit):
	if in_unit != null:
		in_unit.controller.set_command(in_command)
		
func queue_command(in_command, in_unit):
	if in_unit != null:
		in_unit.controller.queue_command(in_command)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	pass
		
func _clicked_char(chr):
	print("CLIEKCKDF")

func _right_clicked(pos, shift):
	if shift:
		queue_command_selected({"type": "MOVE", "dest": pos})
	else:
		set_command_selected({"type": "MOVE", "dest": pos})
		
func _unit_right_clicked(target, shift):
	if target.get_class() == "character":
		if target.team != main_team:
			if shift:
				queue_command_selected({"type": "ATTACK", "target": target})
				target.get_node("target_indicator").t = 0
			else:
				set_command_selected({"type": "ATTACK", "target": target})
				target.get_node("target_indicator").t = 0
		else:
			selected_units = [target]
	elif target.get_class() == "building":
		if shift:
			queue_command_selected({"type": "MOVE", "dest": target.get_move_to()})
		else:
			set_command_selected({"type": "MOVE", "dest": target.get_move_to()})
			
func _drag_targeted(move_loc, target, shift):
	if target.get_class() == "character":
		if target.team != main_team:
			if shift:
				queue_command_selected({"type": "MOVE", "dest": move_loc})				
				queue_command_selected({"type": "ATTACK", "target": target})
				target.get_node("target_indicator").t = 0
			else:
				set_command_selected({"type": "MOVE", "dest": move_loc})				
				queue_command_selected({"type": "ATTACK", "target": target})
				target.get_node("target_indicator").t = 0
		else:
			if shift:
				queue_command_selected({"type": "MOVE", "dest": move_loc})				
			else:
				set_command_selected({"type": "MOVE", "dest": move_loc})				


func _stop(shift):
	if shift:
		queue_command_selected({"type": "STOP"})
	else:
		set_command_selected({"type": "STOP"})

func _unit_selected(unit_index):
	if unit_index < main_team.units.size():
		selected_units = [main_team.units[unit_index]]
		
func _process(delta):
	for unit in main_team.units:
		unit.select_indicator.get_node("cylinder").visible = false
		if !is_human_controlled:
			unit.select_indicator.visible = false
	for unit in selected_units:
		if is_human_controlled:
			unit.select_indicator.get_node("cylinder").visible = true
		
func give_team(in_team):
	main_team = in_team
	add_child(in_team)
	
func _unit_hovered(in_unit):
	if targeted_unit != null:
		targeted_unit.targeted = false
	if in_unit.team != main_team:
		in_unit.targeted = true
		targeted_unit = in_unit
		
func _non_unit_hovered(in_unit):
	if targeted_unit != null:
		targeted_unit.targeted = false
	targeted_unit = null
	
func _boxed_characters(in_units):
	selected_units.clear()
	for unit in in_units:
		if unit.team == main_team:
			selected_units.append(unit)
	pass
		
