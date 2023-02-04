extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var last_clicked = null
var RAY_LENGTH = 400
var hovered_unit = null

var selecting = false
var select_start_pos = null
var time_selecting = null
var select_bodies = []
var select_moved = false

var dragging = false 
var drag_start_pos = null
var drag_target = null
var time_dragging = null
var drag_moved = false

signal clicked_char(chr)
signal right_clicked(pos, queue)
signal unit_right_clicked(target, queue)
signal unit_selected(unit_num)
signal unit_hovered(unit)
signal non_unit_hovered(unit)
signal stop(unit_num)
signal drag_target_sig(move_pos, target)
signal boxed_characters(units)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func click(in_node):
	last_clicked = in_node
	emit_signal("clicked_char", last_clicked)
	
# cast a ray from camera at mouse position, and get the object colliding with the ray
func get_ground_under_mouse():
	if get_viewport().get_camera_3d() == null:
		return {}
	var mouse_pos = get_viewport().get_mouse_position()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	params.to = params.from + get_viewport().get_camera_3d().project_ray_normal(mouse_pos) * RAY_LENGTH
	params.collision_mask = 2
	var space_state = get_world_3d().direct_space_state
	var selection = space_state.intersect_ray(params)
	return selection
	
# cast a ray from camera at mouse position, and get the object colliding with the ray
func get_object_under_mouse():
	if get_viewport().get_camera_3d() == null:
		return {}
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
		if selecting:
			#$select_box_area/CollisionShape3D.disabled = false
			$select_box.visible = true
			$select_box.set_point_position(0,select_start_pos)
			$select_box.set_point_position(1,Vector2(select_start_pos.x, event.position.y))
			$select_box.set_point_position(2,event.position)
			$select_box.set_point_position(3,Vector2(event.position.x, select_start_pos.y))
			$select_box.set_point_position(4,select_start_pos)
			$select_box_area.construct_from_screen_coords([select_start_pos, event.position])
			select_moved = true
			select_bodies = $select_box_area.get_overlapping_bodies()
		elif dragging:
			$drag_attack.start_point = drag_start_pos + Vector3(0,0.1,0)
			var res = get_object_under_mouse()
			if "collider" in res:
				if res["collider"].get_class() == "character":
					$drag_attack.end_point = res["collider"].global_transform.origin + Vector3(0,0.1,0)
					emit_signal("unit_hovered", res["collider"])
					drag_target = res["collider"]
				else:
					$drag_attack.end_point = res["position"] + Vector3(0,0.1,0)
					drag_target = null
			else:
				$drag_attack.end_point = null
				drag_target = null
			drag_moved = true
		else:
			var res = get_object_under_mouse()
			var unit_is_hovered = false
			if res != null:
				if "collider" in res:
					if res["collider"].get_class() == "character":
						hovered_unit = res["collider"]
						emit_signal("unit_hovered", hovered_unit)
						unit_is_hovered = true
					else:
						emit_signal("non_unit_hovered", res["collider"])
	var shift = Input.is_key_pressed(KEY_SHIFT)
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			var res = get_object_under_mouse()
			if "collider" in res:
				if res["collider"].get_class() == "character":
					emit_signal("unit_right_clicked", res["collider"], shift)
			time_selecting = 0
			selecting = true
			select_start_pos = event.position
			select_moved = false
		if event.button_index == 1 and !event.is_pressed():
			if select_moved:
				var selectable_bodies = []			
				for body in select_bodies:
					if body.get_class() == "character":
						selectable_bodies.append(body)
				if selectable_bodies.size():
					emit_signal("boxed_characters", selectable_bodies)					
			selecting = false
			time_selecting = null
			$select_box.visible = false
			#$select_box_area/CollisionShape3D.disabled = true
		if event.button_index == 2 and event.is_pressed():
			dragging = true
			time_dragging = 0
			drag_moved = false
			var res = get_ground_under_mouse()
			if "collider" in res:
				drag_start_pos = res["position"]
			else:
				drag_start_pos = null
		if event.button_index == 2 and !event.is_pressed():
			var res = get_ground_under_mouse()
			if dragging and drag_target != null:
				emit_signal("drag_target_sig", drag_start_pos, drag_target, shift)
			elif "collider" in res and time_dragging < 0.2:
				if res["collider"].get_class() == "building":
					emit_signal("unit_right_clicked", res["collider"], shift)
				else:
					emit_signal("right_clicked", res["position"], shift)
			dragging = false
			$drag_attack.start_point = null
			drag_target = null
			time_dragging = null

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
func _process(delta):
	if time_dragging != null and drag_moved:
		time_dragging += delta
	if time_selecting != null and select_moved:
		time_selecting += delta
	if !selecting:
		$select_box.visible = false
