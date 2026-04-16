extends Node2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var container_anim: AnimationPlayer = $CenterContainer/ContainerAnim
@onready var button_sfx: AudioStreamPlayer = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("TitleMove")
	container_anim.play("Main")
	$CenterContainer/Settings/MasterVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$CenterContainer/Settings/MusicVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$CenterContainer/Settings/SFXVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))


func _on_start_pressed() -> void:
	button_sfx.play()
	animation.play("Start")
	await animation.animation_finished
	get_tree().call_deferred("change_scene_to_file", "res://Levels/tutorial.tscn")


func _on_settings_pressed() -> void:
	button_sfx.play()
	container_anim.play("Settings")


func _on_credits_pressed() -> void:
	button_sfx.play()
	container_anim.play("Credits")
	animation.play("Credits")


func _on_back_pressed() -> void:
	button_sfx.play()
	animation.play("TitleMove")
	container_anim.play("Main")


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	button_sfx.play()
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_master_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_music_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)
