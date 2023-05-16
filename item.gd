extends RigidBody2D
#head script
var new_desired_angle = 0 
#what you want as the desired angle of your rigid body.
#here its 0 to keep the head straight
var locked = false
var snap = false

export var sharp = false

var force = 1
var cooltime_wait = 0
var cooldown = false
var cooltime = 1.3

var impaled = false

var speed = 500  # Speed of movement
onready var target_node: Node2D  # The node we want to follow

# Relative position to the target_node


onready var pin = get_node("PinJoint2D")
onready var visual = get_node("Polygon2D")

	
var available = false

func _ready():
	if sharp:
		connect("body_entered", self, "_on_body_entered")

func _input(event):
	if event.is_action_pressed("snap"):
		snap = true


func _physics_process(delta):
	
	pin.position = Vector2(0,0)
	
	
	if cooldown == true and !impaled:
		cooltime_wait += delta
		if cooltime_wait >= 0.2:
			set_collision_mask_bit(1, true)
			pass
			
		if cooltime_wait >= cooltime:
			cooldown = false
			cooltime_wait = 0
			
	
	var current_angle = get_global_transform().get_rotation()
	if locked:
		angular_velocity = lerp_angle(current_angle, new_desired_angle, (300)* delta)


	if is_stationary() and pin.get_node_b()=="" and !cooldown and !impaled:
			available = true
			set_collision_mask_bit(1, false)
			mass = 0.01
			weight = 0.01
			
			visual.color = Color.green
	else:
		visual.color = Color.red
			

	if snap == true:
		visual.color = Color.blue
	if locked == true:
		visual.color = Color.purple
		
	if snap:
		if target_node:
			available = false
			
			force += 1/2
			# Calculate the target position
			var target_position = target_node.global_position

			# Calculate the direction to the target
			var direction = (target_position - pin.global_position).normalized()

			# Move towards the target
			linear_velocity = (direction * speed * force)
			
			if (pin.global_position - target_position).abs() < Vector2(3,3):
#				pin.global_position = target_position

				global_position = target_position-pin.position
				pin.set_node_b((target_node.get_path()))
				
				
				snap = false
				target_node.owner.grabbed_item = self
				force = 1
				grab()


				
				
		else:
			snap = false
			breakpoint
			linear_velocity = Vector2.ZERO

func grab():
	locked = true
	friction = 1
	bounce = 0.0
	
func release():
	pin.set_node_b("")
	cooldown = true
	locked = false
	friction = 1
	bounce = 0.3
	mass = 1
	weight = 9.8
	apply_central_impulse(Vector2(linear_velocity.x/800,0))
	
func is_stationary() -> bool:
#	print(linear_velocity.length())
	var linear_threshold = 200
	var angular_threshold = deg2rad(50)

	if linear_velocity.length() <= linear_threshold and angular_velocity <= angular_threshold:
		return true
	else:
		return false

func impale(body, colliding_point, direction):
	impaled = true

#	var penetration_vector = -self.linear_velocity.normalized() * 10
#	self.position -= direction*10


	var joint = PinJoint2D.new()
	joint.scale = Vector2(3,3)
	joint.disable_collision = true
	body.add_child(joint)
	joint.global_position = colliding_point
	joint.node_a = self.get_path()
	joint.node_b = body.get_path()
	
	var joint2 = PinJoint2D.new()
	joint2.scale = Vector2(3,3)
	joint2.disable_collision = true
	body.add_child(joint2)
	joint2.global_position = colliding_point-direction*40
	joint2.node_a = self.get_path()
	joint2.node_b = body.get_path()


func _on_body_entered(body):
	if sharp and !available:
		if body is RigidBody2D and !body.is_in_group("tool"):
			if !impaled:
				var result = Physics2DTestMotionResult.new()
				set_collision_mask_bit(0, false)
				if self.test_motion(Vector2(0,0), false, 0.08, result):
					impale(body, result.collision_point, result.collision_normal)
				set_collision_mask_bit(0, true)
				set_collision_mask_bit(1, false)
				
					
				
				if body.get_node("Panel"):
					body.get_node("Panel").modulate = Color.red
				elif body.get_node("Polygon2D"):
					body.get_node("Polygon2D").modulate = Color.red
					

