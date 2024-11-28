extends VBoxContainer

# 配置按钮的透明度和颜色
const NORMAL_ALPHA = 0  # 默认透明度
const HOVER_ALPHA = 0.8   # 鼠标悬停透明度
const PRESSED_ALPHA = 1.0  # 按下透明度
const BUTTON_COLOR = Color(1, 1, 1)  # 按钮背景颜色，白色

func _ready():
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER  # 水平初始收缩
	size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_SHRINK_CENTER
	# 遍历 VBoxContainer 内的所有按钮
	for child in get_children():
		if child is Button:
			# 配置按钮样式
			apply_button_style(child, NORMAL_ALPHA)


# 配置按钮的样式
func apply_button_style(button: Button, alpha: float):
	var style = StyleBoxFlat.new()
	style.bg_color = get_color_with_alpha(BUTTON_COLOR, alpha)  # 设置背景透明颜色
	style.border_width_left = 0  # 移除边框
	style.border_width_right = 0
	style.border_width_top = 0
	style.border_width_bottom = 0
	button.add_theme_stylebox_override("normal", style)

# 获取带有指定透明度的颜色
func get_color_with_alpha(base_color: Color, alpha: float) -> Color:
	return Color(base_color.r, base_color.g, base_color.b, alpha)

# 鼠标进入按钮区域
func _on_button_hover(button: Button):
	apply_button_style(button, HOVER_ALPHA)

# 鼠标离开按钮区域
func _on_button_exit(button: Button):
	apply_button_style(button, NORMAL_ALPHA)

# 按钮被按下
func _on_button_pressed(button: Button):
	apply_button_style(button, PRESSED_ALPHA)

# 按钮松开
func _on_button_released(button: Button):
	apply_button_style(button, HOVER_ALPHA)
