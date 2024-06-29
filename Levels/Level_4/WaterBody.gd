extends Area2D

# Adjust these values based on your requirements
var water_density = 1.0

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	pass
		
		
func _on_body_entered(body):
	body.is_in_water = true
#
#
func _on_body_exited(body):
	body.is_in_water = false


