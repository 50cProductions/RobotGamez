extends CharacterBody2D

var bullet = preload("res://Bullet/bullet.tscn")


@onready var shoot_marker: Marker2D = $"Initial Shoot"

var shoot_marker_posi

func _ready() -> void:
	shoot_marker_posi = shoot_marker.position
	
