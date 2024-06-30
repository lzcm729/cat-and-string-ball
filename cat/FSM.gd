extends Node

@export var initial_state : State
@onready var character : CharacterBody2D = get_parent()

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Transitioned.connect(on_child_transitioned)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
			
#func _process(delta):
	#if current_state:
		#current_state.Update(delta)
		#
#func _physics_process(delta):
	#if current_state:
		#current_state.PhysicsUpdate(delta)

func on_child_transitioned(state, new_state_id):
	if state != current_state: return
	
	var new_state = states.get(new_state_id)
	if not new_state: return 
	
	if current_state:
		current_state.Leave()
	
	new_state.Enter()

	current_state = new_state
