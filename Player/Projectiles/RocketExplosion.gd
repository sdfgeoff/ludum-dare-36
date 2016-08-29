extends Area2D

const THRESHOLD = 0.3

const KNOCKBACK = 2000
const DAMAGE = 150
var area = 0

var age = 0

var exploded = false

var frame = 0

func _fixed_process(delta):
	age += delta
	if age > self.get_node("Particles2D").get_lifetime() - THRESHOLD:
		queue_free()
	
	frame += 1
	
	if !exploded and frame >= 2:
		exploded = true
		
		var players = get_tree().get_nodes_in_group("ai_target")
		var bots = get_tree().get_nodes_in_group("enemies")
		
		var pos = get_global_pos()
		
		var items = get_overlapping_bodies()
		for unit in items:
			
			var delta_pos = unit.get_global_pos() - pos
			var magnitude = (area - delta_pos.length())/area
			
			if unit in players:
				unit.damage(DAMAGE*magnitude)
			elif unit in bots:
				unit.damage(DAMAGE*magnitude)
			
			if not unit.is_type("TileMap"):
				unit.apply_impulse( Vector2(), KNOCKBACK * delta_pos.normalized() * magnitude )
			

func _ready():
	set_fixed_process(true)
	set_z( -1 )
	
	area = get_node("Node2D").get_scale().x*10
	
	var glob = get_node("/root/glob")
	
	