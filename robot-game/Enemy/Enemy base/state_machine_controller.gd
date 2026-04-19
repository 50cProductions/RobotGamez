extends Node

@export var node_sm: NodeSM
@export var timer: Timer

func _on_walk_point_reached() -> void:
	node_sm.transition("idle")


func _on_timer_timeout() -> void:
	node_sm.transition("walk")
