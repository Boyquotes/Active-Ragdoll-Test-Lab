extends "res://Body.gd"

func _ready():
	jump = "wasd_up"
	crouch = "wasd_down"
	move_right = "wasd_right"
	move_left = "wasd_left"
	spin = "wasd_spin"
	
	chest_polygon.color = Color.blue
