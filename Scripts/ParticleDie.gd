extends Particles2D

var age = 0

func _fixed_process(delta):
	age += delta
	if age > self.get_lifetime():
		queue_free()

func _ready():
	set_fixed_process(true)
	