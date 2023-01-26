extends Spatial


# Declare member variables here. Examples:
# var a = 25
# var b = "text"

var charact = preload("res://unit_controller/unit_controller.tscn")
onready var camera = $campos.get_node("Camera")

# Called when the node enters the scene tree for the first time.
func _ready():
	var instance = charact.instance()
	#instance.name = "u"
	add_child(instance)
	
	$campos.transform.origin = Vector3(0,20,50)
	camera.look_at(Vector3(0,0,0),Vector3(0,1,0))
	camera.set_orthogonal(75,1,400)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):$
#	pass
