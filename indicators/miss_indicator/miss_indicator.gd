extends Node2D

@onready var spawn_time = Time.get_ticks_msec()*1.0/1000
var cur_pos = Vector3(0,0,0)
var duration = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rise_speed = 1.0
	cur_pos += Vector3(0,rise_speed*delta,0)
	if get_viewport().get_camera_3d() != null:
		var screen_pos = get_viewport().get_camera_3d().unproject_position(cur_pos)
		set_global_position(screen_pos)
	duration -= delta
	if duration <= 0:
		queue_free()
