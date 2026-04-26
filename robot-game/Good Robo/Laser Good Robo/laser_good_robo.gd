extends CharacterBody2D

var good_laser_scene = preload("res://Good Robo/Abilities/Good Laser/good_laser.tscn")

@export var attack_cooldown: float = 2.0
var can_attack: bool = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	# Update sprite orientation based on mouse position
	var mouse_pos = get_global_mouse_position()
	var direction_to_mouse = (mouse_pos - global_position).normalized()
	
	if animated_sprite:
		# Flip horizontal if looking right (assuming default is left-facing)
		animated_sprite.flip_h = direction_to_mouse.x > 0

	if Input.is_action_just_pressed("attack") and can_attack:
		fire_laser()

func fire_laser():
	can_attack = false
	
	var laser = good_laser_scene.instantiate()
	# Fire from the top of the robot (offset -150 to be at the top of the 150px tall sprite)
	laser.global_position = global_position + Vector2(0, -150)
	
	# Direction and distance towards mouse
	var target_pos = get_global_mouse_position()
	var diff = target_pos - laser.global_position
	var direction = diff.normalized()
	var distance = diff.length()
	
	if laser.has_method("setup"):
		laser.setup(direction, distance)
	
	get_parent().add_child(laser)
	
	# Cooldown timer
	get_tree().create_timer(attack_cooldown).timeout.connect(func(): can_attack = true)
