extends CharacterBody2D


const speed = 150
const jump_velocity = -400

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if velocity.y > 0 :
		animated_sprite.play('fall')
	
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * speed
		if velocity.y == 0:
			animated_sprite.play("walk")
	else: 
		velocity.x = move_toward(velocity.x, 0, speed)
		if velocity.y == 0:
			animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		animated_sprite.play("jump")
		
	if direction == -1:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	
	move_and_slide()
