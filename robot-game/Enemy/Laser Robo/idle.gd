extends NodeState

@export var char_body_2d: CharacterBody2D
@export var slow_speed: int = 50

func _ready():
	pass
	
func on_process(delta: float) -> void:
	pass

func on_physics_process(delta: float) -> void:
	char_body_2d.velocity.x = move_toward(char_body_2d.velocity.x, 0, slow_speed * delta)
	char_body_2d.move_and_slide()

func enter():
	pass

func exit():
	pass
