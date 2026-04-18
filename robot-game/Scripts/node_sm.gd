class_name NodeSM
extends Node

@export var initial_state: NodeState
var states: Dictionary = {}
var current_state: NodeState
var current_state_name: String

func _ready():
	for child in get_children():
		if child is NodeState:
			states[child.name.to_lower()] = child
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	pass
	
func _process(delta: float) -> void:
	if current_state:
		current_state.on_process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.on_physics_process(delta)

func transition(state_name: String):
	if state_name == current_state.name.to_lower():
		return
	
	var new_state = states.get(state_name.to_lower())
	
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
	current_state_name = current_state.name.to_lower()
