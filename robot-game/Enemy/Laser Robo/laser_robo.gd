extends CharacterBody2D

var laser = preload("res://Enemy/Abilities/Laser/laser.tscn")
<<<<<<< Updated upstream
@onready var detection_shape = $DetectionArea/CollisionShape2D

@onready var shoot_marker: Marker2D = $"Initial Shoot"
@export var damage_amount = 10
=======

@onready var animation := $AnimationPlayer
@onready var shoot_marker: Marker2D = $"Initial Shoot"
@onready var look := $Look
>>>>>>> Stashed changes

var shoot_marker_posi

func _ready() -> void:
	animation.play("idle")
	shoot_marker_posi = shoot_marker.position
	
