
# change these to change the look.
const MOUSE_LOOK_FACTOR = Vector2(0.3,0.5)

func _process(delta):
	var port = get_viewport()
	var mouse_delta = -((port.get_rect().size/2) - port.get_mouse_pos())
	
	set_pos( mouse_delta * MOUSE_LOOK_FACTOR)
	


func _ready():
	set_process(true)