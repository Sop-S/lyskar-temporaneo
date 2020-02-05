extends Control


#--- flags
var fl_player_is_on_floor := false

func _ready():
	pass # Replace with function body.

func _process(delta):
	$fps.text = str( Engine.get_frames_per_second() , " fps" )
	
	$vbox/test.text = str( fl_player_is_on_floor )
