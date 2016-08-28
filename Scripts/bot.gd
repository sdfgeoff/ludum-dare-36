extends RigidBody2D

const WALK_SPEED = 150

#const MAXIMUM_VERTICAL_SPEED_FOR_JUMP = 100;
const JUMP_VERTICAL_IMPULSE = 600
const JUMP_COOLDOWN = 0.2
var jump_cooldown = 0.0

const MASS = 1.0


const DIR_LEFT = -1
const DIR_RIGHT = 1

const DIR_CHANGE_TOLERANCE = 30

var direction = DIR_RIGHT

var hp = 100;

func _fixed_process(delta):
	
	#var space_rid = get_world_2d().get_space()
	#var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
	var walk_speed = 0
	var jumping = false
	direction = 0
	
	
	var targets = get_tree().get_nodes_in_group("ai_target")
	if (targets.size() != 0):
		var target = targets[0]
		
		
		var delta_position = target.get_global_pos().x - get_global_pos().x
		if delta_position > DIR_CHANGE_TOLERANCE:
			direction = DIR_RIGHT
			jumping = get_node("RightRaycast").is_colliding()
		elif delta_position < -DIR_CHANGE_TOLERANCE:
			direction = DIR_LEFT
			jumping = get_node("LeftRaycast").is_colliding()
		
		if not jumping:
			walk_speed = direction * WALK_SPEED
	
		
	else:
		walk_speed = 0
	
	
	var velocity = get_linear_velocity()
	var pos = get_pos()
	
	var walk_delta = walk_speed - velocity.x;
	if (velocity.x < WALK_SPEED and velocity.x > -WALK_SPEED):
		apply_impulse(Vector2(0,0), Vector2(walk_delta,0))
	
	var feet_touching = get_node("FootRaycast1").is_colliding() or get_node("FootRaycast2").is_colliding()
	
	if (jump_cooldown > 0.0): jump_cooldown -= delta
	
	if ( feet_touching and jumping):
		apply_impulse(Vector2(0,0), Vector2(0,- (MASS * (JUMP_VERTICAL_IMPULSE + velocity.y)) ))
		jump_cooldown = JUMP_COOLDOWN
	
	set_rot(0.0)

func damage(dmg):
	hp -= dmg
	if (hp < 0):
		queue_free()


func _ready():
	set_fixed_process(true)
	
	get_node("/root/glob").setup_enemy(self)
	
	
	get_node("FootRaycast1").add_exception(self)
	get_node("FootRaycast2").add_exception(self)
	get_node("LeftRaycast").add_exception(self)
	get_node("RightRaycast").add_exception(self)
	
	
