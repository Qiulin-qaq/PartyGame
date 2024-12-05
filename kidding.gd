extends Control

# 配置按钮的透明度和颜色
const NORMAL_ALPHA = 0  # 默认透明度，值为0表示完全透明
const BUTTON_COLOR = Color(1, 1, 1)  # 按钮背景颜色，白色


# 当节点准备就绪时调用的函数，通常用于初始化相关操作
func _ready():
	# getchild返回所有子节点，这里遍历所有子节点
	for child in get_children():
		if child is Button:
			# 配置按钮样式，调用函数应用样式，传入当前按钮和默认透明度
			apply_button_style(child, NORMAL_ALPHA)

# 配置按钮的样式
func apply_button_style(button: Button, alpha: float):
	var style = StyleBoxFlat.new()
	style.bg_color = get_color_with_alpha(BUTTON_COLOR, alpha)  # 设置背景透明颜色，根据给定的基础颜色和透明度获取实际显示颜色
	button.add_theme_stylebox_override("normal", style)

# 获取带有指定透明度的颜色
func get_color_with_alpha(base_color: Color, alpha: float) -> Color:
	return Color(base_color.r, base_color.g, base_color.b, alpha)
