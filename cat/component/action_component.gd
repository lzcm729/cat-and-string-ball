class_name ActionComponent
extends Node

@export_subgroup("Settings")
@export var hit_force: Vector2 = Vector2(20000, 0)
@export var left_hit_cast: ShapeCast2D
@export var right_hit_cast: ShapeCast2D

var ball_ref

func handle_hit(want_to_jump:bool, orientation:int):
	if not want_to_jump: return 
	var hit_cast = right_hit_cast if (orientation == 1) else left_hit_cast
	hit_cast.force_shapecast_update()
	var results = hit_cast._get_collision_result()
	for result in results:
		if result.collider.name == "StringBall":
			result.collider.BeHit(Vector2(orientation*hit_force.x, hit_force.y))


func PickupBall(ball:Node2D):
	if not ball: return
	ball_ref = ball
	ball_ref.BePicked()


func DropBall():
	if not ball_ref: return
	ball_ref.BeDropped()
	ball_ref = null
