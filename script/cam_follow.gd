#===================================================#
#                                                   #
#                   cam_follow.gd                   #
#                                                   #
#===================================================#

extends Spatial

#this node is the target of the camera
var distance : float = 10
var height   : float = 4

const MAX_DIST   = 50
const MIN_DIST   = 2.5
const MAX_HEIGHT = 20
const MIN_HEIGHT = 1





func _ready():
	$cam.set_as_toplevel(true)

func _physics_process(delta):
	var cam_origin = $cam.global_transform.origin
	var up = Vector3(0,1,0)
	
	var offset = $cam.global_transform.origin - global_transform.origin
	offset = offset.normalized() * distance
	offset.y = height
	var pos = global_transform.origin + offset
	$cam.look_at_from_position(pos, global_transform.origin, up)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_mask == 16:
			distance *= 1.2
			distance  = min(distance, MAX_DIST)
			height   *= 1.2
			height    = min(height,   MAX_HEIGHT)
		elif event.button_mask == 8:
			distance /= 1.2
			distance  = max(distance, MIN_DIST)
			height   /= 1.2
			height    = max(height,   MIN_HEIGHT)
	






