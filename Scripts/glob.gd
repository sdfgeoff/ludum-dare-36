extends Node2D

var terrain_layer = 1
var projectile_layer = 16
var enemy_layer = 8
var player_layer = 4

var toggle_state_pause = false
var button_state_pause = false
var toggle_state_fullscreen = false
var button_state_fullscreen = false


onready var pause_popup = get_node("/root/Game/HUD/Pause Popup")

var score = 0
var score_multiplier = 1
var score_total = 0

onready var hud_score = get_node("/root/Game/HUD/Score")


var weapon_club = preload( "res://Enemies/Melee/Club.tscn" )
var weapon_axe = preload( "res://Enemies/Melee/Axe.tscn" )
var weapon_sword = preload( "res://Enemies/Melee/Sword.tscn" )
var weapon_samurai = preload( "res://Enemies/Melee/Samurai.tscn" )
var weapon_lasersword = preload( "res://Enemies/Melee/LaserSword.tscn" )
var weapon_flamer = preload( "res://Enemies/Ranged/Flamer.tscn" )


func _ready():
	set_pause_mode(2)
	set_process(true)
	update_score()

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
		if !button_state_fullscreen:
			button_state_fullscreen = true
			toggle_state_fullscreen = not(toggle_state_fullscreen)
			OS.set_window_fullscreen(toggle_state_fullscreen)
		else:
			button_state_fullscreen = false


func add_score(score_):
	score += score_
	update_score()

func add_score_multiplier(delta_multiplier):
	score_multiplier += delta_multiplier
	update_score()
	
func update_score():
	score_total = score * score_multiplier
	hud_score.set_text("%s CARNAGE" % (score_total*100))
	