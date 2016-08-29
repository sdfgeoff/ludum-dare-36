
# change these to change the look.
const MOUSE_LOOK_FACTOR = Vector2(0.25,0.25)

var target_angle = 0.0

onready var health_bar = get_node("../Health Bar")
onready var health_bar_offset = health_bar.get_pos()

func _process(delta):
	var port = get_viewport()
	
	var mouse_delta = -((port.get_rect().size/2) - port.get_mouse_pos())
	target_angle = atan2( -mouse_delta.y, mouse_delta.x )
	
	var screen_delta = mouse_delta * MOUSE_LOOK_FACTOR
	
	set_pos( screen_delta )
	
	


func _fixed_process(delta):
	health_bar.set_pos(health_bar_offset + get_pos())


func _ready():
	set_process(true)
	set_fixed_process(true)