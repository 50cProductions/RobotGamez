extends CharacterBody2D

var bullet = preload("res://Enemy/Abilities/Bullet/bullet.tscn")

@onready var shoot_marker: Marker2D = $"Initial Shoot"

@export var damage_amount = 10

var shoot_marker_posi

var original_pos: Vector2
func _ready() -> void:
	Taskmanager.computer_hacked.connect(hacked)
	if !Taskmanager.hacked:
		original_pos = global_position
		position = Vector2(100000, 1000000)
	shoot_marker_posi = shoot_marker.position
	

func hacked():
	position = original_pos
