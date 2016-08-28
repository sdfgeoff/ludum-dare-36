
const RELOAD_TIME = 0.1 # seconds

var bullet = preload("res://Assets/Projectiles/MinigunBullet.tscn")
var cool_down = 0

var firing = false

func _fixed_process(delta): 
	cool_down += delta
	
	var port = get_viewport()
	
	if firing: fire_gun()

func fire_gun():
	if cool_down > RELOAD_TIME:
		
		var proj = bullet.instance()
		proj.set_rot(get_rot())
		proj.set_global_pos(get_global_pos())
		get_tree().get_root().add_child(proj)
		
		cool_down = 0

func _ready():
	set_fixed_process(true)