extends CharacterBody2D

# 定义移动速度
var speed = 100
# 定义移动方向，初始为向右
var direction = Vector2(1, 0)

# 获取 `cleanerArea`
@onready var cleaner_area = $CleanerArea

func _ready():
	# 连接 `cleanerArea` 的碰撞信号
	cleaner_area.connect("area_entered", Callable(self, "_on_cleaner_area_entered"))

func _physics_process(delta):
	# 移动 `cleaner`
	velocity = direction * speed
	move_and_slide()
	# 检测碰撞，如果碰到边界则反转方向
	if is_on_wall():
		direction.x *= -1

func _on_cleaner_area_body_entered(body):
	if body.name == "StringBall":
		if position.x - body.position.x > 0:
			body.BeHit(Vector2(-50000,-20000))
		else:
			body.BeHit(Vector2(50000,-20000))
