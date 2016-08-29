extends Node2D

var terrain_layer = 1
var projectile_layer = 16
var enemy_layer = 8
var player_layer = 4

var pause_state = false

onready var paused_popup = get_node("/root/Game/World/PlayerNode/Player/Camera2D/Paused Popup")


var weapon_club = preload( "res://Enemies/Melee/Club.tscn" )
var weapon_axe = preload( "res://Enemies/Melee/Axe.tscn" )


func _ready():
	set_pause_mode(2)
	set_process(true)

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
	
	if Input.is_action_pressed("pause"):
		pause_state = not(pause_state)
		get_tree().set_pause(pause_state)
		if pause_state:
			paused_popup.show()
		else:
			paused_popup.hide()


