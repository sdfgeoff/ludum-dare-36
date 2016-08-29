





var backwards = false;

const MELEE_IDLE = 0
const MELEE_BACKSWING = 1
const MELEE_SWING = 2

const WEAPON_ANGLE_IDLE = PI
const WEAPON_ANGLE_BACKSWING = PI/2
const BACKSWING_DURATION = 0.5
const SWING_DURATION = 0.1

var state = MELEE_IDLE
var swing_angle = 0

onready var sprite = get_node("Sprite")

func _fixed_process(delta):
	
	if state == MELEE_BACKSWING:
		if swing_angle > WEAPON_ANGLE_BACKSWING:
			state = MELEE_SWING
		else:
			swing_angle += WEAPON_ANGLE_BACKSWING*(delta / BACKSWING_DURATION)
	if state == MELEE_SWING:
		if swing_angle < 0:
			state = MELEE_IDLE
		else:
			swing_angle -= WEAPON_ANGLE_BACKSWING*(delta / SWING_DURATION)


func set_angle( alpha ):
	
	backwards = !(alpha < -(PI/2) or alpha > (PI/2))
	
	if backwards:
		sprite.set_rot(alpha - PI + WEAPON_ANGLE_IDLE + swing_angle)
	else:
		sprite.set_rot(alpha + WEAPON_ANGLE_IDLE - swing_angle)
	
	
	sprite.set_flip_h( backwards )
	
	
	

func attack():
	
	if state == MELEE_IDLE: state = MELEE_BACKSWING


func _ready():
	set_fixed_process(true)

