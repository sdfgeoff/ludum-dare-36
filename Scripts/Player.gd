extends RigidBody2D

const WALK_SPEED = 300

var last_frame_space = false;


#const MAXIMUM_VERTICAL_SPEED_FOR_JUMP = 100;
const JUMP_VERTICAL_IMPULSE = 800
const JUMP_COOLDOWN = 0.2
var jump_cooldown = 0.0

const MASS = 1.0

func _fixed_process(delta):
	
	#var space_rid = get_world_2d().get_space()
	#var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
	var walk_speed = 0
	
	if (Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A) ):
		walk_speed = - WALK_SPEED
	elif (Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D)):
		walk_speed =   WALK_SPEED
	
	
	var velocity = get_linear_velocity()
	var pos = get_pos()
	
	var walk_delta = walk_speed - velocity.x;
	if (velocity.x < WALK_SPEED and velocity.x > -WALK_SPEED):
		apply_impulse(Vector2(0,0), Vector2(walk_delta,0))
	
	var feet_touching = get_node("FootRaycast1").is_colliding() or get_node("FootRaycast2").is_colliding()
	
	if (jump_cooldown > 0.0): jump_cooldown -= delta
	
	if ( feet_touching and Input.is_key_pressed(KEY_SPACE)):
		apply_impulse(Vector2(0,0), Vector2(0,- (MASS * (JUMP_VERTICAL_IMPULSE + velocity.y)) ))
		jump_cooldown = JUMP_COOLDOWN
	
	set_rot(0.0)




func _ready():
	set_fixed_process(true)
	get_node("FootRaycast1").add_exception(self)
	get_node("FootRaycast2").add_exception(self)
	
	