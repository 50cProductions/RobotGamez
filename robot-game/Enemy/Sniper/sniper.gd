extends CharacterBody2D

var bullet = preload("res://Enemy/Abilities/Bullet/bullet.tscn")


@onready var shoot_marker: Marker2D = $"Initial Shoot"

@export var damage_amount = 10

var shoot_marker_posi

func _ready() -> void:
	shoot_marker_posi = shoot_marker.position
	
