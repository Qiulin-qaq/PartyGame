extends HBoxContainer

func _ready():
	# 设置 HBoxContainer 的大小标志
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER  # 水平初始收缩
	size_flags_vertical = Control.SIZE_FILL  # 竖直填充
