#===================================================#
#                                                   #
#                    player.gd                      #
#                                                   #
#===================================================#


extends KinematicBody


var direction : Vector3
var speed : int = 600

const GRAVITY = 100
const MAX_VERT_SPEED = 500

var fl_is_on_floor = false

func _ready():
	pass

func _process(delta):
	direction = Vector3(                                                          \
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), \
	0,                                                                            \
	Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up"))
	
	var cam_global_angle = $cam_follow/cam.global_transform.basis.get_euler().y
	
	direction = direction.rotated( Vector3(0,1,0) , cam_global_angle)
	if direction.length() > 0:
		rotation.y = Vector2(direction.x , -direction.z).angle() - PI/2


func _physics_process(delta):
	fl_is_on_floor = is_on_floor()
	if not is_on_floor():
		direction.y -= GRAVITY * delta
		direction.y = min(MAX_VERT_SPEED , direction.y)
	move_and_slide(direction * speed * delta, Vector3(0,1,0), true, 4, deg2rad(45), false)
	
