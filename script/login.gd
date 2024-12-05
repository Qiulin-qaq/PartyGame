extends Control  

var global_ip_address: String = ""  
var ip_request: HTTPRequest  
var ip_retry_count: int = 0  
var max_ip_retries: int = 3  

# 新增：用于存储用户 IP  
var user_ip: String = ""  

func _ready():  
	ip_request = HTTPRequest.new()  
	add_child(ip_request)  
	  
	ip_request.connect("request_completed", Callable(self, "_on_ip_request_completed"))  
	  
	# 初始获取 IP 地址  
	_request_ip_address()  

	# 设置窗口最小大小及其模式  
	var window = get_window()  
	window.min_size = Vector2(400, 544)  # 根据您的需求调整  
	window.max_size = Vector2(400, 544)
	window.mode = Window.MODE_WINDOWED  # 窗口模式设置为窗口化
	
	# 获取 ErrorPopupPanel 的实例 
	var error_popup = $ErrorPopupPanel  # 确保路径正确
	# 连接 size_changed 信号到 ErrorPopupPanel 的 _on_window_resized 方法 
	get_tree().root.connect("size_changed", Callable(error_popup, "_on_window_resized"))      

func _request_ip_address():  
	var err = ip_request.request("https://api.ipify.org?format=json")  
	if err != OK:  
		print("Failed to send IP request")  
		_handle_ip_request_failure()  

func _on_ip_request_completed(result, response_code, headers, body):  
	if response_code == 200:  
		var json = JSON.parse_string(body.get_string_from_utf8())  
		if json != null and "ip" in json:  
			global_ip_address = json["ip"]  
			user_ip = global_ip_address  # 更新 user_ip  
			print("获取到的 IP 地址: ", global_ip_address)  
			ip_retry_count = 0  # 重置重试计数  
		else:  
			print("IP 地址解析失败")  
			_handle_ip_request_failure()  
	else:  
		print("IP 地址请求失败，响应码: ", response_code)  
		_handle_ip_request_failure()  

func _handle_ip_request_failure():  
	ip_retry_count += 1  
	  
	if ip_retry_count < max_ip_retries:  
		# 等待一段时间后重试  
		await get_tree().create_timer(2.0).timeout  
		_request_ip_address()  
	else:  
		print("多次尝试获取 IP 地址失败")  
		# 设置为空字符串，允许登录  
		global_ip_address = ""  
		user_ip = ""  

# 新增：获取用户 IP 的方法  
func get_user_ip() -> String:  
	return user_ip  

# 新增：检查是否有 IP  
func has_ip() -> bool:  
	return not user_ip.is_empty()
