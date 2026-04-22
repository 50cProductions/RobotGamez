extends Node2D

@onready var ray_cast = $RayCast2D
@onready var line = $Line2D
@onready var particles = $CPUParticles2D

func _process(_delta):
	line.modulate.a = randf_range(0.4, 1.0)
	line.points[0] = Vector2.ZERO
	
	if ray_cast.is_colliding():
		var point = ray_cast.get_collision_point()
		line.points[1] = to_local(point)
		particles.position = to_local(point)
		particles.emitting = true
	else:
		line.points[1] = ray_cast.target_position
		particles.emitting = false

func _on_damage_area_body_entered(body: Node2D) -> void:
		if body.has_method("take_damage"):
			body.take_damage(20, global_position)
