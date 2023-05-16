extends "res://Body.gd"

func _ready():
	jump = "arrow_up"
	crouch = "arrow_down"
	move_right = "arrow_right"
	move_left = "arrow_left"
	spin = "arrow_spin"
	
	chest_polygon.color = Color.red
