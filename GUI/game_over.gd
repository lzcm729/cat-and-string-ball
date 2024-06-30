extends Control

var level_id = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_try_again_pressed():
	var level_name = "level_" + str(level_id) 
	get_tree().change_scene_to_file("res://Levels/" + level_name + '/' + level_name + ".tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://GUI/choose_level.tscn")
