extends Control

var menu_origin_position := Vector2.ZERO
var menu_origin_size := Vector2.ZERO

var current_menu
var menu_stack := []

onready var menu_1 = $Menu1
onready var menu_2 = $Menu2


func _ready():
	menu_origin_position = Vector2(0,0)
	menu_origin_size = get_viewport_rect().size
	current_menu = menu_1
	
func move_to_next_menu(next_menu_id: String):
	var next_menu = get_menu_from_menu_id(next_menu_id)
	current_menu.rect_global_position = Vector2(-menu_origin_size.x, 0)
	next_menu.rect_global_position = menu_origin_position
	menu_stack.append(current_menu)
	current_menu = next_menu

func move_to_previous_menu():
	var previous_menu = menu_stack.pop_back()
	if previous_menu != null:
		previous_menu.rect_global_position = menu_origin_position
		current_menu.rect_global_position = Vector2(menu_origin_size.x, 0)
		current_menu = previous_menu

func get_menu_from_menu_id(menu_id: String) -> Control:
	match menu_id:
		"menu_1":
			return menu_1
		"menu_2":
			return menu_2
		_:
			return menu_1


func _on_Games_pressed():
	move_to_next_menu("menu_2")
	pass # Replace with function body.
