extends Node2D

var terrain_layer = 1
var projectile_layer = 16
var enemy_layer = 8
var player_layer = 4

var toggle_state_pause = false
var button_state_pause = false
var toggle_state_fullscreen = false
var toggle_time_fullscreen = int(0)

onready var pause_popup = get_node("/root/Game/HUD/Pause Popup")

var score = 0
var score_multiplier = 1
var score_total = 0

onready var hud_score = get_node("/root/Game/HUD/Score")
onready var hud_white_border = get_node("/root/Game/HUD/White Border")
onready var white_overlay = get_node("/root/Game/White Overlay")

var cooldown_time_rift = int()
var toggle_time_rift = int()

var weapon_club = preload( "res://Enemies/Melee/Club.tscn" )
var weapon_axe = preload( "res://Enemies/Melee/Axe.tscn" )
var weapon_sword = preload( "res://Enemies/Melee/Sword.tscn" )
var weapon_samurai = preload( "res://Enemies/Melee/Samurai.tscn" )
var weapon_flamer = preload( "res://Enemies/Ranged/Flamer.tscn" )
var weapon_lasersword = preload( "res://Enemies/Melee/LaserSword.tscn" )

var weapons_melee = [weapon_club,weapon_axe,weapon_sword,weapon_samurai,weapon_flamer,weapon_lasersword]

var weapon_rockthrowers = preload( "res://Enemies/Ranged/RockThrower.tscn" )


const EPOCH_COUNT = 6
var epoch = 0
var active_weapons = [weapons_melee[epoch]]
var weapons_set = false


func _ready():
	set_pause_mode(2)
	set_process(true)
	update_score()
	
	hud_white_border.set_modulate(Color(1.0,1.0,1.0,0))
	white_overlay.set_modulate(Color(1.0,1.0,1.0,0))

func setup_player_projectile(obj):
	obj.set_collision_mask( terrain_layer | enemy_layer )
	obj.set_layer_mask( projectile_layer )
	pass

func setup_enemy_projectile(obj):
	obj.set_collision_mask( terrain_layer | player_layer )
	obj.set_layer_mask( projectile_layer )
	pass

func setup_player(obj):
	obj.set_collision_mask( terrain_layer | enemy_layer )
	obj.set_layer_mask( player_layer )
	obj.add_to_group("ai_target")

func setup_enemy(obj):
	obj.set_collision_mask( terrain_layer | enemy_layer | player_layer )
	obj.set_layer_mask( enemy_layer )
	obj.add_to_group("enemies")

func setup_terrain(obj):
	#obj.set_collision_mask( enemy_layer | player_layer | projectile_layer )
	#obj.set_layer_mask( terrain_layer )
	obj.add_to_group("terrain")

func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_pressed("toggle_pause"):
		if !button_state_pause:
			button_state_pause = true
			toggle_state_pause = not(toggle_state_pause)
			get_tree().set_pause(toggle_state_pause)
			if toggle_state_pause:
				pause_popup.show()
			else:
				pause_popup.hide()
	else:
		button_state_pause = false
		
	if Input.is_action_pressed("toggle_fullscreen"):
		if (OS.get_ticks_msec() - toggle_time_fullscreen) > (2000):
			toggle_time_fullscreen = OS.get_ticks_msec()
			toggle_state_fullscreen = not(toggle_state_fullscreen)
			OS.set_window_fullscreen(toggle_state_fullscreen)
	
	var time_to_rift_shift = cooldown_time_rift - (OS.get_ticks_msec() - toggle_time_rift)
	rift_shift(time_to_rift_shift)
	



func add_score(score_):
	score += score_
	update_score()

func add_score_multiplier(delta_multiplier):
	score_multiplier += delta_multiplier
	update_score()
	
func update_score():
	score_total = score * score_multiplier
	hud_score.set_text("%s CARNAGE" % (score_total*100))
	
func rift_shift(time_rem):
	if time_rem < 0:
		toggle_time_rift = OS.get_ticks_msec()
		cooldown_time_rift = round(10000.0*randf() + 10000.0)
		white_overlay.set_modulate(Color(1.0,1.0,1.0,0))
		hud_white_border.set_modulate(Color(1.0,1.0,1.0,0))
		weapons_set = false
	elif time_rem < 100:
		var alpha = time_rem/100
		white_overlay.set_modulate(Color(1.0,1.0,1.0,alpha))
		hud_white_border.set_modulate(Color(1.0,1.0,1.0,alpha))
		if not(weapons_set):
			set_enemy_weapons()
			weapons_set = true
	elif time_rem < 200:
		var alpha = 1.0 - (time_rem-100)/100
		white_overlay.set_modulate(Color(1.0,1.0,1.0,alpha))
	elif time_rem < 2200:
		var alpha = 1.0 - (time_rem-200)/2000.0
		hud_white_border.set_modulate(Color(1.0,1.0,1.0,alpha))
		
		
func set_enemy_weapons():
	var epoch_ = randi() % EPOCH_COUNT
	if epoch_ == epoch:
		epoch = (epoch_+1) % EPOCH_COUNT
	else:
		epoch = epoch_
	
	active_weapons = [weapons_melee[epoch]]
	var bots = get_tree().get_nodes_in_group("enemies")
	for bot in bots:
		bot.set_weapon(chose_weapon())
		
func chose_weapon(is_ranged=null):
	var i = 0
	if is_ranged == null:
		i = randi() % 1
	elif is_ranged:
		i = 1
	return(active_weapons[i].instance())