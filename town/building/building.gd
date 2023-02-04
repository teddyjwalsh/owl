extends StaticBody3D
	
var rng = RandomNumberGenerator.new()
var units = {}
var units_enter_time = {}

var gym_scene = preload("res://models/gym.glb")
var firing_range_scene = preload("res://models/firing_range.glb")
var bar_scene = preload("res://models/bar.glb")
var building_mat = preload("res://town/building/building.tres")

var building_types = ["Gym","Firing Range","Bar"]
var stat_dict = {"Gym": {"strength": 0.01, "agility": 0.01, "stamina": 0.01}, \
		"Firing Range":{"aim": 0.01, "patience": 0.01, "dexterity": 0.01}, \
		"University":{"intelligence": 0.01, "patience": 0.01, "pride": -0.01}, \
		"Blacksmith":{"dexterity": 0.01, "strength": 0.01, "stamina": 0.01}, \
		"Bar": {"friendliness": 0.01, "anxiety": -0.01}
		}
var earning_rate = 0
var synergy_rate = 0.001
var t = 0
var building_type = "Firing Range"
var mesh_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	building_type = building_types[rng.randi_range(0,building_types.size()-1)]
	if building_type == "Gym":
		var gym = gym_scene.instantiate()
		#gym.get_node("lettering").set_surface_override_material(0,building_mat)
		gym.scale = Vector3(0.6,0.6,0.6)
		add_child(gym)
		$Area3D.connect("body_entered",Callable(self,"_door_entered"))
		$Area3D.global_transform.origin = gym.get_node("door").global_transform.origin
		mesh_node = gym
	elif building_type == "Firing Range":
		var firing_range = firing_range_scene.instantiate()
		firing_range.scale = Vector3(0.6,0.6,0.6)
		add_child(firing_range)
		$Area3D.connect("body_entered",Callable(self,"_door_entered"))
		$Area3D.global_transform.origin = firing_range.get_node("door").global_transform.origin
		mesh_node = firing_range
	elif building_type == "Bar":
		var bar = bar_scene.instantiate()
		bar.scale = Vector3(0.6,0.6,0.6)
		add_child(bar)
		$Area3D.connect("body_entered",Callable(self,"_door_entered"))
		$Area3D.global_transform.origin = bar.get_node("door").global_transform.origin
		mesh_node = bar
	var lamp = mesh_node.get_node("lamp")
	if lamp != null:
		var lamp_spot = lamp.global_transform.origin
		var new_lamp = OmniLight3D.new()
		add_child(new_lamp)
		new_lamp.omni_range = 10
		new_lamp.shadow_enabled = true
		new_lamp.light_color = Color(1,0.8,0.6)
		new_lamp.light_energy = 1
		new_lamp.global_transform.origin = lamp_spot - Vector3(0,0.2,0)
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	var to_remove = []
	for unit in units:
		units[unit].team.money += earning_rate*delta
		if t - units_enter_time[units[unit].get_instance_id()] > 5.0:
			if units[unit].controller.state != "IDLE" and units[unit].controller.state != "COOLDOWN":
				to_remove.append(unit)
	for tr in to_remove:
		units[tr].visible = true
		units.erase(tr)
	for unit1 in units:
		for unit2 in units:
			if unit2 != unit1:
				if units[unit2] not in units[unit1].traits.synergy:
					units[unit1].traits.synergy[units[unit2]] = 1.0
				units[unit1].traits.synergy[units[unit2]] += synergy_rate*delta
		for stat in stat_dict[building_type]:
			var learning_rate = 0.01
			var learning_coeff = units[unit1].traits.get_learning_coefficient()
			for unit2 in units:
				if unit2 != unit1:
					if units[unit2].traits.get(stat) > units[unit1].traits.get(stat):
						var diff = units[unit2].traits.get(stat) - units[unit1].traits.get(stat)
						var teaching_coeff = units[unit2].traits.get_teaching_coefficient()
						var synergy = units[unit1].traits.synergy[units[unit2]]
						learning_rate *= synergy*teaching_coeff*(1 + diff)
			units[unit1].traits.learn(delta*learning_coeff*learning_rate, stat)
		print(units[unit1].full_name + " ",units[unit1].traits.agility," ", units[unit1].traits.get_learning_coefficient())

func get_move_to():
	return mesh_node.get_node("door").global_transform.origin
	
func get_class():
	return "building"
	
func _door_entered(body):
	if body.get_class() == "character" and t > 2:
		units[body.get_instance_id()] = body
		body.visible = false
		units_enter_time[body.get_instance_id()] = t
