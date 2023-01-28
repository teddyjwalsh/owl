extends ColorRect

var max_width = 50
var height = 5
@onready var traits = get_parent().get_parent().get_node("traits")

# Called when the node enters the scene tree for the first time.
func _ready():
	color = Color(0.3,0.8,0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_viewport().get_camera_3d() != null:
		var energy = traits.energy
		#var screen_pos = get_viewport().get_camera_3d().unproject_position(get_parent().global_transform.origin)
		#set_global_position(screen_pos + Vector2(-max_width/2, -70))
		color = Color(0.2,0.5,0.2)
		size = Vector2(max_width*energy, height)
  
