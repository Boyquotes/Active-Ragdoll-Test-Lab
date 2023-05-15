extends RigidBody2D
#torso script
#these are variables for movement script


var speed = 400

var jump_power=1500;

var spin_power = 50
#again the varaible to store desired angle
var new_desired_angle = 0

var locked = true

onready var head = get_node("../Head")

var added_up_velocity = 0
onready var Leg_L_up = get_node("../Leg_L_up")
onready var Leg_L_down = get_node("../Leg_L_down")
onready var Leg_R_up = get_node("../Leg_R_up")
onready var Leg_R_down = get_node("../Leg_R_down")

onready var spine2 = get_node("../Spine2")
onready var spine3 = get_node("../Spine3")
onready var spine4 = get_node("../Spine4")
onready var spine5 = get_node("../Spine5")
onready var spine6 = get_node("../Spine6")

onready var waist = get_node("../Body")

var body = []

var variant = 1

onready var raycast = waist.get_node("RayCast2D")


var float_height = 115 # The height at which the character should float
var float_force = 1000  # The force to apply when floating

var velocity = Vector2(0,0)

var stride
var stride_length = 0.5
var mult = 1
var run_dir = 1
var total_up = 0
var running  = false
var spine = []
var legs = []

func _ready():
	stride = 0.0
	body = [head, self, spine2, spine3, spine4, spine5, spine6, waist, Leg_L_up, Leg_L_down, Leg_R_up, Leg_R_down]
	spine = [waist, self, spine2, spine3, spine4, spine5, spine6]
	legs = [Leg_L_up, Leg_L_down, Leg_R_up, Leg_R_down]


var upper_leg_keyframes = [
	0.0, -0.4, 0.0, 0.4
]

var lower_leg_keyframes = [
	0.0, 0.7, 0.0, -0.4
]

func interpolate_keyframes(keyframes, progress):
	var index = int(progress * len(keyframes))
	var t = progress * len(keyframes) - index
	var current_angle = keyframes[index % len(keyframes)]
	var next_angle = keyframes[(index + 1) % len(keyframes)]
	return lerp_angle(current_angle, next_angle, t)


func _input(event):
	if event.is_action_pressed("ui_right"):
		variant = 1
		mult = 1
		for part in body:
				part.linear_velocity.x = 0
		velocity.x = 0
		
	elif event.is_action_pressed("ui_left"):
		variant = 1
		for part in body:
				part.linear_velocity.x = 0
		velocity.x = 0
		
		for part in spine:
			if part != waist:
				part.apply_scale(Vector2(-1,1))

		head.global_position.x -= (head.global_position.x-waist.global_position.x)*2
#		setScale(-1, 2)

		
func _process(_delta):
	
	var float_height = 111 # The height at which the character should float

	if Input.is_action_pressed("ui_right"):
		variant += 0.001
#		print(variant)
		run_dir = -1
		
	#
		for part in spine:
			part.linear_velocity.x = speed*variant
		velocity.x = speed*variant
		

			
			
	elif Input.is_action_pressed("ui_left"):
		variant += 0.001
#		print(variant)
		run_dir = 1
		mult = 1
#		velocity.x -= speed*variant
		
		
		for part in spine:
			part.linear_velocity.x = -speed*variant
		velocity.x = -speed*variant
	
	else:
		velocity.x -= velocity.x/10



	if Input.is_action_just_pressed("ui_up"):
#		variant = 1
		

		Leg_L_up.locked = false
		Leg_R_up.locked = false
		
		for part in spine:
			part.apply_central_impulse(Vector2.UP * jump_power)
			
	elif Input.is_action_pressed("ui_down"):

		# Increase gravity and apply a downward force when the down key is held
#		apply_central_impulse(Vector2.DOWN * jump_power/10)

		for part in spine:
			if part != waist:
				part.locked = false

		head.locked = false
		
#		spine6.locked = false
		
		waist.gravity_scale = -10
		head.gravity_scale = 20.0

	else:
		
		for part in spine:
			if part != waist:
				part.locked = true

		head.locked = true
		
		# Reset gravity when the down key is not held
		waist.gravity_scale = 1.0
		head.gravity_scale = 1.0

	if velocity.length() > 10:
		running = true
	else:
		running = false
		
#		for part in legs:
#			part.locked = true


	waist.linear_velocity.x = velocity.x
	

	
	
#	self.linear_velocity = velocity
	
	upper_leg_keyframes = [
	-1.0, 0, 2.4, 0
	]

	lower_leg_keyframes = [
	2.0, 1.0, 2.0, -1
	]
	
	var current_angle = get_global_transform().get_rotation() 
	if locked:
		angular_velocity = lerp_angle(current_angle, new_desired_angle, (700) *_delta)

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
		Leg_R_up.new_desired_angle = 0
		Leg_L_up.new_desired_angle = 0

		Leg_R_down.new_desired_angle = 0
		Leg_L_down.new_desired_angle = 0


	raycast.global_rotation = 0  # Make the raycast point straight down

	applied_force.y = 0
	if raycast.is_colliding():



		Leg_L_up.locked = true
		Leg_R_up.locked = true
		
		var OG_velocty = linear_velocity.y

		var distance_to_ground = raycast.get_collision_point().distance_to(raycast.global_position)
#		print(distance_to_ground)
		if distance_to_ground < float_height and not Input.is_action_pressed("ui_down"):
			added_up_velocity = (distance_to_ground + (float_height-distance_to_ground) * 0.5)
#			apply_central_impulse(Vector2.UP * float_force * _delta * ((float_height-distance_to_ground)))

			waist.apply_central_impulse(Vector2.UP * added_up_velocity)

#			apply_central_impulse(Vector2.UP * (distance_to_ground + (float_height-distance_to_ground) * 0.02))

		if distance_to_ground > float_height+10 and not Input.is_action_pressed("ui_up"):
			added_up_velocity = (distance_to_ground + (float_height+10-distance_to_ground) * 0.5)
			
			waist.apply_central_impulse(Vector2.UP * -added_up_velocity)

			
#		print((float_height-distance_to_ground)*0.5+distance_to_ground)
		
#		print(float_height-distance_to_ground)

