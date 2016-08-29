
extends RigidBody2D

const HEALING = 200


var spawner = null
var splash = preload("res://Particles/Healing.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_max_contacts_reported(5)
	set_contact_monitor(true)
	
	connect("body_enter",self,"_on_MinigunBullet_body_enter")

	get_node("/root/glob").setup_terrain(self)
	


func _on_MinigunBullet_body_enter( body ):
	
	if (body in get_tree().get_nodes_in_group("ai_target")):
		if body.hp < body.HEALTH_MAXIMUM:
			body.heal(HEALING)
			queue_free()
			
			var p = splash.instance()
			p.set_pos(get_pos())
			get_tree().get_root().add_child(p)
			
			if spawner != null:
				spawner.notify()
