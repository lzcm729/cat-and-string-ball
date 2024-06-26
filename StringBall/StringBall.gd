extends RigidBody2D

#@onready var sprite = $Sprite2D
#@onready var collision = $CollisionShape2D

var size = 100
var recorded_position
const single_scaling_factor = Vector2(0.99, 0.99)

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_force((Vector2(10000, 0)))
	recorded_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	#print(sprite.get_scale())
	#sprite.apply_scale(sprite.get_scale()*0.9)
	#collision.apply_scale(collision.get_scale()*0.9)
	#print(sprite.get_scale())
	var delta_position = abs(position - recorded_position)
	recorded_position = position
	var distance = delta_position.x + delta_position.y
	print(distance)
	Scale(MapDistanceToScale(distance))
	pass

func _on_timer_timeout():
	#print(collision.get_scale())
	Scale(single_scaling_factor)
	#print(collision.get_scale())

func Scale(factor:Vector2):
	# 碰撞按比例缩小
	$CollisionShape2D.apply_scale(factor)
	# sprite需要其他方案
	$Sprite2D.apply_scale(factor)
	
func MapDistanceToScale(distance:float) -> Vector2:
	var res = pow(0.99, distance/10)
	return Vector2(res, res)

# 随着缩小要留下印迹
func DrawFootprint():
	pass
