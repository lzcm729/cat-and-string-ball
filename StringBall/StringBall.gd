extends RigidBody2D

#var chaos_core = preload("res://ChaosCore/ChaosCore.tscn")
#@onready var sprite = $Sprite2D
#@onready var collision = $CollisionShape2D

var initial_hp = 100.
var broken_ratio = 0.3

var can_decay = true

@onready var current_hp = initial_hp
@onready var recorded_position = position
@onready var initial_collision_scale = $CollisionShape2D.get_scale()
@onready var initial_sprite_scale = $Sprite2D.get_scale()

signal show_chaos_core(pos:Vector2)


func _ready():
	BeHit(Vector2(10000, 0))
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if can_decay:
		var delta_position = abs(position - recorded_position)
		recorded_position = position
		var distance = delta_position.x + delta_position.y
		MapDistanceToHP(distance)
	if current_hp > initial_hp * broken_ratio:
		SetScaleByHP()
	else:
		$Sprite2D.hide()
		show_chaos_core.emit(position)
		queue_free()


func MapDistanceToHP(distance:float):
	# 每移动1/n单位距离 size-1
	current_hp -= clampf(distance/50, 0, INF)


func SetScaleByHP():
	var ratio = current_hp / initial_hp
	$CollisionShape2D.set_scale(initial_collision_scale*ratio)
	# TODO sprite需要其他方案
	$Sprite2D.set_scale(initial_sprite_scale*ratio)

# 随着缩小要留下印迹
func DrawFootprint():
	pass


# INTERFACE
# 被叼起来后移动 稳态移动
func StationaryMove(pos:Vector2):
	set_sleeping(false)
	# NOTE 运动时必须用下面这个改位置
	#PhysicsServer2D.body_set_state(
		#get_rid(),
		#PhysicsServer2D.BODY_STATE_TRANSFORM,
		#Transform2D.IDENTITY.translated(pos)
	#)
	self.global_transform.origin = pos # wtf? 竟然可行吗
	set_sleeping(true)


# INTERFACE
# 被击打
func BeHit(force:Vector2):
	apply_central_force(force)


# INTERFACE
# 被叼起来
func BePicked():
	#set_freeze_enabled(true)
	set_sleeping(true)
	can_decay = false


# INTERFACE
# 被扔下
func BeDropped():
	can_decay = true
	set_sleeping(false)
	recorded_position = position


func BeBurned():
	current_hp *= 0.99
