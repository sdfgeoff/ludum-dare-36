extends RigidBody2D

var sparks = preload("res://Assets/Sparks.tscn")


const SPEED = 1000.0
const DAMAGE = 10

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_max_contacts_reported(5)
	set_contact_monitor(true)
	var trans = get_global_transform()
	var facing_vec = trans.x
	set_linear_velocity(facing_vec * SPEED)



func _on_MinigunBullet_body_enter( body ):
	
	if (body in get_tree().get_nodes_in_group("enemies")):
		body.damage(DAMAGE)
	
	var new_sparks = sparks.instance()
	get_tree().get_root().add_child(new_sparks)
	new_sparks.set_global_transform(get_global_transform())
	queue_free()
	
