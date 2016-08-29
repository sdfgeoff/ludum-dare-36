

const RELOAD_TIME = 0.1 # seconds

const bullet_offset = Vector2( 50, 10 )
const bullet_offset_backwards = Vector2( 50, -10 )


var cool_down = RELOAD_TIME

var firing = false

var backwards = false;

func _fixed_process(delta): 
	if cool_down > 0: cool_down -= delta


func set_angle( alpha ):
	
	backwards = alpha < -(PI/2) or alpha > (PI/2)
	
	if backwards:
		set_rot(alpha - PI)
	else:
		set_rot(alpha)
	
	get_node("Sprite").set_flip_h( backwards )
	
	
	

func attack():
	if cool_down < 0:
		
		cool_down = RELOAD_TIME

func _ready():
	set_fixed_process(true)

