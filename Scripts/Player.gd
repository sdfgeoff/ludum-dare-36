extends RigidBody2D

const WALK_SPEED = 300

#const MAXIMUM_VERTICAL_SPEED_FOR_JUMP = 100;
const JUMP_VERTICAL_IMPULSE = 800
const JUMP_COOLDOWN = 0.2
var jump_cooldown = 0.0

const MASS = 1.0

const DIR_LEFT = -1
const DIR_RIGHT = 1

const RIGHT_ARM_POSITION = Vector2( -12, -15 )
const RIGHT_ARM_POSITION_BACKWARDS = Vector2( 14, -15 )

const LEFT_ARM_POSITION = Vector2( 10, -28 )
const LEFT_ARM_POSITION_BACKWARDS = Vector2( -10, -28 )


var direction = 0
var backwards = false

func _fixed_process(delta):
	
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
	

	var target_angle = get_node("Camera2D").target_angle
	backwards = target_angle < -(PI/2) or target_angle > (PI/2)
	get_node("Sprite").set_flip_h( backwards )
	
	var minigun_right = get_node("Arm Right")
	minigun_right.set_angle( target_angle )
	minigun_right.firing = Input.is_mouse_button_pressed(BUTTON_LEFT)
	
	var minigun_left = get_node("Arm Left")
	minigun_left.set_angle( target_angle )
	minigun_left.firing = Input.is_mouse_button_pressed(BUTTON_LEFT)
	
	if backwards:
		minigun_right.set_pos( RIGHT_ARM_POSITION_BACKWARDS )
		minigun_left.set_pos( LEFT_ARM_POSITION_BACKWARDS )
	else:
		minigun_right.set_pos( RIGHT_ARM_POSITION )
		minigun_left.set_pos( LEFT_ARM_POSITION )
	
	set_rot(0.0)



func _ready():
	set_fixed_process(true)
	var glob = get_node("/root/glob")
	glob.setup_player(self)
	
	setup_ray("FootRaycast1", glob.terrain_layer | glob.enemy_layer)
	setup_ray("FootRaycast2", glob.terrain_layer | glob.enemy_layer)
	setup_ray("LeftRaycast", glob.terrain_layer | glob.enemy_layer)
	setup_ray("RightRaycast", glob.terrain_layer | glob.enemy_layer)

func setup_ray(name, mask):
	var ray = get_node(name)
	ray.set_layer_mask(mask)
	ray.add_exception(self)

	