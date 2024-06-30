extends RigidBody2D

#var chaos_core = preload("res://ChaosCore/ChaosCore.tscn")
#@onready var sprite = $Sprite2D
#@onready var collision = $CollisionShape2D


@export var initial_hp = 100.
@export var broken_threshold = 0.3

var can_decay = true
var is_in_water = false
var volumn_in_water = 0.

@onready var current_hp = initial_hp
@onready var recorded_position = position
@onready var initial_collision_scale = $CollisionShape2D.get_scale()
@onready var initial_sprite_scale = $Sprite2D.get_scale()

signal show_chaos_core(pos:Vector2)


func _ready():
	#BeHit(Vector2(10000, 0))
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if can_decay:
		var delta_position = abs(position - recorded_position)
		MapDistanceToHP(delta_position.x + delta_position.y)
		recorded_position = position
		
	if current_hp > initial_hp * broken_threshold:
		SetScaleByHP()
	else:
		$Sprite2D.hide()
		show_chaos_core.emit(position)
		queue_free()


func _integrate_forces(state):
	if is_in_water:
		CalculateVolunmInWater()
		state.apply_central_force(CalculateBuoyancy(1))


func MapDistanceToHP(distance:float):
	# 每移动1/n单位距离 size-1
	current_hp -= clampf(distance/50, 0, INF)


func SetScaleByHP():
	var ratio = current_hp / initial_hp
	var radius = 50 * ratio
	#$CollisionShape2D.set_scale(initial_collision_scale*ratio)
	$CollisionShape2D.shape.set_deferred("radius", radius)
	$WaterDetector.set_target_position(Vector2(0, radius))
	$AirDetector.set_target_position(Vector2(0, -radius))
	# TODO sprite需要其他方案
	$Sprite2D.set_scale(initial_sprite_scale*ratio)

# 随着缩小要留下印迹
func DrawFootprint():
	pass

# 计算排开水体积
func CalculateVolunmInWater():
	var current_radius = $CollisionShape2D.shape.radius
	$WaterDetector.force_raycast_update()
	if $WaterDetector.is_colliding():
		var collision_point_water = $WaterDetector.get_collision_point()
		var distance_water = (collision_point_water - position).y
		if distance_water >= 0:
			var theta = 2*acos(distance_water/current_radius)
			volumn_in_water = (current_radius**2 / 2) * (theta-sin(theta))
		else:
			$AirDetector.force_raycast_update()
			var collision_point_air = $AirDetector.get_collision_point()
			var distance_air = abs((collision_point_air - position).y)
			var theta = 2*acos(distance_air/current_radius)
			volumn_in_water = (PI * current_radius**2)- (current_radius**2 / 2) * (theta-sin(theta))


func CalculateBuoyancy(water_density) -> Vector2:
	var buoyant_force = water_density * volumn_in_water * ProjectSettings.get_setting("physics/2d/default_gravity")
	var displacement = buoyant_force * Vector2(0, -1) / 1000
	return displacement
	
	
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
	$CollisionShape2D.disabled = true
	can_decay = false


# INTERFACE
# 被扔下
func BeDropped():
	can_decay = true
	set_sleeping(false)
	$CollisionShape2D.disabled = false
	recorded_position = position


func BeBurned():
	current_hp *= 0.99
