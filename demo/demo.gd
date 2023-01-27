extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var unit_controller_scene = preload("res://unit_controller/unit_controller.tscn")
var character_scene = preload("res://character/character.tscn")
var main_menu_scene = preload("res://demo/main_menu/main_menu.tscn")
var main_menu = null

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu = main_menu_scene.instance()
	add_child(main_menu)

func generate_demo_team():
	var unit_controller = unit_controller_scene.instance()
	add_child(unit_controller)
	for i in range(4):
		var new_unit = character_scene.instance()
		unit_controller.main_team.add_unit(new_unit)
	unit_controller.main_team.load_intro()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
