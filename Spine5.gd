extends "res://Spine.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _physics_process(delta):
	new_desired_angle = deg2rad(100)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	power = 2000
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
