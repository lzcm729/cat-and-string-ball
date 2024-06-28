extends Area2D

# Adjust these values based on your requirements
var water_density = 1.0
var bodies_in_water = {}

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	for body in bodies_in_water.keys():
		apply_buoyancy(body)

func _on_body_entered(body):
	if body.name == 'StringBall':
		body.set_linear_damp(3) # Adjust damping to simulate water resistance
		#body.set_angular_damp(200) # Adjust angular damping
		bodies_in_water[body] = body


func _on_body_exited(body):
	if body.name == 'StringBall':
		body.set_linear_damp(1) # Reset damping
		#body.set_angular_damp(1)
		bodies_in_water.erase(body)


func apply_buoyancy(body):
	#var volume = body.get_area()
	var buoyant_force = water_density * 1 * gravity

	var displacement = buoyant_force * Vector2(0, -1)

	body.apply_force(displacement, body.global_transform.origin)

