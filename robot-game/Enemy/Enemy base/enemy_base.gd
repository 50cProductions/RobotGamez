extends CharacterBody2D

# This is still work in progress not yet completed guys
@onready var timer = $Timer

@export var speed := 2000
@export var movement_range: Node
@export var wait_time = 1

const GRAVITY = 1000

enum State {
	IDLE,
	WALK
}

var current_state: State
var direction: Vector2 = Vector2.LEFT

var range_size: int
var point_positions: Array[Vector2]
var current_point: Vector2
var current_point_position: int

var can_walk: bool


func _ready():
	if movement_range != null:
		range_size = movement_range.get_children().size()
		for point in movement_range.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No movement range defined")
	
	timer.wait_time = wait_time
			
	current_state = State.IDLE
	

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	idle_behavior(delta)
	walk_behavior(delta)
		
	move_and_slide()


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		

func idle_behavior(delta: float):
	velocity.x = move_toward(velocity.x, 0, speed * delta)
	current_state = State.IDLE

func walk_behavior(delta: float):
	if !can_walk:
		return
		
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = State.WALK
	else:
		current_point_position += 1
		if current_point_position >= range_size:
			current_point_position = 0
		
		current_point = point_positions[current_point_position]

		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		can_walk = false
		timer.start()


func _on_timer_timeout() -> void:
	can_walk = true
