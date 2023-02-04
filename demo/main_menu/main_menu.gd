extends CenterContainer

@onready var battle_queue = get_node("/root/BattleQueue")

# Called when the node enters the scene tree for the first time.
func _ready():
	$start_game.connect("pressed",Callable(self,"_start_game_pressed"))
	
func _start_game_pressed():
	battle_queue.next()
	
func load_in(in_team):
	pass

