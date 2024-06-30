class_name ActionComponent
extends Node

@export_subgroup("Settings")
@export var hit_force: Vector2 = Vector2(20000, 0)
@export var left_hit_cast: ShapeCast2D
@export var right_hit_cast: ShapeCast2D

const pat_sound = preload("res://sounds/pat.tscn")

var ball_ref

func handle_hit(body:Cat, want_to_hit:bool, orientation:int):
	if not want_to_hit: return
	if body.movement_component.is_jumping or body.gravity_component.is_falling and !body.is_in_water: return
	body.velocity.x = 0
	body.is_hitting = true
	var hit_cast = right_hit_cast if (orientation == 1) else left_hit_cast
	hit_cast.force_shapecast_update()
	var results = hit_cast._get_collision_result()
	for result in results:
		if result.collider.name == "StringBall":
			result.collider.BeHit(Vector2(orientation*hit_force.x, hit_force.y))
			body.cat_pat_ball.emit()
			var pat_sound_templ = pat_sound.instantiate()
			get_tree().current_scene.add_child(pat_sound_templ)
		if result.collider.name == 'ChaosCore':
			result.collider.BeEaten()
			body.eat_core.emit()
		if result.collider.name == 'Duck':
			result.collider.apply_central_force(Vector2(5000*body.orientation, -2000))


func handle_pickup(ball:Node2D):
	if not ball: return
	ball_ref = ball
	ball_ref.BePicked()


func handle_drop():
	if not ball_ref: return
	ball_ref.BeDropped()
	ball_ref = null
