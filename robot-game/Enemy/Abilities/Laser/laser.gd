extends RayCast2D

var direction: Vector2
var max_length: float = 2000.0

@onready var line_2d = $Line2D

func _ready() -> void:
	target_position = Vector2(max_length, 0)
	force_raycast_update()
	
	var cast_point = target_position
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		var collider = get_collider()
		if collider and collider.is_in_group("player"):
			if collider.has_method("take_damage"):
				collider.take_damage(10, global_position)
	
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(cast_point)


func _on_timer_timeout() -> void:
	queue_free()
