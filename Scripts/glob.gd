extends Node2D

var terrain_layer = 1
var projectile_layer = 16
var enemy_layer = 8
var player_layer = 4




func _ready():
	pass

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
	


