extends Node2D
@onready var players: Node = $Player
var peer = ENetMultiplayerPeer.new()
const PLAYER = preload("res://player1.tscn")

# 用于存储自定义鼠标节点的变量
var custom_mouse

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_mouse = get_node("mouse")
	if custom_mouse:
		custom_mouse.position = get_viewport().get_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 检查鼠标是否在场景内，以此控制自定义鼠标的可见性与位置更新
	if custom_mouse:
		var mouse_pos = get_viewport().get_mouse_position()
		var viewport_size = get_viewport().get_size()

		# 判断鼠标是否在视口内
		if mouse_pos.x < 0 or mouse_pos.x > viewport_size.x or mouse_pos.y < 0 or mouse_pos.y > viewport_size.y:
			custom_mouse.visible = false
		else:
			custom_mouse.visible = true
			custom_mouse.position = mouse_pos

func _on_create_button_down() -> void:
	var err = peer.create_server(7788)
	if err!= OK:
		printerr("创建服务器失败， 错误码：", err)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	add_player(multiplayer.get_unique_id())
	# 确保创建服务器操作后自定义鼠标能正确显示，更新其位置（如果获取到了自定义鼠标节点的话）
	if custom_mouse:
		custom_mouse.position = get_viewport().get_mouse_position()

func add_player(id: int) -> void:
	var player = PLAYER.instantiate()
	player.name = str(id)
	players.add_child(player)

func _on_peer_connected(id: int) -> void:
	print("有玩家连接，id为", id)
	add_player(id)
	# 有新玩家连接时也更新自定义鼠标位置，保证显示正常
	if custom_mouse:
		custom_mouse.position = get_viewport().get_mouse_position()

func assign_player_color():
	pass

func _on_join_button_down() -> void:
	peer.create_client("127.0.0.1", 7788)
	multiplayer.multiplayer_peer = peer
	# 加入服务器操作后更新自定义鼠标位置，使其正常显示
	if custom_mouse:
		custom_mouse.position = get_viewport().get_mouse_position()

func _on_peer_disconnected(id):
	var player = players.get_node(str(id))
	if player!= null:
		# 移除玩家节点
		players.remove_child(player)

		# 清理该玩家放置的炸弹、颜色实例等相关资源

		# 例如，清理炸弹
		for bomb in get_tree().get_nodes_in_group("bombs"):
			if bomb.get_parent() == player:
				get_tree().current_scene.remove_child(bomb)

		# 清理颜色实例（类似炸弹清理的逻辑）

		player.queue_free()
	# 玩家断开连接后同样更新自定义鼠标位置，维持其正常显示状态
	if custom_mouse:
		custom_mouse.position = get_viewport().get_mouse_position()
