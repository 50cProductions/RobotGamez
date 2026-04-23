extends CharacterBody2D

# This is still work in progress not yet completed guys
@onready var timer = $Timer

@export var speed := 2000
@export var movement_range: Node
@export var wait_time = 1
@export var damage_amount = 10

const GRAVITY = 1000

var direction: Vector2 = Vector2.LEFT

var range_size: int
var point_positions: Array[Vector2]
var current_point: Vector2
var current_point_position: int


func _ready():
	if movement_range != null:
		range_size = movement_range.get_children().size()
		for point in movement_range.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No movement range defined")
	
	timer.wait_time = wait_time
