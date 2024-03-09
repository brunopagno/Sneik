extends Node

@onready var food = $FoodObj

func _on_eat_food(body):
	var win_size = DisplayServer.window_get_size();
	if body == $"../Sneik/Head":
		food.position = Vector2(randf_range(30, win_size.x - 30), randf_range(30, win_size.y - 30))
