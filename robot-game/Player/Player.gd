extends CharacterBody2D

# Stats


# Node References
@export var camera: Camera2D

@onready var CharacterSprite := $AnimatedSprite2D
@onready var AttackParent := $Attack
@onready var AttackSprite := $Attack/Slash
@onready var AttackArea := $Attack/Slash/AttackArea2D

# UI References
@onready var health_bar = $CanvasLayer/CanvasLayer/ProgressBar
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

const KNOCKBACK_FORCE = 500.0

var can_dash: bool = true
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO 

var attack_num: int

var is_invincible: bool = false
const INVINCIBILITY_DURATION: float = 1.0 # مدة المناعة (ثانية واحدة)


func _ready() -> void:
	print(Taskmanager.current_health)
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
	Taskmanager.start_position = global_position
	add_to_group("player")
	AttackArea.get_node("CollisionShape2D").disabled = true
	AttackArea.connect("area_entered", _attack_area_hit)
	AttackArea.connect("body_entered", _attack_area_hit)
	
	Taskmanager.spiked.connect(spiked)
	camera.top_level = true
	_update_health_ui()
	

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
	
	
	#ANIMATIONS!!!
	if !Input.is_action_just_pressed("attack"):
		if is_on_floor():
			if velocity.x != 0:
				CharacterSprite.play("Walk")
			else :
				CharacterSprite.play("Idle") 
		else :
			if is_on_wall() and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
				CharacterSprite.play("WallGrab")
			else:
				CharacterSprite.play("Jump")
	
	else :
		CharacterSprite.play("Attack")
	
	
	if x_input:
		look_dir.x = x_input
	var y_input: float = Input.get_axis("up", "down")
	look_dir.y = y_input
	
	if look_dir > Vector2(0, 0):
		CharacterSprite.flip_h = false
		AttackSprite.flip_v = false
	elif look_dir < Vector2(0, 0):
		CharacterSprite.flip_h = true
		AttackSprite.flip_v = true
	
	
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
			
			CharacterSprite.play("Attack")
			
			if attack_num == 0:
				AttackSprite.play("Slash1")
				attack_num = 2
			elif attack_num == 1:
				AttackSprite.play("Slash1")
				attack_num = 2
			elif attack_num == 2:
				AttackSprite.play("Slash2")
				attack_num = 1
			

	else :
		attack_duration_timer = max(0.0, attack_duration_timer - delta)
		if attack_duration_timer == 0.0:
			AttackArea.get_node("CollisionShape2D").disabled = true
			
			

func _attack_area_hit(target_node: Node) -> void:
	if target_node == self:
		return
	
	if (target_node.is_in_group("pogoable") or target_node.get_parent() and target_node.get_parent().is_in_group("pogoable")) and not is_on_floor():\
	velocity.y = JUMP_VELOCITY
	
func take_damage(amount: int, trap_pos: Vector2):
	if is_invincible:
		return
	
	is_invincible = true
	Taskmanager.current_health -= amount
	
	var direction = 1 if global_position.x > trap_pos.x else -1
	velocity.x = direction * KNOCKBACK_FORCE
	velocity.y = -250
	
	move_and_slide()
	_update_health_ui()
	
	if Taskmanager.current_health <= 0:
		handle_respawn()
	else:
		start_invincibility_timer()

func _update_health_ui():
	if health_bar:
		health_bar.value = Taskmanager.current_health
		var new_style = health_bar.get_theme_stylebox("fill").duplicate()
		if Taskmanager.current_health <= 30:
			new_style.bg_color = Color(1, 0, 0)
		elif Taskmanager.current_health <= 60:
			new_style.bg_color = Color(1, 1, 0)
		else:
			new_style.bg_color = Color(0, 1, 0)
		health_bar.add_theme_stylebox_override("fill", new_style)

func handle_respawn():
	Taskmanager.lives -= 1
	is_invincible = false
	CharacterSprite.modulate.a = 1.0
	
	if Taskmanager.lives > 0:
		Taskmanager.current_health = Taskmanager.max_health
		_update_health_ui()
		get_tree().reload_current_scene()
	else:
		game_over()

func start_invincibility_timer():
	var tween = create_tween().set_loops(5)
	tween.tween_property(CharacterSprite, "modulate:a", 0.5, 0.1)
	tween.tween_property(CharacterSprite, "modulate:a", 1.0, 0.1)
	
	await get_tree().create_timer(INVINCIBILITY_DURATION).timeout
	is_invincible = false
	CharacterSprite.modulate.a = 1.0

func spiked():
	global_position = Taskmanager.start_position 

func game_over():
	get_tree().change_scene_to_file("res://UI/GameOverScreen.tscn")


func _on_hurt_box_body_entered(body: Node2D) -> void:
	print("entered enemy")
	if body.is_in_group("enemy"):
		print("dealing damage")
		take_damage(body.damage_amount, global_position)
		
