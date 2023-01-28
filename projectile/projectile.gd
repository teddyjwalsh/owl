extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_homing = true
var target = null
var speed = 50.0
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",Callable(self,"body_entered"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_homing:
		var dir = (target.global_transform.origin  + Vector3(0,1,0) - global_transform.origin)
		var norm_dir = dir.normalized()
		var dist = dir.length()
		global_transform.origin += norm_dir*delta*speed
		

func body_entered(body):
	print("collide")
	print(body)
	if body.get_class() == "character":
		if body != owner:
			body.traits.add_health(-damage)
			queue_free()
	elif body.get_class() == "StaticBody3D":
		queue_free()
			
