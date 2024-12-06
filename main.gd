extends Control
# 配置按钮的透明度和颜色
const NORMAL_ALPHA = 0  # 默认透明度
const BUTTON_COLOR = Color(1, 1, 1)  # 按钮背景颜色，白色


# Called when the node enters the scene tree for the first time.

func _ready():
	# getchild返回所有子节点
	for child in get_children():
		if child is Button:
			# 配置按钮样式
			apply_button_style(child, NORMAL_ALPHA)

# 配置按钮的样式
func apply_button_style(button: Button, alpha: float):
	var style = StyleBoxFlat.new()
	style.bg_color = get_color_with_alpha(BUTTON_COLOR, alpha)  # 设置背景透明颜色
	button.add_theme_stylebox_override("normal", style)
# 获取带有指定透明度的颜色
func get_color_with_alpha(base_color: Color, alpha: float) -> Color:
	return Color(base_color.r, base_color.g, base_color.b, alpha)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
