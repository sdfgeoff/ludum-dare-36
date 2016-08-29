extends RigidBody2D


const SPEED = 300.0
const DAMAGE = 8
const LIFE = 1.5

var FRAME_COUNT = 8

var frame = 0
var life = 0


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


func _process(delta):
	
	life += delta
	if life > LIFE:
		queue_free()
		
	else:
		var new_frame = int((life/LIFE)*FRAME_COUNT)
		if new_frame > frame:
			get_node("Sprite").set_frame(new_frame)
			frame = new_frame




func _on_MinigunBullet_body_enter( body ):
	
	if (body in get_tree().get_nodes_in_group("ai_target")):
		body.damage(DAMAGE)
	
	queue_free()
	
