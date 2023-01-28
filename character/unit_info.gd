extends VBoxContainer

var max_width = 50
var height = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_viewport().get_camera_3d() != null:
		var screen_pos = get_viewport().get_camera_3d().unproject_position(get_parent().global_transform.origin)
		set_global_position(screen_pos + Vector2(-max_width/2, -65))
