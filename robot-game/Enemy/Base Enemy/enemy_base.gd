extends CharacterBody2D

# This is still work in progress not yet completed guys

@export var max_health := 100
@export var speed := 50

var health := max_health
var target = null
const GRAVITY: float = 14.5

enum State {
	IDLE,
	DEFAULT,
	CHASE,
	ATTACK
}

var current_state = State.IDLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	match current_state:
		State.IDLE:
			idle_behavior()
		State.CHASE:
			chase_behavior(delta)
		State.ATTACK:
			attack_behavior()
			
	move_and_slide()

func _on_player_detected(player):
	target = player
	

func default_behavior():
	print("Default Behavior")
	current_state = State.IDLE
	

func idle_behavior():
	velocity = Vector2.ZERO

func chase_behavior(delta):
	if target == null:
		current_state = State.IDLE
		return
	var direction = (target.global_position - global_position).normalized()
	velocity.x = direction.x * speed

func attack_behavior():
	pass # attack logic

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()
		

func die():
	queue_free()


func _on_player_detection_body_entered(body: Node2D) -> void:
	print("Signal Detected body entered")
	target = body
	current_state = State.CHASE


func _on_player_detection_body_exited(body: Node2D) -> void:
	print("Signal Detected body exited")
	current_state = State.IDLE
	target = null
