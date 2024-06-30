extends CharacterBody2D

var ball_ref : Node2D
var is_in_water = false
var orientation = 1 #1or-1

@export_subgroup("Nodes")
@export var input_component: InputComponent
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var action_component: ActionComponent


func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	animation_component.handle_move_animation(input_component.input_horizontal)
	movement_component.handle_jump(self, input_component.get_jump_input())
	animation_component.handle_jump_animation(movement_component.is_jumping, gravity_component.is_falling)
	action_component.handle_hit(input_component.get_hit_input(), orientation)
	
	move_and_slide()
	
	if ball_ref:
		var pos = Vector2(position.x+50, position.y-100)
		ball_ref.StationaryMove(pos)	


func PickupBall(ball:Node2D):
	if not ball: return
	ball_ref = ball
	ball_ref.BePicked()


func DropBall():
	if not ball_ref: return
	ball_ref.BeDropped()
	ball_ref = null


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			PickupBall(get_node("../StringBall")) # WARNING
		if event.keycode == KEY_G:
			DropBall()

