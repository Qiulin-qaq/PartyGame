extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_new_chat_button_down() -> void:
	get_tree().change_scene_to_file("res://chat.tscn")

func _on_start_game_button_down() -> void:
	get_tree().change_scene_to_file("res://game_selection_scene.tscn")


func _on_settings_button_down() -> void:
	pass # Replace with function body.
