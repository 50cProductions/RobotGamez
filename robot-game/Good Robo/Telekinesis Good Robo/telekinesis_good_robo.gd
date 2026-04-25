extends CharacterBody2D

var player: Node2D
var grabbed_object: Node2D = null

@export var follow_offset: Vector2 = Vector2(-60, -40)
@export var follow_speed: float = 5.0
@export var grab_speed: float = 15.0

# Configure this to grab things
@export_flags_2d_physics var grab_mask: int = 0 

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Find player if not already assigned
	if !player:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
		else:
			# Fallback: try to find by name if group fails
			player = get_parent().get_node_or_null("Player")
	
	if animated_sprite:
		animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	if grabbed_object:
		if is_instance_valid(grabbed_object):
			grabbed_object.global_position = grabbed_object.global_position.lerp(get_global_mouse_position(), delta * grab_speed)
			
			# If it's a CharacterBody2D, we might want to reset its velocity so it doesn't fight the movement
			if grabbed_object is CharacterBody2D:
				grabbed_object.velocity = Vector2.ZERO
			
			# Animation for grabbing
			if animated_sprite.animation != "attack_left":
				animated_sprite.play("attack_left")
			
			# Face the mouse while grabbing (Inverted flip logic because sprite default is left)
			var mouse_dir = (get_global_mouse_position() - global_position).normalized()
			animated_sprite.flip_h = mouse_dir.x > 0
		else:
			grabbed_object = null
	else:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

	# Handle grabbing/dropping
	if Input.is_action_just_pressed("attack"):
		if grabbed_object:
			release_object()
		else:
			try_grab_object()

func try_grab_object() -> void:
	var mouse_pos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	
	# Use a small circle query instead of a point to make grabbing easier
	var query = PhysicsShapeQueryParameters2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 30.0 # Grabbing tolerance
	query.shape = circle
	query.transform = Transform2D(0, mouse_pos)
	query.collision_mask = grab_mask
	query.collide_with_bodies = true
	query.collide_with_areas = true
	
	var results = space_state.intersect_shape(query)
	
	for result in results:
		var collider = result.collider
		if collider is Node2D and collider != self:
			# Immunity checks
			if collider.is_in_group("telekinesis_immune"):
				continue
			if "telekinesis_immune" in collider and collider.telekinesis_immune:
				continue
				
			grabbed_object = collider
			
			# Visual feedback or disabling logic
			if grabbed_object.has_node("Gravity"):
				grabbed_object.get_node("Gravity").set_physics_process(false)
			
			break

func release_object() -> void:
	if grabbed_object and is_instance_valid(grabbed_object):
		if grabbed_object.has_node("Gravity"):
			grabbed_object.get_node("Gravity").set_physics_process(true)
	
	grabbed_object = null
