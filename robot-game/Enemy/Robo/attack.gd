extends NodeState

var laser = preload("res://Enemy/Abilities/Laser/laser.tscn")

@export var char_body_2d: CharacterBody2D
@export var speed: int
var player: CharacterBody2D
var max_speed: int
var can_shoot = false

@onready var laser_timer = $"../../Laser Timer"
@onready var shoot_marker = $"../../Initial Shoot"

func on_process(delta: float):
	pass

func on_physics_process(delta: float) -> void:
	var direction: int
	
	if char_body_2d.global_position > player.global_position:
		direction = -1
	elif char_body_2d.global_position < player.global_position:
		direction = 1
		
	if direction > 0:
		shoot_marker.position.x = abs(shoot_marker.position.x)
	elif direction < 0:
		shoot_marker.position.x = -abs(shoot_marker.position.x)
		
	if can_shoot:
		action_shoot(delta, direction)
		can_shoot = false
		laser_timer.start()
		
	char_body_2d.velocity.x += direction * speed * delta
	char_body_2d.velocity.x = clamp(char_body_2d.velocity.x, -max_speed, max_speed)
	char_body_2d.move_and_slide()

func action_shoot(delta: float, direction: int):
	var laser_instance = laser.instantiate() as Node2D
	
	var target_pos = player.global_position + Vector2(0, -26)
	var dir_to_player = (target_pos - shoot_marker.global_position).normalized()
	
	laser_instance.direction = dir_to_player
	laser_instance.global_position = shoot_marker.global_position
	laser_instance.rotation = dir_to_player.angle()
	
	char_body_2d.get_parent().add_child(laser_instance)

func enter():
	player = get_tree().get_nodes_in_group("player")[0] as CharacterBody2D
	max_speed = speed * 20

func exit():
	pass

func _on_laser_timer_timeout() -> void:
	can_shoot = true
