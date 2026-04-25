extends ColorRect

func _ready() -> void:
	hide()
	Taskmanager.computer_hacked.connect(hacked)

func hacked():
	if !Taskmanager.hacked:
		show()
		$AnimationPlayer.play("hacking")
		await $AnimationPlayer.animation_finished
		hide()
		Taskmanager.hacked = true
