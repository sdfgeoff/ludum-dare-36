extends RigidBody2D

const WALK_SPEED = 150

const JUMP_VERTICAL_IMPULSE = 600
const JUMP_COOLDOWN = 0.2
var jump_cooldown = 0.0

const MASS = 1.0


const DIR_LEFT = -1
const DIR_RIGHT = 1

const DIR_CHANGE_TOLERANCE = 30

var direction = DIR_RIGHT

var hp = 100;
var blood = preload("res://Assets/BloodSplat.tscn")


var backwards = false
var backwards_last = true
var anim_walk = false
var anim_walk_last = true

func _fixed_process(delta):
	
	#var space_rid = get_world_2d().get_space()
	#var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
	var walk_speed = 0
	var jumping = false
	direction = 0
	
	
	var feet_touching = get_node("FootRaycast1").is_colliding() or get_node("FootRaycast2").is_colliding()
	
	
	var targets = get_tree().get_nodes_in_group("ai_target")
	if (targets.size() != 0):
		var target = targets[0]
		
		var delta_position = target.get_global_pos().x - get_global_pos().x
		if delta_position > DIR_CHANGE_TOLERANCE:
			backwards = false
			direction = DIR_RIGHT
			jumping = get_node("RightRaycast").is_colliding()
		elif delta_position < -DIR_CHANGE_TOLERANCE:
			backwards = true
			direction = DIR_LEFT
			jumping = get_node("LeftRaycast").is_colliding()
		
		if not jumping:
			walk_speed = direction * WALK_SPEED
			if feet_touching: set_rot(0.0)
	
	var velocity = get_linear_velocity()
	var pos = get_pos()
	
	var walk_delta = walk_speed - velocity.x;
	if (velocity.x < WALK_SPEED and velocity.x > -WALK_SPEED):
		apply_impulse(Vector2(0,0), Vector2(walk_delta,0))
	
	var sprite = get_node("Sprite")
	anim_walk = (walk_speed != 0) and feet_touching
	
	if (anim_walk != anim_walk_last):
		if (anim_walk):
			sprite.play()
		else: sprite.stop()
	
	if backwards != backwards_last:
		sprite.set_flip_h( direction == DIR_RIGHT )
		get_node("Weapon").get_node("Sprite").set_flip_h( direction == DIR_RIGHT )
	
	
	if (jump_cooldown > 0.0): jump_cooldown -= delta
	
	if ( feet_touching and jumping):
		apply_impulse(Vector2(0,0), Vector2(0,- (MASS * (JUMP_VERTICAL_IMPULSE + velocity.y)) ))
		jump_cooldown = JUMP_COOLDOWN
		
	backwards_last = backwards
	anim_walk_last = anim_walk

func damage(dmg):
	hp -= dmg
	if (hp < 0):
		spawn_blood()
		queue_free()


func spawn_blood():
	var new_blood = blood.instance()
	get_tree().get_root().add_child(new_blood)
	new_blood.set_global_transform(get_global_transform())

func _ready():
	set_fixed_process(true)
	
	var glob = get_node("/root/glob")
	glob.setup_enemy(self)
	
	setup_ray("FootRaycast1", glob.terrain_layer | glob.enemy_layer | glob.player_layer)
	setup_ray("FootRaycast2", glob.terrain_layer | glob.enemy_layer | glob.player_layer)
	setup_ray("LeftRaycast", glob.terrain_layer | glob.enemy_layer)
	setup_ray("RightRaycast", glob.terrain_layer | glob.enemy_layer)


func setup_ray(name, mask):
	var ray = get_node(name)
	ray.set_layer_mask(mask)
	ray.add_exception(self)
	get_node("Sprite").play("Walk Forwards")

