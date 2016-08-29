


var backwards = false;
var last_backwards = false;

const MELEE_IDLE = 0
const MELEE_BACKSWING = 1
const MELEE_SWING = 2

const WEAPON_ANGLE_IDLE = PI
const WEAPON_ANGLE_BACKSWING = PI/2
const BACKSWING_DURATION = 0.5
const SWING_DURATION = 0.1

const DAMAGE = 10
const SCORE = 3


var state = MELEE_IDLE
var swing_angle = 0

var swing_damaging = false

onready var sprite = get_node("Sprite")

func _fixed_process(delta):
	
	if state == MELEE_BACKSWING:
		if swing_angle > WEAPON_ANGLE_BACKSWING:
			state = MELEE_SWING
			swing_damaging = true
		else:
			swing_angle += WEAPON_ANGLE_BACKSWING*(delta / BACKSWING_DURATION)
	if state == MELEE_SWING:
		
		if swing_damaging:
			var hit_ray = get_node("HitRaycast")
			if hit_ray.is_colliding():
				var body = hit_ray.get_collider()
				swing_damaging = false
				
				var rot
				var w_end = get_global_pos() + get_node("HitRaycast").get_cast_to().rotated( get_rot() )
				if backwards: rot = get_rot() + PI/2
				else: rot = get_rot() - PI/2
				
				body.damage(DAMAGE, w_end, rot)
			

		
		if swing_angle < 0:
			state = MELEE_IDLE
			swing_damaging = false
		else:
			swing_angle -= WEAPON_ANGLE_BACKSWING*(delta / SWING_DURATION)


func set_angle( alpha ):
	
	backwards = !(alpha < -(PI/2) or alpha > (PI/2))
	
	if backwards:
		set_rot(alpha + WEAPON_ANGLE_IDLE + swing_angle)
	else:
		set_rot(alpha + WEAPON_ANGLE_IDLE - swing_angle)
	
	if (backwards != last_backwards):
		sprite.set_flip_h( backwards )
		if backwards: sprite.set_rot(PI)
		else: sprite.set_rot(0)
		
		var new_cast = get_node("RangeRaycast").get_cast_to()
		new_cast.y *= -1
		get_node("RangeRaycast").set_cast_to( new_cast )
		
		new_cast = get_node("HitRaycast").get_cast_to()
		new_cast.y *= -1
		get_node("HitRaycast").set_cast_to( new_cast )
		
		
	last_backwards = backwards


func in_range():
	return get_node("RangeRaycast").is_colliding()


func attack():
	if state == MELEE_IDLE: state = MELEE_BACKSWING


func _ready():
	set_fixed_process(true)
	
	var glob = get_node("/root/glob")
	
	setup_ray("RangeRaycast", glob.player_layer)
	setup_ray("HitRaycast", glob.player_layer)



func setup_ray(name, mask):
	var ray = get_node(name)
	ray.set_layer_mask(mask)

