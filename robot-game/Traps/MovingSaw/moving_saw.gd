extends Node2D

enum MovementDirection {HORIZONTAL, VERTICAL, DIAGONAL}

@export_group("Saw Movement")
@export var direction: MovementDirection = MovementDirection.HORIZONTAL
@export var speed: float = 2.0
@export var distance: float = 200.0
@export var start_from_zero: bool = true
@export var reverse_direction: bool = false

@export_group("Saw Size")
@export var width_scale: float = 1.0
@export var height_scale: float = 1.0

@onready var saw_node = $Movingsaw

var time: float = 0.0

func _process(delta):
	if saw_node == null: return
	
	saw_node.scale = Vector2(width_scale, height_scale)
	
	time += delta * speed
	var movement: float
	
	if start_from_zero:
		movement = (1.0 - cos(time)) * (distance / 2.0)
	else:
		movement = sin(time) * distance

	if reverse_direction:
		movement *= -1

	var new_pos = Vector2.ZERO
	
	match direction:
		MovementDirection.HORIZONTAL:
			new_pos.x = movement
		MovementDirection.VERTICAL:
			new_pos.y = movement
		MovementDirection.DIAGONAL:
			new_pos.x = movement
			new_pos.y = movement
			
	saw_node.position = new_pos
	saw_node.rotation += delta * 10

func _on_movingsaw_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage(35, global_position)
