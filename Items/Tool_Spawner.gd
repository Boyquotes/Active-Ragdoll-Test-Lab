extends Node2D

onready var tools = load("res://Items/Tools.tscn").instance().get_children()


func _ready():
	for thing in get_children():
		thing.connect("done", self, "_spawn_new_tool")
	_spawn_new_tool()
	_spawn_new_tool()
	_spawn_new_tool()


func _spawn_new_tool():
	var new_tool = tools[randi() % tools.size()].duplicate() # Create a new instance of the tool
	new_tool.connect("done", self, "_spawn_new_tool") # Connect the "done" signal to the spawn_new_tool method
	
	var x_range_start = -1000 # Replace with your actual range start
	var x_range_end = 1000 # Replace with your actual range end
	var y_height = -1000 # Replace with your actual y height
	
	var random_x = rand_range(x_range_start, x_range_end) # Generate a random x position within the range
#	print(random_x)
	
	new_tool.owner = self
	add_child(new_tool) # Add the new tool as a child of the current node
	
	new_tool.global_position = Vector2(random_x, y_height) # Set the position of the new tool
