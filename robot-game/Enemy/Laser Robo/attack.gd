extends NodeState

@onready var laser_reset_timer = $"../../Laser Reset Timer"
@onready var sprite: Sprite2D = $"../../Sprite"

@export var laser_enemy: CharacterBody2D
@export var speed: int
var player: CharacterBody2D
var max_speed: int
var can_shoot = false

func on_process(delta: float):
	pass

func on_physics_process(delta: float) -> void:
	var direction: int
	
	if laser_enemy.global_position > player.global_position:
		direction = -1
		sprite.flip_h = true
	elif laser_enemy.global_position < player.global_position:
		direction = 1
		sprite.flip_h = false
	if direction > 0:
		laser_enemy.shoot_marker.position.x = laser_enemy.shoot_marker_posi.x
	elif direction < 0:
		laser_enemy.shoot_marker.position.x = -laser_enemy.shoot_marker_posi.x
	
	if can_shoot:
		action_shoot(delta, direction)
		can_shoot = false
		laser_reset_timer.start()
		
	laser_enemy.move_and_slide()


func action_shoot(delta: float, direction: int):
	var laser_instance = laser_enemy.laser.instantiate() as Node2D
	var calculated_laser_length = laser_enemy.detection_shape.shape.size.x / 2.0
	laser_instance.max_length = calculated_laser_length
	var offset = player.global_position + Vector2(0, -16)
	var dir_to_player = (offset - laser_enemy.shoot_marker.global_position).normalized()
	laser_instance.direction = dir_to_player
	laser_instance.global_position = laser_enemy.shoot_marker.global_position
	laser_instance.rotation = dir_to_player.angle()
	
	laser_enemy.get_parent().add_child(laser_instance)
	

func enter():
	player = get_tree().get_nodes_in_group("player")[0] as CharacterBody2D
	max_speed = speed * 20

func exit():
	pass


func _on_bullet_timer_timeout() -> void:
	can_shoot = true
