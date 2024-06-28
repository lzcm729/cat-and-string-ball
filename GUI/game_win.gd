extends Control

var level_id = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://GUI/choose_level.tscn")
	



func _on_next_pressed():
	get_tree().change_scene_to_file("res://Levels/level_" + str(min(level_id + 1, 5)) + ".tscn")
