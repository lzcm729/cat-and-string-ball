class_name InputComponent
extends Node


var input_horizontal: float = 0.


func _process(_delta: float) -> void:
	input_horizontal = Input.get_axis("move_left", "move_right")
	if input_horizontal == 1:
		get_parent().orientation = 1
	elif input_horizontal == -1:
		get_parent().orientation = -1
	else:
		pass

func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")

func get_hit_input() -> bool:
	return Input.is_action_just_pressed("hit")
