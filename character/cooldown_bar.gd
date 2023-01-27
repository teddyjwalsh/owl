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
	var init_cooldown = get_parent().get_node("controller").initial_cooldown
	var cooldown = get_parent().get_node("controller").current_cooldown
	if cooldown != null:
		visible = true
		var screen_pos = get_viewport().get_camera().unproject_position(get_parent().global_transform.origin)
		set_global_position(screen_pos + Vector2(-max_width/2, -65))
		color = Color(0.5,0.5,0.5)
		rect_size = Vector2(max_width*(cooldown/init_cooldown), height)
	else:
		visible = false
