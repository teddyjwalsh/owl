extends HFlowContainer

var max_width = 50
var height = 5
@onready var traits = get_parent().get_parent().get_node("traits")
var old_health = 1.0
var dec_rate = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	$health_bar.color = Color(0.3,0.8,0.2)
	size = Vector2(max_width, height)
	$health_bar.material = $health_bar.material.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_viewport().get_camera_3d() != null:
		var health = traits.health
		old_health = max(health, old_health - dec_rate*delta)
		#var screen_pos = get_viewport().get_camera_3d().unproject_position(get_parent().get_parent().global_transform.origin)
		#set_global_position(screen_pos + Vector2(-max_width/2, -75))
		#$health_bar.color = Color(0.5,0.2,0.2)
		#$white_part.color = Color(0.9,0.9,0.9)
		$health_bar.size = Vector2(max_width, height)
		#$white_part.size = Vector2(max_width*(1.0 - health), height)
		$health_bar.material.set_shader_parameter("current_health", health)
		$health_bar.material.set_shader_parameter("old_health", old_health)
