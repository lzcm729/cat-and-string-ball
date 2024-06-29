extends Node2D

@export var level_id = 1
@onready var high_light = $highlight
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_tree().change_scene_to_file("res://Levels/level_" + str(level_id) +".tscn")


func _on_mouse_entered():
	high_light.visible = true


func _on_mouse_exited():
	high_light.visible = false
