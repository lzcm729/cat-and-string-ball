extends Area2D

# Adjust these values based on your requirements
var water_density = 1.0
var ball
var duck
var bodies_in_water = {}

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	if ball:
		apply_buoyancy(ball)
	#if duck:
		#apply_buoyancy(duck)
		
		
func _on_body_entered(body):
	body.is_in_water = true
	
	if body.name == 'Cat':
		pass
	if body.name == 'StringBall':
		ball = body
	if body.name == 'Duck':
		duck = body
#
#
func _on_body_exited(body):
	body.is_in_water = false
	
	if body.name == 'Cat':
		pass
	if body.name == 'StringBall':
		ball = null
	if body.name == 'Duck':
		duck = null


func apply_buoyancy(body):
	var volume = body.volumn_in_water
	var buoyant_force = water_density * volume * gravity / 1000
	var displacement = buoyant_force * Vector2(0, -1)
	body.apply_force(displacement, body.global_transform.origin)


#func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#if body.name == 'StringBall':
		#var ball_shape = body.get_node('CollisionShape2D').shape
		#var res = $CollisionShape2D.shape.collide_and_get_contacts(Transform2D(), ball_shape, Transform2D())
		#print(res)
