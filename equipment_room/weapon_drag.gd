extends RichTextLabel

var clicked = false
var hovered = false
signal click_sig(out_data)
signal release_sig()
var data = null


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(connect("mouse_entered", _mouse_enter) == OK)
	assert(connect("mouse_exited", _mouse_exit) == OK)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				if hovered == true:
					clicked = true
					emit_signal("click_sig", data)
			else:
				if clicked:
					emit_signal("release_sig")					
				clicked = false
	
func _mouse_enter():
	hovered = true
	
func _mouse_exit():
	hovered = false
