extends RigidBody2D

var is_in_water = false
var volumn_in_water = 0.

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


#func _physics_process(delta):
	#if is_in_water:
		#CalculateVolunmInWater()
		#ApplyBuoyancy(1)


# 计算排开水体积
func CalculateVolunmInWater():
	var size = $CollisionShape2D.get_shape().get_size() as Vector2
	var width = size.x
	var height = size.y
	$WaterDetector.force_raycast_update()
	if $WaterDetector.is_colliding():
		var collision_point_water = $WaterDetector.get_collision_point()
		var distance = collision_point_water.y - (position.y - height/2)
		volumn_in_water = width * (height - distance)


func GetWholeVolunm() -> float:
	return 128*128


func CalculateBuoyancy(water_density) -> Vector2:
	var buoyant_force = water_density * volumn_in_water * ProjectSettings.get_setting("physics/2d/default_gravity")
	var displacement = buoyant_force * Vector2(0, -1) / 500
	return displacement

func _integrate_forces(state):
	if is_in_water:
		CalculateVolunmInWater()
		state.apply_central_force(CalculateBuoyancy(1))
