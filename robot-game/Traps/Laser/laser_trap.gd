extends Node2D

# تعريف المتغيرات التي ستتحكم بها من اليمين (Inspector)
@export_enum("Down", "Up", "Right", "Left") var direction: String = "Down"
@export var laser_length: int = 300
@export var laser_color: Color = Color.RED

# العقد الداخلية
@onready var ray_cast = $RayCast2D
@onready var line = $Line2D
@onready var particles = $CPUParticles2D

func _ready():
	# هذا السطر يضمن عدم حدوث خطأ عند بدء اللعبة
	update_laser_setup()

func update_laser_setup():
	if not ray_cast or not line: return
	
	# ضبط لون الخط
	line.default_color = laser_color
	
	# ضبط اتجاه وطول الليزر
	match direction:
		"Down": ray_cast.target_position = Vector2(0, laser_length)
		"Up": ray_cast.target_position = Vector2(0, -laser_length)
		"Right": ray_cast.target_position = Vector2(laser_length, 0)
		"Left": ray_cast.target_position = Vector2(-laser_length, 0)
	
	# جعل نهاية الخط عند نهاية المستشعر مبدئياً
	line.points[1] = ray_cast.target_position

func _process(_delta):
	# تحديث شكل الليزر وتأثير الوميض
	line.modulate.a = randf_range(0.4, 1.0)
	line.points[0] = Vector2.ZERO
	
	if ray_cast.is_colliding():
		var collision_point = ray_cast.get_collision_point()
		var local_point = to_local(collision_point)
		
		line.points[1] = local_point
		particles.position = local_point
		particles.emitting = true
		
		# إذا لمس الليزر اللاعب (تأكد أن اللاعب في Collision Layer الصحيح)
		var target = ray_cast.get_collider()
		if target.is_in_group("player"):
			get_tree().reload_current_scene()
	else:
		line.points[1] = ray_cast.target_position
		particles.emitting = false
