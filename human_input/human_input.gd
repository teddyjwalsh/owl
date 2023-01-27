extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var last_clicked = null
var RAY_LENGTH = 400
var hovered_unit = null

signal clicked_char(chr)
signal right_clicked(pos, queue)
signal unit_right_clicked(target, queue)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func click(in_node):
	last_clicked = in_node
	emit_signal("clicked_char", last_clicked)
	
# cast a ray from camera at mouse position, and get the object colliding with the ray
func get_object_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = get_viewport().get_camera().project_ray_origin(mouse_pos)
	var ray_to = ray_from + get_viewport().get_camera().project_ray_normal(mouse_pos) * RAY_LENGTH
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection
	
	
func _input(event):
	if event is InputEventMouseMotion:
		var res = get_object_under_mouse()
		if res["collider"].get_class() == "character":
			hovered_unit = res["collider"]		
	if event is InputEventMouseButton:
		var shift = Input.is_key_pressed(KEY_SHIFT)
		if event.button_index == 1 and !event.is_pressed():
			var res = get_object_under_mouse()
			print(res)
		if event.button_index == 2 and !event.is_pressed():
			var res = get_object_under_mouse()
			if res["collider"].get_class() == "character":
				emit_signal("unit_right_clicked", res["collider"], shift)
			else:
				emit_signal("right_clicked", res["position"], shift)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
