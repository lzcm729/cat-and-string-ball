extends CharacterBody2D


const speed = 150
const jump_velocity = -800

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var cat_area = $Marker2D/PatArea  # 猫角色的碰撞区域（Area2D），在场景中命名为 CatArea
@onready var cat_action = $CatAction
@onready var animation_tree = $AnimationTree

#记录猫的朝向
var is_left = false

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
		#set_collision_layer_value(2, true)
		for body in cat_area.get_overlapping_bodies():
			if body.has_method("Hit"):
				body.Hit(Vector2(10000, 0))  # 调用物体的 Hit 方法，施加力量向量 (10000, 0)
		#set_collision_layer_value(2, false)
		if is_left:
			cat_action.play('AttackLeft')
			await cat_action.animation_finished
		else:
			cat_action.play('AttackRight')
			await cat_action.animation_finished			
	
	move_and_slide()
	
