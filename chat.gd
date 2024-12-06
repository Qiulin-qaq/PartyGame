extends Node2D

@export var scroll_velocity = -100.0
@onready var background = $Background
# 用于存储自定义鼠标节点的变量
var custom_mouse
@onready var chatmusic_node = $BGM
var last_play_time = 0.0 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 获取自定义鼠标节点（此处需填入你项目中实际的自定义鼠标节点路径）
	custom_mouse = get_node("mouse")
	if custom_mouse:
		custom_mouse.position = get_viewport().get_mouse_position()
	setup_background()
	# 获取chatmusic音乐节点（此处需填入实际路径来正确获取该节点）
	chatmusic_node = get_node("BGM")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	background.scroll_offset.x += scroll_velocity * delta
	get_node("/root/Backgroundstate").scroll_offset_x = background.scroll_offset.x
	# 检查鼠标是否在场景内，进而控制自定义鼠标的可见性和位置
	if custom_mouse:
		var mouse_pos = get_viewport().get_mouse_position()
		var viewport_size = get_viewport().get_size()

		# 判断鼠标是否在视口范围内
		if mouse_pos.x < 0 or mouse_pos.x > viewport_size.x or mouse_pos.y < 0 or mouse_pos.y > viewport_size.y:
			custom_mouse.visible = false
		else:
			custom_mouse.visible = true
			custom_mouse.position = mouse_pos

func _on_back_to_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")

func setup_background():
	var background_state = get_node("/root/Backgroundstate")
	background.scroll_offset.x = background_state.scroll_offset_x


func _on_chatmusic_pressed() -> void:
	if not is_instance_valid(chatmusic_node):
		print("chatmusic节点未找到！")
		return

	# 获取chatmusic按钮
	var chatmusic_button = get_node("chatmusic")
	if chatmusic_button:
		var button_text = chatmusic_button.text

		if button_text == "♪～(´ε｀ )  ":
			# 如果按钮文本是"音乐：开"，则保存当前播放位置并停止音乐
			last_play_time = chatmusic_node.get_playback_position()
			chatmusic_node.stop()
			chatmusic_button.text = "ヽ(´з｀)ﾉ "
		elif button_text == "ヽ(´з｀)ﾉ ":
			# 如果按钮文本是"音乐：关"，则恢复音乐并从保存的时间继续播放
			chatmusic_node.play()
			chatmusic_node.seek(last_play_time)  # 从保存的时间继续播放
			chatmusic_button.text = "♪～(´ε｀ )  "
