extends VisibilityNotifier2D

const SPAWN_PROB = 0.001

var enemy = preload("res://Enemies/Bot.tscn")

func _fixed_process(delta):
	if not is_on_screen():
		if randf() < SPAWN_PROB:
			var new_enemy = enemy.instance()
			get_tree().get_root().add_child(new_enemy)
			new_enemy.set_global_transform(get_global_transform())


func _ready():
	set_fixed_process(true)