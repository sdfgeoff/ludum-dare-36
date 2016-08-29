
const RELOAD_TIME = 0.1 # seconds

const bullet_offset = Vector2( 70, 10 )
const bullet_offset_backwards = Vector2( 70, -10 )


var bullet = preload("res://Player/Projectiles/MinigunBullet.tscn")
var cool_down = 0


var firing = false

var backwards = false;

func _fixed_process(delta): 
	cool_down += delta
	
	var port = get_viewport()
	
	if firing: fire_gun()

func set_angle( alpha ):
	
	backwards = alpha < -(PI/2) or alpha > (PI/2)
	
	if backwards:
		set_rot(alpha - PI)
	else:
		set_rot(alpha)
	
	#var sprite = get_node("Sprite")
	set_flip_h( backwards )
	#set_flip_v( backwards )
	
	
	

func fire_gun():
	if cool_down > RELOAD_TIME:
		
		var proj = bullet.instance()
		var angle = get_rot()
		
		if backwards:
			proj.set_global_pos( get_global_pos() - bullet_offset_backwards.rotated(angle) )
			angle -= PI
		else:
			proj.set_global_pos( get_global_pos() + bullet_offset.rotated(angle) )
		proj.set_rot(angle)
		
		get_tree().get_root().add_child(proj)
		
		cool_down = 0

func _ready():
	set_fixed_process(true)