extends NodeState

@export var enemy: CharacterBody2D
@export var slow_speed: int = 50
@onready var sprite: Sprite2D = $"../../Sprite"

signal point_reached

func _ready():
	pass
	
func on_process(delta: float) -> void:
	pass

func on_physics_process(delta: float) -> void:
	if abs(enemy.position.x - enemy.current_point.x) > 0.5:
		enemy.velocity.x = enemy.direction.x * enemy.speed * delta
	else:
		enemy.current_point_position += 1
		if enemy.current_point_position >= enemy.range_size:
			enemy.current_point_position = 0
		
		enemy.current_point = enemy.point_positions[enemy.current_point_position]

		if enemy.current_point.x > enemy.position.x:
			enemy.direction = Vector2.RIGHT
			sprite.flip_h = false
		else:
			enemy.direction = Vector2.LEFT
			sprite.flip_h = true
		point_reached.emit()

func enter():
	pass

func exit():
	pass
