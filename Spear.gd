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



func _on_Spear_body_entered(body):
	if sharp:
		if body is RigidBody2D and !body.is_in_group("tool"):
			if !impaled:
				var result = Physics2DTestMotionResult.new()
				var point = test_motion(Vector2(0,0), false, 0.08, result)
				impale(body, result.collision_point)
				
				if body.get_node("Panel"):
					body.get_node("Panel").modulate = Color.red
				else:
					body.get_node("Polygon2D").modulate = Color.red
