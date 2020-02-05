#===================================================#
#                                                   #
#                    player.gd                      #
#                                                   #
#===================================================#


extends KinematicBody

var speed              : float = 600.0
var steering_dampening : float = 2 #percentage

var direction   : Vector3
var move_vector : Vector3

const JUMP           = 10
const GRAVITY        = 1200
const MAX_VERT_SPEED = 1500

var fl_is_on_floor = false

func _ready():
	pass

func _process(delta):
	direction = Vector3(                                                          \
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), \
	Input.get_action_strength("ui_select") * JUMP * int(is_on_floor()),                                                                            \
	Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up"))
	
	#--- adjust direction to camera angle
	var cam_global_angle = $cam_follow/cam.global_transform.basis.get_euler().y
	
	direction = direction.rotated( Vector3(0,1,0) , cam_global_angle)
	
	#--- rotate the player body facing the direction
	if move_vector.length() > 0.0:
		rotation.y = Vector2(move_vector.x , -move_vector.z).angle() - PI/2
	


func _physics_process(delta):
	move_vector = Vector3()
	
	#--- steering behaviour
	var steering = (direction - move_vector) * speed * (steering_dampening / 100.0)
	move_vector += steering
	
	#--- gravity
	fl_is_on_floor = is_on_floor()
	if not is_on_floor():
		move_vector.y -= GRAVITY * delta
		move_vector.y = min(MAX_VERT_SPEED , move_vector.y)
	
	move_vector.x = clamp(move_vector.x , -MAX_VERT_SPEED , MAX_VERT_SPEED)
	move_vector.z = clamp(move_vector.z , -MAX_VERT_SPEED , MAX_VERT_SPEED)
	
	move_vector = move_and_slide(move_vector, Vector3(0,1,0), true, 4, deg2rad(45))






