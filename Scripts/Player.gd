extends RigidBody2D

const GRAVITY = 10.0
const WALK_SPEED = 20

var velocity = Vector2()



func _fixed_process(delta):

    velocity.y = GRAVITY
    if (Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A) ):
        velocity.x = - WALK_SPEED
    elif (Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D)):
        velocity.x =   WALK_SPEED
    else:
        velocity.x = 0

    var motion = velocity * delta
    #motion = move(motion)
    
    set_rot(0.0)

    apply_impulse( Vector2(0,0), velocity )

    #more comments
    #if (is_colliding()):
    #    var n = get_collision_normal()
    #    motion = n.slide(motion)
    #    velocity = n.slide(velocity)
    #    move(motion)


func _ready():
    set_fixed_process(true)