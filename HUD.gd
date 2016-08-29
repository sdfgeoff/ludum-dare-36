
extends Control

onready var score = get_node("Score")
onready var score_offset = score.get_pos()
onready var pause_popup = get_node("Pause Popup")
onready var pause_popup_offset = pause_popup.get_pos()

onready var camera = get_node("../World/PlayerNode/Player/Camera2D")

func _ready():
	set_fixed_process(true)


func _fixed_process(delta):
	var center = camera.get_global_pos()
	score.set_pos(score_offset + center)
	pause_popup.set_pos(pause_popup_offset + center)


