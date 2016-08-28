extends AnimatedSprite

var sprite = SpriteFrames.new()

var walk = [preload("res://Assets/Player/main_mech_0.png"),
	preload("res://Assets/Player/main_mech_1.png"), 
	preload("res://Assets/Player/main_mech_2.png"), 
	preload("res://Assets/Player/main_mech_0.png"),
	preload("res://Assets/Player/main_mech_3.png"),
	preload("res://Assets/Player/main_mech_4.png")]

var stand = preload("res://Assets/Player/main_mech_0.png")

func _ready():
	sprite.add_animation("Walk")
	for item in walk:
	    sprite.add_frame("Walk", item)
	sprite.add_animation("Stand")
	sprite.add_frame("Stand", stand)
	set_sprite_frames(sprite)
	play("Stand")


