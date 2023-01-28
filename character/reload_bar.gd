extends ColorRect

var max_width = 50
var height = 5
@onready var controller = get_parent().get_parent().get_node("controller")

# Called when the node enters the scene tree for the first time.
func _ready():
	color = Color(0.4,0.3,0.1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_viewport().get_camera_3d() != null:
		var init_cooldown = controller.initial_reload
		var cooldown = controller.current_reload
		if cooldown != null:
			visible = true
			#var screen_pos = get_viewport().get_camera_3d().unproject_position(get_parent().global_transform.origin)
			#set_global_position(screen_pos + Vector2(-max_width/2, -65))
			color = Color(0.6,0.5,0.1)
			size = Vector2(max_width*(cooldown/init_cooldown), height)
		else:
			visible = false

