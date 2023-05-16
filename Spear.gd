extends "res://item.gd"


func release():
	pin.set_node_b("")
	cooldown = true
	locked = false
	friction = 1
	bounce = 0.3
	mass = 1
	weight = 9.8
	apply_central_impulse(Vector2(linear_velocity.x/275,linear_velocity.x/1000))

#
#
#func _on_Spear_body_entered(body):
#
