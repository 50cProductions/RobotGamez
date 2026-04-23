extends NodeState

@onready var bullet_timer = $"../../Bullet Timer"

@export var sniper: CharacterBody2D
@export var speed: int
var player: CharacterBody2D
var max_speed: int
var can_shoot = true

func on_process(delta: float):
	pass

func on_physics_process(delta: float) -> void:
	var direction: int
	
	if sniper.global_position > player.global_position:
		direction = -1
	elif sniper.global_position < player.global_position:
		direction = 1
		
	if direction > 0:
		sniper.shoot_marker.position.x = sniper.shoot_marker_posi.x
	elif direction < 0:
		sniper.shoot_marker.position.x = -sniper.shoot_marker_posi.x
	
	if can_shoot:
		action_shoot(delta, direction)
		can_shoot = false
		bullet_timer.start()
		
	sniper.move_and_slide()


func action_shoot(delta: float, direction: int):
	var bullet_instance = sniper.bullet.instantiate() as Node2D
	var offset = player.global_position + Vector2(0, -16)
	var dir_to_player = (offset - sniper.shoot_marker.global_position).normalized()
	bullet_instance.direction = dir_to_player
	bullet_instance.global_position = sniper.shoot_marker.global_position
	bullet_instance.rotation = dir_to_player.angle()
	
	sniper.get_parent().add_child(bullet_instance)
	

func enter():
	player = get_tree().get_nodes_in_group("player")[0] as CharacterBody2D
	max_speed = speed * 20

func exit():
	pass


func _on_bullet_timer_timeout() -> void:
	can_shoot = true
