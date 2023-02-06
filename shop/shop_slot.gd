extends Button

var item_slot = null
var price = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item_slot != null:
		text = item_slot.weapon_name + "\n" + str(price) + " GOLD"
	else:
		text = ""

func _purchase(in_team):
	if in_team.money >= price:
		in_team.money -= price
		#in_team.add_child(item_slot)
		#get_parent().remove_child(item_slot)
		in_team.inventory.append(item_slot)
		item_slot = null
