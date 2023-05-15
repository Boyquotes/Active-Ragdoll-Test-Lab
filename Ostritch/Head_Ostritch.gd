extends RigidBody2D
#head script
var new_desired_angle = 0 
#what you want as the desired angle of your rigid body.
#here its 0 to keep the head straight
var locked = true

func _ready():
	 pass
func _process(delta):
	#finds what the current angle of head is in every frame 
	var current_angle = get_global_transform().get_rotation()
	if locked:
		angular_velocity = lerp_angle(current_angle, new_desired_angle, (300)* delta)
