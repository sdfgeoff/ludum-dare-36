extends Particles2D

const THRESHOLD = 0.3

var age = 0

func _fixed_process(delta):
	age += delta
	if age > self.get_lifetime() - THRESHOLD:
		queue_free()

func _ready():
	set_fixed_process(true)
	set_z( -1 )
	