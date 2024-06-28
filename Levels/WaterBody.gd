extends Area2D

# Adjust these values based on your requirements
var water_density = 1.0
var ball

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	if ball:
		apply_buoyancy(ball)
#
func _on_body_entered(body):
	if body.name == 'Cat':
		body.is_in_water = true
	if body.name == 'StringBall':
		body.is_in_water = true
		ball = body
#
#
func _on_body_exited(body):
	if body.name == 'Cat':
		body.is_in_water = false
	if body.name == 'StringBall':
		body.is_in_water = false
		ball = null


func apply_buoyancy(body):
	var volume = body.volumn_in_water
	var buoyant_force = water_density * volume * gravity / 1000
	print_debug(buoyant_force)
	var displacement = buoyant_force * Vector2(0, -1)
	body.apply_force(displacement, body.global_transform.origin)


#func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#if body.name == 'StringBall':
		#var ball_shape = body.get_node('CollisionShape2D').shape
		#var res = $CollisionShape2D.shape.collide_and_get_contacts(Transform2D(), ball_shape, Transform2D())
		#print(res)
