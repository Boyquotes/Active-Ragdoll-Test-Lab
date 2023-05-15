extends RigidBody2D
#torso script
#these are variables for movement script


var speed = 400

var jump_power=1000;

var spin_power = 50
#again the varaible to store desired angle
var new_desired_angle = 0

var locked: bool = true

var spin_dir: int
var holding_something = false
#onready var head = get_node("Head")
var grabbed_item = null

var spin_multiplier = 1
#var added_up_velocity = 0
onready var Leg_L_up = get_node("Leg_L_up")
onready var Leg_L_down = get_node("Leg_L_down")
onready var Leg_R_up = get_node("Leg_R_up")
onready var Leg_R_down = get_node("Leg_R_down")


onready var spine1 = get_node("Spine6/Spine5/Spine4/Spine3/Spine2/Spine1")
onready var spine2 = get_node("Spine6/Spine5/Spine4/Spine3/Spine2")
onready var spine3 = get_node("Spine6/Spine5/Spine4/Spine3")
onready var spine4 = get_node("Spine6/Spine5/Spine4")
onready var spine5 = get_node("Spine6/Spine5")
onready var spine6 = get_node("Spine6")

#onready var waist = get_node("../Body")
export var controllable = true

onready var chest_polygon = get_node("Polygon2D")

var body = []

var variant = 1

onready var raycast = self.get_node("RayCast2D")
onready var pickup_zone = get_node("Pickup_range")

var float_height = 100 # The height at which the character should float
var float_force = 1000  # The force to apply when floating

var velocity = Vector2(0,0)

var stride
var stride_length = 0.5
var mult = 1
var run_dir = 1
var running  = false
var spine = []
var legs = []

var grabber
var upper_leg_keyframes = [
-1.0, 0, 2.4, 0
]

var lower_leg_keyframes = [
2.0, 1.0, 2.0, -1
]


func _ready():
	grabber = spine1
	stride = 0.0
	body = [spine1, spine2, spine3, spine4, spine5, spine6, self, Leg_L_up, Leg_L_down, Leg_R_up, Leg_R_down]
	spine = [spine1, spine2, spine3, spine4, spine5, spine6]
	legs = [Leg_L_up, Leg_L_down, Leg_R_up, Leg_R_down]






func interpolate_keyframes(keyframes, progress):
	var index = int(progress * len(keyframes))
	var t = progress * len(keyframes) - index
	var current_angle = keyframes[index % len(keyframes)]
	var next_angle = keyframes[(index + 1) % len(keyframes)]
	return lerp_angle(current_angle, next_angle, t)



func _input(event):
	if event.is_action_pressed("ui_right") and controllable:
		variant = 1
		mult = 1
#		for part in body:
#				part.linear_velocity.x = 0
#		velocity.x = 0
		
	elif event.is_action_pressed("ui_left") and controllable:
		variant = 1
		for part in legs:
				part.linear_velocity.x = 0
		velocity.x = 0
		
	if event.is_action_pressed("spin") and controllable:
		self.mode = RigidBody2D.MODE_RIGID
		locked = false
		
		for part in spine:
			part.locked = false
		
		spin_dir = run_dir*-1

	if event.is_action_released("spin") and controllable:
		if grabbed_item:
			grabbed_item.release()
			grabbed_item = null
			holding_something = false
			
		for part in spine:
			part.locked = true
		locked = true
		
		spin_multiplier = 1

		
func _process(_delta):
	

	
#	print(get_parent())


	if Input.is_action_pressed("ui_right") and controllable:
		variant += 0.001
#		print(variant)
		run_dir = -1
		
		
		
	#
#		for part in spine:
#			part.linear_velocity.x = speed*variant
		velocity.x = speed*variant
		

			
			
	elif Input.is_action_pressed("ui_left") and controllable:
		variant += 0.001
#		print(variant)
		run_dir = 1
#		mult = 1

#		velocity.x -= speed*variant
		
		
#		for part in spine:
#			part.linear_velocity.x = -speed*variant

		velocity.x = -speed*variant


	else:
		velocity.x -= velocity.x/10





	if velocity.length() > 10:
		running = true
	else:
		running = false
		
#		for part in legs:
#			part.locked = tru

	if Input.is_action_pressed("spin") and controllable:

		
		spin_multiplier += 0.003
		angular_velocity = 10*spin_dir*spin_multiplier  # Set a constant angular velocity
	else:

		if abs(get_transform().get_rotation()) < 0.5 and raycast.is_colliding() and not Input.is_action_pressed("ui_up") :
			self.mode = RigidBody2D.MODE_CHARACTER
		
#		angular_velocity = 0  # Stop rotating when the spin button is not pressed



#		for part in spine:
#			if part != self:
#				part.power = 0
#		pass


	self.linear_velocity.x = velocity.x
	

	
	
#	spine1.linear_velocity = velocity
	

	
	var current_angle = get_global_transform().get_rotation() 

#	print(rad2deg(get_global_transform().get_rotation()))
	if locked:
		angular_velocity = lerp_angle(current_angle, new_desired_angle, (500) *_delta)

	if running:
		# Increase stride every frame based on delta time
		stride += mult * _delta

		# Upper Leg power
#		print(spine4.linear_velocity.x)
		var new_power = abs(spine4.linear_velocity.x)
		Leg_R_up.power = min(new_power, 400)
		Leg_L_up.power = min(new_power, 400)
		
		mult = min(2.5, new_power/400)
		
#		print(mult)
		
		
		# Upper Leg new desired angles
		Leg_R_up.new_desired_angle = interpolate_keyframes(upper_leg_keyframes, stride)*run_dir
		Leg_L_up.new_desired_angle = interpolate_keyframes(upper_leg_keyframes, stride + 0.5)*run_dir

		# Lower Leg new desired angles
		Leg_R_down.new_desired_angle = -interpolate_keyframes(lower_leg_keyframes, stride)*run_dir
		Leg_L_down.new_desired_angle = -interpolate_keyframes(lower_leg_keyframes, stride + 0.5)*run_dir

	else:
		Leg_R_up.new_desired_angle = deg2rad(15)
		Leg_L_up.new_desired_angle = deg2rad(-15)

		Leg_R_down.new_desired_angle = 0
		Leg_L_down.new_desired_angle = 0


	raycast.global_rotation = 0  # Make the raycast point straight down
	pickup_zone.global_rotation = 0
	
#	applied_force.y = 0
	if raycast.is_colliding():


		var distance_to_ground = raycast.get_collision_point().distance_to(raycast.global_position)

		if distance_to_ground < float_height and not (Input.is_action_pressed("ui_down") and controllable):
			chest_polygon.color = Color.red

			# Calculate the difference between the current height and the desired height
			var height_difference = float_height - distance_to_ground

			# Set the vertical velocity to a value proportional to the height difference
			self.linear_velocity.y = -height_difference * float_force/100

		elif distance_to_ground > float_height+10 and not (Input.is_action_pressed("ui_up") and controllable):
			chest_polygon.color = Color.yellow

			# Calculate the difference between the current height and the desired height
			var height_difference = distance_to_ground - float_height

			# Set the vertical velocity to a value proportional to the height difference
			self.linear_velocity.y = height_difference * float_force/100

#			for part in spine:
#				part.locked = true
				
#		else:
#			chest_polygon.color = Color.white
			
#		if self.mode == RigidBody2D.MODE_RIGID:
#			chest_polygon.color = Color.white
	
	if Input.is_action_just_pressed("ui_up") and controllable and raycast.is_colliding():
#		variant = 1
		self.mode = RigidBody2D.MODE_RIGID

		Leg_L_up.locked = false
		Leg_R_up.locked = false
#
#		print(Vector2.UP)
		for part in legs:
#			part.linear_velocity.y = 0
			part.apply_central_impulse(Vector2.UP * jump_power)
		apply_central_impulse(Vector2(0, -jump_power*1))
		
		
		for part in spine:
			part.locked = false
			
#		apply_impulse(Vector2.UP * 500000)
#		linear_velocity.y = 0

		
			
#		self.apply_central_impulse(Vector2.UP * 500000)
			
	elif Input.is_action_pressed("ui_down") and controllable:

		# Increase gravity and apply a downward force when the down key is held
#		apply_central_impulse(Vector2.DOWN * jump_power/10)

		for part in legs:
				part.locked = false
#		self.gravity_scale = 4

	else:
		
		for part in legs:
				part.locked = true
		# Reset gravity when the down key is not held
		self.gravity_scale = 1.0
#		head.gravity_scale = 1.0

func _on_Area2D_body_entered(body):
#	print("ENTERED")
	if body.available and !holding_something:
		body.target_node = grabber
		body.snap = true
		holding_something = true

