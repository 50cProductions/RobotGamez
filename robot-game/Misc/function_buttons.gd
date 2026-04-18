class_name FunctionButtons
extends Button

@export var title: String
@export_multiline var description: String
@export var locked: bool

var random := RandomNumberGenerator.new()
var temp_description: String

func _ready() -> void:
	if locked:
		title = "???"
		description = "[LOCKED]"
	
