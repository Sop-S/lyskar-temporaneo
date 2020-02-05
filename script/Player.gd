#===================================================#
#                                                   #
#                    player.gd                      #
#                                                   #
#===================================================#


extends KinematicBody

#--- global var
var direction   : Vector3
var move_vector : Vector3

#--- player stats
var accelleration  : float = 100
var friction       : float = 180
var jump_acc       : float = 20
var gravity_acc    : float = 190
var max_speed      : int   = 15
var max_fall_speed : int   = 80

var fl_is_on_floor = false




func _ready():
	pass

func _process(delta):
	direction = Vector3(                                                          \
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), \
	Input.get_action_strength("ui_select") * (jump_acc + gravity_acc*delta) * int(is_on_floor()),\
	Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up"))
	
	#--- adjust direction to camera angle
	var cam_global_angle = $cam_follow/cam.global_transform.basis.get_euler().y
	
	direction = direction.rotated( Vector3(0,1,0) , cam_global_angle)
	#--- normalize direction Vector TODO
	
	


func _physics_process(delta):
#	move_vector = Vector3()
	
	#--- steering behaviour
#	var steering = (direction - move_vector) * speed * (steering_dampening / 100.0)
	if direction == Vector3():
		move_vector.x /= 1.0 + delta * friction
		move_vector.z /= 1.0 + delta * friction
	else:
		move_vector += direction * delta * accelleration
	
	#--- gravity
	fl_is_on_floor = is_on_floor()
	if not is_on_floor():
		move_vector.y -= gravity_acc * delta
		move_vector.y = clamp(move_vector.y, -max_fall_speed, max_fall_speed)
	
	move_vector.x = clamp(move_vector.x , -max_speed , max_speed)
	move_vector.z = clamp(move_vector.z , -max_speed , max_speed)
	
	move_vector = move_and_slide_with_snap(move_vector, Vector3(0,1,0), Vector3(0,1,0), false, 4, deg2rad(45))
	
	#--- rotate the player body facing the direction
	if move_vector.length() > 0.2:
		rotation.y = Vector2(move_vector.x , -move_vector.z).angle() - PI/2
	






