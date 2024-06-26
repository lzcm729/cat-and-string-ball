extends Button

func _on_pressed():
	#跳往选关界面
	get_tree().change_scene_to_file("res://GUI/start_menu.tscn")
