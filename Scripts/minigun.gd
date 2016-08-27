
const RELOAD_TIME = 0.2 # seconds

var bullet = preload("res://Assets/Projectiles/MinigunBullet.tscn")
var cool_down = 0

func _fixed_process(delta): 
	cool_down += delta
	fire_gun()
	
func fire_gun():
	if cool_down > RELOAD_TIME:
		add_child(bullet.instance())
		cool_down = 0

func _ready():
	add_child(bullet.instance())
	set_fixed_process(true)