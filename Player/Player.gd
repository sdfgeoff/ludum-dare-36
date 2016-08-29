extends RigidBody2D

onready var glob = get_node("/root/glob")
onready var hud = get_node("/root/Game/HUD")


var damage_particles = preload("res://Particles/PlayerDamage.tscn")

const HEALTH_MAXIMUM = 1000
const WALK_SPEED = 300
const WALK_IMPULSE = 100

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

var hp = HEALTH_MAXIMUM
var direction = 0
var direction_last = 0
var backwards = false
var backwards_last = true # this causes it to flip first frame is mouse in wrong side.
var anim_current = 1


var dead = false

func do_animation( ):
	
	var sprite = get_node("Sprite")
	var frame = sprite.get_frame()
	
	if (backwards != backwards_last):
		sprite.set_flip_h( backwards )
	
	var facing = 1
	if (backwards): facing = -1
	
	if (direction == 0 and direction_last != 0):
		sprite.stop()
	elif (direction != direction_last):
		if (direction == anim_current):
			sprite.play()
		elif (direction == facing):
			sprite.play("Fwd")
			sprite.set_frame( (frame+1)%6 )
		else:
			sprite.play("Back")
			sprite.set_frame( (frame-1)%6 )
		anim_current = direction

func _fixed_process(delta):
	
	if (dead): return
	
	var walk_speed = 0
	var walk_protection_ray = null;
	
	# use keys to set motion
	
	if Input.is_action_pressed("move_left"):	
		direction = DIR_LEFT
		walk_speed = -WALK_SPEED
		walk_protection_ray = get_node("LeftRaycast")
	
	elif Input.is_action_pressed("move_right"):
		direction = DIR_RIGHT
		walk_speed = WALK_SPEED
		walk_protection_ray = get_node("RightRaycast")
	
	# dont walk if a wall contacts the wall ray
	if (walk_protection_ray != null):
		if (walk_protection_ray.is_colliding()):
			var collider = walk_protection_ray.get_collider() 
			var terrain_nodes = get_tree().get_nodes_in_group("terrain")
			if collider in terrain_nodes: walk_speed = 0
	
	
	var velocity = get_linear_velocity()
	var pos = get_pos()
	var target_angle = get_node("Camera2D").target_angle
	
	
	var feet_touching = get_node("FootRaycast1").is_colliding() or get_node("FootRaycast2").is_colliding()
	
	backwards = target_angle < -(PI/2) or target_angle > (PI/2)
	
	
	# using an impusle to walk
	var walk_delta = walk_speed - velocity.x;
	if walk_delta > WALK_IMPULSE: walk_delta = WALK_IMPULSE
	elif walk_delta < -WALK_IMPULSE: walk_delta = -WALK_IMPULSE
	apply_impulse(Vector2(0,0), Vector2(walk_delta,0))
	if (!feet_touching or walk_speed == 0):
		direction = 0
	
	do_animation()
	
	# jumping
	if (jump_cooldown > 0.0): jump_cooldown -= delta
	if ( feet_touching and Input.is_action_pressed("jump")):
		apply_impulse(Vector2(0,0), Vector2(0,- (MASS * (JUMP_VERTICAL_IMPULSE + velocity.y)) ))
		jump_cooldown = JUMP_COOLDOWN
	
	
	# targeting and firing the miniguns
	var minigun_right = get_node("Arm Right")
	minigun_right.set_angle( target_angle )
	minigun_right.firing = Input.is_action_pressed("weapon_primary")
	
	var minigun_left = get_node("Arm Left")
	minigun_left.set_angle( target_angle )
	minigun_left.firing = Input.is_action_pressed("weapon_primary")
	
	# fixing the position of the minigun
	if backwards != backwards_last:
		if backwards:
			minigun_right.set_pos( RIGHT_ARM_POSITION_BACKWARDS )
			minigun_left.set_pos( LEFT_ARM_POSITION_BACKWARDS )
		else:
			minigun_right.set_pos( RIGHT_ARM_POSITION )
			minigun_left.set_pos( LEFT_ARM_POSITION )
	
	set_rot(0.0)
	
	backwards_last = backwards
	direction_last = direction



func _ready():
	set_fixed_process(true)
	glob.setup_player(self)
	
	setup_ray("FootRaycast1", glob.terrain_layer | glob.enemy_layer)
	setup_ray("FootRaycast2", glob.terrain_layer | glob.enemy_layer)
	setup_ray("LeftRaycast", glob.terrain_layer | glob.enemy_layer)
	setup_ray("RightRaycast", glob.terrain_layer | glob.enemy_layer)
	
	hud.set_health_max(HEALTH_MAXIMUM)


func setup_ray(name, mask):
	var ray = get_node(name)
	ray.set_layer_mask(mask)
	ray.add_exception(self)

func damage(dmg, pos = null, angle = 0):
	if (!dead):
		
		if pos != null:
			var sparks = damage_particles.instance()
			sparks.set_global_pos( pos )
			sparks.set_rot(angle)
			get_tree().get_root().add_child(sparks)
		
		hp -= dmg
		hud.set_health(hp)
		if (hp < 0):
			dead = true
			hp = 0

func add_score(score):
	glob.add_score(score)

func add_score_multiplier(delta_multiplier):
	glob.add_score_multiplier(delta_multiplier)