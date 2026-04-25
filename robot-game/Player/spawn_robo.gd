extends Node

var laser_good_robo_scene = preload("res://Good Robo/Laser Good Robo/laser_good_robo.tscn")

@export var player: CharacterBody2D

var laser_good_robo

func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	spawn_laser_robo()
	despawn_laser_robo()
	

func despawn_laser_robo():
	if !can_despawn_laser_robo():
		return
	
	laser_good_robo.queue_free()
	laser_good_robo = null
	player.robo_available = false
	

func spawn_laser_robo():
	if !can_spawn_robo_laser():
		return
		
	laser_good_robo = laser_good_robo_scene.instantiate() as Node2D
	player.get_parent().add_child(laser_good_robo)
	player.robo_available = true

func can_despawn_laser_robo():
	return Input.is_action_just_pressed("despawn_robo") && player.robo_available

func can_spawn_robo_laser():
	return Input.is_action_just_pressed("spawn_robo") && !player.robo_available
