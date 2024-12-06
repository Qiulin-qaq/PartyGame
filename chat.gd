extends Node2D

@export var scroll_velocity = -100.0
@onready var background = $Background
# 用于存储自定义鼠标节点的变量
var custom_mouse
@onready var chatmusic_node = $BGM
var last_play_time = 0.0 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 获取自定义鼠标节点（此处需填入你项目中实际的自定义鼠标节点路径）
	custom_mouse = get_node("mouse")
	if custom_mouse:
		custom_mouse.position = get_viewport().get_mouse_position()
	setup_background()
	# 获取chatmusic音乐节点（此处需填入实际路径来正确获取该节点）
	chatmusic_node = get_node("BGM")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	background.scroll_offset.x += scroll_velocity * delta
	get_node("/root/Backgroundstate").scroll_offset_x = background.scroll_offset.x
	# 检查鼠标是否在场景内，进而控制自定义鼠标的可见性和位置
	if custom_mouse:
		var mouse_pos = get_viewport().get_mouse_position()
		var viewport_size = get_viewport().get_size()

		# 判断鼠标是否在视口范围内
		if mouse_pos.x < 0 or mouse_pos.x > viewport_size.x or mouse_pos.y < 0 or mouse_pos.y > viewport_size.y:
			custom_mouse.visible = false
		else:
			custom_mouse.visible = true
			custom_mouse.position = mouse_pos

func _on_back_to_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://startmenu.tscn")
