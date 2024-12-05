extends PopupPanel  

var rect_size = Vector2(500, 300)  # 弹窗的大小  

func _ready():  
	print("ErrorPopupPanel is ready")  
	
	# 获取 DialogText 和 OKButton  
	var dialog_text = $VBoxContainer/DialogText  
	var ok_button = $VBoxContainer/OKButton  
	
	# 设置 DialogText 样式  
	dialog_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER  
	dialog_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER  
	dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART  
	dialog_text.custom_minimum_size = Vector2(460, 150)  # 设置最小尺寸  
	dialog_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL  
	dialog_text.size_flags_vertical = Control.SIZE_EXPAND_FILL  
	
	# 设置字体大小和颜色  
	dialog_text.add_theme_font_size_override("font_size", 24)  
	dialog_text.add_theme_color_override("font_color", Color(1, 1, 1, 1))  
	
	# 设置 OKButton 样式  
	ok_button.text = "确定"  
	ok_button.custom_minimum_size = Vector2(200, 50)  # 设置按钮最小尺寸  
	ok_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER  
	
	# 设置按钮样式  
	ok_button.add_theme_font_size_override("font_size", 24)  
	ok_button.add_theme_color_override("font_color", Color(1, 1, 1, 1))  # 白色文字  
	ok_button.add_theme_color_override("bg_color", Color(0.2, 0.6, 0.86, 1))  # 蓝色背景  
	
	# 连接确认按钮的点击事件  
	ok_button.pressed.connect(_on_ok_button_pressed)  

	# 设置初始位置  
	_center_popup()  

func show_error(message: String):  
	var dialog_text = $VBoxContainer/DialogText  
	dialog_text.text = message  
	popup_centered()  

func _on_ok_button_pressed():  
	hide()  

func _center_popup():  
	var viewport_rect = get_viewport().get_visible_rect()  
	position = (viewport_rect.size - rect_size) / 2  
	print("Popup centered at: ", position)  

# 在窗口大小变化时调用  
func _on_window_resized():  
	_center_popup()
