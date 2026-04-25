extends CharacterBody2D

var good_laser_scene = preload("res://Good Robo/Abilities/Good Laser/good_laser.tscn")

@export var attack_cooldown: float = 2.0
var can_attack: bool = true

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack") and can_attack:
		fire_laser()

func fire_laser():
	can_attack = false
	
	var laser = good_laser_scene.instantiate()
	laser.global_position = global_position
	
	# Direction and distance towards mouse
	var target_pos = get_global_mouse_position()
	var diff = target_pos - global_position
	var direction = diff.normalized()
	var distance = diff.length()
	
	if laser.has_method("setup"):
		laser.setup(direction, distance)
	
	get_parent().add_child(laser)
	
	# Cooldown timer
	get_tree().create_timer(attack_cooldown).timeout.connect(func(): can_attack = true)
