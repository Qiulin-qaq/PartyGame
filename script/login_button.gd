@tool  
extends Button  

# 窗口基准大小（用于计算字体缩放）  
const BASE_WINDOW_WIDTH = 1920.0  
const BASE_WINDOW_HEIGHT = 1080.0  

# 基准字体大小  
const BASE_FONT_SIZE = 120   

# 引用 login 场景脚本以获取 IP 地址  
@onready var login_script = get_node("/root/Login")  

# 用户名最大长度  
@export var max_username_length: int = 20  

# 引用错误弹窗  
@onready var error_popuppanel = get_node("/root/Login/ErrorPopupPanel")   
# 引用输入字段和错误标签  
@onready var username_input: LineEdit = get_node("../UserNameLineEdit")  

# 全局用户名变量  
var global_username: String = ""  

# 用户信息字典（可以持久化存储）  
var user_info: Dictionary = {}  

func _ready():  
	
	# 连接窗口大小变化信号  
	get_tree().root.connect("size_changed", Callable(self, "_on_window_resized"))  
	
	# 连接按钮点击信号  
	pressed.connect(_on_login_pressed)  
	
	# 初始更新  
	_on_window_resized()  
	
	# 初始禁用按钮  
	#disabled = true  
	
	# 监听输入变化  
	username_input.text_changed.connect(_on_input_changed)  
	
	# 限制输入长度  
	username_input.max_length = max_username_length  

	# 可选：设置字体颜色  
	self.add_theme_color_override("font_color", Color(1, 1, 1, 1))  # 白色  
	self.add_theme_color_override("font_hover_color", Color(0.8, 0.8, 0.8, 1))  # 悬停时略微变暗  
	self.add_theme_color_override("font_pressed_color", Color(0.6, 0.6, 0.6, 1))  # 按下时更暗  



func _on_window_resized():  
	# 获取窗口高度  
	var window_height = get_tree().root.size.y  
	
	# 计算按钮高度 (在300px到1080px之间平滑缩放)  
	var button_height = lerp(  
		40.0,  
		80.0,  
		clamp((window_height - 300.0) / (1080.0 - 300.0), 0.0, 1.0)  
	)  
	
	# 更新按钮高度  
	if button_height < 100.0 && button_height > 40:  
		custom_minimum_size.y = button_height  
	
	# 获取当前窗口大小  
	var window = get_viewport_rect().size  
	
	# 计算缩放比例（以宽度为主）  
	var scale_factor = window.x / BASE_WINDOW_WIDTH  
	
	# 计算动态字体大小  
	var dynamic_font_size = int(BASE_FONT_SIZE * scale_factor)  
 
	# 设置字体大小  
	if dynamic_font_size < 50:  
		add_theme_font_size_override("font_size", dynamic_font_size)  
	
	# 设置字体阴影  
	add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.5))  # 半透明黑色阴影  
	add_theme_constant_override("shadow_offset_x", 2)  # 水平阴影偏移  
	add_theme_constant_override("shadow_offset_y", 2)  # 垂直阴影偏移  

func _on_input_changed(_text: String = ""):  
	# 检查用户名是否为空  
	disabled = username_input.text.is_empty()  

func _on_login_pressed():  
	# 获取输入的用户名  
	var username = username_input.text  
	
	# 基本验证  
	if username.is_empty():  
		error_popuppanel.show_error("用户名不能为空")  
		return  
	
	# 长度验证  
	if username.length() > max_username_length:  
		error_popuppanel.show_error("用户名不能超过 %d 个字符" % max_username_length)  
		username_input.text = ""  
		return  
	
	# 获取用户 IP（允许为空）  
	var user_ip = login_script.get_user_ip() if login_script.has_method("get_user_ip") else ""  
	
	# 将用户名和 IP 绑定（即使 IP 为空）  
	user_info[username] = {  
		"ip": user_ip,  
		"login_time": Time.get_datetime_dict_from_system()  
	}  
	
	# 可选：持久化存储  
	_save_user_info()  
	
	# 执行登录逻辑  
	if login(username):  
		# 设置全局用户名  
		global_username = username  
		
		# 登录成功  
		print("登录成功，IP：", user_ip if user_ip else "无IP")  
		# 跳转到主界面  
		get_tree().change_scene_to_file("res://mainmenu.tscn")  
	else:  
		# 登录失败  
		print("登录失败")  
		error_popuppanel.show_error("登录失败，请重试")  

func login(_username: String) -> bool:  
	# 简单的用户名验证逻辑  
	return true  

func _save_user_info():  
	var save_path = "user://user_info.json"  
	var file = FileAccess.open(save_path, FileAccess.WRITE)  
	
	if file:  
		file.store_string(JSON.stringify(user_info))  
		file.close()  
		print("用户信息已保存到: ", save_path)   
	else:  
		print("无法保存用户信息，写入错误:", FileAccess.get_open_error())  

# 支持回车键登录  
func _unhandled_input(event):  
	if event is InputEventKey and event.pressed:  
		if event.keycode == KEY_ENTER and not disabled:  
			_on_login_pressed()  

# 可以在其他脚本中通过这个方法获取用户名  
func get_username() -> String:  
	# 添加安全检查，防止访问未定义的键  
	if global_username.is_empty():  
		print("警告：未找到当前用户信息")  
		return "error"  
	
	# 尝试访问用户信息，增加错误处理  
	if user_info.has(global_username):  
		var user_ip = user_info[global_username].get("ip", "")  
		if user_ip.is_empty():  
			return global_username  
		else:  
			return "%s@%s" % [global_username, user_ip]  
	else:  
		print("警告：用户信息不存在")  
		return "error"  

# 获取当前用户名  
func get_current_username() -> String:  
	return global_username  

# 获取当前用户 IP  
func get_current_user_ip() -> String:  
	if global_username.is_empty() or not user_info.has(global_username):  
		return ""  
	return user_info[global_username].get("ip", "")  

# 获取登录时间  
func get_current_user_login_time() -> Dictionary:  
	if global_username.is_empty() or not user_info.has(global_username):  
		return {}  
	return user_info[global_username].get("login_time", {})
