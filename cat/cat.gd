extends CharacterBody2D


const speed = 300
const jump_velocity = -800

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var cat_area = $Marker2D/PatArea  # 猫角色的碰撞区域（Area2D），在场景中命名为 CatArea
@onready var cat_action = $CatAction
@onready var animation_tree = $AnimationTree

#记录猫的朝向
var is_left = false

var ball_ref : Node2D

func _physics_process(delta):
	#如果在空中，那么就下坠
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		is_left = direction == -1
	
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
		if is_left:
			cat_action.play('AttackLeft')
		else:
			cat_action.play('AttackRight')
	
	# TEST
	if Input.is_action_just_pressed("pickup_ball"):
		# WARNING
		ball_ref = get_node("../StringBall") 
		if ball_ref:
			ball_ref.BePicked(self)
				
	if Input.is_action_just_pressed("drop_ball"):
		if ball_ref:
			ball_ref.BeDropped()
			ball_ref = null
			
	# TEST
	if ball_ref:
		var pos = Vector2(position.x, position.y-200)
		ball_ref.StationaryMove(pos)
			
	move_and_slide()
	

func _on_pat_area_body_entered(body):
	if body.name == 'StringBall':
		if self.position.x - body.position.x < 0:
			body.Hit(Vector2(20000, 0))
		else:
			body.Hit(Vector2(-20000, 0))
