extends MarginContainer

@export var scroll_velocity = -100.0
@onready var background = $Background
@onready var click_sound = $click
@onready var bgm_node = $BGm  # 假设BGM节点的路径正确

var last_play_time = 0.0  # 用于保存BGM的播放时间
var custom_mouse  # 用于保存自定义鼠标节点

func _ready():
	# 设置窗口尺寸
	get_window().min_size = Vector2i(1152, 648)
	get_window().max_size = Vector2i(1152, 648)

	# 设置 MarginContainer 的边距
	add_theme_constant_override("margin_left", 300)  # 左边距
	add_theme_constant_override("margin_right", 0)  # 右边距
	add_theme_constant_override("margin_top", 80)  # 上边距
	add_theme_constant_override("margin_bottom", 80)  # 下边距

	# 设置锚点为整个矩形
	custom_minimum_size = Vector2(0, 0)  # 确保不会限制大小
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 1.0
	anchor_bottom = 1.0

	# 给按钮添加点击音效
	_hook_button_sound(self)

	# 以下测试用，试试你的资源节点找到了没
	if not is_instance_valid(bgm_node):
		print("BGM节点未找到！")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# 获取自定义鼠标节点
	custom_mouse = get_node("mouse")
	if custom_mouse:
		custom_mouse.position = get_viewport().get_mouse_position()

	setup_background()

func _process(delta):
	background.scroll_offset.x += scroll_velocity * delta
	get_node("/root/Backgroundstate").scroll_offset_x = background.scroll_offset.x
	# 检查鼠标是否在场景内，如果不在则隐藏自定义鼠标，因为鼠标移出窗口外会有图片卡在边框，所以回复自定义
	if custom_mouse:
		var mouse_pos = get_viewport().get_mouse_position()
		var viewport_size = get_viewport().get_size()

		# 判断鼠标是否在视口内
		if mouse_pos.x < 0 or mouse_pos.x > viewport_size.x or mouse_pos.y < 0 or mouse_pos.y > viewport_size.y:
			custom_mouse.visible = false
		else:
			custom_mouse.visible = true
			custom_mouse.position = mouse_pos  # 更新自定义鼠标位置

func _input(event):
	if event is InputEventMouseMotion:
		if custom_mouse:
			custom_mouse.position = event.position

func _hook_button_sound(node):
	for child in node.get_children():
		if child is Button:
			var callable_play = Callable(click_sound, "play")
			child.connect("pressed", callable_play)
		else:
			_hook_button_sound(child)

func _on_bgm_option_pressed() -> void:
	# 如果BGM节点无效，直接返回
	if not is_instance_valid(bgm_node):
		print("BGM节点未找到！")
		return

	# 获取bgm_option按钮
	var bgm_option_button = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/for_position/settingmenu/BGMoption")
	if bgm_option_button:
		var button_text = bgm_option_button.text

		if button_text == "音乐：开 ":
			# 如果按钮文本是"音乐：开"，则保存当前播放位置并停止音乐
			last_play_time = bgm_node.get_playback_position()  # 保存当前播放时间
			bgm_node.stop()
			bgm_option_button.text = "音乐：关 "
		elif button_text == "音乐：关 ":
			# 如果按钮文本是"音乐：关"，则恢复音乐并从保存的时间继续播放
			bgm_node.play()
			bgm_node.seek(last_play_time)  # 从保存的时间继续播放
			bgm_option_button.text = "音乐：开 "


func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://game_selection_scene.tscn")


func _on_chat_button_down() -> void:
	get_tree().change_scene_to_file("res://chat.tscn")

func setup_background():
	var background_state = get_node("/root/Backgroundstate")
	background.scroll_offset.x = background_state.scroll_offset_x
