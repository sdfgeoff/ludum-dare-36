
extends Control

onready var score = get_node("Score")
onready var score_offset = score.get_pos()

onready var rockets = get_node("Rockets")
onready var rockets_offset = rockets.get_pos()

onready var health_bar = get_node("Health Bar")
onready var health_bar_offset = health_bar.get_pos()

onready var pause_popup = get_node("Pause Popup")
onready var pause_popup_offset = pause_popup.get_pos()

onready var white_border = get_node("White Border")
onready var white_border_offset = white_border.get_pos()

onready var camera = get_node("/root/Game/World/PlayerNode/Player/Camera2D")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var center = camera.get_global_pos()
	score.set_pos(score_offset + center)
	health_bar.set_pos(health_bar_offset + center)
	pause_popup.set_pos(pause_popup_offset + center)
	white_border.set_pos(white_border_offset + center)
	rockets.set_pos( rockets_offset + center )

func set_health_max(hp):
	health_bar.set_max(hp)
	set_health(hp)

func set_health(hp):
	health_bar.set_value(hp)

func set_rockets(count):
	rockets.set_text("ROCKETS %s" % (count))