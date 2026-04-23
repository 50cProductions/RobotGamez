extends CharacterBody2D

var laser = preload("res://Enemy/Abilities/Laser/laser.tscn")
@onready var detection_shape = $DetectionArea/CollisionShape2D

@onready var shoot_marker: Marker2D = $"Initial Shoot"
@export var damage_amount = 10

var shoot_marker_posi

func _ready() -> void:
	shoot_marker_posi = shoot_marker.position
	
