extends  Control

func _on_next_level_button_pressed():
	Taskmanager.hacked = false
	get_tree().change_scene_to_file("res://Levels/Test.tscn")

func on_next_level_button_pressed() -> void:
	Taskmanager.hacked = false
	get_tree().change_scene_to_file("res://Levels/Menus/main_menu.tscn")
