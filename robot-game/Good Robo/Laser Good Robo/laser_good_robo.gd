extends CharacterBody2D

var good_laser_scene = preload("res://Good Robo/Abilities/Good Laser/good_laser.tscn")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		fire_laser()

func fire_laser():
	var laser = good_laser_scene.instantiate()
	laser.global_position = global_position
	
	# Direction towards mouse
	var target_pos = get_global_mouse_position()
	var direction = (target_pos - global_position).normalized()
	
	if laser.has_method("setup"):
		laser.setup(direction)
	
	get_parent().add_child(laser)
