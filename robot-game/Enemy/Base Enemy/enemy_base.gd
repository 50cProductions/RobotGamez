extends CharacterBody2D

# This is still work in progress not yet completed guys

@export var max_health := 100
@export var speed := 25

var health := max_health
var target = null

enum State {
	IDLE,
	DEFAULT,
	CHASE,
	ATTACK
}

var current_state = State.IDLE

func _ready():
	for area in $DetectionAreas.get_children():
		if area.has_signal("player_entered"):
			area.player_entered.connect(_on_player_detected)

func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			idle_behavior()
		State.CHASE:
			chase_behavior(delta)
		State.ATTACK:
			attack_behavior()

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
	velocity = direction * speed
	move_and_slide()

func attack_behavior():
	pass # attack logic

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()
		

func die():
	queue_free()


func _on_player_detection_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_player_detection_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
