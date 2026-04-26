extends Area2D

@export var next_level_path: String = "res://Levels/level2.tscn"

func _ready() -> void:
	$Sprite2D.play("default")
	if Taskmanager.hacked:
		show()
	else:
		hide()

func _on_body_entered(body):
	if body.is_in_group("player") or "player" in body.name:
		get_tree().change_scene_to_file("res://UI/WinScreen.tscn")
