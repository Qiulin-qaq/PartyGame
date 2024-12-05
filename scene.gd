extends Node2D
@onready var players: Node = $Player
var peer = ENetMultiplayerPeer.new()
const PLAYER = preload("res://player1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_create_button_down() -> void:
	var err = peer.create_server(7788)
	if err != OK:
		printerr("创建服务器失败， 错误码：",err)
		return
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	add_player(multiplayer.get_unique_id())
	#multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
func add_player(id: int) -> void:
	var player = PLAYER.instantiate()
	player.name = str(id)
	players.add_child(player)
	
	
	

	
func _on_peer_connected(id: int) -> void:
	print("有玩家连接，id为",id)
	add_player(id)

		
func assign_player_color():
	pass
func _on_join_button_down() -> void:
	peer.create_client("127.0.0.1", 7788)
	multiplayer.multiplayer_peer = peer
	
	
	
	
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
