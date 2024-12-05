extends TextureRect

# 旋转晃动幅度（角度），限制在±20度内
var rotation_amplitude = 0.3
# 晃动周期（完成一次旋转晃动的时间，单位：秒）
var period = 5
# 时间计数器
var time = 0

func _ready():
	# 设置旋转中心为自身的中心点
	var texture_size = texture.get_size()  # 获取纹理的尺寸
	pivot_offset = texture_size / 2  # 设置旋转点为纹理中心

func _process(delta):
	time += delta
	# 计算旋转角度
	var rotation_angle = rotation_amplitude * sin(2 * PI * time / period)
	rotation_angle = clamp(rotation_angle, -rotation_amplitude, rotation_amplitude)
	
	
	set_rotation(rotation_angle)
