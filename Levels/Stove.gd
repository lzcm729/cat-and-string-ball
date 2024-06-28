extends StaticBody2D

var ball

func _ready():
	pass


func _process(delta):
	pass

func _physics_process(delta):
	if not $FireArea.is_monitoring(): return
	for body in $FireArea.get_overlapping_bodies():
		if body.name == "StringBall":
			body.BeBurned()

func _on_ignition_button_turn_off_fire():
	$FireArea/Sprite2D.hide()
	$FireArea.set_monitoring(false)



func _on_ignition_button_turn_on_fire():
	$FireArea/Sprite2D.show()
	$FireArea.set_monitoring(true)
