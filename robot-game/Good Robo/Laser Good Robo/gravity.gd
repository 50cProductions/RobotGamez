extends Node

@export var char_body_2d: CharacterBody2D

const GRAVITY = 1000

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	char_body_2d.move_and_slide()

func apply_gravity(delta):
	if !char_body_2d.is_on_floor():
		char_body_2d.velocity.y += GRAVITY * delta
