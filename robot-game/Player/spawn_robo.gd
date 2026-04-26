extends Node

var laser_good_robo_scene = preload("res://Good Robo/Laser Good Robo/laser_good_robo.tscn")
var telekinesis_good_robo_scene = load("res://Good Robo/Telekinesis Good Robo/telekinesis_good_robo.tscn")

@export var player: CharacterBody2D

var current_robo: Node2D

func _physics_process(_delta: float) -> void:
	if Taskmanager.hacked:
		handle_spawn()
		handle_despawn()

func handle_despawn() -> void:
	if Input.is_action_just_pressed("despawn_robo") and player.robo_available:
		if is_instance_valid(current_robo):
			current_robo.queue_free()
		current_robo = null
		player.robo_available = false

func handle_spawn() -> void:
	if player.robo_available:
		return
		
	if Input.is_action_just_pressed("spawn_robo"):
		spawn_robo(laser_good_robo_scene)
	elif Input.is_action_just_pressed("spawn_telekinesis_robo"):
		spawn_robo(telekinesis_good_robo_scene)

func spawn_robo(scene: PackedScene) -> void:
	current_robo = scene.instantiate() as Node2D
	current_robo.global_position = player.global_position
	player.get_parent().add_child(current_robo)
	player.robo_available = true
