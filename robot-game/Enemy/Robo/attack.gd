extends NodeState

@export var char_body_2d: CharacterBody2D
@export var speed: int
var player: CharacterBody2D
var max_speed: int

func on_process(delta: float):
	pass

func on_physics_process(delta: float) -> void:
	var direction: int
	
	if char_body_2d.global_position > player.global_position:
		direction = -1
	elif char_body_2d.global_position < player.global_position:
		direction = 1
	
	char_body_2d.velocity.x += direction * speed * delta
	char_body_2d.velocity.x = clamp(char_body_2d.velocity.x, -max_speed, max_speed)
	char_body_2d.move_and_slide()
	

func enter():
	player = get_tree().get_nodes_in_group("player")[0] as CharacterBody2D
	max_speed = speed * 20

func exit():
	pass
