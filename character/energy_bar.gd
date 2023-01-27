extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var max_width = 50
var height = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	color = Color(0.3,0.8,0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_viewport().get_camera() != null:
		var energy = get_parent().get_node("traits").energy
		var screen_pos = get_viewport().get_camera().unproject_position(get_parent().global_transform.origin)
		set_global_position(screen_pos + Vector2(-max_width/2, -70))
		color = Color(0.2,0.5,0.2)
		rect_size = Vector2(max_width*energy, height)
  
