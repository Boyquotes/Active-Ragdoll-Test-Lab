extends "res://Player/Spine.gd"




func _ready():
	power = 1000

func _physics_process(delta):
	new_desired_angle = deg2rad(140)
	
