extends Node2D

@export var speed: float = 600.0
@export var damage: int = 50
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)

func setup(dir: Vector2):
	direction = dir
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage, global_position)
		queue_free()

func _on_hit_box_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("enemy"):
		if parent.has_method("take_damage"):
			parent.take_damage(damage, global_position)
		queue_free()
	elif area.is_in_group("enemy"):
		if area.has_method("take_damage"):
			area.take_damage(damage, global_position)
		queue_free()
