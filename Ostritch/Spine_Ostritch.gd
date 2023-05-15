extends RigidBody2D
#leg script
var new_desired_angle = 0 
var power = 1000
var max_angle = 120 # Maximum angle in radians. You can change this variable.
var locked = true



#func _integrate_forces(state):
#	max_angle = 0 # Maximum angle in radians. You can change this variable.
#	var adjusted = calculate_overshot(rotation_degrees)
##	print(adjusted)
##	var xform = state.get_transform().rotated(adjusted)
##	state.get_contact_collider_velocity_at_position(
#	angular_velocity -= adjusted
#
##	state.set_transform(xform)


func _process(delta):
	var current_angle = get_global_transform().get_rotation()

	if locked:
		angular_velocity = lerp_angle(current_angle, (new_desired_angle), (power)* delta)


func calculate_overshot(angle):
	
	# This function will limit the angle between -max_angle and max_angle
	if angle > max_angle:
		return angle-max_angle
	elif angle < -max_angle:
		return angle+max_angle
	else:
		return 0
