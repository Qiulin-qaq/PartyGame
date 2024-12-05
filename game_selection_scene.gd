extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_goto_game_1_button_down() -> void:
	get_tree().change_scene_to_file("res://scene.tscn")


func _on_goto_game_2_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/newgame.tscn")


func _on_back_to_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")
