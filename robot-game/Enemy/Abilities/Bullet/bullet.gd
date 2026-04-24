extends MeshInstance2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 600
var direction: Vector2
var damage_amount = 40

func _ready() -> void:
	animated_sprite_2d.play("default")

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_timer_timeout() -> void:
	queue_free()
	

func get_damage_amount():
	return damage_amount


func _on_hit_box_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_hit_box_body_entered(body: Node2D) -> void:
	queue_free()
