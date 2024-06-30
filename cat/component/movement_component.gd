class_name MovementComponent
extends Node

@export_subgroup("Settings")
@export var speed: float = 200
@export var jump_velocity: float = -750.0
@export var swim_speed: float = 20

var is_jumping: bool = false


func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	body.velocity.x = direction * speed

func handle_vertical_movement(body: CharacterBody2D, direction: float) -> void:
	if body.is_in_water:
		body.velocity.y += direction * swim_speed

func handle_jump(body: CharacterBody2D, want_to_jump: bool) -> void:
	if want_to_jump and body.is_on_floor():
		body.velocity.y = jump_velocity

	is_jumping = body.velocity.y < 0 and not body.is_on_floor()
