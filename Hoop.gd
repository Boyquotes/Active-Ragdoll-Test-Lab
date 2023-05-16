extends StaticBody2D


onready var timer = get_node("Timer")

var body_inside


func _on_Hoop_Goal_body_entered(body):
	if body.is_in_group("score-able"):
		body_inside = body
		timer.start() 

func _on_Hoop_Goal_body_exited(body):
	if body.is_in_group("score-able"):
		timer.stop()
		timer.wait_time = 2
	
func _on_Timer_timeout():
	body_inside.emit_signal("done")
	body_inside.queue_free()
