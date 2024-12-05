extends Label  

# 用户名标签的最小和最大字体大小  
@export var min_font_size: float = 16.0  
@export var max_font_size: float = 48.0  

func _ready():  
	# 确保标签有 LabelSettings  
	if not label_settings:  
		label_settings = LabelSettings.new()  
	
	# 设置最小尺寸  
	custom_minimum_size = Vector2(100, 30)  
	
	# 延迟一帧后更新字体大小  
	call_deferred("update_font_size_delayed")  

func update_font_size_delayed():  
	# 尝试获取窗口或根节点的高度  
	var root = get_tree().root  
	var window_height = root.size.y  
	
	# 如果根节点高度为0，尝试获取屏幕高度  
	if window_height == 0:  
		window_height = DisplayServer.screen_get_size().y  
	
	# 根据窗口高度计算字体大小  
	var font_size = lerp(  
		min_font_size,   
		max_font_size,   
		clamp((window_height - 300.0) / (1080.0 - 300.0), 0.0, 1.0)  
	)  
	
	# 设置字体大小  
	if label_settings:  
		label_settings.font_size = font_size  
	
func _process(delta):  
	# 如果父容器高度仍然为0，继续尝试更新  
	if get_parent() and get_parent().size.y == 0:  
		update_font_size_delayed()
