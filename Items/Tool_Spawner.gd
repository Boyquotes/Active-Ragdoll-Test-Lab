extends Node2D

onready var tools = load("res://Items/Tools.tscn").instance().get_children()

var loaded_tools = []

func _ready():
#	for thing in get_children():
#		thing.connect("done", self, "_spawn_new_tool")
	_spawn_new_tool()
	_spawn_new_tool()
	_spawn_new_tool()


func _spawn_new_tool():
	var new_tool = tools[randi() % tools.size()].duplicate() 
	new_tool.connect("done", self, "_spawn_new_tool") 
	
	var x_range_start = -1000 
	var x_range_end = 1000 
	var y_height = -1000
	
	var random_x = rand_range(x_range_start, x_range_end) 

	
	add_child(new_tool)
#	new_tool.owner = self
	
	new_tool.global_position = Vector2(random_x, y_height) 
	
#	loaded_tools.append(new_tool)
	if get_children().size() >= 7:
		for curr_tool in get_children():
			if curr_tool.done == true:
				curr_tool.queue_free()
				break
