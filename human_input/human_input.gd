extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var last_clicked = null
var RAY_LENGTH = 400
var hovered_unit = null

signal clicked_char(chr)
signal right_clicked(pos, queue)
signal unit_right_clicked(target, queue)
signal unit_selected(unit_num)
signal stop(unit_num)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func click(in_node):
	last_clicked = in_node
	emit_signal("clicked_char", last_clicked)
	
# cast a ray from camera at mouse position, and get the object colliding with the ray
func get_object_under_mouse():
	if get_viewport().get_camera_3d() == null:
		return null
	var mouse_pos = get_viewport().get_mouse_position()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	params.to = params.from + get_viewport().get_camera_3d().project_ray_normal(mouse_pos) * RAY_LENGTH
	params.collision_mask = 1
	var space_state = get_world_3d().direct_space_state
	var selection = space_state.intersect_ray(params)
	return selection
	
func _input(event):
	if event is InputEventMouseMotion:
		var res = get_object_under_mouse()
		if res != null:
			if "collider" in res:
				if res["collider"].get_class() == "character":
					hovered_unit = res["collider"]
	var shift = Input.is_key_pressed(KEY_SHIFT)
	if event is InputEventMouseButton:
		
		if event.button_index == 1 and !event.is_pressed():
			var res = get_object_under_mouse()
			print(res)
		if event.button_index == 2 and !event.is_pressed():
			var res = get_object_under_mouse()
			if "collider" in res:
				if res["collider"].get_class() == "character":
					emit_signal("unit_right_clicked", res["collider"], shift)
				else:
					emit_signal("right_clicked", res["position"], shift)
					print("RIght")
				
	if event is InputEventKey and event.keycode == KEY_1:
		emit_signal("unit_selected", 0)
	if event is InputEventKey and event.keycode == KEY_2:
		emit_signal("unit_selected", 1)
	if event is InputEventKey and event.keycode == KEY_3:
		emit_signal("unit_selected", 2)
	if event is InputEventKey and event.keycode == KEY_4:
		emit_signal("unit_selected", 3)
	if event is InputEventKey and event.keycode == KEY_S:
		emit_signal("stop", shift)	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
