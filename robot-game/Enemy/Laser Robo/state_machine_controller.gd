extends Node

@export var node_sm: NodeSM


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		node_sm.transition("attack")


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		node_sm.transition("idle")
