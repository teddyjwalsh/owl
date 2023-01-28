extends CenterContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	$start_game.connect("pressed",Callable(self,"_start_game_pressed"))
	
func _start_game_pressed():
	get_parent().generate_demo_team()
	queue_free()

