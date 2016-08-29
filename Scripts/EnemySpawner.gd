extends VisibilityNotifier2D

const SPAWN_PROB_RAMP = 0.0003

const BOT_MAX = 8

const SPAWN_RAMP_PERIOD = 120

var enemy = preload("res://Enemies/Bot.tscn")
var spawn_probability = 0.001
var timer = 0

var bot_count = 0


func _fixed_process(delta):
	if not is_on_screen() and bot_count < BOT_MAX:
		if randf() < spawn_probability:
			var new_enemy = enemy.instance()
			get_tree().get_root().add_child(new_enemy)
			new_enemy.set_global_transform(get_global_transform())
			new_enemy.get_node("Bot").set_spawner(self)
			bot_count += 1
	
	timer += delta
	if timer > SPAWN_RAMP_PERIOD:
		spawn_probability += SPAWN_PROB_RAMP


func _ready():
	set_fixed_process(true)