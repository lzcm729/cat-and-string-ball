class_name ActionComponent
extends Node

@export_subgroup("Settings")
@export var hit_force: Vector2 = Vector2(20000, 0)
@export var left_hit_cast: ShapeCast2D
@export var right_hit_cast: ShapeCast2D

var ball_ref

func handle_hit(body:Cat, want_to_hit:bool, orientation:int):
	if not want_to_hit: return
	if body.movement_component.is_jumping or body.gravity_component.is_falling: return
	body.velocity.x = 0
	body.is_hitting = true
	var hit_cast = right_hit_cast if (orientation == 1) else left_hit_cast
	hit_cast.force_shapecast_update()
	var results = hit_cast._get_collision_result()
	for result in results:
		if result.collider.name == "StringBall":
			result.collider.BeHit(Vector2(orientation*hit_force.x, hit_force.y))
			body.emit_signal("cat_pat_ball")
		if result.collider.name == 'ChaosCore':
			result.collider.BeEaten()
			body.eat_core.emit()


func handle_pickup(ball:Node2D):
	if not ball: return
	ball_ref = ball
	ball_ref.BePicked()


func handle_drop():
	if not ball_ref: return
	ball_ref.BeDropped()
	ball_ref = null
