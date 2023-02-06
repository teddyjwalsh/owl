extends Node

var weather = "rain"
var temperature = 72
var types = ["rain", "sunny", "snow"]
var means = [60,80,20]
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shuffle():
	var rand_ind = rng.randi_range(0,types.size()-1)
	weather = types[rand_ind]
	temperature = rng.randfn(means[rand_ind], 20)
