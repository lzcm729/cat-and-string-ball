class_name AnimationComponent
extends Node


@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D


func handle_horizontal_flip(move_direction:float) -> void:
	if move_direction == 0:
		return

	sprite.flip_h = false if move_direction > 0 else true


func handle_move_animation(body, move_direction:float) -> void:
	if body.is_hitting: return
	handle_horizontal_flip(move_direction)
	if body.is_in_water: return
	if move_direction != 0:
		sprite.play("run")
	else:
		sprite.play("idle")
		
		
func handle_swim_animation(body, move_direction:float) -> void:
	if body.is_in_water:
		sprite.play("swim")


func handle_jump_animation(body, is_jumping:bool, is_falling:bool) -> void:
	if body.is_in_water: return
	if is_jumping:
		sprite.play("jump")
	elif is_falling:
		sprite.play("fall")


func handle_hit_animation(body) -> void:
	if body.is_hitting:
		if sprite.animation != "hit":
			sprite.play("hit")
			await sprite.animation_finished
			body.is_hitting = false
