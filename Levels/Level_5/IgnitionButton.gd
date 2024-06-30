extends StaticBody2D

signal turn_on_fire
signal turn_off_fire

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.name == "CatNew":
		$Area2D/CollisionShape2D/Sprite2D.visible = false
		turn_on_fire.emit()


func _on_area_2d_body_exited(body):
	if body.name == "CatNew":
		$Area2D/CollisionShape2D/Sprite2D.visible = true		
		turn_off_fire.emit()
