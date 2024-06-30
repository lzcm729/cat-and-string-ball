extends Button

var globals = Globals


func _on_pressed():
	#进入选关界面
	get_tree().change_scene_to_file("res://GUI/choose_level.tscn")
	globals.check_is_first_in()
	
	


func _on_exit_pressed():
	#退出游戏
	get_tree().quit()


func _on_about_pressed():
	#作者界面
	get_tree().change_scene_to_file("res://GUI/designer_intro.tscn")
	
	


func _on_how_to_play_pressed():
	#打开操作说明
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")
