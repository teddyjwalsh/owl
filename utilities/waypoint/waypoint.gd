extends Node3D

var t = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	$MeshInstance3D.set_instance_shader_parameter("local_time", t)
	$MeshInstance3D2.scale = Vector3(1.0,1.0,1.0)*min(2,1.0/t);
