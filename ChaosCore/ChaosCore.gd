extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_sleeping(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func BeEaten():
	$Timer.stop()


func _on_string_ball_show_chaos_core(pos):
	global_transform.origin = pos
	$Timer.start()
	set_sleeping(false)
	show()


func _on_timer_timeout():
	if scale >= Vector2(10, 10): return
	apply_scale(Vector2(1.1, 1.1))
