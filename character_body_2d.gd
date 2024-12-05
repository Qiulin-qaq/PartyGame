extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D

var color_count = 0
var color_scene
var color_instance
var color_count_label

var visited_positions = []
var game_positions = [
	Vector2(500, 300),  
	Vector2(500, 100),  
	Vector2(128, 100),  
	Vector2(900, 100)   
]
var walk_animation_names = [
	"walk_red",
	"walk_blue",
	"walk_green",
	"walk_yellow"
]
var is_moving = false
var range_number
var color_number
var walk_animation_name 


var colored_positions = []


var game_over = false
func _ready() -> void:
	range_number = randi()%4
	position = game_positions[range_number]
	
	color_number = randi() % 4
	walk_animation_name = walk_animation_names[color_number]
	
func _enter_tree() -> void:
	
	set_multiplayer_authority(name.to_int())
	
	
func update_color_count_label()->void:
	color_count_label = get_node("Label")
	color_count_label.text = "当前着色数： "+ str(color_count)
		
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return 
	move(delta)
	
	if color_count >= 500 and not game_over:
		game_over = true
		game_end()
	
func move(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("左", "右", "上", "下")
	
	if direction:
		var currentSpeed: float = SPEED
		if (Input.is_action_pressed("加速")):
			currentSpeed = 200.0
		velocity.x = direction.x * currentSpeed
		velocity.y = direction.y * currentSpeed
		is_moving = true
		var new_position = position + Vector2(velocity.x * delta, velocity.y * delta)
		printerr("移动到：", new_position)
		if  not visited_positions.has(new_position):
			position = new_position
			visited_positions.append(new_position)
			if not colored_positions.has(new_position):
				update_player_animation.rpc("walk_red")
				change_tile_color()
			else:
				is_moving = false
		else:
			is_moving =false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		update_player_animation.rpc("idle_red")
		is_moving = false
	move_and_slide()
		

func change_tile_color()-> void:
	color_scene = load("res://Color.tscn")
	if color_scene:
		color_instance = color_scene.instantiate()
		if color_instance is Node2D:
			var color = color_instance
			color.position = position
			get_tree().current_scene.add_child(color)
			
			color_count = color_count +1
			update_color_count_label()
			
			colored_positions.append(position)
			await get_tree().create_timer(0).timeout
		else:
			print("颜色实例化失败")
		
	
	
func game_end():
	
	rpc("end_game")

@rpc("authority", "call_local")
func end_game():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = true
	timer.start()
	
	await timer.timeout
	timer.queue_free()
	get_tree().change_scene_to_file("res://mainmenu.tscn")
	
	
@rpc("authority", "call_local")
func update_player_animation(animation_name:String)->void:
	animation_player.play(animation_name)
	
