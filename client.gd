extends Node

# 要连接的WebSocket服务器URL
@export var websocket_url = "ws://127.0.0.1:9000"
# WebSocket客户端实例
var client = WebSocketPeer.new()

var connected = false
var last_sent_message = ""
var is_my_message_sent = false  # 新增变量，用于标记自己是否发送了消息

func _ready():
	$"../VBoxContainer/ChatWindow".bbcode_enabled = true
	var err = client.connect_to_url(websocket_url)
	if err!= OK:
		print("无法连接到服务器：", err)
		set_process(false)
	else:
		print("正在连接到 WebSocket 服务器...")
		set_process(true)

func _process(_delta):
	client.poll()
	var state = client.get_ready_state()		

	if state == WebSocketPeer.STATE_OPEN:
		if not connected:
			print("成功连接到服务器")
			connected = true

		while client.get_available_packet_count() > 0:
			var pkt = client.get_packet()
			var message = pkt.get_string_from_utf8()
			if not is_my_message_sent or message!= last_sent_message:
				update_chat_window(message, false)

	elif state == WebSocketPeer.STATE_CLOSING:
		print("正在关闭连接")
		connected = false

	elif state == WebSocketPeer.STATE_CLOSED:
		var code = client.get_close_code()
		print("WebSocket 连接已关闭，代码：%d。是否干净断开：%s" % [code, code!= -1])
		connected = false
		set_process(false)

# 更新聊天窗口
func update_chat_window(message, is_self_message = false):
	var chat_window = $"../VBoxContainer/ChatWindow"
	chat_window.bbcode_enabled = true
	if is_self_message:
		chat_window.text += "[right][color=gray]我: " + message + "[/color][/right]\n"
	else:
		var local_port = client.get_connected_port()
		chat_window.text += "[left][color=gray]" + "用户"+ message + "[/color][/left]\n"
	chat_window.scroll_to_line(chat_window.get_line_count())

# 处理发送消息的按钮点击事件
func _on_send_pressed() -> void:
	var message_text = $"../VBoxContainer/ChatInput/Message".text
	if message_text!= "":
		
		last_sent_message = message_text
		is_my_message_sent = true
		client.send_text(message_text)
		update_chat_window(message_text, true)
		$"../VBoxContainer/ChatInput/Message".text = ""
