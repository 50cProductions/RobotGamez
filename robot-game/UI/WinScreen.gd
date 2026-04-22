extends  Control

func _on_next_level_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Test.tscn")

func on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Menus/main_menu.tscn")
