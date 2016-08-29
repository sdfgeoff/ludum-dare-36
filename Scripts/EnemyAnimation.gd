extends AnimatedSprite

var sprite = SpriteFrames.new()

var walk_forwards = [preload("res://Enemies/Character/enemy_char_0.png"),
	preload("res://Enemies/Character/enemy_char_1.png"), 
	preload("res://Enemies/Character/enemy_char_0.png"), 
	preload("res://Enemies/Character/enemy_char_2.png")]

var walk_backwards = [preload("res://Enemies/Character/enemy_char_0.png"),
	preload("res://Enemies/Character/enemy_char_2.png"), 
	preload("res://Enemies/Character/enemy_char_0.png"), 
	preload("res://Enemies/Character/enemy_char_1.png")]

var stand = preload("res://Enemies/Character/enemy_char_0.png")

func _ready():
	sprite.add_animation("Walk Forwards")
	for item in walk_forwards:
	    sprite.add_frame("Walk Forwards", item)
	
	sprite.add_animation("Walk Backwards")
	for item in walk_backwards:
	    sprite.add_frame("Walk Backwards", item)
	
	sprite.add_animation("Stand")
	sprite.add_frame("Stand", stand)
	set_sprite_frames(sprite)
	play("Stand")


