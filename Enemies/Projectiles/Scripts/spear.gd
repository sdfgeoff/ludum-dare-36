extends RigidBody2D


const SPEED = 500.0
const DAMAGE = 6


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_max_contacts_reported(5)
	set_contact_monitor(true)
	var trans = get_global_transform()
	var facing_vec = trans.x
	facing_vec.x += randf()*0.15 - 0.075
	facing_vec.y += randf()*0.15 - 0.075
	set_linear_velocity(facing_vec.normalized() * SPEED)
	
	get_node("/root/glob").setup_enemy_projectile(self)
	set_process(true)
	
	set_angular_velocity(15)
	set_fixed_process(true)

func _fixed_process(delta):
	
	var vel = get_linear_velocity()
	var angle = atan2(vel.x, vel.y) - PI/2
	set_rot( angle )



func _on_MinigunBullet_body_enter( body ):
	
	if (body in get_tree().get_nodes_in_group("ai_target")):
		
		var vel = get_linear_velocity()
		var angle = atan2(vel.x, vel.y) + PI
		
		body.damage(DAMAGE, get_global_pos(), angle)
	
	queue_free()
	
