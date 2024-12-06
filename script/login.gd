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
	  

	# 设置窗口最小大小及其模式  
	var window = get_window()  
	window.min_size = Vector2(1144, 640)  # 根据您的需求调整  
	window.max_size = Vector2(1144, 640)
	window.mode = Window.MODE_WINDOWED  # 窗口模式设置为窗口化
	
	# 获取 ErrorPopupPanel 的实例 
	var error_popup = $ErrorPopupPanel  # 确保路径正确
	# 连接 size_changed 信号到 ErrorPopupPanel 的 _on_window_resized 方法 
	get_tree().root.connect("size_changed", Callable(error_popup, "_on_window_resized"))      


# 新增：获取用户 IP 的方法  
func get_user_ip() -> String:  
	return user_ip  

# 新增：检查是否有 IP  
func has_ip() -> bool:  
	return not user_ip.is_empty()
