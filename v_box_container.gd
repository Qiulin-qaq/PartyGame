extends VBoxContainer

# 配置按钮的透明度和颜色
const NORMAL_ALPHA = 0  # 默认透明度
const BUTTON_COLOR = Color(1, 1, 1)  # 按钮背景颜色，白色

var bgm_option_button
var current_menu = "game"  # 记录当前所在菜单，初始化为game菜单，实现任意处返回的逻辑必须记录菜单层数
var dontclick_clicked = false

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


func _on_set_pressed():
	var game_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/Control/game")
	if game_node!= null:
		game_node.visible = false
	var for_position_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/for_position")
	if for_position_node!= null:
		for_position_node.visible = true
	current_menu = "for_position"  # 进入setting菜单，更新当前菜单记录


func _on_back_pressed():
	var game_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/Control/game")
	if game_node!= null:
		game_node.visible = true
	var for_position_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/for_position")
	if for_position_node!= null:
		for_position_node.visible = false
	current_menu = "game"  # 返回game菜单，更新当前菜单记录


func _on_dontclick_pressed() -> void:
	# 获取voice节点
	var voice_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/for_position/settingmenu/Voice")
	if voice_node!= null:
		voice_node.volume_db = 20
	voice_node.play()

	var kidding_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/kidding")
	if kidding_node!= null:
		kidding_node.visible = true
	dontclick_clicked = true
	var for_position_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/for_position")
	if for_position_node!= null:
		for_position_node.visible = false
	current_menu = "kidding"  # 进入kidding菜单，更新当前菜单记录


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if current_menu == "kidding" && dontclick_clicked:
			# 获取kidding节点并设置为不可见
			var kidding_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/kidding")
			if kidding_node!= null:
				kidding_node.visible = false

			# 获取for_position节点并设置为可见
			var for_position_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/for_position")
			if for_position_node!= null:
				for_position_node.visible = true
			current_menu = "for_position"  # 更新当前菜单为setting
		elif current_menu == "information":
			# 获取information节点并设置为不可见
			var information_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/information")
			if information_node!= null:
				information_node.visible = false

			# 获取for_position节点并设置为可见
			var for_position_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/for_position")
			if for_position_node!= null:
				for_position_node.visible = true
			current_menu = "for_position"  # 更新当前菜单为setting
		else:
			dontclick_clicked = false  # 在非kidding和information菜单点击时，重置dontclick_clicked状态


func _on_exit_pressed() -> void:
	get_tree().quit()  # 获取场景树的根节点并调用quit方法来关闭窗口


func _on_about_pressed() -> void:
	# 获取for_position节点并设置为不可见
	var for_position_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/for_position")
	if for_position_node!= null:
		for_position_node.visible = false

	# 获取information节点并设置为可见
	var information_node = get_node("/root/MarginContainer/HBoxContainer/VBoxContainer/information")
	if information_node!= null:
		information_node.visible = true

	current_menu = "information"  # 更新当前菜单记录为information
