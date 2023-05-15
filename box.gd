extends KinematicBody2D

func _ready():
 pass 
func _physics_process(delta):
	global_position=get_global_mouse_position()
