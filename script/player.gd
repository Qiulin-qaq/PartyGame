extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# 动画状态机，用于切换不同动画
enum AnimationState {
	IDLE,
	JUMP,
	WALK
}

@onready var animation_play = $AnimationPlayer
@onready var sprite = $Sprite2D

# 记录当前动画状态
var current_animation_state = AnimationState.IDLE

func _physics_process(delta: float) -> void:
	# 先处理物理相关逻辑，如重力等
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 处理跳跃逻辑，并更新动画状态
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_animation_state = AnimationState.JUMP

	# 获取输入方向并处理移动/减速逻辑，同时更新动画状态以及精灵翻转逻辑
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if current_animation_state != AnimationState.JUMP:  # 只有在空中时跳跃动画才会播放
			current_animation_state = AnimationState.WALK

		if direction < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			current_animation_state = AnimationState.IDLE

	move_and_slide()

	update_animation()


func update_animation():
	# 如果正在跳跃并且有水平输入，播放跳跃动画
	if current_animation_state == AnimationState.JUMP:
		animation_play.play("jump")
	elif current_animation_state == AnimationState.WALK:
		animation_play.play("walk")
	elif current_animation_state == AnimationState.IDLE:
		animation_play.play("idel")
