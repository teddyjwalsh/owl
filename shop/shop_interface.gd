extends Node2D

@onready var grid = $CenterContainer/PanelContainer/VBoxContainer/GridContainer
var slot_scene = preload("res://shop/shop_slot.tscn")
@onready var human_input = get_node("/root/HumanInput")

var team = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/PanelContainer/VBoxContainer/exit_button.connect("pressed",_exit)
	var wg = get_node("/root/WeaponGenerator")
	for i in range(6):
		var new_slot = slot_scene.instantiate()
		grid.add_child(new_slot)
		new_slot.item_slot = wg.gen_random()
		new_slot.add_child(new_slot.item_slot)
		new_slot.connect("pressed", func f(): new_slot._purchase(self.team))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _exit():
	visible = false
	human_input.current_shop_interface = null
