extends Area2D

signal player_entered(player)

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("player_entered", body)
