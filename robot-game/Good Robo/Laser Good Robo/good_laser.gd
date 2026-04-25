extends Node2D

@onready var line_2d = $Line2D
@onready var hit_box = $HitBox
@onready var collision_shape = $HitBox/CollisionShape2D

@export var damage: int = 200
@export var beam_duration: float = 0.5

var is_active: bool = true

func _ready() -> void:
	# Start with zero width and animate it
	var original_width = line_2d.width
	line_2d.width = 0
	
	var tween = create_tween()
	# Grow fast
	tween.tween_property(line_2d, "width", original_width * 1.5, 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	# Fade out
	tween.tween_property(line_2d, "width", 0, beam_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(finish_beam)
	
	# Initial damage check
	apply_beam_damage()

func setup(dir: Vector2, distance: float):
	rotation = dir.angle()
	
	# Set line length
	$Line2D.points[1] = Vector2(distance, 0)
	
	# Set hitbox length
	var shape = RectangleShape2D.new()
	shape.size = Vector2(distance, 40)
	$HitBox/CollisionShape2D.shape = shape
	$HitBox/CollisionShape2D.position.x = distance / 2.0

func apply_beam_damage():
	# Area2D might need a frame or two to update overlapping objects
	# We'll check for a few frames while the beam is "hot"
	for i in range(5):
		if !is_inside_tree(): return
		
		var bodies = hit_box.get_overlapping_bodies()
		for body in bodies:
			handle_damage(body)
				
		var areas = hit_box.get_overlapping_areas()
		for area in areas:
			handle_damage(area)
			
		await get_tree().process_frame

func handle_damage(target: Node):
	# Basic check to avoid double damage in the loop
	if !target.has_meta("hit_by_beam_" + str(get_instance_id())):
		if target.is_in_group("enemy") or (target.get_parent() and target.get_parent().is_in_group("enemy")):
			var enemy = target if target.is_in_group("enemy") else target.get_parent()
			if enemy.has_method("take_damage"):
				enemy.take_damage(damage, global_position)
				target.set_meta("hit_by_beam_" + str(get_instance_id()), true)

func _on_hit_box_body_entered(body: Node2D) -> void:
	handle_damage(body)

func _on_hit_box_area_entered(area: Area2D) -> void:
	handle_damage(area)

func finish_beam():
	is_active = false
	queue_free()
