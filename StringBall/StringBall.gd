extends RigidBody2D

#var chaos_core = preload("res://ChaosCore/ChaosCore.tscn")
#@onready var sprite = $Sprite2D
#@onready var collision = $CollisionShape2D

var initial_hp = 100.
var broken_ratio = 0.3

var can_decay = true
var cat_ref : Node2D

@onready var current_hp = initial_hp
@onready var recorded_position = position
@onready var initial_collision_scale = $CollisionShape2D.get_scale()
@onready var initial_sprite_scale = $Sprite2D.get_scale()

signal show_chaos_core(pos:Vector2)


func _ready():
	Hit(Vector2(10000, 0))
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if can_decay:
		var delta_position = abs(position - recorded_position)
		recorded_position = position
		var distance = delta_position.x + delta_position.y
		MapDistanceToSize(distance)
		if current_hp > initial_hp * broken_ratio:
			SetScaleBySize()
		else:
			$Sprite2D.hide()
			show_chaos_core.emit(position)
			queue_free()


func MapDistanceToSize(distance:float):
	# 每移动1/n单位距离 size-1
	current_hp -= clampf(distance/50, 0, INF)


func SetScaleBySize():
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
	#set_sleeping(false)
	PhysicsServer2D.body_set_state(
		self.get_rid(),
		PhysicsServer2D.BODY_STATE_SLEEPING,
		false
	)
	PhysicsServer2D.body_set_state(
		self.get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(pos)
	)
	PhysicsServer2D.body_set_state(
		self.get_rid(),
		PhysicsServer2D.BODY_STATE_SLEEPING,
		true
	)
	#set_sleeping(true)

# INTERFACE
# 被击打
func Hit(force:Vector2):
	apply_central_force(force)


# INTERFACE
# 被叼起来
func BePicked(cat:Node2D):
	cat_ref = cat
	set_sleeping(true)
	can_decay = false


# INTERFACE
# 被扔下
func BeDropped():
	if not cat_ref: return 
	can_decay = true
	var pos = cat_ref.position
	set_sleeping(false)
	PhysicsServer2D.body_set_state(
		self.get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(pos)
	)
	cat_ref = null


# TEST
#func _input(event):
	#if event is InputEventKey and event.pressed:
		#if event.keycode == KEY_T:
			#BePicked($"../Cat")
		#if event.keycode == KEY_G:
			##BeDropped()
			#BeCarry(Vector2(500,200))
