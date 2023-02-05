extends Node

var bqueue = []

var current_scene = null
var team = null

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pop():
	return bqueue.pop_back()
	
func push(in_battle):
	bqueue.push_back(in_battle)

func next():
	if bqueue.size() > 0:
		if current_scene != null:
			current_scene.queue_free()
		current_scene = bqueue.pop_front().instantiate()
		add_child(current_scene)
		current_scene.load_in(team)
