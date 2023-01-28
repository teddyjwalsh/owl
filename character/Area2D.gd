extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var poly = $CollisionShape2D.get_shape()
var previous_width = 0

@onready var hi = get_node("/root/HumanInput")

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.set_shape(poly)
	

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			hi.click(get_parent())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var width = get_parent().get_graphical_width()
	if width != previous_width:
		poly.set_extents(Vector2(width/2,width/2))
