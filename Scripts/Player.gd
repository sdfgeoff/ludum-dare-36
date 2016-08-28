extends RigidBody2D

const WALK_SPEED = 300

#const MAXIMUM_VERTICAL_SPEED_FOR_JUMP = 100;
const JUMP_VERTICAL_IMPULSE = 800
const JUMP_COOLDOWN = 0.2
var jump_cooldown = 0.0

const MASS = 1.0

const DIR_LEFT = -1
const DIR_RIGHT = 1

var direction = 0;

func _fixed_process(delta):
	
	#var space_rid = get_world_2d().get_space()
	#var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
	var walk_speed = 0
	var walk_protection_ray = null;
	
	if (Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A) ):
		
		direction = DIR_LEFT
		walk_speed = -WALK_SPEED
		walk_protection_ray = get_node("LeftRaycast")
		
			
	elif (Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D)):
		
		direction = DIR_RIGHT
		walk_speed = WALK_SPEED
		walk_protection_ray = get_node("RightRaycast")
		
	
	if (walk_protection_ray != null):
		if (walk_protection_ray.is_colliding()):
			var collider = walk_protection_ray.get_collider() 
			var terrain_nodes = get_tree().get_nodes_in_group("terrain")
			if collider in terrain_nodes: walk_speed = 0
	
	
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
	
	get_node("Minigun").set_rot( get_node("Camera2D").target_angle )
	
	set_rot(0.0)



func _ready():
	set_fixed_process(true)
	get_node("FootRaycast1").add_exception(self)
	get_node("FootRaycast2").add_exception(self)
	get_node("LeftRaycast").add_exception(self)
	get_node("RightRaycast").add_exception(self)
	
	add_to_group("ai_target")
	
	