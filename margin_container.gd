extends MarginContainer

func _ready():
	# 设置窗口最小尺寸
	get_window().min_size = Vector2i(500, 500)
	get_window().max_size = Vector2i(1152, 648)
	# 设置 MarginContainer 的边距
	add_theme_constant_override("margin_left", 0)  # 左边距
	add_theme_constant_override("margin_right", 0)  # 右边距
	add_theme_constant_override("margin_top", 80)  # 上边距
	add_theme_constant_override("margin_bottom", 80)  # 下边距

	# 设置锚点为整个矩形
	custom_minimum_size = Vector2(0, 0)  # 确保不会限制大小
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 1.0
	anchor_bottom = 1.0


func _on_start_game_button_down() -> void:
	pass # Replace with function body.


func _on_new_chat_button_down() -> void:
	pass # Replace with function body.


func _on_settings_button_down() -> void:
	pass # Replace with function body.
