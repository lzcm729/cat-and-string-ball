extends Node

var is_first_in = true
var level_2 = false
var level_3 = false
var level_4 = false
var level_5 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func check_is_first_in():
	if is_first_in:
		get_tree().change_scene_to_file("res://Levels/level_1.tscn")
		is_first_in = false 


func check_level_finish(id:int):
	match id:
		2:
			return level_2
		3:
			return level_3
		4:
			return level_4
		5:
			return level_5
			
func change_level_finish(id:int):
	match id:
		2:
			level_2 = true
		3:
			level_3 = true
		4:
			level_4 = true
		5:
			level_5 = true
	
