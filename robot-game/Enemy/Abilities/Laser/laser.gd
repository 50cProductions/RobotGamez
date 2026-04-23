extends Node2D

var direction: Vector2
var damage_amount = 10
var max_length: float = 200

@onready var line_2d = $Line2D

func _ready() -> void:
	var end_point = Vector2(max_length, 0)
	
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(end_point)
	
	if has_node("HitBox/CollisionShape2D"):
		var shape = SegmentShape2D.new()
		shape.a = Vector2.ZERO
		shape.b = end_point
		$HitBox/CollisionShape2D.shape = shape

func _on_timer_timeout() -> void:
	queue_free()

func get_damage_amount():
	return damage_amount

func _on_hit_box_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func _on_hit_box_body_entered(body: Node2D) -> void:
	pass
