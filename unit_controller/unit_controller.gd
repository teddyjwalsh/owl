extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var num_units = 0

var chr = preload("res://character/character.tscn")
var team_scene = preload("res://team/team.tscn")
onready var hi = get_node("/root/HumanInput")
var main_team = null;
var selected_unit = null

# Called when the node enters the scene tree for the first time.
func _ready():
	hi.connect("clicked_char", self, "_clicked_char")
	hi.connect("right_clicked", self, "_right_clicked")
	hi.connect("unit_right_clicked", self, "_unit_right_clicked")
	main_team = team_scene.instance()
	add_child(main_team)

func set_command_selected(in_command):
	print("setggggg")
	if selected_unit != null:
		selected_unit.controller.set_command(in_command)
		
func queue_command_selected(in_command):
	if selected_unit != null:
		selected_unit.controller.queue_command(in_command)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventKey and event.scancode == KEY_T and !event.pressed:
		var new_char = chr.instance()
		new_char.transform.origin = Vector3(20,5,5)
		new_char.name = "new_unit" + str(main_team.units.count())
		main_team.add_unit(new_char)
		selected_unit = new_char
		
func _clicked_char(chr):
	print("CLIEKCKDF")

func _right_clicked(pos, shift):
	if shift:
		queue_command_selected({"type": Controller.STATE.MOVE, "dest": pos})
	else:
		set_command_selected({"type": Controller.STATE.MOVE, "dest": pos})
		
func _unit_right_clicked(target, shift):
	if shift:
		queue_command_selected({"type": Controller.STATE.ATTACK, "target": target})
	else:
		set_command_selected({"type": Controller.STATE.ATTACK, "target": target})
