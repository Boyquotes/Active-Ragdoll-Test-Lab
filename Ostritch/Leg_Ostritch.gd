extends RigidBody2D
#leg script
var new_desired_angle = 0 
var power = 300
var locked = true
#Called when the node enters the scene tree for the first time.
func _ready(): 
	pass 

func _process(delta):
	#same thing here as well
	
	var current_angle = get_global_transform().get_rotation()
	if locked:
		angular_velocity = lerp_angle(current_angle, new_desired_angle, (power)* delta)

