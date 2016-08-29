extends VisibilityNotifier2D



var medkit = preload("res://Map/Physics Objects/Medkit.tscn")


const LIVE_ITEM_COUNT = 1


func notify():
	var spawners = get_tree().get_nodes_in_group("item_spawn")
	var count = spawners.size()
	
	var index = int(floor(randf()*count))
	var spawn = spawners[index]
	if spawn == self:
		index = (index + 1)%count
		spawn = spawners[index]
	
	spawn.spawn_item()
	
	


func spawn_item():
	var item = medkit.instance()
	get_tree().get_root().call_deferred("add_child",item)
	item.set_global_transform(get_global_transform())

func _ready():
	add_to_group( "item_spawn" )
	
	var glob = get_node("/root/glob")
	
	if glob.item_spawns_live < LIVE_ITEM_COUNT:
		glob.item_spawns_live += 1
		notify()