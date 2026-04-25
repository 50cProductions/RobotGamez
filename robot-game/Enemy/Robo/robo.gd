extends CharacterBody2D

@export var damage_amount = 40

var original_pos: Vector2
func _ready() -> void:
	Taskmanager.computer_hacked.connect(hacked)
	if !Taskmanager.hacked:
		original_pos = global_position
		position = Vector2(100000, 1000000)
	

func hacked():
	position = original_pos
