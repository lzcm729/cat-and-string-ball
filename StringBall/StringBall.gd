extends RigidBody2D

#var chaos_core = preload("res://ChaosCore/ChaosCore.tscn")
#@onready var sprite = $Sprite2D
#@onready var collision = $CollisionShape2D

var initial_hp = 100.
var broken_ratio = 0.3

var is_free_moving = true

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
	if not is_sleeping():
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
# 被击打
func Hit(force:Vector2):
	apply_central_force(force)


# INTERFACE
# 被叼起来 返回此时球相较于初始值的比例
func BePicked() -> float:
	set_sleeping(true)
	hide()
	return current_hp / initial_hp


# INTERFACE
# 被扔下
func BeDropped(pos:Vector2):
	PhysicsServer2D.body_set_state(
		self.get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(pos)
	)
	set_sleeping(false)
	await get_tree().process_frame
	show()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			BePicked()
		if event.keycode == KEY_G:
			BeDropped(Vector2(500, 250))

