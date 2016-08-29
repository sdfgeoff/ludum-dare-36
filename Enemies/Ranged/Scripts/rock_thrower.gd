


var backwards = false;
var last_backwards = false;

const SCORE = 2

const COOLDOWN = 3.5

const angle_per_dist = 0.5 / 500

var cooldown = 0

var projectile = preload("res://Enemies/Projectiles/Rock.tscn")
var projectile_port = Vector2( -10, -20 )

const WEAPON_ANGLE_IDLE = PI
const WEAPON_SPRITE_ANGLE = 0

onready var sprite = get_node("Sprite")


func _fixed_process(delta):
	if (cooldown > 0):
		cooldown -= delta


func aim( target_pos ):
	
	var delta_pos = target_pos - get_global_pos()
	var alpha = atan2( -delta_pos.y, delta_pos.x )
	
	backwards = !(alpha < -(PI/2) or alpha > (PI/2))
	
	if backwards:
		alpha += delta_pos.length() * angle_per_dist
	else:
		alpha -= delta_pos.length() * angle_per_dist
	
	set_rot(alpha + WEAPON_ANGLE_IDLE)
	
	if (backwards != last_backwards):
		sprite.set_flip_h( backwards )
		if backwards: sprite.set_rot(PI + WEAPON_SPRITE_ANGLE)
		else: sprite.set_rot(-WEAPON_SPRITE_ANGLE)
		
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
		bullet.set_rot(get_rot()+PI)
		get_tree().get_root().add_child(bullet)
		


func _ready():
	set_fixed_process(true)
	
	var glob = get_node("/root/glob")
	
	setup_ray("RangeRaycast", glob.player_layer | glob.terrain_layer)


func setup_ray(name, mask):
	var ray = get_node(name)
	ray.set_layer_mask(mask)

