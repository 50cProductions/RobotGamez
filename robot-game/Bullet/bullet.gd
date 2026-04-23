extends MeshInstance2D

var speed = 600
var direction: Vector2

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_timer_timeout() -> void:
	queue_free()
