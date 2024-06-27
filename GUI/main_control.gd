extends Control

@export var level_name = ''

@onready var level_name_label = $level_name


# Called when the node enters the scene tree for the first time.
func _ready():
	level_name_label.text = str(level_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# TEST
#func _input(event):
	#if event is InputEventKey and event.pressed:
		#if event.keycode == KEY_T:
			#$"../StringBall".BePicked($"../Cat")
		#if event.keycode == KEY_G:
			#$"../StringBall".BeDropped()
