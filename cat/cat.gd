extends CharacterBody2D


const speed = 300
const jump_velocity = -800

signal cat_pat_ball
signal eat_core

var gravity = 980

#@onready var hit_area = $Marker2D/PatArea  # 猫角色的碰撞区域（Area2D）
@onready var hit_area = $Area2D  # 猫角色的碰撞区域（Area2D）
@onready var cat_action = $CatAction
@onready var animation_tree = $AnimationTree

#猫咪的状态机
enum {
	MOVE,
	ATTACK
}

#记录猫的朝向
var is_left = false
var ball_ref : Node2D
var is_in_water = false

var state = MOVE

func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
	

	
	#如果在空中，那么就下坠
	if not is_on_floor():
		if is_in_water:
			velocity.y += (gravity - 1000) * delta
		else:
			velocity.y += gravity * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		is_left = direction == -1
	

	
	if velocity.y > 0 :
		if is_left:
			cat_action.play("FallLeft")
		else:
			cat_action.play('FallRight')
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		if is_left:
			cat_action.play('JumpLeft')
		else:
			cat_action.play('JumpRight')
		
	if Input.is_action_just_pressed("ui_patpat"):
		state = ATTACK


	# TEST
	if ball_ref:
		var pos = Vector2(position.x+50, position.y-100)
		ball_ref.StationaryMove(pos)
			
	move_and_slide()


func PickupBall(ball:Node2D):
	if not ball: return
	ball_ref = ball
	ball_ref.BePicked()


func DropBall():
	if not ball_ref: return
	ball_ref.BeDropped()
	ball_ref = null
	
# 向前挥击
func Hit(id:String):
	# 播放攻击动画
	cat_action.play(id)
	
	var overlapping_bodies = hit_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.name == "StringBall":
			if self.position.x - body.position.x < 0:
				print_debug('left')
				body.BeHit(Vector2(20000, 0))
			else:
				print_debug('right')
				body.BeHit(Vector2(-20000, 0))

#状态函数
func move_state():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		if velocity.y == 0:
			if is_left:
				cat_action.play("RunLeft")	
			else:
				cat_action.play("RunRight")					
	else: 
		velocity.x = move_toward(velocity.x, 0, speed)
		if velocity.y == 0:
			if is_left:
				cat_action.play("IdleLeft")
			else:
				cat_action.play("IdleRight")
				
func attack_state():
	if is_left:
		cat_action.play('AttackLeft')
	else:
		cat_action.play('AttackRight')
	await cat_action.animation_finished
	state = MOVE
	

# TEST
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			PickupBall(get_node("../StringBall")) # WARNING
		if event.keycode == KEY_G:
			DropBall()
		if event.keycode == KEY_Q:
			Hit('AttackLeft' if is_left else 'AttackRight')


func _on_pat_area_body_entered(body):
	if body.name == "StringBall":
		emit_signal("cat_pat_ball")
		if is_left:
			body.BeHit(Vector2(-50000, 0))
		else:
			body.BeHit(Vector2(50000, 0))
	if body.name == 'ChaosCore':
		emit_signal("eat_core")
		body.BeEaten()
