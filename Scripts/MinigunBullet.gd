
extends RigidBody2D

const SPEED = 1000.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_max_contacts_reported(5)
	set_contact_monitor(true)
	set_linear_velocity(Vector2(SPEED,0.0))



func _on_MinigunBullet_body_enter( body ):
	queue_free()
