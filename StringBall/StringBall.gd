extends RigidBody2D
var chaos_core = preload("res://ChaosCore/ChaosCore.tscn")
#@onready var sprite = $Sprite2D
#@onready var collision = $CollisionShape2D

var initial_size = 100.
var broken_size = 30.

@onready var current_size = initial_size
@onready var recorded_position = position
@onready var initial_collision_scale = $CollisionShape2D.get_scale()
@onready var initial_sprite_scale = $Sprite2D.get_scale()

signal show_chaos_core(pos:Vector2)


func _ready():
	Hit(Vector2(10000, 0))


func _process(delta):
	pass


func _physics_process(delta):
	var delta_position = abs(position - recorded_position)
	recorded_position = position
	var distance = delta_position.x + delta_position.y
	MapDistanceToSize(distance)
	if current_size > broken_size:
		SetScaleBySize()
	else:
		$Sprite2D.hide()
		show_chaos_core.emit(position)
		queue_free()


# DEPRECATED
func SelfScale(factor:Vector2):
	# 碰撞按比例缩小
	$CollisionShape2D.apply_scale(factor)
	# sprite需要其他方案
	$Sprite2D.apply_scale(factor)


# DEPRECATED
func MapDistanceToScale(distance:float) -> Vector2:
	# 每移动1/10单位距离 缩放*0.99
	var res = pow(0.99, distance/10)
	return Vector2(res, res)


func MapDistanceToSize(distance:float):
	# 每移动1/5单位距离 size-1
	current_size -= distance/5


func SetScaleBySize():
	var ratio = current_size / initial_size
	$CollisionShape2D.set_scale(initial_collision_scale*ratio)
	# TODO sprite需要其他方案
	$Sprite2D.set_scale(initial_sprite_scale*ratio)


# 被击打
func Hit(force:Vector2):
	apply_central_force(force)


# 随着缩小要留下印迹
func DrawFootprint():
	pass
