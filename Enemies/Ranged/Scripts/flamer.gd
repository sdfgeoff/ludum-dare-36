


var backwards = false;
var last_backwards = false;

const SCORE = 10

const COOLDOWN = 0.2

var cooldown = 0

var projectile = preload("res://Player/Projectiles/MinigunBullet.tscn")
var projectile_port = Vector2( -10, 10 )

const WEAPON_ANGLE_IDLE = PI

onready var sprite = get_node("Sprite")


func _fixed_process(delta):
	if (cooldown > 0):
		cooldown -= delta


func set_angle( alpha ):
	backwards = !(alpha < -(PI/2) or alpha > (PI/2))
	
	set_rot(alpha + WEAPON_ANGLE_IDLE)
	
	if (backwards != last_backwards):
		sprite.set_flip_h( backwards )
		if backwards: sprite.set_rot(PI)
		else: sprite.set_rot(0)
		
		var new_cast = get_node("RangeRaycast").get_cast_to()
		new_cast.y *= -1
		get_node("RangeRaycast").set_cast_to( new_cast )
		
		projectile_port.y *= -1
		
		
	last_backwards = backwards


func in_range():
	var ray = get_node("RangeRaycast")
	if ray.is_colliding():
		if ray.get_collider() in get_tree().get_nodes_in_group("ai_target"):
			return true
	return false


func attack():
	
	if cooldown <= 0:
		cooldown = COOLDOWN
		
		var bullet = projectile.instance()
		
		bullet.set_global_pos( get_global_pos() + projectile_port.rotated(get_rot()))
		bullet.set_rot(get_rot())
		get_tree().get_root().add_child(bullet)
		


func _ready():
	set_fixed_process(true)
	
	var glob = get_node("/root/glob")
	
	setup_ray("RangeRaycast", glob.player_layer | glob.terrain_layer)


func setup_ray(name, mask):
	var ray = get_node(name)
	ray.set_layer_mask(mask)

