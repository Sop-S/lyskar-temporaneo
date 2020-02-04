#===================================================#
#                                                   #
#                    player.gd                      #
#                                                   #
#===================================================#


extends KinematicBody

var speed              : float = 100.0
var steering_dampening : float = 20.0 #percentage

var direction   : Vector3
var move_vector : Vector3

const GRAVITY        = 100
const MAX_VERT_SPEED = 500

var fl_is_on_floor = false

func _ready():
	pass

func _process(delta):
	direction = Vector3(                                                          \
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), \
	0,                                                                            \
	Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up"))
	
	#--- adjust direction to camera angle
	var cam_global_angle = $cam_follow/cam.global_transform.basis.get_euler().y
	
	direction = direction.rotated( Vector3(0,1,0) , cam_global_angle) * speed
	
	#--- rotate the player body facing the direction
	if move_vector.length() > 0.2:
		rotation.y = Vector2(direction.x , -direction.z).angle() - PI/2
	


func _physics_process(delta):
	move_vector = Vector3()
	#--- gravity
	fl_is_on_floor = is_on_floor()
	if not is_on_floor():
		move_vector.y -= GRAVITY
		move_vector.y = min(MAX_VERT_SPEED , move_vector.y)
	
	#--- steering behaviour
	var steering = (direction - move_vector) * (steering_dampening / 100.0)
	
	move_vector += steering
	move_vector = move_and_slide(move_vector, Vector3(0,1,0), true, 4, deg2rad(45), false)

