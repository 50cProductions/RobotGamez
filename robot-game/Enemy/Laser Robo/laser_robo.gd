extends CharacterBody2D

var laser = preload("res://Enemy/Abilities/Laser/laser.tscn")


@onready var shoot_marker: Marker2D = $"Initial Shoot"

var shoot_marker_posi

func _ready() -> void:
	shoot_marker_posi = shoot_marker.position
	
