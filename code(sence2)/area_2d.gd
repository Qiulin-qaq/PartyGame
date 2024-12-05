extends Area2D


func _ready():
	connect("body_entered",Callable(self,"on_body_entered"))
	connect("body_exited", Callable(self,"on_body_exited"))
	

func on_body_entered(node):
	print("我是一个：" + name +  ",一个" + node.name + "进入我的区域")

func on_body_exited(node):
	print("我是一个：" + name +  ",一个" + node.name + "移出我的区域")
