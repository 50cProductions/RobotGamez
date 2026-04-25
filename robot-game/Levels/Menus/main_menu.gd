extends Node2D

#Welcome to the hivemind :D

#Main Variables
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var container_anim: AnimationPlayer = $CenterContainer/ContainerAnim
@onready var button_sfx: AudioStreamPlayer = $Button
@onready var missions: CarouselContainer = $CenterContainer/Missions

#Robot Variables
@onready var robots: CarouselContainer = $CenterContainer/Robots
@onready var craft: Button = $CenterContainer/Robots/Craft
@onready var desc_robot: RichTextLabel = $CenterContainer/Robots/Desc
@onready var inven_activate_animation: AnimationPlayer = $CenterContainer/Robots/Inventory/InvenAnimation
@onready var inven_numbers: RichTextLabel = $CenterContainer/Robots/Inventory/Numbers


var can_craft: bool

var inven_activated: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Taskmanager.hacked = false
	animation.play("TitleMove")
	container_anim.play("Main")
	$CenterContainer/Settings/MasterVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$CenterContainer/Settings/MusicVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$CenterContainer/Settings/SFXVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	

func _process(delta: float) -> void:
	robot_details()

#Main Buttons
func _on_start_pressed() -> void:
	button_sfx.play()
	container_anim.play("Select")
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



#Settings
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



#Select
func _on_robots_pressed() -> void:
	button_sfx.play()
	container_anim.play("RobotDetails")
func _on_missions_pressed() -> void:
	button_sfx.play()
	container_anim.play("Missions")
func _on_back_select_pressed() -> void:
	button_sfx.play()
	container_anim.play("Select")


#Robot's
func _on_craft_pressed() -> void:
	if robots.selected_index == 0:
		Taskmanager.metal -= 10
		Taskmanager.Robot1 = true
	if robots.selected_index == 1:
		Taskmanager.metal -= 10
		Taskmanager.Robot2 = true
	if robots.selected_index == 2:
		Taskmanager.metal -= 10
		Taskmanager.Robot3 = true
	if robots.selected_index == 3:
		Taskmanager.metal -= 10
		Taskmanager.Robot4 = true

func robot_details() -> void:
	if robots.selected_index == 0:
		desc_robot.text = "Details:
Robot 1 is very cool"
		
		#Craft
		if Taskmanager.metal >= 10:
			can_craft = true
		else:
			can_craft = false
		
		if Taskmanager.Robot1:
			craft.text = "crafted"
			craft.disabled = true
		else:
			craft.text = "Craft"
			craft.disabled = false
			
	if robots.selected_index == 1:
		desc_robot.text = "Details:
Robot 2 is very cool"
		
		#Craft
		if Taskmanager.metal >= 10:
			can_craft = true
		else:
			can_craft = false
		
		if Taskmanager.Robot2:
			craft.text = "crafted"
			craft.disabled = true
		else:
			craft.text = "Craft"
			craft.disabled = false
			
	if robots.selected_index == 2:
		desc_robot.text = "Details:
Robot 3 is very cool"
		
		#Craft
		if Taskmanager.metal >= 10:
			can_craft = true
		else:
			can_craft = false
		
		if Taskmanager.Robot3:
			craft.text = "crafted"
			craft.disabled = true
		else:
			craft.text = "Craft"
			craft.disabled = false
			
	if robots.selected_index == 3:
		desc_robot.text = "Details:
Robot 4 is very cool"
		
		#Craft
		if Taskmanager.metal >= 10:
			can_craft = true
		else:
			can_craft = false
		
		if Taskmanager.Robot4:
			craft.text = "crafted"
			craft.disabled = true
		else:
			craft.text = "Craft"
			craft.disabled = false
	
	if can_craft:
		craft.disabled = false
	else:
		craft.disabled = true
	
	inven_numbers.text = str(Taskmanager.metal) + "\n" + str(Taskmanager.copper) + "\n" + str(Taskmanager.helliorb) + "\n" + str(Taskmanager.gunpowder) + "\n" + str(Taskmanager.raycrystal)  


#Inventory
func _on_inven_activate_pressed() -> void:
	if !inven_activated:
		inven_activate_animation.play("Activate")
		inven_activated = true
	else:
		inven_activate_animation.play("Deactive")
		inven_activated = false


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/WinScreen.tscn")
