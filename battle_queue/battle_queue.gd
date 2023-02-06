extends Node

var bqueue = []

var current_scene = null
var team = null
var weather_server = null

# Called when the node enters the scene tree for the first time.
func _ready():	
	weather_server = get_node("/root/WeatherServer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pop():
	return bqueue.pop_back()
	
func push(in_battle):
	bqueue.push_back(in_battle)

func next():
	if bqueue.size() > 0:
		weather_server.shuffle()
		if current_scene != null:
			current_scene.queue_free()
		current_scene = bqueue.pop_front().instantiate()
		add_child(current_scene)
		current_scene.load_in(team)
