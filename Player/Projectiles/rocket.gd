extends RigidBody2D


const SPEED = 100.0
const ACCELL = 1000

var speed = SPEED
var facing_vec

var kill_script = preload("res://Particles/ParticleDie.gd")
var explosion = preload("res://Player/Projectiles/RocketExplosion.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_max_contacts_reported(5)
	set_contact_monitor(true)
	var trans = get_global_transform()
	facing_vec = trans.x
	
	
	get_node("/root/glob").setup_player_projectile(self)
	
	set_fixed_process(true)
	connect("body_enter",self,"_on_MinigunBullet_body_enter")

func _fixed_process(delta):
	speed += ACCELL*delta
	
	set_linear_velocity(facing_vec.normalized() * speed)


func _on_MinigunBullet_body_enter( body ):
	
	#var new_sparks = sparks.instance()
	#get_tree().get_root().add_child(new_sparks)
	#new_sparks.set_global_transform(get_global_transform())
	
	var particles = get_node("Particles2D")
	remove_child(particles)
	particles.set_global_pos( get_global_pos() )
	get_tree().get_root().add_child(particles)
	particles.set_emitting(false)
	particles.set_script( kill_script )
	particles._ready()
	
	var expl = explosion.instance()
	expl.set_global_pos( get_global_pos() )
	get_tree().get_root().add_child(expl)
	
	queue_free()
	
