extends Control

@export var level_name = ''
@export var level_health = 5
@export var level_id = 1

@onready var level_name_label = $level_name
@onready var health_label = $health

const game_win_templ = preload("res://GUI/game_win.tscn")
const game_over_templ = preload("res://GUI/game_over.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	level_name_label.text = str(level_name)
	health_label.text = '血量' + str(level_health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if level_health == 0:
		var game_over = game_over_templ.instantiate()
		game_over.level_id = level_id
		self.add_child(game_over)

# TEST
#func _input(event):
	#if event is InputEventKey and event.pressed:
		#if event.keycode == KEY_T:
			#$"../StringBall".BePicked($"../Cat")
		#if event.keycode == KEY_G:
			#$"../StringBall".BeDropped()


func _on_cat_cat_pat_ball():
	level_health = level_health - 1
	health_label.text = '血量' + str(level_health)
