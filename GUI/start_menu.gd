extends Control

@onready var house_grass_follow = $Bg/path/housegrass_follow
@onready var title_follow = $Bg/path/title_follow

@onready var title = $Bg/path/title_follow/Title

const bgm = preload("res://sounds/bgm.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if house_grass_follow.progress_ratio < 1:
		house_grass_follow.progress_ratio = house_grass_follow.progress_ratio + 0.04
	if title_follow.progress_ratio < 1:
		title_follow.progress_ratio = title_follow.progress_ratio + 0.03
			

	
		
