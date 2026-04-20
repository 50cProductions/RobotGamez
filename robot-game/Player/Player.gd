extends CharacterBody2D

@export var camera: Camera2D

@onready var AttackParent := $Attack
@onready var AttackSprite := $Attack/MeshInstance2D
@onready var AttackArea := $Attack/MeshInstance2D/AttackArea2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5

const GRAVITY_NORMAL: float = 14.5
const GRAVITY_WALL: float = 8.5
const WALL_JUMP_PUSH_FORCE: float = 100.0

var wall_contact_coyote: float = 0.0
const WALL_CONTACT_COYOTE_TIME: float = 0.2

var wall_jump_lock: float = 0.0
const WALL_JUMP_LOCK_TIME: float = 0.05

var look_dir: Vector2 = Vector2.RIGHT
var was_in_air = false

var TotalAttackDuration: float = 0.25
var attack_duration_timer: float = 0.0
var attack_distance: float = 90.0

const DASH_SPEED: float = 700.0
const DASH_DURATION: float = 0.15
const DASH_COOLDOWN: float = 0.4

var can_dash: bool = true
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO 



func _ready() -> void:
	if Taskmanager.activate:
		global_position = Taskmanager.PlayerPos
		if Taskmanager.PlayerJumpOnEnter:
			velocity.y = JUMP_VELOCITY
			var jump_tween = create_tween()
			jump_tween.tween_property(self, "scale",
			Vector2(0.8, 1.25), 0.1)
			jump_tween.chain().tween_property(self, "scale",
			Vector2(1.0, 1.0), 0.1)
		Taskmanager.activate = false
	
	add_to_group("player")
	AttackSprite.modulate.a = 0.0
	AttackArea.get_node("CollisionShape2D").disabled = true
	AttackArea.connect("area_entered", _attack_area_hit)
	AttackArea.connect("body_entered", _attack_area_hit)
	camera.top_level = true

func _physics_process(delta: float) -> void:
	# Dash timers
	dash_timer = max(dash_timer - delta, 0.0)
	dash_cooldown_timer = max(dash_cooldown_timer - delta, 0.0)
	if dash_timer <= 0.0 and is_on_floor() or is_on_wall():
		can_dash = true

	# Start dash
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		dash_timer = DASH_DURATION
		dash_cooldown_timer = DASH_COOLDOWN
		
		dash_direction = look_dir.normalized()
		if dash_direction == Vector2.ZERO:
			dash_direction = Vector2(sign(velocity.x) if velocity.x != 0 else 1, 0)

	# DASH OVERRIDE
	if dash_timer > 0.0:
		velocity = dash_direction * DASH_SPEED
		move_and_slide()
		return

	var x_input: float = Input.get_axis("left", "right") 
	var velocity_weight_x: float = 1.0 - exp(-(ACCELERATION if x_input else FRICTION) * delta)
	velocity.x = lerp(velocity.x, x_input * SPEED, velocity_weight_x)
	 
	if x_input:
		look_dir.x = x_input
	var y_input: float = Input.get_axis("up", "down")
	look_dir.y = y_input
	
	if wall_jump_lock > 0.0:
		wall_jump_lock -= delta
		velocity.x = lerp(velocity.x, x_input * SPEED, velocity_weight_x * 0.5)
	else :
		velocity.x = lerp(velocity.x, x_input * SPEED, velocity_weight_x)
	
	#Wall Jump & Slide
	if is_on_floor() or wall_contact_coyote > 0.0:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			var jump_tween = create_tween()
			jump_tween.tween_property(self, "scale",
			Vector2(0.8, 1.25), 0.1)
			jump_tween.chain().tween_property(self, "scale",
			 Vector2(1.0, 1.0), 0.1)
			if wall_contact_coyote > 0.0:
				velocity.x = -look_dir.x * WALL_JUMP_PUSH_FORCE
				wall_jump_lock = WALL_JUMP_LOCK_TIME
	
	if !is_on_floor() and velocity.y > 0 and is_on_wall() and velocity.x != 0:
		look_dir.x = sign(velocity.x)
		wall_contact_coyote = WALL_CONTACT_COYOTE_TIME
		velocity.y = GRAVITY_WALL
	else:
		wall_contact_coyote -= delta
		velocity.y += GRAVITY_NORMAL
	
	_attack_logic(delta)
	move_and_slide()
	
	# Handle squash and stretch effect on landing for better game feel
	if is_on_floor():
		if was_in_air:
			var squash_tween = create_tween()
			squash_tween.tween_property(self, "scale",
			Vector2(1.25, 0.75), 0.1)
			squash_tween.chain().tween_property(self, "scale", 
			Vector2(1.0, 1.0), 0.1)
			was_in_air = false
	else:
			was_in_air = true
	
	# Camera Look Ahead logic
	var target_offset = 100.0
	if velocity.x > 0:
		camera.offset.x = lerp(camera.offset.x, target_offset, 0.05)
	elif velocity.x < 0:
		camera.offset.x = lerp(camera.offset.x, -target_offset, 0.05)


func _attack_logic(delta: float) -> void:
	if attack_duration_timer == 0.0:
		if Input.is_action_just_pressed("attack"):
			if look_dir.y and (look_dir.y < 0 or !is_on_floor()):
				AttackParent.rotation_degrees = 90 if look_dir.y > 0 else  -90
			else:
				AttackParent.rotation_degrees = 0 if look_dir.x > 0 else 180
			
			AttackArea.get_node("CollisionShape2D").disabled = false
			attack_duration_timer = TotalAttackDuration
			AttackSprite.position.x = 0.0
			
			var attack_pos_tween: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			attack_pos_tween.tween_property(AttackSprite, "position:x", attack_distance, TotalAttackDuration)
			var attack_modulate_tween: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			attack_modulate_tween.tween_property(AttackSprite, "modulate:a", 1.0, TotalAttackDuration * 0.1)
			attack_modulate_tween.chain().tween_property(AttackSprite, "modulate:a", 0.0, TotalAttackDuration * 0.9)
	else :
		attack_duration_timer = max(0.0, attack_duration_timer - delta)
		if attack_duration_timer == 0.0:
			AttackArea.get_node("CollisionShape2D").disabled = true
			
			

func _attack_area_hit(target_node: Node) -> void:
	if target_node == self:
		return
	
	if (target_node.is_in_group("pogoable") or target_node.get_parent() and target_node.get_parent().is_in_group("pogoable")) and not is_on_floor():\
	velocity.y = JUMP_VELOCITY
