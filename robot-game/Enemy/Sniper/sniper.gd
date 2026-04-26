extends CharacterBody2D

var bullet = preload("res://Enemy/Abilities/Bullet/bullet.tscn")

@onready var shoot_marker: Marker2D = $"Initial Shoot"

@export var damage_amount = 10
@export var max_health = 50
const KNOCKBACK_FORCE = 50.0

var current_health

var shoot_marker_posi

var original_pos: Vector2
func _ready() -> void:
	current_health = max_health
	Taskmanager.computer_hacked.connect(hacked)
	if !Taskmanager.hacked:
		original_pos = global_position
		position = Vector2(100000, 1000000)
	shoot_marker_posi = shoot_marker.position
	

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, 0, 400 * delta)
	move_and_slide()

func hacked():
	global_position = original_pos
	
func take_damage(damage: float, posi: Vector2):
	current_health -= damage
	var direction = 1 if global_position.x > posi.x else -1
	velocity.x = direction * KNOCKBACK_FORCE
	velocity.y = -100
	if current_health <= 0:
		queue_free()
	
	


func _on_hurt_box_area_entered(area: Area2D) -> void:
	# takes damage from player slash attach
	var node = area.get_parent().get_parent().get_parent() as Node
	if area.get_parent().get_parent().get_parent().has_method("get_damage_amount"):
		take_damage(node.get_damage_amount(), node.global_position)
