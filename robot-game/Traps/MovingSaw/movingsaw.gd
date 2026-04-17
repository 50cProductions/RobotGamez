extends Area2D

# 1. متغيرات التحكم (تظهر في Inspector)
@export var speed: float = 100.0         # سرعة التحرك
@export var distance: float = 200.0      # المسافة المقطوعة
@export var rotation_speed: float = 10.0  # سرعة الدوران

# 2. متغيرات داخلية للحساب
var start_x: float
var direction: int = 1

# يتم استدعاؤها عند بدء اللعبة
func _ready() -> void:
	start_x = position.x

# يتم استدعاؤها في كل إطار (Frame)
func _process(delta: float) -> void:
	# جعل المنشار يدور حول نفسه
	$Sprite2D.rotation += rotation_speed * delta
	
	# تحريك المنشار يميناً ويساراً
	position.x += speed * direction * delta
	
	# عكس الاتجاه عند الوصول لنهاية المسافة
	if position.x > start_x + distance:
		direction = -1
	elif position.x < start_x:
		direction = 1

# يتم استدعاؤها عند لمس اللاعب للمنشار
func _on_body_entered(body: Node2D) -> void:
	# تأكد من ربط هذه الدالة عبر تبويب Node كما فعلنا سابقاً
	get_tree().reload_current_scene()
